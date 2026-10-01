/*
* This file is part of the Pandaria 5.4.8 Project. See THANKS file for Copyright information
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

#include "ScriptedCreature.h"
#include "ScriptMgr.h"
#include "SpellAuraEffects.h"
#include "SpellScript.h"
#include "Unit.h"

enum Spells
{
    SPELL_ALGAE                             = 93491,
    SPELL_RAM                               = 93492,
    SPELL_WAKE                              = 93494
};

enum Events
{
    EVENT_ALGAE                             = 1,
    EVENT_RAM                               = 2,
    EVENT_WAKE                              = 3
};

struct boss_mobus : public ScriptedAI
{
    boss_mobus(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        _events.Reset();
    }

    void EnterCombat(Unit* /*who*/) override
    {
        _events.ScheduleEvent(EVENT_ALGAE, 7s);
        _events.ScheduleEvent(EVENT_RAM, 12s);
        _events.ScheduleEvent(EVENT_WAKE, 30s);
    }

    void UpdateAI(uint32 diff) override
    {
        if (!UpdateVictim())
            return;

        _events.Update(diff);

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_ALGAE:
                    if (Unit* target = SelectTarget(SELECT_TARGET_RANDOM, 0, 80.0f, true))
                        DoCast(target, SPELL_ALGAE);

                    _events.ScheduleEvent(EVENT_ALGAE, 12s);
                    break;
                case EVENT_RAM:
                    DoCastVictim(SPELL_RAM);
                    _events.ScheduleEvent(EVENT_RAM, 40s);
                    break;
                case EVENT_WAKE:
                    DoCast(SPELL_WAKE);
                    _events.ScheduleEvent(EVENT_WAKE, 50s);
                    break;
                default:
                    break;
            }
        }

        DoMeleeAttackIfReady();
    }

private:
    EventMap _events;
};

void AddSC_boss_mobus()
{
    new creature_script<boss_mobus>("boss_mobus");
}
