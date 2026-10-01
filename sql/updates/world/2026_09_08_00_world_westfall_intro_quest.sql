DELETE FROM `creature_questender` WHERE `id` = 42309 AND `quest` = 184;

DELETE FROM `spell_area` WHERE `spell` = 79489 AND `area` = 40;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_status`, `quest_end_status`) VALUES
(79489, 40, 0, 0, 0, 0, 2, 1, 64, 11);

UPDATE `quest_template` SET `NextQuestId` = 0 WHERE `Id` IN (26378, 28562);
UPDATE `quest_template` SET `PrevQuestId` = 26209 WHERE `Id` IN (26213, 26214);

DELETE FROM `conditions` WHERE `SourceEntry` IN (26378, 28562, 26209) AND `SourceGroup` = 0 AND `SourceTypeOrReferenceId` = 19;
DELETE FROM `conditions` WHERE `SourceEntry` IN (5983, 42384, 42386) AND `SourceGroup` = 1 AND `SourceTypeOrReferenceId` = 22;
DELETE FROM `conditions` WHERE `SourceEntry` IN (0, 1) AND `SourceGroup` = 11635 AND `SourceTypeOrReferenceId` = 15;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 1, 5983, 2, 0, 14, 0, 26209, 0, 0, 0, 0, 0, "", "If Invoker has never finished, not has active quest 'Murder Was The Case That They Gave Me'"),
(19, 0, 26378, 0, 0, 8, 0, 26209, 0, 0, 1, 0, 0, "", "Checks if Player has not been rewarded quest"),
(19, 0, 28562, 0, 0, 8, 0, 26209, 0, 0, 1, 0, 0, "", "Checks if Player has not been rewarded quest"),
(19, 0, 26209, 0, 0, 28, 0, 184, 0, 0, 1, 0, 0, "", "Quest 'Murder Was The Case That They Gave Me' available if quest 'Furlbrow's Deed' has not been completed."),
(19, 0, 26209, 0, 0, 28, 0, 26378, 0, 0, 1, 0, 0, "", "Quest 'Murder Was The Case That They Gave Me' available if quest 'Hero's Call Westfall!' has not been completed."),
(15, 11635, 0, 0, 0, 9, 0, 26209, 0, 0, 0, 0, 0, "", "Show gossip menu 11635 option id 0 if quest Murder Was The Case That They Gave Me has been taken."),
(15, 11635, 0, 0, 0, 28, 0, 26209, 0, 0, 1, 0, 0, "", "Show gossip menu 11635 option id 0 if quest Murder Was The Case That They Gave Me has not been completed."),
(15, 11635, 1, 0, 0, 9, 0, 26209, 0, 0, 0, 0, 0, "", "Show gossip menu 11635 option id 1 if quest Murder Was The Case That They Gave Me has been taken."),
(15, 11635, 1, 0, 0, 28, 0, 26209, 0, 0, 1, 0, 0, "", "Show gossip menu 11635 option id 1 if quest Murder Was The Case That They Gave Me has not been completed.");

UPDATE `creature_template` SET `npcflag` = 0 WHERE `entry` IN (42391, 42384, 42386, 42383);
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 214948 AND `id` = 42391;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215063 AND `id` = 42391;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215064 AND `id` = 42384;
UPDATE `creature` SET `position_x` = -9806.317383, `position_y` = 975.031555, `position_z` = 29.130316, `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215037 AND `id` = 42391;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215035 AND `id` = 42386;
UPDATE `creature` SET `position_x` = -9834.652344, `position_y` = 956.962891, `position_z` = 29.130316, `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215014 AND `id` = 42391;
UPDATE `creature` SET `position_x` = -9810.663086, `position_y` = 1006.39679, `position_z` = 29.130316, `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215034 AND `id` = 42386;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215032 AND `id` = 42386;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215036 AND `id` = 42384;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215057 AND `id` = 42386;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215043 AND `id` = 42386;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215030 AND `id` = 42383;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215038 AND `id` = 42383;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215031 AND `id` = 42383;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 215044 AND `id` = 42384;
UPDATE `creature` SET `npcflag` = 1, `wander_distance` = 10, `movement_type` = 1, `ScriptName` = "npc_westfall_hobo_witness" WHERE `guid` = 214934 AND `id` = 42384;

UPDATE `creature` SET `wander_distance` = 7, `movement_type` = 1 WHERE `guid` IN (214353, 214355, 214356, 214360);
DELETE FROM `creature_addon` WHERE `guid` IN (214353, 214355, 214356, 214360);
INSERT INTO `creature_addon` (`guid`, `auras`) VALUES
(214353, "79488"),
(214355, "79488"),
(214356, "79488"),
(214360, "79488");
DELETE FROM `waypoint_data` WHERE `id` IN (214353, 214355);

DELETE FROM `creature_addon` WHERE `guid` IN (214357, 214354);
INSERT INTO `creature_addon` (`guid`, `bytes1`, `bytes2`, `auras`) VALUES
(214357, 65544, 4097, "79488"),
(214354, 65544, 4097, "79488");

DELETE FROM `creature_addon` WHERE `guid` IN (215064, 215035, 215034, 215032, 215036, 215057, 215043, 215030, 215031, 215044, 214934);
INSERT INTO `creature_addon` (`guid`, `bytes2`) VALUES
(215064, 4097),(215035, 4097),(215034, 4097),
(215032, 4097),(215036, 4097),(215057, 4097),
(215043, 4097),(215044, 4097),(214934, 4097);

DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` = 42413);
DELETE FROM `creature` WHERE `guid` IN (215039, 215040, 215041, 215042, 215045, 215046, 215047, 215048, 215058, 215059, 215060, 215061) AND `id` = 42413;

DELETE FROM `waypoint_data` WHERE `id` IN (215032, 215030, 215031);

DELETE FROM `areatrigger_scripts` WHERE `entry` = 5983;
INSERT INTO `areatrigger_scripts` (`entry`, `ScriptName`) VALUES
(5983, "SmartTrigger");

DELETE FROM `spell_script_names` WHERE `spell_id` IN (79168, 79169);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(79168, "spell_westfall_aggro_hobo"),
(79169, "spell_westfall_summon_ragamuffin_looter");

UPDATE `gossip_menu_option` SET `option_id` = 1, `npc_option_npcflag` = 1 WHERE `menu_id` = 11635 AND `id` = 1;
UPDATE `gossip_menu_option` SET `option_id` = 1, `npc_option_npcflag` = 1 WHERE `menu_id` = 11635 AND `id` = 0;

UPDATE `creature_template` SET `AIName` = "SmartAI" WHERE `entry` IN (42308, 42309, 42413);
UPDATE `creature_template` SET `AIName` = "" WHERE `entry` IN (42383, 42384, 42386, 42391);
UPDATE `creature_template` SET `unit_flags` = 33536 WHERE `entry` = 42413;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 5983 AND `source_type` = 2;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (42308, 42309, 42383, 42384, 42386, 42391, 42413) AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (42308*100, 26209*100, 26209*100+01, 26209*100+02, 26209*100+03, 26209*100+04, 26209*100+05, 26209*100+06) AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(5983, 2, 0, 0, 46, 0, 100, 0, 5983, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 10, 214362, 42308, 0, 0, 0, 0, 0, "Areatrigger - On Trigger - Set Data 1 1 (Lieutenant Horatio Laine)"),

(42308, 0, 0, 1, 38, 0, 100, 0, 1, 1, 120000, 120000, 59, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Data Set 1 1 - Set Run Off"),
(42308, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 80, 42308*100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Data Set 1 1 (Link) - Start Script"),
(42308, 0, 2, 0, 34, 0, 100, 0, 8, 1, 0, 0, 90, 8, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On MI 1 - Set Unit Field Bytes 1 (8)"),
(42308, 0, 3, 0, 34, 0, 100, 0, 8, 2, 0, 0, 66, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On MI 2 - Set Orientation"),

(42308*100, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 10, 214357, 42309, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Set Data 1 0 (Stormwind Investigator)"),
(42308*100, 9, 1, 0, 0, 0, 100, 0, 7000, 7000, 0, 0, 45, 1, 1, 0, 0, 0, 0, 10, 214357, 42309, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Set Data 1 1 (Stormwind Investigator)"),
(42308*100, 9, 2, 0, 0, 0, 100, 0, 7000, 7000, 0, 0, 45, 2, 1, 0, 0, 0, 0, 10, 214354, 42309, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Set Data 2 1 (Stormwind Investigator)"),
(42308*100, 9, 3, 0, 0, 0, 100, 0, 6000, 6000, 0, 0, 69, 1, 0, 0, 0, 0, 0, 8, 0, 0, 0, -9851.94, 910.24, 29.9428, 0, "Lieutenant Horatio Laine - On Script - Move To Position (1)"),
(42308*100, 9, 4, 0, 0, 0, 100, 0, 150, 150, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Say Text Line 0"),
(42308*100, 9, 5, 0, 0, 0, 100, 0, 5000, 5000, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Say Text Line 1"),
(42308*100, 9, 6, 0, 0, 0, 100, 0, 1500, 1500, 0, 0, 85, 78935, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Cast Spell 'Horatio's Sunglasses'"),
(42308*100, 9, 7, 0, 0, 0, 100, 0, 2300, 2300, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Say Text Line 2"),
(42308*100, 9, 8, 0, 0, 0, 100, 0, 10500, 10500, 0, 0, 69, 2, 0, 0, 0, 0, 0, 8, 0, 0, 0, -9849.856, 914.9618, 30.27025, 0, "Lieutenant Horatio Laine - On Script - Move To Position (2)"),
(42308*100, 9, 9, 0, 0, 0, 100, 0, 0, 0, 0, 0, 91, 8, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Remove Unit Field Bytes 1 (8)"),
(42308*100, 9, 10, 0, 0, 0, 100, 0, 0, 0, 0, 0, 28, 78935, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Lieutenant Horatio Laine - On Script - Remove Aura Due To Spell 'Horatio's Sunglasses'"),

(42309, 0, 0, 0, 38, 0, 100, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "Stormwind Investigator - On Data Set 1 0 - Say Text Line 0"),
(42309, 0, 1, 0, 38, 0, 100, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "Stormwind Investigator - On Data Set 1 1 - Say Text Line 1"),
(42309, 0, 2, 0, 38, 0, 100, 0, 2, 1, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "Stormwind Investigator - On Data Set 1 2 - Say Text Line 2"),

(42413, 0, 0, 1, 54, 0, 100, 0, 0, 0, 0, 0, 66, 0, 0, 0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, "Ragamuffin - On Just Summoned - Set Orientation (Owner Or Summoner)"),
(42413, 0, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 67, 0, 2500, 2500, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, "Ragamuffin - On Just Summoned (Link) - Create Timed Event (0)"),
(42413, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 67, 1, 10000, 10000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, "Ragamuffin - On Just Summoned (Link) - Create Timed Event (1)"),
(42413, 0, 3, 4, 59, 0, 100, 0, 0, 0, 0, 0, 125, 2, 5, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Ragamuffin - On Timed Event Triggered (0) - Trigger Random Timed Event (2-5)"),
(42413, 0, 4, 0, 61, 0, 100, 0, 0, 0, 0, 0, 114, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1.5, 0, 0, "Ragamuffin - On Timed Event Triggered (0) (Link) - Move Offset"),
(42413, 0, 5, 0, 59, 0, 100, 0, 1, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Ragamuffin - On Timed Event Triggered (1) - Despawn"),
(42413, 0, 6, 0, 34, 0, 100, 0, 0, 0, 0, 0, 128, 649, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, "Ragamuffin - On MI - Play Anim Kit (649)"),
(42413, 0, 7, 0, 59, 0, 100, 0, 2, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, "Ragamuffin - On Timed Event Triggered (2) - Say Text Line 0");

DELETE FROM `creature_text` WHERE `entry` IN (42308, 42309, 42383, 42384, 42386, 42391, 42413);
INSERT INTO `creature_text` (`entry`, `text_group`, `id`, `text`, `text_female`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `text_range`, `comment`) VALUES
(42308, 0, 0, "No kidding, rookie...", "", 12, 7, 100, 273, 0, 0, 0, "Lieutenant Horatio Laine"),
(42308, 1, 0, "Looks like they really put the cart...", "", 12, 7, 100, 0, 0, 0, 0, "Lieutenant Horatio Laine"),
(42308, 2, 0, "...before the horse.", "", 12, 7, 100, 0, 0, 0, 0, "Lieutenant Horatio Laine"),

(42309, 0, 0, "It's a bloodbath, lieutenant. They've been murdered.", "", 12, 7, 100, 1, 0, 0, 0, "Stormwind Investigator"),
(42309, 1, 0, "Given the body temperature, I'd say they've been dead no more than 6 hours.", "", 12, 7, 100, 0, 0, 0, 0, "Stormwind Investigator"),
(42309, 2, 0, "Damn shame what they did to Old Blanchy...", "", 12, 7, 100, 0, 0, 0, 0, "Stormwind Investigator"),

(42383, 0, 0, "Listen, $gpal:lady;, I don't want any trouble, ok I didn't see who murdered 'em, but I sure heard it! Lot of yelling. Human voices... you dig Now get out of here before I change my mind about beating you up and takin' your shoes.", "", 12, 0, 100, 396, 0, 0, 0, "Transient"),
(42383, 1, 0, "I didn't see who killed 'em, $gbub:lady;, but I got a whiff. Smelled rich, kinda like you. Damn shame too. Furlbrows were a fixture around here. Nice people, always willin' to share a meal or a patch of dirt.", "", 12, 0, 100, 396, 0, 0, 0, "Transient"),
(42383, 2, 0, "Who killed the Furlbrows I'll tell you who killed the Furlbrows KING VARIAN WRYNN, THAT'S WHO! And he's killin' the rest of us too. One bum at a time. The only thing I can tell you is that I saw some gnolls leavin' the place a few hours before the law arrived.", "", 12, 0, 100, 5, 0, 0, 0, "Transient"),
(42383, 3, 0, "Between you, me, and the tree, murlocs killed the Furlbrows. Yep, saw 'em with my own two eyes. Think they'd been casin' the joint for days, maybe months. They left in a hurry once they got wind of Johnny Law and the idiot brigade over there...", "", 12, 0, 100, 273, 0, 0, 0, "Transient"),
(42383, 4, 0, "Judgment day comes! The brotherhood will be reborn!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 1, "Now you've gone and done it! TIME FOR THE FIST!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 2, "You'll get nothing out of me!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 3, "Livin' like an animal is hard enough without your insults!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 4, "I ain't tellin' you a damn thing!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 5, "Maybe I can sell your liver for some gold.", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 6, "You want my foot in your front or in your rear Make the call.", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 7, "They died of natural causes...", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 8, "You rich punks are all the same!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 4, 9, "You can't buy me! DIE!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 0, "Judgment day comes! The brotherhood will be reborn!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 1, "Now you've gone and done it! TIME FOR THE FIST!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 2, "You'll get nothing out of me!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 3, "Livin' like an animal is hard enough without your insults!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 4, "I ain't tellin' you a damn thing!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 5, "Maybe I can sell your liver for some gold.", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 6, "You want my foot in your front or in your rear Make the call.", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 7, "They died of natural causes...", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 8, "You rich punks are all the same!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 5, 9, "I TOLD YOU TO PAY UP, PAL!", "", 12, 7, 100, 0, 0, 0, 0, "Transient"),
(42383, 6, 0, "Looks like we'll be eating shoe leather for dinner again.", "", 12, 7, 100, 396, 0, 0, 0, "Transient"),
(42383, 6, 1, "HAHAHAH! Good one, Mr. Penguin! GOOD ONE!", "", 12, 7, 100, 153, 0, 0, 0, "Transient"),
(42383, 6, 2, "What happened to me I used to be the king of Stormwind!", "", 12, 7, 100, 15, 0, 0, 0, "Transient"),
(42383, 6, 3, "I don't think I'm gonna make it...", "", 12, 7, 100, 18, 0, 0, 0, "Transient"),
(42383, 6, 4, "Get off my land!", "", 12, 7, 100, 397, 0, 0, 0, "Transient"),
(42383, 6, 5, "I miss being robbed by the Defias. At least they'd leave you a little something to eat from time to time.", "", 12, 7, 100, 396, 0, 0, 0, "Transient"),
(42383, 6, 6, "I'm starving!", "", 12, 7, 100, 5, 0, 0, 0, "Transient"),
(42383, 6, 7, "I wonder if it's possible to eat rocks Got plenty of rocks around here. Just imagine it! I'd be the richest person in the world for making that discovery!", "", 12, 7, 100, 4, 0, 0, 0, "Transient"),
(42383, 7, 0, "JACKPOT!", "", 12, 7, 100, 5, 0, 0, 0, "Transient"),
(42383, 8, 0, "Looks like I found us a savory and clean piece of dirt! Tonight we eat like kings, Mr. Penguin! Of course I'll share it with you! You're my best friend!", "", 12, 7, 100, 18, 0, 0, 0, "Transient"),
(42383, 9, 0, "HEY! HEY YOU! GET OFF MY PROPERTY!", "", 12, 7, 100, 22, 0, 0, 0, "Transient"),
(42383, 10, 0, "%s attempts to run away in fear!", "", 16, 0, 100, 0, 0, 0, 0, "Transient"),

(42384, 0, 0, "Listen, $gpal:lady;, I don't want any trouble, ok I didn't see who murdered 'em, but I sure heard it! Lot of yelling. Human voices... you dig Now get out of here before I change my mind about beating you up and takin' your shoes.", "", 12, 0, 100, 396, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 1, 0, "I didn't see who killed 'em, $gbub:lady;, but I got a whiff. Smelled rich, kinda like you. Damn shame too. Furlbrows were a fixture around here. Nice people, always willin' to share a meal or a patch of dirt.", "", 12, 0, 100, 396, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 2, 0, "Who killed the Furlbrows I'll tell you who killed the Furlbrows KING VARIAN WRYNN, THAT'S WHO! And he's killin' the rest of us too. One bum at a time. The only thing I can tell you is that I saw some gnolls leavin' the place a few hours before the law arrived.", "", 12, 0, 100, 5, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 3, 0, "Between you, me, and the tree, murlocs killed the Furlbrows. Yep, saw 'em with my own two eyes. Think they'd been casin' the joint for days, maybe months. They left in a hurry once they got wind of Johnny Law and the idiot brigade over there...", "", 12, 0, 100, 273, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 0, "Judgment day comes! The brotherhood will be reborn!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 1, "Now you've gone and done it! TIME FOR THE FIST!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 2, "You'll get nothing out of me!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 3, "Livin' like an animal is hard enough without your insults!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 4, "I ain't tellin' you a damn thing!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 5, "Maybe I can sell your liver for some gold.", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 6, "You want my foot in your front or in your rear Make the call.", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 7, "They died of natural causes...", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 8, "You rich punks are all the same!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 4, 9, "You can't buy me! DIE!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 0, "Judgment day comes! The brotherhood will be reborn!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 1, "Now you've gone and done it! TIME FOR THE FIST!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 2, "You'll get nothing out of me!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 3, "Livin' like an animal is hard enough without your insults!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 4, "I ain't tellin' you a damn thing!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 5, "Maybe I can sell your liver for some gold.", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 6, "You want my foot in your front or in your rear Make the call.", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 7, "They died of natural causes...", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 8, "You rich punks are all the same!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 5, 9, "I TOLD YOU TO PAY UP, PAL!", "", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 6, 0, "Looks like we'll be eating shoe leather for dinner again.", "", 12, 7, 100, 396, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 6, 1, "HAHAHAH! Good one, Mr. Penguin! GOOD ONE!", "", 12, 7, 100, 153, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 6, 2, "What happened to me I used to be the king of Stormwind!", "", 12, 7, 100, 15, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 6, 3, "I don't think I'm gonna make it...", "", 12, 7, 100, 18, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 6, 4, "Get off my land!", "", 12, 7, 100, 397, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 6, 5, "I miss being robbed by the Defias. At least they'd leave you a little something to eat from time to time.", "", 12, 7, 100, 396, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 6, 6, "I'm starving!", "", 12, 7, 100, 5, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 6, 7, "I wonder if it's possible to eat rocks Got plenty of rocks around here. Just imagine it! I'd be the richest person in the world for making that discovery!", "", 12, 7, 100, 4, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 7, 0, "JACKPOT!", "", 12, 7, 100, 5, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 8, 0, "Looks like I found us a savory and clean piece of dirt! Tonight we eat like kings, Mr. Penguin! Of course I'll share it with you! You're my best friend!", "", 12, 7, 100, 18, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 9, 0, "HEY! HEY YOU! GET OFF MY PROPERTY!", "", 12, 7, 100, 22, 0, 0, 0, "Homeless Stormwind Citizen"),
(42384, 10, 0, "%s attempts to run away in fear!", "", 16, 0, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),

(42386, 0, 0, "", "Listen, $gpal:lady;, I don't want any trouble, ok I didn't see who murdered 'em, but I sure heard it! Lot of yelling. Human voices... you dig Now get out of here before I change my mind about beating you up and takin' your shoes.", 12, 0, 100, 396, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 1, 0, "", "I didn't see who killed 'em, $gbub:lady;, but I got a whiff. Smelled rich, kinda like you. Damn shame too. Furlbrows were a fixture around here. Nice people, always willin' to share a meal or a patch of dirt.", 12, 0, 100, 396, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 2, 0, "", "Who killed the Furlbrows I'll tell you who killed the Furlbrows KING VARIAN WRYNN, THAT'S WHO! And he's killin' the rest of us too. One bum at a time. The only thing I can tell you is that I saw some gnolls leavin' the place a few hours before the law arrived.", 12, 0, 100, 5, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 3, 0, "", "Between you, me, and the tree, murlocs killed the Furlbrows. Yep, saw 'em with my own two eyes. Think they'd been casin' the joint for days, maybe months. They left in a hurry once they got wind of Johnny Law and the idiot brigade over there...", 12, 0, 100, 273, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 0, "", "Judgment day comes! The brotherhood will be reborn!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 1, "", "Now you've gone and done it! TIME FOR THE FIST!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 2, "", "You'll get nothing out of me!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 3, "", "Livin' like an animal is hard enough without your insults!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 4, "", "I ain't tellin' you a damn thing!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 5, "", "Maybe I can sell your liver for some gold.", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 6, "", "You want my foot in your front or in your rear Make the call.", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 7, "", "They died of natural causes...", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 8, "", "You rich punks are all the same!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 4, 9, "", "You can't buy me! DIE!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 0, "", "Judgment day comes! The brotherhood will be reborn!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 1, "", "Now you've gone and done it! TIME FOR THE FIST!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 2, "", "You'll get nothing out of me!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 3, "", "Livin' like an animal is hard enough without your insults!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 4, "", "I ain't tellin' you a damn thing!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 5, "", "Maybe I can sell your liver for some gold.", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 6, "", "You want my foot in your front or in your rear Make the call.", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 7, "", "They died of natural causes...", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 8, "", "You rich punks are all the same!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 5, 9, "", "I TOLD YOU TO PAY UP, PAL!", 12, 7, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 6, 0, "", "Looks like we'll be eating shoe leather for dinner again.", 12, 7, 100, 396, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 6, 1, "", "HAHAHAH! Good one, Mr. Penguin! GOOD ONE!", 12, 7, 100, 153, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 6, 2, "", "What happened to me I used to be the king of Stormwind!", 12, 7, 100, 15, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 6, 3, "", "I don't think I'm gonna make it...", 12, 7, 100, 18, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 6, 4, "", "Get off my land!", 12, 7, 100, 397, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 6, 5, "", "I miss being robbed by the Defias. At least they'd leave you a little something to eat from time to time.", 12, 7, 100, 396, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 6, 6, "", "I'm starving!", 12, 7, 100, 5, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 6, 7, "", "I wonder if it's possible to eat rocks Got plenty of rocks around here. Just imagine it! I'd be the richest person in the world for making that discovery!", 12, 7, 100, 4, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 7, 0, "", "JACKPOT!", 12, 7, 100, 5, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 8, 0, "", "Looks like I found us a savory and clean piece of dirt! Tonight we eat like kings, Mr. Penguin! Of course I'll share it with you! You're my best friend!", 12, 7, 100, 18, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 9, 0, "", "HEY! HEY YOU! GET OFF MY PROPERTY!", 12, 7, 100, 22, 0, 0, 0, "Homeless Stormwind Citizen"),
(42386, 10, 0, "", "%s attempts to run away in fear!", 16, 0, 100, 0, 0, 0, 0, "Homeless Stormwind Citizen"),

(42391, 0, 0, "Listen, $gpal:lady;, I don't want any trouble, ok I didn't see who murdered 'em, but I sure heard it! Lot of yelling. Human voices... you dig Now get out of here before I change my mind about beating you up and takin' your shoes.", "Listen, $gpal:lady;, I don't want any trouble, ok I didn't see who murdered 'em, but I sure heard it! Lot of yelling. Human voices... you dig Now get out of here before I change my mind about beating you up and takin' your shoes.", 12, 0, 100, 396, 0, 0, 0, "West Plains Drifter"),
(42391, 1, 0, "I didn't see who killed 'em, $gbub:lady;, but I got a whiff. Smelled rich, kinda like you. Damn shame too. Furlbrows were a fixture around here. Nice people, always willin' to share a meal or a patch of dirt.", "I didn't see who killed 'em, $gbub:lady;, but I got a whiff. Smelled rich, kinda like you. Damn shame too. Furlbrows were a fixture around here. Nice people, always willin' to share a meal or a patch of dirt.", 12, 0, 100, 396, 0, 0, 0, "West Plains Drifter"),
(42391, 2, 0, "Who killed the Furlbrows I'll tell you who killed the Furlbrows KING VARIAN WRYNN, THAT'S WHO! And he's killin' the rest of us too. One bum at a time. The only thing I can tell you is that I saw some gnolls leavin' the place a few hours before the law arrived.", "Who killed the Furlbrows I'll tell you who killed the Furlbrows KING VARIAN WRYNN, THAT'S WHO! And he's killin' the rest of us too. One bum at a time. The only thing I can tell you is that I saw some gnolls leavin' the place a few hours before the law arrived.", 12, 0, 100, 5, 0, 0, 0, "West Plains Drifter"),
(42391, 3, 0, "Between you, me, and the tree, murlocs killed the Furlbrows. Yep, saw 'em with my own two eyes. Think they'd been casin' the joint for days, maybe months. They left in a hurry once they got wind of Johnny Law and the idiot brigade over there...", "Between you, me, and the tree, murlocs killed the Furlbrows. Yep, saw 'em with my own two eyes. Think they'd been casin' the joint for days, maybe months. They left in a hurry once they got wind of Johnny Law and the idiot brigade over there...", 12, 0, 100, 273, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 0, "Judgment day comes! The brotherhood will be reborn!", "Judgment day comes! The brotherhood will be reborn!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 1, "Now you've gone and done it! TIME FOR THE FIST!", "Now you've gone and done it! TIME FOR THE FIST!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 2, "You'll get nothing out of me!", "You'll get nothing out of me!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 3, "Livin' like an animal is hard enough without your insults!", "Livin' like an animal is hard enough without your insults!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 4, "I ain't tellin' you a damn thing!", "I ain't tellin' you a damn thing!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 5, "Maybe I can sell your liver for some gold.", "Maybe I can sell your liver for some gold.", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 6, "You want my foot in your front or in your rear Make the call.", "You want my foot in your front or in your rear Make the call.", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 7, "They died of natural causes...", "They died of natural causes...", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 8, "You rich punks are all the same!", "You rich punks are all the same!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 4, 9, "You can't buy me! DIE!", "You can't buy me! DIE!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 0, "Judgment day comes! The brotherhood will be reborn!", "Judgment day comes! The brotherhood will be reborn!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 1, "Now you've gone and done it! TIME FOR THE FIST!", "Now you've gone and done it! TIME FOR THE FIST!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 2, "You'll get nothing out of me!", "You'll get nothing out of me!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 3, "Livin' like an animal is hard enough without your insults!", "Livin' like an animal is hard enough without your insults!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 4, "I ain't tellin' you a damn thing!", "I ain't tellin' you a damn thing!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 5, "Maybe I can sell your liver for some gold.", "Maybe I can sell your liver for some gold.", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 6, "You want my foot in your front or in your rear Make the call.", "You want my foot in your front or in your rear Make the call.", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 7, "They died of natural causes...", "They died of natural causes...", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 8, "You rich punks are all the same!", "You rich punks are all the same!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 5, 9, "I TOLD YOU TO PAY UP, PAL!", "I TOLD YOU TO PAY UP, PAL!", 12, 7, 100, 0, 0, 0, 0, "West Plains Drifter"),
(42391, 6, 0, "Looks like we'll be eating shoe leather for dinner again.", "Looks like we'll be eating shoe leather for dinner again.", 12, 7, 100, 396, 0, 0, 0, "West Plains Drifter"),
(42391, 6, 1, "HAHAHAH! Good one, Mr. Penguin! GOOD ONE!", "HAHAHAH! Good one, Mr. Penguin! GOOD ONE!", 12, 7, 100, 153, 0, 0, 0, "West Plains Drifter"),
(42391, 6, 2, "What happened to me I used to be the king of Stormwind!", "What happened to me I used to be the king of Stormwind!", 12, 7, 100, 15, 0, 0, 0, "West Plains Drifter"),
(42391, 6, 3, "I don't think I'm gonna make it...", "I don't think I'm gonna make it...", 12, 7, 100, 18, 0, 0, 0, "West Plains Drifter"),
(42391, 6, 4, "Get off my land!", "Get off my land!", 12, 7, 100, 397, 0, 0, 0, "West Plains Drifter"),
(42391, 6, 5, "I miss being robbed by the Defias. At least they'd leave you a little something to eat from time to time.", "I miss being robbed by the Defias. At least they'd leave you a little something to eat from time to time.", 12, 7, 100, 396, 0, 0, 0, "West Plains Drifter"),
(42391, 6, 6, "I'm starving!", "I'm starving!", 12, 7, 100, 5, 0, 0, 0, "West Plains Drifter"),
(42391, 6, 7, "I wonder if it's possible to eat rocks Got plenty of rocks around here. Just imagine it! I'd be the richest person in the world for making that discovery!", "I wonder if it's possible to eat rocks Got plenty of rocks around here. Just imagine it! I'd be the richest person in the world for making that discovery!", 12, 7, 100, 4, 0, 0, 0, "West Plains Drifter"),
(42391, 7, 0, "JACKPOT!", "JACKPOT!", 12, 7, 100, 5, 0, 0, 0, "West Plains Drifter"),
(42391, 8, 0, "Looks like I found us a savory and clean piece of dirt! Tonight we eat like kings, Mr. Penguin! Of course I'll share it with you! You're my best friend!", "Looks like I found us a savory and clean piece of dirt! Tonight we eat like kings, Mr. Penguin! Of course I'll share it with you! You're my best friend!", 12, 7, 100, 18, 0, 0, 0, "West Plains Drifter"),
(42391, 9, 0, "HEY! HEY YOU! GET OFF MY PROPERTY!", "HEY! HEY YOU! GET OFF MY PROPERTY!", 12, 7, 100, 22, 0, 0, 0, "West Plains Drifter"),
(42391, 10, 0, "%s attempts to run away in fear!", "%s attempts to run away in fear!", 16, 0, 100, 0, 0, 0, 0, "West Plains Drifter"),

(42413, 0, 0, "Check $ghis:her; pockets!", "Check $ghis:her; pockets!", 12, 7, 20, 0, 0, 0, 0, "Ragamuffin"),
(42413, 0, 1, "Does $ghe:she; have boots Get 'em!", "Does $ghe:she; have boots Get 'em!", 12, 7, 20, 0, 0, 0, 0, "Ragamuffin"),
(42413, 0, 2, "MINE!", "MINE!", 12, 7, 20, 0, 0, 0, 0, "Ragamuffin");

DELETE FROM `creature_text_locale` WHERE `CreatureID` IN (42308, 42309, 42383, 42384, 42386, 42391, 42413) AND `Locale` = "ruRU";
INSERT INTO `creature_text_locale` (`CreatureID`, `GroupID`, `ID`, `Locale`, `Text`, `TextFemale`) VALUES
(42308,0,0,"ruRU","Кроме шуток, салага...",""),
(42308,1,0,"ruRU","Похоже, они поставили телегу...",""),
(42308,2,0,"ruRU","...вперед кобылы.",""),

(42309,0,0,"ruRU","Это просто бойня, лейтенант. Их всех убили.",""),
(42309,1,0,"ruRU","Судя по температуре тел, они мертвы не более 6 часов.",""),
(42309,2,0,"ruRU","Смерть и кости! Что они сотворили со старушкой Савраской...",""),

(42383,0,0,"ruRU","Слушай, $gпарень:девица;, мне не нужны неприятности, ясно? Я не видел, кто их прикончил, но слышал это, будь спок! Крику было... Человеческие голоса... Сечешь, о чем я? Теперь вали отсюда, пока я тебе не навалял и не забрал твои сапоги.",""),
(42383,1,0,"ruRU","Не видел я, кто их убил, $gпарень:девица;, но пахло будь здоров. Запах хороший, на твой похож. Паскудно все это. Хмуробровы с давних пор здесь жили. Хорошие люди, делились едой и всяким таким.",""),
(42383,2,0,"ruRU","Кто убил Хмуробровов? Я те скажу, кто их убил: КОРОЛЬ ВАРИАН РИНН, ВОТ КТО! И нас всех тоже прикончит. По одному. Сказать могу только одно: я видел, как за несколько часов до прибытия стражи отсюда уходили гноллы.",""),
(42383,3,0,"ruRU","Между нами говоря, Хмуробровов убили мурлоки. Угу, своими глазами видел. Шныряли тут много дней, а может и месяцев. Однако быстренько свалили отсюда, как стражу почуяли...",""),
(42383,4,0,"ruRU","Грядет судный день! Братство возродится!",""),
(42383,4,1,"ruRU","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!",""),
(42383,4,2,"ruRU","Ты ничего из меня не вытянешь!",""),
(42383,4,3,"ruRU","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!",""),
(42383,4,4,"ruRU","Я те ниче ваще не скажу!",""),
(42383,4,5,"ruRU","Печень что ли твою продать, чтобы деньжата появились.",""),
(42383,4,6,"ruRU","Тебе дать по морде или по заднице? Выбирай.",""),
(42383,4,7,"ruRU","Они умерли от старости.",""),
(42383,4,8,"ruRU","Все богатеи одинаковы!",""),
(42383,4,9,"ruRU","Ты меня не купишь! СДОХНИ!",""),
(42383,5,0,"ruRU","Грядет судный день! Братство возродится!",""),
(42383,5,1,"ruRU","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!",""),
(42383,5,2,"ruRU","Ты ничего из меня не вытянешь!",""),
(42383,5,3,"ruRU","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!",""),
(42383,5,4,"ruRU","Я те ниче ваще не скажу!",""),
(42383,5,5,"ruRU","Печень что ли твою продать, чтобы деньжата появились.",""),
(42383,5,6,"ruRU","Тебе дать по морде или по заднице? Выбирай.",""),
(42383,5,7,"ruRU","Они умерли от старости.",""),
(42383,5,8,"ruRU","Все богатеи одинаковы!",""),
(42383,5,9,"ruRU","Я ЖЕ СКАЗАЛ, ЧТО ТЫ $gДОЛЖЕН:ДОЛЖНА; ЗАПЛАТИТЬ!",""),
(42383,6,0,"ruRU","Похоже, у нас опять будут сапоги на ужин.",""),
(42383,6,1,"ruRU","ХА-ХА-ХА! Неплохо, мистер Пингвин! ВЕСЬМА НЕПЛОХО!",""),
(42383,6,2,"ruRU","Что со мной случилось? Я был королем Штормграда!",""),
(42383,6,3,"ruRU","Не думаю, что у меня получится...",""),
(42383,6,4,"ruRU","Свали с моей земли!",""),
(42383,6,5,"ruRU","Я скучаю по тем временам, когда нас грабили ребята из Братства Справедливости. Они хотя бы иногда хоть краюшку хлеба оставляли.",""),
(42383,6,6,"ruRU","Я умираю от голода!",""),
(42383,6,7,"ruRU","Любопытно, можно ли камни есть? У нас тут камней – хоть чем ешь. Только вообрази – я б на этом открытии озолотился!",""),
(42383,7,0,"ruRU","ДЖЕКПОТ!",""),
(42383,8,0,"ruRU","Похоже, нам попался аппетитный кусочек грязи! Сегодня нас ждет королевский пир, мистер Пингвин! Конечно, я с тобой поделюсь! Ты ж мой лучший друг!",""),
(42383,9,0,"ruRU","ЭЙ! ТЫ! ОСТАВЬ В ПОКОЕ МОЮ СОБСТВЕННОСТЬ!",""),
(42383,10,0,"ruRU","%s в панике пытается бежать!",""),

(42384,0,0,"ruRU","Слушай, $gпарень:девица;, мне не нужны неприятности, ясно? Я не видел, кто их прикончил, но слышал это, будь спок! Крику было... Человеческие голоса... Сечешь, о чем я? Теперь вали отсюда, пока я тебе не навалял и не забрал твои сапоги.",""),
(42384,1,0,"ruRU","Не видел я, кто их убил, $gпарень:девица;, но пахло будь здоров. Запах хороший, на твой похож. Паскудно все это. Хмуробровы с давних пор здесь жили. Хорошие люди, делились едой и всяким таким.",""),
(42384,2,0,"ruRU","Кто убил Хмуробровов? Я те скажу, кто их убил: КОРОЛЬ ВАРИАН РИНН, ВОТ КТО! И нас всех тоже прикончит. По одному. Сказать могу только одно: я видел, как за несколько часов до прибытия стражи отсюда уходили гноллы.",""),
(42384,3,0,"ruRU","Между нами говоря, Хмуробровов убили мурлоки. Угу, своими глазами видел. Шныряли тут много дней, а может и месяцев. Однако быстренько свалили отсюда, как стражу почуяли...",""),
(42384,4,0,"ruRU","Грядет судный день! Братство возродится!",""),
(42384,4,1,"ruRU","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!",""),
(42384,4,2,"ruRU","Ты ничего из меня не вытянешь!",""),
(42384,4,3,"ruRU","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!",""),
(42384,4,4,"ruRU","Я те ниче ваще не скажу!",""),
(42384,4,5,"ruRU","Печень что ли твою продать, чтобы деньжата появились.",""),
(42384,4,6,"ruRU","Тебе дать по морде или по заднице? Выбирай.",""),
(42384,4,7,"ruRU","Они умерли от старости.",""),
(42384,4,8,"ruRU","Все богатеи одинаковы!",""),
(42384,4,9,"ruRU","Ты меня не купишь! СДОХНИ!",""),
(42384,5,0,"ruRU","Грядет судный день! Братство возродится!",""),
(42384,5,1,"ruRU","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!",""),
(42384,5,2,"ruRU","Ты ничего из меня не вытянешь!",""),
(42384,5,3,"ruRU","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!",""),
(42384,5,4,"ruRU","Я те ниче ваще не скажу!",""),
(42384,5,5,"ruRU","Печень что ли твою продать, чтобы деньжата появились.",""),
(42384,5,6,"ruRU","Тебе дать по морде или по заднице? Выбирай.",""),
(42384,5,7,"ruRU","Они умерли от старости.",""),
(42384,5,8,"ruRU","Все богатеи одинаковы!",""),
(42384,5,9,"ruRU","Я ЖЕ СКАЗАЛ, ЧТО ТЫ $gДОЛЖЕН:ДОЛЖНА; ЗАПЛАТИТЬ!",""),
(42384,6,0,"ruRU","Похоже, у нас опять будут сапоги на ужин.",""),
(42384,6,1,"ruRU","ХА-ХА-ХА! Неплохо, мистер Пингвин! ВЕСЬМА НЕПЛОХО!",""),
(42384,6,2,"ruRU","Что со мной случилось? Я был королем Штормграда!",""),
(42384,6,3,"ruRU","Не думаю, что у меня получится...",""),
(42384,6,4,"ruRU","Свали с моей земли!",""),
(42384,6,5,"ruRU","Я скучаю по тем временам, когда нас грабили ребята из Братства Справедливости. Они хотя бы иногда хоть краюшку хлеба оставляли.",""),
(42384,6,6,"ruRU","Я умираю от голода!",""),
(42384,6,7,"ruRU","Любопытно, можно ли камни есть? У нас тут камней – хоть чем ешь. Только вообрази – я б на этом открытии озолотился!",""),
(42384,7,0,"ruRU","ДЖЕКПОТ!",""),
(42384,8,0,"ruRU","Похоже, нам попался аппетитный кусочек грязи! Сегодня нас ждет королевский пир, мистер Пингвин! Конечно, я с тобой поделюсь! Ты ж мой лучший друг!",""),
(42384,9,0,"ruRU","ЭЙ! ТЫ! ОСТАВЬ В ПОКОЕ МОЮ СОБСТВЕННОСТЬ!",""),
(42384,10,0,"ruRU","%s в панике пытается бежать!",""),

(42386,0,0,"ruRU","","Слушай, $gпарень:девица;, мне не нужны неприятности, ясно? Я не видела, кто их прикончил, но слышала это, будь спок! Крику было... Человеческие голоса... Понимаешь, о чем я? Теперь вали отсюда, пока я тебе не наваляла и не забрала твои сапоги."),
(42386,1,0,"ruRU","","Не видела я, кто их убил, $gпарень:девица;, но пахло будь здоров. Запах хороший, на твой похож. Паскудно все это. Хмуробровы с давних пор здесь жили. Хорошие люди, делились едой и всяким таким."),
(42386,2,0,"ruRU","","Кто убил Хмуробровов? Я те скажу, кто их убил: КОРОЛЬ ВАРИАН РИНН, ВОТ КТО! И нас всех тоже прикончит. По одному. Сказать могу только одно: я видела, как за несколько часов до прибытия стражи отсюда уходили гноллы."),
(42386,3,0,"ruRU","","Между нами говоря, Хмуробровов убили мурлоки. Угу, своими глазами видела. Шныряли тут много дней, а может и месяцев. Однако быстренько свалили отсюда, как стражу почуяли..."),
(42386,4,0,"ruRU","","Грядет судный день! Братство возродится!"),
(42386,4,1,"ruRU","","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!"),
(42386,4,2,"ruRU","","Ты ничего из меня не вытянешь!"),
(42386,4,3,"ruRU","","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!"),
(42386,4,4,"ruRU","","Я те ниче ваще не скажу!"),
(42386,4,5,"ruRU","","Печень что ли твою продать, чтобы деньжата появились."),
(42386,4,6,"ruRU","","Тебе дать по морде или по заднице? Выбирай."),
(42386,4,7,"ruRU","","Они умерли от старости."),
(42386,4,8,"ruRU","","Все богатеи одинаковы!"),
(42386,4,9,"ruRU","","Ты меня не купишь! СДОХНИ!"),
(42386,5,0,"ruRU","","Грядет судный день! Братство возродится!"),
(42386,5,1,"ruRU","","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!"),
(42386,5,2,"ruRU","","Ты ничего из меня не вытянешь!"),
(42386,5,3,"ruRU","","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!"),
(42386,5,4,"ruRU","","Я те ниче ваще не скажу!"),
(42386,5,5,"ruRU","","Печень что ли твою продать, чтобы деньжата появились."),
(42386,5,6,"ruRU","","Тебе дать по морде или по заднице? Выбирай."),
(42386,5,7,"ruRU","","Они умерли от старости."),
(42386,5,8,"ruRU","","Все богатеи одинаковы!"),
(42386,5,9,"ruRU","","Я ЖЕ СКАЗАЛА, ЧТО ТЫ $gДОЛЖЕН:ДОЛЖНА; ЗАПЛАТИТЬ!"),
(42386,6,0,"ruRU","","Похоже, у нас опять будут сапоги на ужин."),
(42386,6,1,"ruRU","","ХА-ХА-ХА! Неплохо, мистер Пингвин! ВЕСЬМА НЕПЛОХО!"),
(42386,6,2,"ruRU","","Что со мной случилось? Я была королевой Штормграда!"),
(42386,6,3,"ruRU","","Не думаю, что у меня получится..."),
(42386,6,4,"ruRU","","Свали с моей земли!"),
(42386,6,5,"ruRU","","Я скучаю по тем временам, когда нас грабили ребята из Братства Справедливости. Они хотя бы иногда хоть краюшку хлеба оставляли."),
(42386,6,6,"ruRU","","Я умираю от голода!"),
(42386,6,7,"ruRU","","Любопытно, можно ли камни есть? У нас тут камней – хоть чем ешь. Только вообрази – я б на этом открытии озолотилась!"),
(42386,7,0,"ruRU","","ДЖЕКПОТ!"),
(42386,8,0,"ruRU","","Похоже, нам попался аппетитный кусочек грязи! Сегодня нас ждет королевский пир, мистер Пингвин! Конечно, я с тобой поделюсь! Ты ж мой лучший друг!"),
(42386,9,0,"ruRU","","ЭЙ! ТЫ! ОСТАВЬ В ПОКОЕ МОЮ СОБСТВЕННОСТЬ!"),
(42386,10,0,"ruRU","","%s в панике пытается бежать!"),

(42391,0,0,"ruRU","Слушай, $gпарень:девица;, мне не нужны неприятности, ясно? Я не видел, кто их прикончил, но слышал это, будь спок! Крику было... Человеческие голоса... Сечешь, о чем я? Теперь вали отсюда, пока я тебе не навалял и не забрал твои сапоги.","Слушай, $gпарень:девица;, мне не нужны неприятности, ясно? Я не видела, кто их прикончил, но слышала это, будь спок! Крику было... Человеческие голоса... Понимаешь, о чем я? Теперь вали отсюда, пока я тебе не наваляла и не забрала твои сапоги."),
(42391,1,0,"ruRU","Не видел я, кто их убил, $gпарень:девица;, но пахло будь здоров. Запах хороший, на твой похож. Паскудно все это. Хмуробровы с давних пор здесь жили. Хорошие люди, делились едой и всяким таким.","Не видела я, кто их убил, $gпарень:девица;, но пахло будь здоров. Запах хороший, на твой похож. Паскудно все это. Хмуробровы с давних пор здесь жили. Хорошие люди, делились едой и всяким таким."),
(42391,2,0,"ruRU","Кто убил Хмуробровов? Я те скажу, кто их убил: КОРОЛЬ ВАРИАН РИНН, ВОТ КТО! И нас всех тоже прикончит. По одному. Сказать могу только одно: я видел, как за несколько часов до прибытия стражи отсюда уходили гноллы.","Кто убил Хмуробровов? Я те скажу, кто их убил: КОРОЛЬ ВАРИАН РИНН, ВОТ КТО! И нас всех тоже прикончит. По одному. Сказать могу только одно: я видела, как за несколько часов до прибытия стражи отсюда уходили гноллы."),
(42391,3,0,"ruRU","Между нами говоря, Хмуробровов убили мурлоки. Угу, своими глазами видел. Шныряли тут много дней, а может и месяцев. Однако быстренько свалили отсюда, как стражу почуяли...","Между нами говоря, Хмуробровов убили мурлоки. Угу, своими глазами видела. Шныряли тут много дней, а может и месяцев. Однако быстренько свалили отсюда, как стражу почуяли..."),
(42391,4,0,"ruRU","Грядет судный день! Братство возродится!","Грядет судный день! Братство возродится!"),
(42391,4,1,"ruRU","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!"),
(42391,4,2,"ruRU","Ты ничего из меня не вытянешь!","Ты ничего из меня не вытянешь!"),
(42391,4,3,"ruRU","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!"),
(42391,4,4,"ruRU","Я те ниче ваще не скажу!","Я те ниче ваще не скажу!"),
(42391,4,5,"ruRU","Печень что ли твою продать, чтобы деньжата появились.","Печень что ли твою продать, чтобы деньжата появились."),
(42391,4,6,"ruRU","Тебе дать по морде или по заднице? Выбирай.","Тебе дать по морде или по заднице? Выбирай."),
(42391,4,7,"ruRU","Они умерли от старости.","Они умерли от старости."),
(42391,4,8,"ruRU","Все богатеи одинаковы!","Все богатеи одинаковы!"),
(42391,4,9,"ruRU","Ты меня не купишь! СДОХНИ!","Ты меня не купишь! СДОХНИ!"),
(42391,5,0,"ruRU","Грядет судный день! Братство возродится!","Грядет судный день! Братство возродится!"),
(42391,5,1,"ruRU","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!","Ну, теперь ты $gнарвался:нарвалась;! СЕЙЧАС Я ТЕБЕ ВРЕЖУ!"),
(42391,5,2,"ruRU","Ты ничего из меня не вытянешь!","Ты ничего из меня не вытянешь!"),
(42391,5,3,"ruRU","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!","Я и без тебя живу, как животное! А тут еще и оскорбления выслушивать приходится!"),
(42391,5,4,"ruRU","Я те ниче ваще не скажу!","Я те ниче ваще не скажу!"),
(42391,5,5,"ruRU","Печень что ли твою продать, чтобы деньжата появились.","Печень что ли твою продать, чтобы деньжата появились."),
(42391,5,6,"ruRU","Тебе дать по морде или по заднице? Выбирай.","Тебе дать по морде или по заднице? Выбирай."),
(42391,5,7,"ruRU","Они умерли от старости.","Они умерли от старости."),
(42391,5,8,"ruRU","Все богатеи одинаковы!","Все богатеи одинаковы!"),
(42391,5,9,"ruRU","Я ЖЕ СКАЗАЛ, ЧТО ТЫ $gДОЛЖЕН:ДОЛЖНА; ЗАПЛАТИТЬ!","Я ЖЕ СКАЗАЛА, ЧТО ТЫ $gДОЛЖЕН:ДОЛЖНА; ЗАПЛАТИТЬ!"),
(42391,6,0,"ruRU","Похоже, у нас опять будут сапоги на ужин.","Похоже, у нас опять будут сапоги на ужин."),
(42391,6,1,"ruRU","ХА-ХА-ХА! Неплохо, мистер Пингвин! ВЕСЬМА НЕПЛОХО!","ХА-ХА-ХА! Неплохо, мистер Пингвин! ВЕСЬМА НЕПЛОХО!"),
(42391,6,2,"ruRU","Что со мной случилось? Я был королем Штормграда!","Что со мной случилось? Я была королевой Штормграда!"),
(42391,6,3,"ruRU","Не думаю, что у меня получится...","Не думаю, что у меня получится..."),
(42391,6,4,"ruRU","Свали с моей земли!","Свали с моей земли!"),
(42391,6,5,"ruRU","Я скучаю по тем временам, когда нас грабили ребята из Братства Справедливости. Они хотя бы иногда хоть краюшку хлеба оставляли.","Я скучаю по тем временам, когда нас грабили ребята из Братства Справедливости. Они хотя бы иногда хоть краюшку хлеба оставляли."),
(42391,6,6,"ruRU","Я умираю от голода!","Я умираю от голода!"),
(42391,6,7,"ruRU","Любопытно, можно ли камни есть? У нас тут камней – хоть чем ешь. Только вообрази – я б на этом открытии озолотился!","Любопытно, можно ли камни есть? У нас тут камней – хоть чем ешь. Только вообрази – я б на этом открытии озолотилась!"),
(42391,7,0,"ruRU","ДЖЕКПОТ!","ДЖЕКПОТ!"),
(42391,8,0,"ruRU","Похоже, нам попался аппетитный кусочек грязи! Сегодня нас ждет королевский пир, мистер Пингвин! Конечно, я с тобой поделюсь! Ты ж мой лучший друг!","Похоже, нам попался аппетитный кусочек грязи! Сегодня нас ждет королевский пир, мистер Пингвин! Конечно, я с тобой поделюсь! Ты ж мой лучший друг!"),
(42391,9,0,"ruRU","ЭЙ! ТЫ! ОСТАВЬ В ПОКОЕ МОЮ СОБСТВЕННОСТЬ!","ЭЙ! ТЫ! ОСТАВЬ В ПОКОЕ МОЮ СОБСТВЕННОСТЬ!"),
(42391,10,0,"ruRU","%s в панике пытается бежать!","%s в панике пытается бежать!"),

(42413,0,0,"ruRU","Пошарь у $gнего:нее; в карманах!","Пошарь у $gнего:нее; в карманах!"),
(42413,0,1,"ruRU","У $gнего:нее; есть обувка? Давай ее сюда!","У $gнего:нее; есть обувка? Давай ее сюда!"),
(42413,0,2,"ruRU","МОЕ!","МОЕ!");
