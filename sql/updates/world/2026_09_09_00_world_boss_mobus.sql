UPDATE `creature_template` SET `InhabitType` = 2, `AIName` = "", `ScriptName` = "boss_mobus" WHERE `entry` = 50009;

UPDATE `creature` SET `position_x` = -5417.732, `position_y` = 5257.314, `position_z` = -487.6926, `orientation` = 2.732448577880859375,`wander_distance` = 0, `movement_type` = 2 WHERE `guid` = 317090 AND `id` = 50009;

DELETE FROM `creature_template_addon` WHERE `entry` = 50009;
DELETE FROM `creature_addon` WHERE `guid` = 317090;
INSERT INTO `creature_addon` (`guid`, `path_id`, `auras`) VALUES
(317090, 317090*10, "8876");

DELETE FROM `pool_template` WHERE `entry` = 30010;
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES
(30010, 2, "Cataclysm rare elite bosses");

DELETE FROM `pool_creature` WHERE `pool_entry` = 30010;
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(317090, 30010, 0, "Cataclysm rare bosses - Mobus"),
(318795, 30010, 0, "Cataclysm rare bosses - Akma'hat"),
(371477, 30010, 0, "Cataclysm rare bosses - Garr"),
(371485, 30010, 0, "Cataclysm rare bosses - Julak-Doom"),
(371491, 30010, 0, "Cataclysm rare bosses - Xariona");

DELETE FROM `waypoint_data` WHERE `id` IN (317090, 317090*10);
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `move_flag`) VALUES
(317090*10, 0, -5417.732, 5257.314, -487.6926, 0, 0, 0),
(317090*10, 1, -5482.764, 5159.9873, -487.6926, 0, 0, 0),
(317090*10, 2, -5580.091, 5094.955, -487.6926, 0, 0, 0),
(317090*10, 3, -5694.896, 5072.119, -487.6926, 0, 0, 0),
(317090*10, 4, -5809.701, 5094.955, -487.6926, 0, 0, 0),
(317090*10, 5, -5907.028, 5159.9873, -487.6926, 0, 0, 0),
(317090*10, 6, -5972.06, 5257.314, -487.6926, 0, 0, 0),
(317090*10, 7, -5994.896, 5372.119, -487.6926, 0, 0, 0),
(317090*10, 8, -5972.06, 5486.9243, -487.6926, 0, 0, 0),
(317090*10, 9, -5907.0283, 5584.251, -487.6926, 0, 0, 0),
(317090*10, 10, -5809.701, 5649.283, -487.6926, 0, 0, 0),
(317090*10, 11, -5694.896, 5672.119, -487.6926, 0, 0, 0),
(317090*10, 12, -5580.091, 5649.283, -487.6926, 0, 0, 0),
(317090*10, 13, -5482.7637, 5584.251, -487.6926, 0, 0, 0),
(317090*10, 14, -5417.732, 5486.924, -487.6926, 0, 0, 0),
(317090*10, 15, -5394.896, 5372.119, -487.6926, 0, 0, 0);
