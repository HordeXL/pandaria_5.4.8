/*
* This file is part of the Legends of Azeroth Pandaria Project. See THANKS file for Copyright information
*
* This program is free software; you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by the
* Free Software Foundation; either version 2 of the License, or (at your
* option) any later version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
* more details.
*
* You should have received a copy of the GNU General Public License along
* with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#include "PlayerbotMgr.h"

#include <cstdio>
#include <cstring>
#include <istream>
#include <string>

#include "BotFactory.h"
#include "Helper.h"
#include "PlayerbotAIConfig.h"
#include "CharacterCache.h"
#include "ChannelMgr.h"
#include "CharacterHandler.h"
#include "Common.h"
#include "Chat.h"
#include "DatabaseEnv.h"
#include "Define.h"
#include "Group.h"
#include "GroupMgr.h"
#include "ObjectAccessor.h"
#include "ByteBuffer.h"
#include "ObjectMgr.h"
#include "Playerbots.h"
#include "RandomPlayerbotMgr.h"
#include "WorldSession.h"
#include "ChannelMgr.h"
#include "Language.h"
#include "Log.h"
#include "TaskMgr.h"

PlayerbotHolder::PlayerbotHolder() : PlayerbotAIBase(false) {}
class PlayerbotLoginQueryHolder : public LoginQueryHolder
{
private:
    uint32 masterAccountId;
    PlayerbotHolder* playerbotHolder;

public:
    PlayerbotLoginQueryHolder(PlayerbotHolder* playerbotHolder, uint32 masterAccount, uint32 accountId, ObjectGuid guid)
        : LoginQueryHolder(accountId, guid)
        , masterAccountId(masterAccount)
        , playerbotHolder(playerbotHolder)
    {
    }

    uint32 GetMasterAccountId() const { return masterAccountId; }
    PlayerbotHolder* GetPlayerbotHolder() { return playerbotHolder; }
};

void PlayerbotHolder::AddPlayerBot(ObjectGuid playerGuid, uint32 masterAccountId)
{
    // bot is loading
    if (botLoading.find(playerGuid) != botLoading.end())
    {
        TC_LOG_DEBUG("playerbots", "Bot %u is already loading", playerGuid.GetCounter());
        return;
    }

    // has bot already been added?
    Player* bot = ObjectAccessor::FindPlayer(playerGuid);
    if (bot && bot->IsInWorld())
    {
        TC_LOG_DEBUG("playerbots", "Bot %u is already in game", playerGuid.GetCounter());
        return;
    }

    uint32 accountId = sCharacterCache->GetCharacterAccountIdByGuid(playerGuid);
    if (!accountId)
    {
        TC_LOG_ERROR("playerbots", "Bot %u has invalid accountid (CharacterCache returned 0)", playerGuid.GetCounter());
        return;
    }

    // will be delete in WorldSession
    PlayerbotLoginQueryHolder* holder = new PlayerbotLoginQueryHolder(this, masterAccountId, accountId, playerGuid);
    if (!holder->Initialize())
    {
        TC_LOG_ERROR("playerbots", "Holder initialize failed");
        delete holder;
        return;
    }

    TC_LOG_INFO("playerbots", "AddPlayerBot: starting login for GUID %u", playerGuid.GetCounter());
    botLoading.insert(playerGuid);

    QueryResultHolderFuture future = CharacterDatabase.DelayQueryHolder(holder);

    // Asynchronous: wait for DB query on a background thread, then schedule
    // the login callback on the world thread via TaskMgr.  The old synchronous
    // future.get() blocked the world thread for O(bots) DB queries and caused
    // "already connected" hangs and high latency for real players.
    std::thread([this, holder, future, playerGuid]()
    {
        SQLQueryHolder* result = nullptr;
        int getResult = future.get(result);
        if (getResult == 0 && result)
        {
            TaskMgr::Default()->ScheduleInvocation([this, result]()
            {
                HandlePlayerBotLoginCallback(static_cast<PlayerbotLoginQueryHolder const&>(*result));
            });
        }
        else
        {
            TC_LOG_ERROR("playerbots", "Bot login query holder execution failed for GUID %u (getResult=%d)", playerGuid.GetCounter(), getResult);
            TaskMgr::Default()->ScheduleInvocation([this, playerGuid, holder]()
            {
                botLoading.erase(playerGuid);
                delete holder;
            });
        }
    }).detach();
}

void PlayerbotHolder::HandlePlayerBotLoginCallback(PlayerbotLoginQueryHolder const& holder)
{
    uint32 botAccountId = holder.GetAccountId();
    ObjectGuid botGUID = holder.GetGuid();

    // At login DBC locale should be what the server is set to use by default (as spells etc are hardcoded to ENUS this
    // allows channels to work as intended)
    // Créer une session WorldSession pour le bot
    WorldSession* botSession = new WorldSession(botAccountId, nullptr, SEC_PLAYER, EXPANSION_MISTS_OF_PANDARIA, 0, LOCALE_frFR, 0, false, false, true);
    botSession->SetBot(true);

    botSession->HandlePlayerLogin((LoginQueryHolder*)&holder);  // will delete lqh
    Player* bot = botSession->GetPlayer();
    if (!bot)
    {
        // Debug log
        TC_LOG_DEBUG("playerbots", "Bot player could not be loaded for account ID: %u", botAccountId);
        botSession->LogoutPlayer(true);
        delete botSession;
        botLoading.erase(botGUID);
        return;
    }

    uint32 masterAccount = holder.GetMasterAccountId();
    WorldSession* masterSession = masterAccount ? sWorld->FindSession(masterAccount) : nullptr;

    // Check if masterSession->GetPlayer() is valid
    Player* masterPlayer = masterSession ? masterSession->GetPlayer() : nullptr;
    if (masterSession && !masterPlayer)
    {
        TC_LOG_DEBUG("playerbots", "Master session found but no player is associated for master account ID: %u", masterAccount);
    }

    std::ostringstream out;
    bool allowed = true;
    if (botAccountId == masterAccount)
    {
        allowed = true;
    }
    else if (masterSession /* && sPlayerbotAIConfig->allowGuildBots*/ && bot->GetGuildId() != 0 && bot->GetGuildId() == masterPlayer->GetGuildId())
    {
        allowed = true;
    }
    else if (sPlayerbotAIConfig->IsInRandomAccountList(botAccountId))
    {
        allowed = true;
    }
    else
    {
        allowed = false;
        out << "Failure: You are not allowed to control bot " << bot->GetName().c_str();
    }

    if (allowed && masterSession && masterPlayer)
    {
        PlayerbotMgr* mgr = GET_PLAYERBOT_MGR(masterPlayer);
        if (!mgr)
        {
            TC_LOG_DEBUG("playerbots", "PlayerbotMgr not found for master player with GUID: %u", GUID_LOPART(masterPlayer->GetGUID()));
        }

        uint32 count = mgr->GetPlayerbotsCount();
        uint32 cls_count = mgr->GetPlayerbotsCountByClass(bot->GetClass());
        if (count >= sPlayerbotAIConfig->maxAddedBots)
        {
            allowed = false;
            out << "Failure: You have added too many bots";
        }
        else if (cls_count >= sPlayerbotAIConfig->maxAddedBotsPerClass)
        {
            allowed = false;
            out << "Failure: You have added too many bots for this class";
        }
    }

    if (allowed)
    {
        sRandomPlayerbotMgr->OnPlayerLogin(bot);
        OnBotLogin(bot);

        TC_LOG_DEBUG("playerbots", "Player logged: %s", bot->GetName().c_str());
    }
    else
    {
        TC_LOG_ERROR("playerbots", "Bot error on logging: %s", out.str().c_str());
        botSession->LogoutPlayer(true);
        delete botSession;
    }

    botLoading.erase(botGUID);
}

