#ifndef _PLAYERBOT_RANDOMPLAYERBOTBRACKETMGR_H
#define _PLAYERBOT_RANDOMPLAYERBOTBRACKETMGR_H

#include "Playerbots.h"

// -- BracketManager
class RandomBotBacketManager
{
public:
    static RandomBotBacketManager* instance()
    {
        static RandomBotBacketManager instance;
        return &instance;
    }
private:
    struct LevelRangeConfig
    {
        uint8 lower;            ///< Lower bound (inclusive)
        uint8 upper;            ///< Upper bound (inclusive)
        uint8 desiredPercent;   ///< Desired percentage of bots in this range
    };

    struct BotBracketInfo
    {
        uint32 guid;
        uint8  level;
        uint8  playerClass;
    };

public:
    RandomBotBacketManager();

    void AdjustBotToRange(BotBracketInfo const& bot, int targetRangeIndex, const LevelRangeConfig* factionRanges);
    int GetLevelRangeIndex(uint8 level);
    uint8 GetRandomLevelInRange(const LevelRangeConfig& range);
    void Update(uint32 diff);

private:
    uint32 _timer;
    static const uint8 NUM_RANGES = 11;
    LevelRangeConfig _AllianceLevelRanges[NUM_RANGES];
    LevelRangeConfig _HordeLevelRanges[NUM_RANGES];
    static const uint32 _BotDistCheckFrequency = 300; // in seconds
    // Limit the number of bots re-randomized per check. A full re-randomize
    // (talents reset, pet rebuild, equipment) runs on the world thread and can
    // stall the client; keep it to one bot per check and spread the work.
    static const uint32 _MaxAdjustPerCheck = 1;
};

#define sBracketMgr RandomBotBacketManager::instance()

#endif
