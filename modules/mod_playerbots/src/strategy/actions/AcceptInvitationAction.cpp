#include "AcceptInvitationAction.h"

#include "Event.h"
#include "Group.h"
#include "ObjectAccessor.h"
#include "PlayerbotAIConfig.h"
#include "Playerbots.h"
#include "WorldPacket.h"

AcceptInvitationAction::AcceptInvitationAction(PlayerbotAI* botAI, const std::string name)
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

    // Accept the invite (synchronous, bot joins the group).
    WorldPacket p;
    uint8 unk = 0;
    p << unk;
    p.WriteBit(true);
    p.WriteBit(true);
    p.FlushBits();
    bot->GetSession()->HandleGroupInviteResponseOpcode(p);

    // After accepting, set the group leader as master. Look up the leader
    // directly from the group rather than via GetGroupMaster() which has
    // fallback logic that may return the old master.
    if (sRandomPlayerbotMgr->IsRandomBot(bot))
    {
        Player* groupMaster = nullptr;
        if (Group* group = bot->GetGroup())
            groupMaster = ObjectAccessor::FindPlayer(group->GetLeaderGUID());

        if (groupMaster)
        {
            botAI->SetMaster(groupMaster);
            TC_LOG_INFO("playerbots", "AcceptInvitation: bot %s now has master %s", bot->GetName().c_str(), groupMaster->GetName().c_str());
        }
        else
            TC_LOG_INFO("playerbots", "AcceptInvitation: bot %s COULD NOT SET MASTER - group leader not found", bot->GetName().c_str());
    }

    botAI->ResetStrategies();
    botAI->ChangeStrategy("+follow,-lfg,-bg", BOT_STATE_NON_COMBAT);
    botAI->Reset();

    return true;
}
