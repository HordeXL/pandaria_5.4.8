#include "RandomPlayerbotBracketMgr.h"

#include "Helper.h"
#include "ObjectAccessor.h"
#include "PlayerbotSpec.h"
#include "RandomPlayerbotMgr.h"

RandomBotBacketManager::RandomBotBacketManager()
    : _timer{ _BotDistCheckFrequency * 1000 }  // start high so first check runs immediately
{
    _AllianceLevelRanges[0]     = { 1, 9,   2 };
    _AllianceLevelRanges[1]     = { 10, 19, 8 };
    _AllianceLevelRanges[2]     = { 20, 29, 8 };
    _AllianceLevelRanges[3]     = { 30, 39, 8 };
    _AllianceLevelRanges[4]     = { 40, 49, 8 };
    _AllianceLevelRanges[5]     = { 50, 59, 9 };
    _AllianceLevelRanges[6]     = { 60, 69, 9 };
    _AllianceLevelRanges[7]     = { 70, 79, 9 };
    _AllianceLevelRanges[8]     = { 80, 84, 9 };
    _AllianceLevelRanges[9]     = { 85, 89, 10 };
    _AllianceLevelRanges[10]    = { 90, 90, 20 };

    for (uint8 i = 0; i < NUM_RANGES; ++i)
        _HordeLevelRanges[i] = _AllianceLevelRanges[i];

    uint32 totalAlliancePercent = 0;
    uint32 totalHordePercent = 0;
    for (uint8 i = 0; i < NUM_RANGES; ++i)
    {
        totalAlliancePercent += _AllianceLevelRanges[i].desiredPercent;
        totalHordePercent += _HordeLevelRanges[i].desiredPercent;
    }
    if (totalAlliancePercent != 100)
        TC_LOG_ERROR("server.loading", "[BotLevelBrackets] totalAlliancePercent Sum of percentages is %u (expected 100).", totalAlliancePercent);
    if (totalHordePercent != 100)
        TC_LOG_ERROR("server.loading", "[BotLevelBrackets] totalHordePercent Sum of percentages is %u (expected 100).", totalHordePercent);
}

int RandomBotBacketManager::GetLevelRangeIndex(uint8 level)
{
    for (int i = 0; i < NUM_RANGES; ++i)
    {
        // Use Alliance boundaries as reference.
        if (level >= _AllianceLevelRanges[i].lower && level <= _AllianceLevelRanges[i].upper)
            return i;
    }
    return -1;
}

uint8 RandomBotBacketManager::GetRandomLevelInRange(const LevelRangeConfig& range)
{
    return urand(range.lower, range.upper);
}

void RandomBotBacketManager::AdjustBotToRange(BotBracketInfo const& bot, int targetRangeIndex, const LevelRangeConfig* factionRanges)
{
    if (targetRangeIndex < 0 || targetRangeIndex >= NUM_RANGES)
        return;

    uint8 botOriginalLevel = bot.level;
    uint8 newLevel = 0;
    // If the bot is a Death Knight, ensure level is not set below 55.
    if (bot.playerClass == CLASS_DEATH_KNIGHT)
    {
        uint8 lowerBound = factionRanges[targetRangeIndex].lower;
        uint8 upperBound = factionRanges[targetRangeIndex].upper;
        if (upperBound < 55)
        {
            // This target range is invalid for Death Knights.
            return;
        }
        // Adjust lower bound to 55 if necessary.
        if (lowerBound < 55)
            lowerBound = 55;
        newLevel = urand(lowerBound, upperBound);
    }
    else
    {
        newLevel = GetRandomLevelInRange(factionRanges[targetRangeIndex]);
    }

    // Use GUID-based overload to avoid accessing Player* pointer
    // (which may have been freed after the read lock was released).
    sRandomPlayerbotMgr->TagForRandomize(bot.guid, newLevel, urand(15, 55));
    TC_LOG_DEBUG("playerbots", "[BotLevelBrackets] AdjustBotToRange: bot #%u level %u -> %u (range %u-%u)",
                 bot.guid, botOriginalLevel, newLevel, factionRanges[targetRangeIndex].lower, factionRanges[targetRangeIndex].upper);
}

