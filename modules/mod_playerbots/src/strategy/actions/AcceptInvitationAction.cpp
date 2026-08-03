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
