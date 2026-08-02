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

    // The inviter is the leader of the pending invite group
    // (set by Group::AddLeaderInvite when the invite was created).
    ObjectGuid leaderGuid = grp->GetLeaderGUID();
    Player* inviter = leaderGuid ? ObjectAccessor::FindPlayer(leaderGuid) : nullptr;
    if (!inviter)
        return false;

    WorldPacket p;
    uint8 unk = 0;
    p << unk;
    p.WriteBit(true);
    p.WriteBit(true);
    p.FlushBits();
    bot->GetSession()->HandleGroupInviteResponseOpcode(p);

    if (sRandomPlayerbotMgr->IsRandomBot(bot))
        botAI->SetMaster(inviter);

    botAI->ResetStrategies();
    botAI->ChangeStrategy("+follow,-lfg,-bg", BOT_STATE_NON_COMBAT);
    botAI->Reset();

    if (bot->GetDistance(inviter) > sPlayerbotAIConfig->sightDistance)
    {
        //Teleport(inviter, bot);
    }
    return true;
}
