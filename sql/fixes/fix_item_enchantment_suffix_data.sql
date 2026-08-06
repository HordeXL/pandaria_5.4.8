-- Fix: item_enchantment_template Suffix 组混入 Property 类型 ench
-- 导致 bot 随机化装备时 sItemRandomSuffixStore 查不到 ID(如 771),报错刷屏+卡死
-- 删除仅被 item_template.RandomSuffix 引用组中的非 ItemRandomSuffix.dbc ench
-- 备份表: item_enchantment_template_bak(执行前已创建)

DELETE FROM item_enchantment_template
WHERE entry IN (SELECT DISTINCT RandomSuffix FROM item_template WHERE RandomSuffix > 0)
AND ench NOT IN (SELECT id FROM ItemRandomSuffix);
