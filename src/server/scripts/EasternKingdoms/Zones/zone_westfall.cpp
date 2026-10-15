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

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "SpellScript.h"
#include "SharedDefines.h"
#include "Unit.h"

enum HoboGossipData
{
    GOSSIP_MENU_ID_HOBO                               = 11635,

    GOSSIP_MENU_OPTION_QUESTION                       = 0,
    GOSSIP_MENU_OPTION_PAY                            = 1
};

enum HoboQuest
{
    QUEST_MURDER_WAS_THE_CASE_THAT_THEY_GAVE_ME       = 26209
};

enum HoboQuestObjective
{
    CLUE_1                                            = 0,
    CLUE_2                                            = 1,
    CLUE_3                                            = 2,
    CLUE_4                                            = 3
};

enum HoboSpell
{
    SPELL_HOBO_INFORMATION_1                          = 79181,
    SPELL_HOBO_INFORMATION_2                          = 79182,
    SPELL_HOBO_INFORMATION_3                          = 79183,
    SPELL_HOBO_INFORMATION_4                          = 79184,
    SPELL_SUMMON_RAGAMUFFIN_LOOTER                    = 79169,
    SPELL_SUMMON_RAGAMUFFIN_LOOTER_1                  = 79170,
    SPELL_SUMMON_RAGAMUFFIN_LOOTER_2                  = 79171,
    SPELL_SUMMON_RAGAMUFFIN_LOOTER_3                  = 79172,
    SPELL_SUMMON_RAGAMUFFIN_LOOTER_4                  = 79173,
    SPELL_AGGRO_HOBO                                  = 79168,
    SPELL_ROOT_SELF_PERMANENT                         = 125467
};

enum HoboText
{
    SAY_CLUE_1                                        = 0,
    SAY_CLUE_2                                        = 1,
    SAY_CLUE_3                                        = 2,
    SAY_CLUE_4                                        = 3,
    SAY_AGGRO_BRIBE                                   = 4,
    SAY_AGGRO_CONVINCE                                = 5,
    SAY_EVENT                                         = 6,
    SAY_JACKPOT_INTRO                                 = 7,
    SAY_JACKPOT_END                                   = 8,
    SAY_PROPERTY_RAGE                                 = 9,
    SAY_FLEE                                          = 10
};

enum HoboEvent
{
    EVENT_TALK                                        = 1,
    EVENT_JACKPOT_INTRO                               = 2,
    EVENT_CRY                                         = 3,
    EVENT_PROPERTY_RAGE                               = 4,
    EVENT_JACKPOT_MIDDLE                              = 5,
    EVENT_JACKPOT_END                                 = 6,
    EVENT_RESUME_MOVE                                 = 7,
    EVENT_GROUP_OOC                                   = 1
};

enum HoboCreature
{
    NPC_HOMELESS_STORMWIND_CITIZEN_1                  = 42386,
    NPC_HOMELESS_STORMWIND_CITIZEN_2                  = 42384,
    NPC_WEST_PLAINS_DRIFTER                           = 42391,
    NPC_TRANSIENT                                     = 42383
};

enum HoboAction
{
    ACTION_AGGRO_HOBO                                 = 1,
    ACTION_AGGRO_HOBO_DONE                            = 2
};

class npc_westfall_hobo_witness : public CreatureScript
{
public:
    npc_westfall_hobo_witness() : CreatureScript("npc_westfall_hobo_witness") { }

    struct npc_westfall_hobo_witnessAI : public ScriptedAI
    {
        npc_westfall_hobo_witnessAI(Creature* creature) : ScriptedAI(creature), _bribeFailed(false), _hoboRage(false), _flee(false) { }