void PlayerbotHolder::UpdateSessions()
{
    // Use a thread-safe snapshot to prevent iterator invalidation when
    // DisablePlayerBot (Map thread) or LogoutPlayerBot (World thread)
    // erases from playerBots during iteration.
    PlayerBotMap bots = GetAllBotsSafe();
    for (auto const& itr : bots)
    {
        Player* const bot = itr.second;
        if (!bot)
            continue;

        if (bot->IsBeingTeleported())
        {
            // Defer HandleTeleportAck to the Map thread via RequestOp.
            // HandleTeleportAck calls AddPlayerToMap, HandleMoveTeleportAck,
            // and HandleMoveWorldportAckOpcode which all modify Map/Player
            // state and must not run on the World thread.
            PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
            if (botAI)
            {
                botAI->RequestOp(PlayerbotAI::BOT_OP_TELEPORT_ACK);
            }
        }
        else if (bot->IsInWorld())
        {
            HandleBotPackets(bot->GetSession());
        }
    }
}

void PlayerbotHolder::HandleBotPackets(WorldSession* session)
{
    /*WorldPacket* packet;
    while (session->GetPacketQueue().next(packet))
    {
        OpcodeClient opcode = static_cast<OpcodeClient>(packet->GetOpcode());
        ClientOpcodeHandler const* opHandle = opcodeTable[opcode];
        opHandle->Call(session, *packet);
        delete packet;
    }*/
}

void PlayerbotHolder::LogoutAllBots()
{
    /*
    while (true)
    {
        PlayerBotMap::const_iterator itr = GetPlayerBotsBegin();
        if (itr == GetPlayerBotsEnd())
            break;

        Player* bot= itr->second;
        if (!GET_PLAYERBOT_AI(bot)->IsRealPlayer())
            LogoutPlayerBot(bot->GetGUID());
    }
    */

    // Thread-safe snapshot under shared lock.
    PlayerBotMap bots = GetAllBotsSafe();
    for (auto& itr : bots)
    {
        Player* bot = itr.second;
        if (!bot)
            continue;

        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (!botAI || botAI->IsRealPlayer())
            continue;

        LogoutPlayerBot(bot->GetGUID());

        // Small delay between logouts to avoid blocking the World thread
        // for too long when many bots are logged out at once (e.g. on
        // master logout). Each logout involves SaveToDB + LogoutPlayer.
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }
}

void PlayerbotMgr::CancelLogout()
{
    Player* master = GetMaster();
    if (!master)
        return;

    for (PlayerBotMap::const_iterator it = GetPlayerBotsBegin(); it != GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (!botAI || botAI->IsRealPlayer())
            continue;

        if (bot->GetSession()->isLogingOut())
        {
            /*WorldPackets::Character::LogoutCancel data = WorldPacket(CMSG_LOGOUT_CANCEL);
            bot->GetSession()->HandleLogoutCancelOpcode(data);
            botAI->TellMaster("Logout cancelled!");*/
        }
    }

    for (PlayerBotMap::const_iterator it = sRandomPlayerbotMgr->GetPlayerBotsBegin();
        it != sRandomPlayerbotMgr->GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (!botAI || botAI->IsRealPlayer())
            continue;

        if (botAI->GetMaster() != master)
            continue;

        if (bot->GetSession()->isLogingOut())
        {
            /*WorldPackets::Character::LogoutCancel data = WorldPacket(CMSG_LOGOUT_CANCEL);
            bot->GetSession()->HandleLogoutCancelOpcode(data);*/
        }
    }
}

