-- 任务完成器日志表
-- 记录每次使用任务完成器完成的任务记录（同任务不重复记录）

DROP TABLE IF EXISTS `任务完成记录`;

CREATE TABLE `任务完成记录` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `quest_id` INT UNSIGNED NOT NULL COMMENT '任务ID',
    `quest_name` VARCHAR(255) NOT NULL COMMENT '任务名称',
    `quest_giver_npc` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务领取NPC ID',
    `quest_objectives` TEXT COMMENT '任务目标描述',
    `quest_turnin_npc` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '交任务NPC ID',
    `player_name` VARCHAR(50) NOT NULL DEFAULT '' COMMENT '玩家名称',
    `faction` VARCHAR(10) NOT NULL DEFAULT '' COMMENT '阵营',
    `completed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '完成时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务完成器使用记录';
