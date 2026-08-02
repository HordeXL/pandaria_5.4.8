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

    // Accept the invite (synchronous, bot joins the group).
    WorldPacket p;
    uint8 unk = 0;
    p << unk;
    p.WriteBit(true);
    p.WriteBit(true);
    p.FlushBits();
    bot->GetSession()->HandleGroupInviteResponseOpcode(p);

    // After accepting, set the group leader as master.  Do not rely on
    // GetLeaderGUID() before accepting: when the inviter already has a group
    // the pending invite group's leader is the *original* leader, not the
    // inviter, and FindPlayer may fail (offline/different map).
    if (sRandomPlayerbotMgr->IsRandomBot(bot))
    {
        if (Player* groupMaster = botAI->GetGroupMaster())
            botAI->SetMaster(groupMaster);
    }

    botAI->ResetStrategies();
    botAI->ChangeStrategy("+follow,-lfg,-bg", BOT_STATE_NON_COMBAT);
    botAI->Reset();

    return true;
}