void PlayerbotHolder::LogoutPlayerBot(ObjectGuid guid)
{
    // IMPORTANT: This function deletes the bot's WorldSession and Player
    // objects. It must only be called from the World thread (via
    // UpdateAIInternal/UpdateSessions/OnPlayerLogout), never from a Map
    // worker thread, because other Map threads may still be ticking the
    // bot's auras, pets, or AI. All current callers are on the World thread.
    if (Player* bot = GetPlayerBot(guid))
    {
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (!botAI)
            return;

        Group* group = bot->GetGroup();
        if (group && !bot->InBattleground() && !bot->InBattlegroundQueue() && botAI->HasActivePlayerMaster())
        {
            //sPlayerbotDbStore->Save(botAI);
        }

        TC_LOG_INFO("playerbots", "Bot %s logging out", bot->GetName().c_str());
        bot->SaveToDB(false);

        WorldSession* botWorldSessionPtr = bot->GetSession();
        WorldSession* masterWorldSessionPtr = nullptr;

        if (botWorldSessionPtr->isLogingOut())
            return;

        Player* master = botAI->GetMaster();
        if (master)
            masterWorldSessionPtr = master->GetSession();

        // check for instant logout
        bool logout = botWorldSessionPtr->ShouldLogOut(time(nullptr));

        if (masterWorldSessionPtr && masterWorldSessionPtr->ShouldLogOut(time(nullptr)))
            logout = true;

        if (masterWorldSessionPtr && !masterWorldSessionPtr->GetPlayer())
            logout = true;

        if (bot->HasFlag(PLAYER_FIELD_PLAYER_FLAGS, PLAYER_FLAGS_RESTING) || bot->HasUnitState(UNIT_STATE_IN_FLIGHT) ||
            botWorldSessionPtr->GetSecurity() >= AccountTypes::SEC_PLAYER)
        {
            logout = true;
        }

        if (master &&
            (master->HasFlag(PLAYER_FIELD_PLAYER_FLAGS, PLAYER_FLAGS_RESTING) || master->HasUnitState(UNIT_STATE_IN_FLIGHT) ||
                (masterWorldSessionPtr &&
                    masterWorldSessionPtr->GetSecurity() >= AccountTypes::SEC_PLAYER)))
        {
            logout = true;
        }

        //TravelTarget* target = nullptr;
        //if (botAI->GetAiObjectContext())  // Maybe some day re-write to delate all pointer values.
        {
            //target = botAI->GetAiObjectContext()->GetValue<TravelTarget*>("travel target")->Get();
        }

        // Peiru: Allow bots to always instant logout to see if this resolves logout crashes
        logout = true;

        // if no instant logout, request normal logout
        if (!logout)
        {
            if (bot->GetSession()->isLogingOut())
                return;
            else if (bot)
            {
                /*botAI->TellMaster("I'm logging out!");
                WorldPackets::Character::LogoutRequest data = WorldPacket(CMSG_LOGOUT_REQUEST);
                botWorldSessionPtr->HandleLogoutRequestOpcode(data);
                if (!bot)
                {
                    playerBots.erase(guid);
                    delete botWorldSessionPtr;
                    if (target)
                        delete target;
                }*/
                return;
            }
            else
            {
                { std::unique_lock<std::shared_mutex> lock(_playerBotsMutex); playerBots.erase(guid); }
                delete botWorldSessionPtr;  // finally delete the bot's WorldSession
                //if (target)
                    //delete target;
            }
            return;
        }  // if instant logout possible, do it
        else if (bot && (logout || !botWorldSessionPtr->isLogingOut()))
        {
            botAI->TellMaster("Goodbye!");
            { std::unique_lock<std::shared_mutex> lock(_playerBotsMutex); playerBots.erase(guid); }
            botWorldSessionPtr->LogoutPlayer(true);  // this will delete the bot Player object and PlayerbotAI object
            delete botWorldSessionPtr;               // finally delete the bot's WorldSession
        }
    }
}

void PlayerbotHolder::DisablePlayerBot(ObjectGuid guid)
{
    if (Player* bot = GetPlayerBot(guid))
    {
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (!botAI)
        {
            return;
        }
        botAI->TellMaster("Goodbye!");
        bot->StopMoving();
        bot->GetMotionMaster()->Clear();

        Group* group = bot->GetGroup();
        if (group && !bot->InBattleground() && !bot->InBattlegroundQueue() && botAI->HasActivePlayerMaster())
        {
            //sPlayerbotDbStore->Save(botAI);
        }

        TC_LOG_DEBUG("playerbots", "Bot %s logged out", bot->GetName().c_str());

        bot->SaveToDB(false);

        // If the bot is not in the world (e.g. logging out mid-teleport), the core
        // logout path may skip RemovePlayerFromMap, leaving pets/minions/charmed
        // units stuck in m_Controlled and later hitting Unit::RemoveFromWorld's
        // assert when those units are removed by the map thread. Release them here.
        if (!bot->IsInWorld())
            bot->RemoveAllControlled();

        //if (botAI->GetAiObjectContext())  // Maybe some day re-write to delate all pointer values.
        //{
        //    TravelTarget* target = botAI->GetAiObjectContext()->GetValue<TravelTarget*>("travel target")->Get();
        //    if (target)
        //        delete target;
        //}

        { std::unique_lock<std::shared_mutex> lock(_playerBotsMutex); playerBots.erase(guid); }

        delete botAI;
    }
}

Player* PlayerbotHolder::GetPlayerBot(uint32 lowGuid) const
{
    ObjectGuid playerGuid = ObjectGuid(MAKE_NEW_GUID(lowGuid, 0, HIGHGUID_PLAYER));
    std::shared_lock<std::shared_mutex> lock(_playerBotsMutex);
    PlayerBotMap::const_iterator it = playerBots.find(playerGuid);
    return (it == playerBots.end()) ? 0 : it->second;
}

PlayerBotMap PlayerbotHolder::GetAllBotsSafe() const
{
    std::shared_lock<std::shared_mutex> lock(_playerBotsMutex);
    return playerBots;
}

Player* PlayerbotHolder::GetPlayerBot(ObjectGuid playerGuid) const
{
    std::shared_lock<std::shared_mutex> lock(_playerBotsMutex);
    PlayerBotMap::const_iterator it = playerBots.find(playerGuid);
    return (it == playerBots.end()) ? 0 : it->second;
}