        void GiveClue(Player* player)
        {
            if (!player)
                return;

            _events.CancelEventGroup(EVENT_GROUP_OOC);
            me->SetFacingToObject(player);

            uint16 slot = player->FindQuestSlot(QUEST_MURDER_WAS_THE_CASE_THAT_THEY_GAVE_ME);

            if (player->GetQuestSlotCounter(slot, CLUE_1) == 0)
            {
                player->CastSpell(player, SPELL_HOBO_INFORMATION_1);
                Talk(SAY_CLUE_1, player);
                me->DespawnOrUnsummon(12000);
                return;
            }

            if (player->GetQuestSlotCounter(slot, CLUE_2) == 0)
            {
                player->CastSpell(player, SPELL_HOBO_INFORMATION_2);
                Talk(SAY_CLUE_2, player);
                me->DespawnOrUnsummon(12000);
                return;
            }

            if (player->GetQuestSlotCounter(slot, CLUE_3) == 0)
            {
                player->CastSpell(player, SPELL_HOBO_INFORMATION_3);
                Talk(SAY_CLUE_3, player);
                me->DespawnOrUnsummon(12000);
                return;
            }

            if (player->GetQuestSlotCounter(slot, CLUE_4) == 0)
            {
                player->CastSpell(player, SPELL_HOBO_INFORMATION_4);
                Talk(SAY_CLUE_4, player);
                me->DespawnOrUnsummon(12000);
                return;
            }
        }

        void EnterCombat(Unit* who) override
        {
            me->SetAIAnimKitId(0);
            me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
            _events.CancelEventGroup(EVENT_GROUP_OOC);

            if (!who->IsPlayer())
                return;

            Talk(_bribeFailed ? SAY_AGGRO_BRIBE : SAY_AGGRO_CONVINCE, who);
        }

        void DamageTaken(Unit* /*attacker*/, uint32& damage) override
        {
            if (!_flee && me->HealthBelowPctDamaged(20, damage))
            {
                _flee = true;
                me->DoFleeToGetAssistance();
                Talk(SAY_FLEE);
            }
        }

        void JustDied(Unit* who) override
        {
            if (who && who->IsCreature() && who->ToCreature()->IsAIEnabled)
                who->ToCreature()->AI()->DoAction(ACTION_AGGRO_HOBO_DONE);

            me->CastSpell(me, SPELL_SUMMON_RAGAMUFFIN_LOOTER);
        }

        void Reset() override
        {
            ScriptedAI::Reset();
            _events.Reset();
            _bribeFailed = false;
            _hoboRage = false;
            _flee = false;
            me->SetFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
            me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC);
            _events.ScheduleEvent(EVENT_RESUME_MOVE, 0, EVENT_GROUP_OOC);
        }

        void DoAction(int32 action) override
        {
            switch (action)
            {
                case ACTION_AGGRO_HOBO:
                    if (Unit* target = ObjectAccessor::GetUnit(*me, _targetGUID))
                    {
                        _hoboRage = true;
                        me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
                        me->StopMoving();
                        me->SetFacingToObject(target);
                        AttackStart(target);
                    }
                    break;
                case ACTION_AGGRO_HOBO_DONE:
                    _hoboRage = false;
                    break;
                default:
                    return;
            }
        }

        void SetGUID(uint64 guid, int32 /*id*/) override
        {
            _targetGUID = guid;
            DoAction(ACTION_AGGRO_HOBO);
        }