void RandomBotBacketManager::Update(uint32 diff)
{
    _timer += diff;
    if (_timer < (_BotDistCheckFrequency * 1000))
        return;
    _timer = 0;

    // Total number of bots adjusted in this check; capped by _MaxAdjustPerCheck
    // so the world thread is not blocked by a batch of full re-randomizations.
    uint32 totalAdjusted = 0;

    // Containers for Alliance bots.
    uint32 totalAllianceBots = 0;
    int allianceActualCounts[NUM_RANGES] = {0};
    std::vector<BotBracketInfo> allianceBotsByRange[NUM_RANGES];

    // Containers for Horde bots.
    uint32 totalHordeBots = 0;
    int hordeActualCounts[NUM_RANGES] = {0};
    std::vector<BotBracketInfo> hordeBotsByRange[NUM_RANGES];

    // Phase 1: Collect bot data under read lock.
    // The lock is scoped to ONLY the iteration phase so that database I/O
    // and logging in Phase 2 do not block player login/logout.
    {
        TRINITY_READ_GUARD(HashMapHolder<Player>::LockType, *HashMapHolder<Player>::GetLock());
        auto const& allPlayers = ObjectAccessor::GetPlayers();
        for (auto const& itr : allPlayers)
        {
            Player* player = itr.second;
            if (!player || !player->IsInWorld())
                continue;

            if (!sRandomPlayerbotMgr->IsRandomBot(GUID_LOPART(player->GetGUID())))
                continue;

            BotBracketInfo info;
            info.guid = GUID_LOPART(player->GetGUID());
            info.level = player->GetLevel();
            info.playerClass = player->GetClass();

            auto team = player->GetTeam();
            if (team == Team::ALLIANCE)
            {
                totalAllianceBots++;
                int rangeIndex = GetLevelRangeIndex(info.level);
                if (rangeIndex >= 0)
                {
                    allianceActualCounts[rangeIndex]++;
                    allianceBotsByRange[rangeIndex].push_back(info);
                }
            }
            else if (team == Team::HORDE)
            {
                totalHordeBots++;
                int rangeIndex = GetLevelRangeIndex(info.level);
                if (rangeIndex >= 0)
                {
                    hordeActualCounts[rangeIndex]++;
                    hordeBotsByRange[rangeIndex].push_back(info);
                }
            }
        }
    } // Read lock released here.

    // Phase 2: Log and adjust WITHOUT holding the read lock.
    // This allows player login/logout to proceed during database I/O.

    // Process Alliance bots.
    if (totalAllianceBots > 0)
    {
        int allianceDesiredCounts[NUM_RANGES] = {0};
        for (int i = 0; i < NUM_RANGES; ++i)
        {
            allianceDesiredCounts[i] = static_cast<int>(round((_AllianceLevelRanges[i].desiredPercent / 100.0) * totalAllianceBots));
            TC_LOG_DEBUG("playerbots", "[BotLevelBrackets] Alliance Range %u (%u-%u): Desired = %u, Actual = %u.",
                     i + 1, _AllianceLevelRanges[i].lower, _AllianceLevelRanges[i].upper,
                     allianceDesiredCounts[i], allianceActualCounts[i]);
        }
        // Adjust overpopulated ranges.
        for (int i = 0; i < NUM_RANGES; ++i)
        {
            while (allianceActualCounts[i] > allianceDesiredCounts[i] && !allianceBotsByRange[i].empty())
            {
                BotBracketInfo bot = allianceBotsByRange[i].back();
                allianceBotsByRange[i].pop_back();
                int targetRange = -1;
                if (bot.playerClass == CLASS_DEATH_KNIGHT)
                {
                    for (int j = 0; j < NUM_RANGES; ++j)
                    {
                        if (allianceActualCounts[j] < allianceDesiredCounts[j] && _AllianceLevelRanges[j].upper >= 55)
                        {
                            targetRange = j;
                            break;
                        }
                    }
                }
                else
                {
                    for (int j = 0; j < NUM_RANGES; ++j)
                    {
                        if (allianceActualCounts[j] < allianceDesiredCounts[j])
                        {
                            targetRange = j;
                            break;
                        }
                    }
                }
                if (targetRange == -1)
                    break;
                AdjustBotToRange(bot, targetRange, _AllianceLevelRanges);
                allianceActualCounts[i]--;
                allianceActualCounts[targetRange]++;
                if (++totalAdjusted >= _MaxAdjustPerCheck)
                    return;
            }
        }
    }

    // Process Horde bots.
    if (totalHordeBots > 0)
    {
        int hordeDesiredCounts[NUM_RANGES] = {0};
        for (int i = 0; i < NUM_RANGES; ++i)
        {
            hordeDesiredCounts[i] = static_cast<int>(round((_HordeLevelRanges[i].desiredPercent / 100.0) * totalHordeBots));
            TC_LOG_DEBUG("playerbots", "[BotLevelBrackets] Horde Range %u (%u-%u): Desired = %u, Actual = %u.",
                     i + 1, _HordeLevelRanges[i].lower, _HordeLevelRanges[i].upper,
                     hordeDesiredCounts[i], hordeActualCounts[i]);
        }
        for (int i = 0; i < NUM_RANGES; ++i)
        {
            while (hordeActualCounts[i] > hordeDesiredCounts[i] && !hordeBotsByRange[i].empty())
            {
                BotBracketInfo bot = hordeBotsByRange[i].back();
                hordeBotsByRange[i].pop_back();
                int targetRange = -1;
                if (bot.playerClass == CLASS_DEATH_KNIGHT)
                {
                    for (int j = 0; j < NUM_RANGES; ++j)
                    {
                        if (hordeActualCounts[j] < hordeDesiredCounts[j] && _HordeLevelRanges[j].upper >= 55)
                        {
                            targetRange = j;
                            break;
                        }
                    }
                }
                else
                {
                    for (int j = 0; j < NUM_RANGES; ++j)
                    {
                        if (hordeActualCounts[j] < hordeDesiredCounts[j])
                        {
                            targetRange = j;
                            break;
                        }
                    }
                }
                if (targetRange == -1)
                    break;
                AdjustBotToRange(bot, targetRange, _HordeLevelRanges);
                hordeActualCounts[i]--;
                hordeActualCounts[targetRange]++;
                if (++totalAdjusted >= _MaxAdjustPerCheck)
                    return;
            }
        }
    }

    TC_LOG_DEBUG("playerbots", "[BotLevelBrackets] Distribution adjustment complete. Alliance bots: %u, Horde bots: %u.",
             totalAllianceBots, totalHordeBots);
}