void PlayerbotHolder::OnBotLogin(Player* const bot)
{
    // Prevent duplicate login
    {
        std::shared_lock<std::shared_mutex> lock(_playerBotsMutex);
        if (playerBots.find(bot->GetGUID()) != playerBots.end())
            return;
    }

    sPlayerbotsMgr->AddPlayerbotData(bot, true);
    {
        std::unique_lock<std::shared_mutex> lock(_playerBotsMutex);
        playerBots[bot->GetGUID()] = bot;
    }
    OnBotLoginInternal(bot);

    // Join chat channels. This must happen before the master check below:
    // random bots have no master and would return early, never joining.
    // bots join World chat if not solo oriented
    if (bot->GetLevel() >= 10 && sRandomPlayerbotMgr->IsRandomBot(bot))
    {
        // Make the bot join the world channel for chat
        if (ChannelMgr* cMgr = ChannelMgr::forTeam(bot->GetTeamId()))
            if (Channel* channel = cMgr->GetJoinChannel("World", 0))
                channel->JoinChannel(bot, "");
    }

    // join standard channels
    LocaleConstant locale = bot->GetSession()->GetSessionDbcLocale();
    AreaTableEntry const* current_zone = sAreaTableStore.LookupEntry(bot->GetZoneId());
    ChannelMgr* cMgr = ChannelMgr::forTeam(bot->GetTeamId());

    if (current_zone && cMgr)
    {
        for (uint32 i = 0; i < sChatChannelsStore.GetNumRows(); ++i)
        {
            ChatChannelsEntry const* channel = sChatChannelsStore.LookupEntry(i);
            if (!channel || !bot->CanJoinConstantChannelInZone(channel, current_zone))
                continue;

            Channel* new_channel = nullptr;
            if (channel->flags & CHANNEL_DBC_FLAG_GLOBAL)
            {
                // WorldDefense etc.: channel name has no zone/city placeholder
                new_channel = cMgr->GetJoinChannel(channel->pattern[locale], channel->ChannelID);
            }
            else
            {
                char new_channel_name_buf[200];
                char const* nameExt = (channel->flags & CHANNEL_DBC_FLAG_CITY_ONLY)
                    ? sObjectMgr->GetTrinityString(LANG_CHANNEL_CITY, locale)
                    : current_zone->area_name[locale];
                snprintf(new_channel_name_buf, 200, channel->pattern[locale], nameExt);
                new_channel = cMgr->GetJoinChannel(new_channel_name_buf, channel->ChannelID);
            }

            if (new_channel)
                new_channel->JoinChannel(bot, "");
        }
    }

    PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
    if (!botAI)
    {
        // Log a warning here to indicate that the botAI is null
        //TC_LOG_DEBUG("playerbots", "PlayerbotAI is null for bot with GUID: %u", bot->GetGUID());
        return;
    }

    Player* master = botAI->GetMaster();
    if (!master)
    {
        // Log a warning to indicate that the master is null
        //TC_LOG_DEBUG("playerbots", "Master is null for bot with GUID: %u", bot->GetGUID());
        return;
    }

    Group* group = bot->GetGroup();
    if (group)
    {
        bool groupValid = false;
        Group::MemberSlotList const& slots = group->GetMemberSlots();
        for (Group::MemberSlotList::const_iterator i = slots.begin(); i != slots.end(); ++i)
        {
            ObjectGuid member = i->guid;
            if (master)
            {
                if (master->GetGUID() == member)
                {
                    groupValid = true;
                    break;
                }
            }
            else
            {
                uint32 account = sCharacterCache->GetCharacterAccountIdByGuid(member);
                if (!sPlayerbotAIConfig->IsInRandomAccountList(account))
                {
                    groupValid = true;
                    break;
                }
            }
        }

        if (!groupValid)
        {
            bot->RemoveFromGroup();
        }
    }

    group = bot->GetGroup();
    // ResetStrategies below would race with the map thread's DoNextAction
    // (both touch the same Engine/Strategy lists).  Bots work fine without
    // an explicit reset here — the strategy engine is initialized on first
    // UpdateAI tick.
    //if (group)
    //{
    //    botAI->ResetStrategies();
    //}
    //else
    //{
    //    botAI->ResetStrategies();
    //}

    if (master && !master->HasUnitState(UNIT_STATE_IN_FLIGHT))
    {
        bot->GetMotionMaster()->MovementExpired();
        bot->CleanupAfterTaxiFlight();
    }

    // check activity
    botAI->AllowActivity(ALL_ACTIVITY, true);

    // set delay on login
    botAI->SetNextCheckDelay(urand(2000, 4000));

    botAI->TellMaster("Hello!");

    if (master && master->GetGroup() && !group)
    {
        Group* mgroup = master->GetGroup();
        if (mgroup->GetMembersCount() >= 5)
        {
            if (!mgroup->isRaidGroup() && !mgroup->isLFGGroup() && !mgroup->isBGGroup() && !mgroup->isBFGroup())
            {
                mgroup->ConvertToRaid();
            }
            if (mgroup->isRaidGroup())
            {
                mgroup->AddMember(bot);
            }
        }
        else
        {
            mgroup->AddMember(bot);
        }
    }
    else if (master && !group)
    {
        Group* newGroup = new Group();
        newGroup->Create(master);
        sGroupMgr->AddGroup(newGroup);
        newGroup->AddMember(bot);
    }

    if (master)
    {
        bot->TeleportTo(master->GetMapId(), master->GetPositionX(), master->GetPositionY(), master->GetPositionZ(), master->GetOrientation());
    }

    uint32 accountId = bot->GetSession()->GetAccountId();
    /*bool isRandomAccount = sPlayerbotAIConfig->IsInRandomAccountList(accountId);

    if (isRandomAccount && sPlayerbotAIConfig->randomBotFixedLevel)
    {
        bot->SetPlayerFlag(PLAYER_FLAGS_NO_XP_GAIN);
    }
    else if (isRandomAccount && !sPlayerbotAIConfig->randomBotFixedLevel)
    {
        bot->RemovePlayerFlag(PLAYER_FLAGS_NO_XP_GAIN);
    }*/

    bot->SaveToDB(false);
}

std::string const PlayerbotHolder::ProcessBotCommand(std::string const /*cmd*/, ObjectGuid /*guid*/, ObjectGuid /*masterguid*/,
    bool /*admin*/, uint32 /*masterAccountId*/, uint32 /*masterGuildId*/)
{
    return "unknown command";
}

bool PlayerbotMgr::HandlePlayerbotMgrCommand(ChatHandler* handler, char const* args)
{
    if (!sPlayerbotAIConfig->enabled)
    {
        handler->PSendSysMessage("|cffff0000Playerbot system is currently disabled!");
        return false;
    }

    WorldSession* m_session = handler->GetSession();
    if (!m_session)
    {
        handler->PSendSysMessage("You may only add bots from an active session");
        return false;
    }

    Player* player = m_session->GetPlayer();
    PlayerbotMgr* mgr = GET_PLAYERBOT_MGR(player);
    if (!mgr)
    {
        handler->PSendSysMessage("You cannot control bots yet");
        return false;
    }

    std::vector<std::string> messages = mgr->HandlePlayerbotCommand(args, player);
    if (messages.empty())
        return true;

    for (std::vector<std::string>::iterator i = messages.begin(); i != messages.end(); ++i)
    {
        handler->PSendSysMessage("%s", i->c_str());
    }

    return true;
}