        void UpdateAI(uint32 diff) override
        {
            _events.Update(diff);

            while (uint32 eventId = _events.ExecuteEvent())
            {
                switch (eventId)
                {
                    case EVENT_TALK:
                        me->AddAura(SPELL_ROOT_SELF_PERMANENT, me);
                        Talk(SAY_EVENT);
                        _events.ScheduleEvent(EVENT_RESUME_MOVE, 6s, EVENT_GROUP_OOC);
                        break;
                    case EVENT_JACKPOT_INTRO:
                        me->AddAura(SPELL_ROOT_SELF_PERMANENT, me);
                        Talk(SAY_JACKPOT_INTRO);
                        _events.ScheduleEvent(EVENT_JACKPOT_MIDDLE, 2s + 500ms, EVENT_GROUP_OOC);
                        break;
                    case EVENT_JACKPOT_MIDDLE:
                        me->SetAIAnimKitId(648);
                        Talk(SAY_JACKPOT_END);
                        _events.ScheduleEvent(EVENT_JACKPOT_END, 6s, EVENT_GROUP_OOC);
                        break;
                    case EVENT_JACKPOT_END:
                        me->SetAIAnimKitId(0);
                        _events.ScheduleEvent(EVENT_RESUME_MOVE, 4s, EVENT_GROUP_OOC);
                        break;
                    case EVENT_CRY:
                        me->HandleEmoteCommand(EMOTE_ONESHOT_CRY);
                        me->AddAura(SPELL_ROOT_SELF_PERMANENT, me);
                        _events.ScheduleEvent(EVENT_RESUME_MOVE, 2s, EVENT_GROUP_OOC);
                        break;
                    case EVENT_PROPERTY_RAGE:
                    {
                        uint32 creatureId = RAND(NPC_HOMELESS_STORMWIND_CITIZEN_1, NPC_HOMELESS_STORMWIND_CITIZEN_2, NPC_WEST_PLAINS_DRIFTER, NPC_TRANSIENT);

                        if (Creature* creature = GetClosestCreatureWithEntry(me, creatureId, 25.0f))
                        {
                            if (!creature->IsAlive() || creature->IsInCombat())
                            {
                                _events.ScheduleEvent(EVENT_RESUME_MOVE, 0, EVENT_GROUP_OOC);
                                return;
                            }

                            _hoboRage = true;
                            Talk(SAY_PROPERTY_RAGE);
                            me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
                            me->StopMoving();
                            me->CastSpell(creature, SPELL_AGGRO_HOBO, true);
                            me->SetFacingToObject(creature);
                        }
                        else
                            _events.ScheduleEvent(EVENT_RESUME_MOVE, 0, EVENT_GROUP_OOC);
                        break;
                    }
                    case EVENT_RESUME_MOVE:
                        me->RemoveAura(SPELL_ROOT_SELF_PERMANENT);

                        if (roll_chance_i(50))
                        {
                            if (roll_chance_i(70))
                                _events.ScheduleEvent(EVENT_TALK, randtime(30s, 80s), EVENT_GROUP_OOC);
                            else
                                _events.ScheduleEvent(urand(EVENT_JACKPOT_INTRO, EVENT_PROPERTY_RAGE), randtime(30s, 80s), EVENT_GROUP_OOC);
                        }
                        else
                            _events.ScheduleEvent(EVENT_RESUME_MOVE, randtime(30s, 80s));
                        break;
                    default:
                        break;
                }
            }

            if (!_hoboRage)
                if (!UpdateVictim())
                    return;

            DoMeleeAttackIfReady();
        }

        void sGossipSelect(Player* player, uint32 sender, uint32 action) override
        {
            uint8 clueGainChance = 0;

            if (sender == GOSSIP_MENU_ID_HOBO && action == GOSSIP_MENU_OPTION_QUESTION)
            {
                clueGainChance = 25;
            }

            if (sender == GOSSIP_MENU_ID_HOBO && action == GOSSIP_MENU_OPTION_PAY)
            {
                clueGainChance = 75;
                _bribeFailed = true;
            }

            me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
            CloseGossipMenuFor(player);

            if (roll_chance_i(clueGainChance))
                GiveClue(player);
            else
            {
                me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_FLAG_IMMUNE_TO_PC);
                AttackStart(player);
            }
        }

    private:
        EventMap _events;
        uint64 _targetGUID;
        bool _bribeFailed;
        bool _hoboRage;
        bool _flee;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_westfall_hobo_witnessAI(creature);
    }
};

