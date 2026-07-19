-- 任务完成器 - Quest Completer Item
-- 右键点击列出所有可完成的任务，选择后自动完成并发放奖励

DELETE FROM `item_template` WHERE `entry` = 200000;
DELETE FROM `item_script_names` WHERE `Id` = 200000;

INSERT INTO `item_template` (`entry`, `class`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `maxcount`, `stackable`, `Material`, `ArmorDamageModifier`, `spellid_1`, `spelltrigger_1`)
VALUES (200000, 0, '任务完成卷轴', 44462, 5, 0, 1, 0, 0, 0, -1, -1, 1, 1, 0, 1, 0, 0, 12883, 0);

INSERT INTO `item_script_names` (`Id`, `ScriptName`)
VALUES (200000, 'item_quest_completer');