std::vector<std::string> PlayerbotHolder::HandlePlayerbotCommand(char const* args, Player* master)
{
    std::vector<std::string> messages;

    if (!*args)
    {
        messages.push_back("usage: list/add/init/remove PLAYERNAME\n");
        messages.push_back("usage: addclass CLASSNAME\n");
        messages.push_back("usage: setspec TAB (with bot target selected)\n");
        messages.push_back("usage: reequip (with bot target selected) - re-equip selected bot\n");
        messages.push_back("usage: rndbot reequip - re-equip ALL online bots");
        return messages;
    }

    char* cmd = strtok((char*)args, " ");
    char* charname = strtok(nullptr, " ");
    if (!cmd)
    {
        messages.push_back("usage: list/reload/tweak/self or add/init/remove PLAYERNAME or addclass CLASSNAME");
        return messages;
    }

    if (!strcmp(cmd, "list"))
    {
        messages.push_back("Available random bots:");
        for (auto accountId : sPlayerbotAIConfig->randomBotAccounts)
        {
            QueryResult result = CharacterDatabase.PQuery("SELECT guid, name, race, class, level FROM characters WHERE account = %u", accountId);
            if (!result)
                continue;
            do
            {
                Field* fields = result->Fetch();
                uint32 guid = fields[0].GetUInt32();
                std::string name = fields[1].GetString();
                uint8 race = fields[2].GetUInt8();
                uint8 cls = fields[3].GetUInt8();
                uint8 level = fields[4].GetUInt8();
                std::string raceStr = (race == 1 || race == 3 || race == 4 || race == 7 || race == 11 || race == 22) ? "A" : "H";
                bool online = ObjectAccessor::FindPlayer(ObjectGuid(MAKE_NEW_GUID(guid, 0, HIGHGUID_PLAYER))) != nullptr;
                messages.push_back(raceStr + " [" + std::to_string(level) + "] " + name + (online ? " (online)" : ""));
            } while (result->NextRow());
        }
        return messages;
    }

    if (!strcmp(cmd, "add"))
    {
        if (!charname)
        {
            messages.push_back("Usage: add PLAYERNAME");
            return messages;
        }

        QueryResult result = CharacterDatabase.PQuery("SELECT guid, account FROM characters WHERE name = '%s'", charname);
        if (!result)
        {
            messages.push_back("Character not found");
            return messages;
        }
        Field* fields = result->Fetch();
        uint32 guid = fields[0].GetUInt32();
        uint32 accountId = fields[1].GetUInt32();

        if (!sPlayerbotAIConfig->IsInRandomAccountList(accountId))
        {
            messages.push_back("Character is not a random bot");
            return messages;
        }

        ObjectGuid botGuid = ObjectGuid(MAKE_NEW_GUID(guid, 0, HIGHGUID_PLAYER));
        if (ObjectAccessor::FindPlayer(botGuid))
        {
            messages.push_back("Bot is already online");
            return messages;
        }

        AddPlayerBot(botGuid, master->GetSession()->GetAccountId());
        messages.push_back("Bot " + std::string(charname) + " added");
        return messages;
    }

    if (!strcmp(cmd, "addspec") && master)
    {
        if (!charname || !strcmp(charname, "tank") || !strcmp(charname, "dps") || !strcmp(charname, "heal"))
        {
            messages.push_back(
                "addclass: invalid SPECNAME(tank/heal/dps)");
            return messages;
        }
        std::map<std::string, std::vector<uint8>> clazs = {
            {"tank", { 1, 2, 11, 6, 10 }},
            {"heal", { 2, 5, 7, 11, 10 }},
            {"dps", { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }}
        };
    }
    if (!strcmp(cmd, "setspec") && master && master->GetTarget())
    {
        uint32 tab = std::atoi(charname);

        auto bot = ObjectAccessor::FindPlayer(master->GetTarget());
        if (bot)
        {
            PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
            if (botAI)
            {
                // Defer to Map thread: ResetTalents + InitEquipment modify Player
                // UpdateFields and must run on the bot's own Map thread.
                botAI->RequestOp(PlayerbotAI::BOT_OP_SETSPEC, tab);
            }
        }
        return StringVector();
    }

    if (!strcmp(cmd, "reequip") && master)
    {
        Player* target = ObjectAccessor::FindPlayer(master->GetTarget());
        if (!target)
        {
            messages.push_back("Usage: select a bot target, then type: .bot reequip");
            messages.push_back("Or reequip all bots: .bot rndbot reequip");
            return messages;
        }

        if (!GET_PLAYERBOT_AI(target))
        {
            messages.push_back("Target is not a bot");
            return messages;
        }

        // Set flag: the actual reequip runs on the Map thread in UpdateAI,
        // avoiding cross-thread Player object access that causes crashes.
        GET_PLAYERBOT_AI(target)->SetPendingReequip(true);
        messages.push_back(std::string(target->GetName().c_str()) + " reequip scheduled.");
        return messages;
    }

    if (!strcmp(cmd, "rndbot") && master)
    {
        if (!charname)
        {
            messages.push_back("Usage: .bot rndbot reequip - reequip all online bots");
            return messages;
        }

        if (!strcmp(charname, "reequip"))
        {
            uint32 count = 0;
            std::vector<PlayerbotAI*> aiList;

            // Collect bot AI pointers under read lock to prevent iterator invalidation
            // when other threads modify the player map (login/logout) during iteration.
            {
                TRINITY_READ_GUARD(HashMapHolder<Player>::LockType, *HashMapHolder<Player>::GetLock());
                auto const& allPlayers = ObjectAccessor::GetPlayers();
                for (auto const& itr : allPlayers)
                {
                    Player* bot = itr.second;
                    if (!bot || !bot->IsInWorld())
                        continue;
                    PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
                    if (!botAI)
                        continue;
                    aiList.push_back(botAI);
                    count++;
                }

                // Stagger reequip operations with random delays to prevent
                // SMSG_UPDATE_OBJECT packet storms that freeze the client.
                // Spread bots over ~5 bots/second (200ms per bot).
                uint32 maxDelayMs = count * 200;
                if (maxDelayMs < 1000)
                    maxDelayMs = 1000;

                for (PlayerbotAI* botAI : aiList)
                {
                    botAI->SetReequipDelay(urand(0, maxDelayMs));
                    botAI->SetPendingReequip(true);
                }
            }

            std::ostringstream ss;
            uint32 totalSeconds = (count * 200) / 1000;
            if (totalSeconds < 1)
                totalSeconds = 1;
            ss << "Scheduled reequip for " << count << " bot(s) over ~" << totalSeconds << "s. Processing on map thread.";
            messages.push_back(ss.str());
            return messages;
        }

        messages.push_back("Unknown rndbot subcommand. Available: reequip");
        return messages;
    }

    if (!strcmp(cmd, "addclass"))
    {
        if (!charname)
        {
            messages.push_back(
                "addclass: invalid CLASSNAME(warrior/paladin/hunter/rogue/priest/shaman/mage/warlock/druid/dk)");
            return messages;
        }
        uint8 claz;
        if (!strcmp(charname, "warrior"))
        {
            claz = 1;
        }
        else if (!strcmp(charname, "paladin"))
        {
            claz = 2;
        }
        else if (!strcmp(charname, "hunter"))
        {
            claz = 3;
        }
        else if (!strcmp(charname, "rogue"))
        {
            claz = 4;
        }
        else if (!strcmp(charname, "priest"))
        {
            claz = 5;
        }
        else if (!strcmp(charname, "shaman"))
        {
            claz = 7;
        }
        else if (!strcmp(charname, "mage"))
        {
            claz = 8;
        }
        else if (!strcmp(charname, "warlock"))
        {
            claz = 9;
        }
        else if (!strcmp(charname, "druid"))
        {
            claz = 11;
        }
        else if (!strcmp(charname, "dk"))
        {
            claz = 6;
        }
        else if (!strcmp(charname, "monk"))
        {
            claz = 10;
        }
        else
        {
            messages.push_back("Error: Invalid Class. Try again.");
            return messages;
        }
        TeamId teamId = master->GetTeamId();
        GuidVector guidCache = sRandomPlayerbotMgr->AddclassCache()[RandomPlayerbotMgr::GetTeamClassIdx(teamId == TEAM_ALLIANCE, claz)];
        
        std::mt19937 gen(std::chrono::system_clock::now().time_since_epoch().count());
        std::shuffle(guidCache.begin(), guidCache.end(), gen);
        for (size_t i = 0; i < guidCache.size(); i++)
        {
            ObjectGuid guid = guidCache[i];
            if (botLoading.find(guid) != botLoading.end())
                continue;
            if (ObjectAccessor::FindPlayer(guid))
                continue;

            AddPlayerBot(guid, master->GetSession()->GetAccountId());
            // Wait for the bot to finish loading, then defer all Player-modifying
            // operations (Randomize, InitTalentsTree, InitEquipment, TeleportTo) to
            // the bot's Map thread via RequestOp.  The detached thread only polls
            // ObjectAccessor::FindPlayer (lock-protected) and sets an atomic flag —
            // it never touches Player object members directly, preventing the
            // cross-thread data races that produce malformed SMSG_UPDATE_OBJECT
            // packets and freeze the client.
            std::thread([this, master, guid]
            {
                Player* bot = nullptr;
                int max_try = 100;
                do
                {
                    std::this_thread::sleep_for(std::chrono::milliseconds(120));
                    bot = ObjectAccessor::FindPlayer(guid);
                    if (bot) break;
                    --max_try;
                } while (bot == nullptr && max_try > 0);
                if (!bot) return;

                PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
                if (botAI)
                    botAI->RequestOp(PlayerbotAI::BOT_OP_ADDCLASS, master->GetLevel(), master->GetGUID());
            }).detach();
            
            messages.push_back("Add class " + std::string(charname));
            return messages;
        }
        messages.push_back("Add class failed, no available characters!");
        return messages;
    }

    return {};
}