// Summon Ragamuffin Looter 79169
class spell_westfall_summon_ragamuffin_looter : public SpellScript
{
    PrepareSpellScript(spell_westfall_summon_ragamuffin_looter);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        if (!sSpellMgr->GetSpellInfo(SPELL_SUMMON_RAGAMUFFIN_LOOTER_1) ||
            !sSpellMgr->GetSpellInfo(SPELL_SUMMON_RAGAMUFFIN_LOOTER_2) ||
            !sSpellMgr->GetSpellInfo(SPELL_SUMMON_RAGAMUFFIN_LOOTER_3) ||
            !sSpellMgr->GetSpellInfo(SPELL_SUMMON_RAGAMUFFIN_LOOTER_4))
            return false;
        return true;
    }

    void HandleScript(SpellEffIndex /*effIndex*/)
    {
        Unit* caster = GetCaster();
        caster->CastSpell(caster, SPELL_SUMMON_RAGAMUFFIN_LOOTER_1, true);
        caster->CastSpell(caster, SPELL_SUMMON_RAGAMUFFIN_LOOTER_2, true);
        caster->CastSpell(caster, SPELL_SUMMON_RAGAMUFFIN_LOOTER_3, true);
        caster->CastSpell(caster, SPELL_SUMMON_RAGAMUFFIN_LOOTER_4, true);
    }

    void Register() override
    {
        OnEffectLaunch += SpellEffectFn(spell_westfall_summon_ragamuffin_looter::HandleScript, EFFECT_0, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

// Aggro Hobo 79168
class spell_westfall_aggro_hobo : public SpellScript
{
    PrepareSpellScript(spell_westfall_aggro_hobo);

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        if (Creature* creature = GetHitCreature())
            if (creature->IsAIEnabled)
                creature->AI()->SetGUID(GetCaster()->GetGUID(), 0);
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_westfall_aggro_hobo::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

// Unbound Energy 79084
class spell_westfall_unbound_energy : public SpellScript
{
    PrepareSpellScript(spell_westfall_unbound_energy);

    void FilterTargets(std::list<WorldObject*>& targets)
    {
        if (targets.empty())
            return;

        Unit* caster = GetCaster();
        targets.remove_if([caster](WorldObject const* target)->bool
        {
            return caster == target;
        });

        if (targets.size() > 1)
            Trinity::Containers::RandomResizeList(targets, 1);
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_westfall_unbound_energy::FilterTargets, EFFECT_0, TARGET_UNIT_SRC_AREA_ENTRY);
    }
};

// Wake Harvest Golem 79436
class spell_westfall_wake_harvest_golem : public SpellScript
{
    PrepareSpellScript(spell_westfall_wake_harvest_golem);

    void HandleHit(SpellEffIndex effIndex)
    {
        if (Player* caster = GetCaster()->ToPlayer())
            caster->KilledMonsterCredit(GetSpellInfo()->Effects[EFFECT_1].MiscValue);
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_westfall_wake_harvest_golem::HandleHit, EFFECT_0, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

// Quest Credit: Jangolode Event 79275
class spell_westfall_quest_credit_jangolode_event : public SpellScript
{
    PrepareSpellScript(spell_westfall_quest_credit_jangolode_event);

    void HandleScriptEffect(SpellEffIndex /*effIndex*/)
    {
        GetHitUnit()->ExitVehicle();
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_westfall_quest_credit_jangolode_event::HandleScriptEffect, EFFECT_1, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

void AddSC_westfall()
{
    new npc_westfall_hobo_witness();
    new spell_script<spell_westfall_summon_ragamuffin_looter>("spell_westfall_summon_ragamuffin_looter");
    new spell_script<spell_westfall_aggro_hobo>("spell_westfall_aggro_hobo");
    new spell_script<spell_westfall_unbound_energy>("spell_westfall_unbound_energy");
    new spell_script<spell_westfall_wake_harvest_golem>("spell_westfall_wake_harvest_golem");
    new spell_script<spell_westfall_quest_credit_jangolode_event>("spell_westfall_quest_credit_jangolode_event");
}
