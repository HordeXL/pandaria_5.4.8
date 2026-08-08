#include "AcceptInvitationAction.h"

#include "Event.h"
#include "Group.h"
#include "ObjectAccessor.h"
#include "PlayerbotAIConfig.h"
#include "Playerbots.h"
#include "WorldPacket.h"
#include "WorldSession.h"

AcceptInvitationAction::AcceptInvitationAction(PlayerbotAI* botAI, std::string const name)
    : Action(botAI, name)
{
}

bool AcceptInvitationAction::Execute(Event /*event*/)
{
    Group* grp = bot->GetGroupInvite();
    if (!grp)
        return false;

    // If the bot is the group leader of the pending invite (i.e. the bot
    // invited itself when creating a group), silently skip - nothing to do.
    if (grp->GetLeaderGUID() == bot->GetGUID())
    {
        bot->SetGroupInvite(nullptr);
        return false;
    }

    // Cross-map invite: teleport to the leader's map first, then accept on a
    // later tick once the teleport finished. Accepting while m_currMap still
    // points at the old map makes Group::BroadcastGroupUpdate hit
    // "WorldObject::AddToUpdate - invalid map".
    Player* leader = ObjectAccessor::FindPlayer(grp->GetLeaderGUID());
    if (leader && leader->IsInWorld() && leader->GetMapId() != bot->GetMapId())
    {
        if (!bot->IsBeingTeleported())
        {
            bot->TeleportTo(leader->GetMapId(), leader->GetPositionX(), leader->GetPositionY(), leader->GetPositionZ(), leader->GetOrientation());
        }
        // Keep re-checking while the teleport is in flight (cross-map teleports
        // can take longer than one tick); once the bot arrives on the leader's
        // map, this action accepts the invite normally on the next evaluation.
        botAI->SetNextCheckDelay(3000);
        return true;
    }

    TC_LOG_INFO("playerbots", "AcceptInvitation: bot %s accepting invite", bot->GetName().c_str());

    // NOTE: We MUST NOT invoke the opcode handler directly on this thread.
    // This code runs inside a Map::Update worker thread where the thread_local
    // `CurrentMap` points to this bot's map.  Directly calling
    // HandleGroupInviteResponseOpcode triggers group->BroadcastGroupUpdate()
    // which iterates every group member and calls ForceValuesUpdateAtIndex ->
    // AddToUpdate.  For members on a DIFFERENT map, AddToUpdate either
    //
    //  1. logs "invalid map..." and returns (if we leave CurrentMap intact), OR
    //  2. if we try to hack around the check by temporarily clearing CurrentMap,
    //     we end up calling m_currMap->AddUpdateObject from the WRONG map's
    //     worker thread.  That is a race on Map::m_objectsToUpdate (no lock)
    //     which corrupts the vector, produces malformed SMSG_UPDATE_OBJECT
    //     packets and freezes the receiving client.
    //
    // The correct and architecture-compliant path is to enqueue the incoming
    // packet on the bot's WorldSession.  The world thread (single consumer of
    // _recvQueue) will run the handler with CurrentMap==nullptr which keeps
    // the original cross-map guard semantics in AddToUpdate perfectly safe.
    //
    // Because the packet is processed asynchronously we cannot observe the
    // bot's new group / new master on this tick.  PlayerbotAI's UpdateMaster
    // loop (PlayerbotAI.cpp ~line 970-1047) already contains the logic to
    // promote the first real player in the group (or the leader) to master,
    // reset strategies and switch to "+follow" once the bot has actually
    // joined the group, so no additional bookkeeping is required here.
    {
        WorldPacket* p = new WorldPacket(CMSG_GROUP_INVITE_RESPONSE, 1 + 2);
        uint8 unk = 0;
        *p << unk;
        p->WriteBit(true);
        p->WriteBit(true);
        p->FlushBits();
        bot->GetSession()->QueuePacket(p);
    }

    return true;
}