uint32 PlayerbotHolder::GetAccountId(std::string const name) { return AccountMgr::GetId(name); }

uint32 PlayerbotHolder::GetAccountId(ObjectGuid guid)
{
    if (!IS_PLAYER_GUID(guid.GetRawValue()))
        return 0;

    // prevent DB access for online player
    if (Player* player = ObjectAccessor::FindPlayer(guid))
        return player->GetSession()->GetAccountId();

    uint32 lowguid = guid.GetCounter();
    if (QueryResult result = CharacterDatabase.PQuery("SELECT account FROM characters WHERE guid = {}", lowguid))
    {
        uint32 acc = (*result)[0].GetUInt32();
        return acc;
    }

    return 0;
}

std::string const PlayerbotHolder::ListBots(Player* master)
{
    std::set<std::string> bots;
    std::map<uint8, std::string> classNames;

    classNames[CLASS_DEATH_KNIGHT] = "Death Knight";
    classNames[CLASS_DRUID] = "Druid";
    classNames[CLASS_HUNTER] = "Hunter";
    classNames[CLASS_MAGE] = "Mage";
    classNames[CLASS_PALADIN] = "Paladin";
    classNames[CLASS_PRIEST] = "Priest";
    classNames[CLASS_ROGUE] = "Rogue";
    classNames[CLASS_SHAMAN] = "Shaman";
    classNames[CLASS_WARLOCK] = "Warlock";
    classNames[CLASS_WARRIOR] = "Warrior";
    classNames[CLASS_DEATH_KNIGHT] = "DeathKnight";
    classNames[CLASS_MONK] = "Monk";

    std::map<std::string, std::string> online;
    std::vector<std::string> names;
    std::map<std::string, std::string> classes;

    for (PlayerBotMap::const_iterator it = GetPlayerBotsBegin(); it != GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        std::string const name = bot->GetName();
        bots.insert(name);

        names.push_back(name);
        online[name] = "+";
        classes[name] = classNames[bot->GetClass()];
    }

    /*if (master)
    {
        QueryResult results = CharacterDatabase.Query("SELECT class, name FROM characters WHERE account = {}",
            master->GetSession()->GetAccountId());
        if (results)
        {
            do
            {
                Field* fields = results->Fetch();
                uint8 cls = fields[0].Get<uint8>();
                std::string const name = fields[1].Get<std::string>();
                if (bots.find(name) == bots.end() && name != master->GetSession()->GetPlayerName())
                {
                    names.push_back(name);
                    online[name] = "-";
                    classes[name] = classNames[cls];
                }
            } while (results->NextRow());
        }
    }*/

    std::sort(names.begin(), names.end());

    if (Group* group = master->GetGroup())
    {
        Group::MemberSlotList const& groupSlot = group->GetMemberSlots();
        for (Group::member_citerator itr = groupSlot.begin(); itr != groupSlot.end(); itr++)
        {
            Player* member = ObjectAccessor::FindPlayer(itr->guid);
            if (member && sRandomPlayerbotMgr->IsRandomBot(member))
            {
                std::string const name = member->GetName();

                names.push_back(name);
                online[name] = "+";
                classes[name] = classNames[member->GetClass()];
            }
        }
    }

    std::ostringstream out;
    bool first = true;
    out << "Bot roster: ";
    for (std::vector<std::string>::iterator i = names.begin(); i != names.end(); ++i)
    {
        if (first)
            first = false;
        else
            out << ", ";

        std::string const name = *i;
        out << online[name] << name << " " << classes[name];
    }

    return out.str();
}

