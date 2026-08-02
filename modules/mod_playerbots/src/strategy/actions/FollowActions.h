#ifndef _PLAYERBOT_FOLLOWACTIONS_H
#define _PLAYERBOT_FOLLOWACTIONS_H

#include "MovementActions.h"

class PlayerbotAI;

class FollowAction : public MovementAction
{
public:
    FollowAction(PlayerbotAI* botAI, std::string const name = "follow") : MovementAction(botAI, name) {}

    bool Execute(Event event) override;
    bool isUseful() override;
    bool CanDeadFollow(Unit* target);
};

class FleeToMasterAction : public FollowAction
{
public:
    FleeToMasterAction(PlayerbotAI* botAI) : FollowAction(botAI, "flee to master") {}

    bool Execute(Event event) override;
    bool isUseful() override;
};

class InviteNearbyAction : public Action
{
public:
    InviteNearbyAction(PlayerbotAI* botAI) : Action(botAI, "invite nearby") {}

    bool Execute(Event event) override;
};

class InviteGuildAction : public Action
{
public:
    InviteGuildAction(PlayerbotAI* botAI) : Action(botAI, "invite guild") {}

    bool Execute(Event event) override;
};

#endif