std::string const PlayerbotHolder::LookupBots(Player* master)
{
    std::list<std::string> messages;
    messages.push_back("Classes Available:");
    messages.push_back("|TInterface\\icons\\INV_Sword_27.png:25:25:0:-1|t Warrior");
    messages.push_back("|TInterface\\icons\\INV_Hammer_01.png:25:25:0:-1|t Paladin");
    messages.push_back("|TInterface\\icons\\INV_Weapon_Bow_07.png:25:25:0:-1|t Hunter");
    messages.push_back("|TInterface\\icons\\INV_ThrowingKnife_04.png:25:25:0:-1|t Rogue");
    messages.push_back("|TInterface\\icons\\INV_Staff_30.png:25:25:0:-1|t Priest");
    messages.push_back("|TInterface\\icons\\inv_jewelry_talisman_04.png:25:25:0:-1|t Shaman");
    messages.push_back("|TInterface\\icons\\INV_staff_30.png:25:25:0:-1|t Mage");
    messages.push_back("|TInterface\\icons\\INV_staff_30.png:25:25:0:-1|t Warlock");
    messages.push_back("|TInterface\\icons\\Ability_Druid_Maul.png:25:25:0:-1|t Druid");
    messages.push_back("DK");
    messages.push_back("Monk");
    messages.push_back("(Usage: .bot lookup CLASS)");
    std::string ret_msg;
    for (std::string msg : messages)
    {
        ret_msg += msg + "\n";
    }
    return ret_msg;
}

uint32 PlayerbotHolder::GetPlayerbotsCountByClass(uint32 cls)
{
    uint32 count = 0;
    for (PlayerBotMap::const_iterator it = GetPlayerBotsBegin(); it != GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        if (bot && bot->IsInWorld() && bot->GetClass() == cls)
        {
            count++;
        }
    }
    return count;
}

PlayerbotMgr::PlayerbotMgr(Player* const master) : PlayerbotHolder(), master(master), lastErrorTell(0) {}

PlayerbotMgr::~PlayerbotMgr()
{
    if (master)
        sPlayerbotsMgr->RemovePlayerBotData(master->GetGUID(), false);
}

void PlayerbotMgr::UpdateAIInternal(uint32 elapsed, bool /*minimal*/)
{
    SetNextCheckDelay(sPlayerbotAIConfig->reactDelay);
    CheckTellErrors(elapsed);
}

void PlayerbotMgr::HandleCommand(uint32 type, std::string const text)
{
    Player* master = GetMaster();
    if (!master)
        return;

    if (text.find(":"/*sPlayerbotAIConfig->commandSeparator*/) != std::string::npos)
    {
        std::vector<std::string> commands;
        split(commands, text, ":"/*sPlayerbotAIConfig->commandSeparator.c_str()*/);
        for (std::vector<std::string>::iterator i = commands.begin(); i != commands.end(); ++i)
        {
            HandleCommand(type, *i);
        }

        return;
    }

    for (PlayerBotMap::const_iterator it = GetPlayerBotsBegin(); it != GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        //if (botAI)
            //botAI->HandleCommand(type, text, master);
    }

    for (PlayerBotMap::const_iterator it = sRandomPlayerbotMgr->GetPlayerBotsBegin();
        it != sRandomPlayerbotMgr->GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        //if (botAI && botAI->GetMaster() == master)
            //botAI->HandleCommand(type, text, master);
    }
}

void PlayerbotMgr::HandleMasterIncomingPacket(WorldPacket const& packet)
{
    for (PlayerBotMap::const_iterator it = GetPlayerBotsBegin(); it != GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        if (!bot)
            continue;
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (botAI)
            botAI->HandleMasterIncomingPacket(packet);
    }

    for (PlayerBotMap::const_iterator it = sRandomPlayerbotMgr->GetPlayerBotsBegin();
        it != sRandomPlayerbotMgr->GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (botAI && botAI->GetMaster() == GetMaster())
            botAI->HandleMasterIncomingPacket(packet);
    }

    switch (packet.GetOpcode())
    {
        // if master is logging out, log out all bots
    case CMSG_LOGOUT_REQUEST:
    {
        LogoutAllBots();
        break;
    }
    // if master cancelled logout, cancel too
    case CMSG_LOGOUT_CANCEL:
    {
        CancelLogout();
        break;
    }
    }
}

void PlayerbotMgr::HandleMasterOutgoingPacket(WorldPacket const& packet)
{
    for (PlayerBotMap::const_iterator it = GetPlayerBotsBegin(); it != GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (botAI)
            botAI->HandleMasterOutgoingPacket(packet);
    }

    for (PlayerBotMap::const_iterator it = sRandomPlayerbotMgr->GetPlayerBotsBegin();
        it != sRandomPlayerbotMgr->GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
        if (botAI && botAI->GetMaster() == GetMaster())
            botAI->HandleMasterOutgoingPacket(packet);
    }
}

void PlayerbotMgr::SaveToDB()
{
    for (PlayerBotMap::const_iterator it = GetPlayerBotsBegin(); it != GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        bot->SaveToDB(false);
    }

    for (PlayerBotMap::const_iterator it = sRandomPlayerbotMgr->GetPlayerBotsBegin();
        it != sRandomPlayerbotMgr->GetPlayerBotsEnd(); ++it)
    {
        Player* const bot = it->second;
        if (GET_PLAYERBOT_AI(bot) && GET_PLAYERBOT_AI(bot)->GetMaster() == GetMaster())
            bot->SaveToDB(false);
    }
}

void PlayerbotMgr::OnBotLoginInternal(Player* const bot)
{
    PlayerbotAI* botAI = GET_PLAYERBOT_AI(bot);
    if (!botAI)
    {
        return;
    }
    botAI->SetMaster(master);
    //botAI->ResetStrategies();

    TC_LOG_INFO("playerbots", "Bot %s logged in - Active spec tab: %u Spec: %u ", bot->GetName().c_str(), (uint32)bot->GetActiveSpec(), (uint32)bot->GetSpecialization());
}

void PlayerbotMgr::OnPlayerLogin(Player* player)
{
    if (!sPlayerbotAIConfig->botAutologin || !player)
        return;

    // Auto-login all of the player's alts as bots (AiPlayerbot.BotAutologin).
    uint32 accountId = player->GetSession()->GetAccountId();
    QueryResult results = CharacterDatabase.PQuery("SELECT name FROM characters WHERE account = %u", accountId);
    if (results)
    {
        std::ostringstream out;
        out << "add ";
        bool first = true;
        do
        {
            Field* fields = results->Fetch();

            if (first)
                first = false;
            else
                out << ",";

            out << fields[0].GetString();
        } while (results->NextRow());

        HandlePlayerbotCommand(out.str().c_str(), player);
    }
}

void PlayerbotMgr::TellError(std::string const botName, std::string const text)
{
    std::set<std::string> names = errors[text];
    if (names.find(botName) == names.end())
    {
        names.insert(botName);
    }
    TC_LOG_DEBUG("playerbots", "TellErro: %s: %s", botName.c_str(), text.c_str());
    errors[text] = names;
}

void PlayerbotMgr::CheckTellErrors(uint32 elapsed)
{
    time_t now = time(nullptr);
    if ((now - lastErrorTell) < sPlayerbotAIConfig->errorDelay / 1000)
        return;

    lastErrorTell = now;

    for (PlayerBotErrorMap::iterator i = errors.begin(); i != errors.end(); ++i)
    {
        std::string const text = i->first;
        std::set<std::string> names = i->second;

        std::ostringstream out;
        bool first = true;
        for (std::set<std::string>::iterator j = names.begin(); j != names.end(); ++j)
        {
            if (!first)
                out << ", ";
            else
                first = false;

            out << *j;
        }

        out << "|cfff00000: " << text;

        //ChatHandler(master->GetSession()).PSendSysMessage(out.str().c_str());
    }

    errors.clear();
}

void PlayerbotsMgr::AddPlayerbotData(Player* player, bool isBotAI)
{
    if (!player)
    {
        return;
    }
    // If the guid already exists in the map, remove it

    if (!isBotAI)
    {
        std::unordered_map<ObjectGuid, PlayerbotAIBase*>::iterator itr = _playerbotsMgrMap.find(player->GetGUID());
        if (itr != _playerbotsMgrMap.end())
        {
            _playerbotsMgrMap.erase(itr);
        }
        PlayerbotMgr* playerbotMgr = new PlayerbotMgr(player);
        ASSERT(_playerbotsMgrMap.emplace(player->GetGUID(), playerbotMgr).second);

        playerbotMgr->OnPlayerLogin(player);
    }
    else
    {
        std::unordered_map<ObjectGuid, PlayerbotAIBase*>::iterator itr = _playerbotsAIMap.find(player->GetGUID());
        if (itr != _playerbotsAIMap.end())
        {
            _playerbotsAIMap.erase(itr);
        }
        PlayerbotAI* botAI = new PlayerbotAI(player);
        ASSERT(_playerbotsAIMap.emplace(player->GetGUID(), botAI).second);
    }
}

void PlayerbotsMgr::RemovePlayerBotData(ObjectGuid const& guid, bool is_AI)
{
    if (is_AI)
    {
        std::unordered_map<ObjectGuid, PlayerbotAIBase*>::iterator itr = _playerbotsAIMap.find(guid);
        if (itr != _playerbotsAIMap.end())
        {
            _playerbotsAIMap.erase(itr);
        }
    }
    else
    {
        std::unordered_map<ObjectGuid, PlayerbotAIBase*>::iterator itr = _playerbotsMgrMap.find(guid);
        if (itr != _playerbotsMgrMap.end())
        {
            _playerbotsMgrMap.erase(itr);
        }
    }
}

PlayerbotAI* PlayerbotsMgr::GetPlayerbotAI(Player* player)
{
    if (!(sPlayerbotAIConfig->enabled) || !player)
    {
        return nullptr;
    }
    // if (player->GetSession()->isLogingOut() || player->IsDuringRemoveFromWorld()) {
    //     return nullptr;
    // }
    auto itr = _playerbotsAIMap.find(player->GetGUID());
    if (itr != _playerbotsAIMap.end())
    {
        if (itr->second->IsBotAI())
            return reinterpret_cast<PlayerbotAI*>(itr->second);
    }

    return nullptr;
}

PlayerbotMgr* PlayerbotsMgr::GetPlayerbotMgr(Player* player)
{
    if (!(sPlayerbotAIConfig->enabled) || !player)
    {
        return nullptr;
    }
    auto itr = _playerbotsMgrMap.find(player->GetGUID());
    if (itr != _playerbotsMgrMap.end())
    {
        if (!itr->second->IsBotAI())
            return reinterpret_cast<PlayerbotMgr*>(itr->second);
    }

    return nullptr;
}
