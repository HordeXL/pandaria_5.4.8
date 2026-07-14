/*
 Navicat Premium Data Transfer

 Source Server         : Pandaria
 Source Server Type    : MySQL
 Source Server Version : 50562 (5.5.62)
 Source Host           : localhost:3306
 Source Schema         : auth

 Target Server Type    : MySQL
 Target Server Version : 50562 (5.5.62)
 File Encoding         : 65001

 Date: 14/07/2026 23:59:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `battlenet_account` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `sha_pass_hash` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `sessionkey` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `v` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `s` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `token_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `reg_mail` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `joindate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '127.0.0.1',
  `failed_logins` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `locked` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `last_login` timestamp NULL DEFAULT NULL,
  `online` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `expansion` tinyint(3) UNSIGNED NOT NULL DEFAULT 4,
  `mutetime` bigint(20) NOT NULL DEFAULT 0,
  `mutereason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `muteby` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `locale` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `os` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `recruiter` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `project_member_id` int(30) UNSIGNED NOT NULL DEFAULT 0,
  `rank` int(5) NULL DEFAULT NULL,
  `staff_id` int(5) NULL DEFAULT NULL,
  `vp` int(5) NULL DEFAULT NULL,
  `dp` int(10) NOT NULL DEFAULT 0,
  `isactive` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `activation` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `invited_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `inv_friend_acc` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `rewarded` int(4) NOT NULL DEFAULT 0,
  `flags` int(5) NOT NULL DEFAULT 0,
  `gmlevel` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `active_realm_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `online_mute_timer` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `active_mute_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `project_verified` tinyint(1) NOT NULL DEFAULT 0,
  `cash` int(10) NOT NULL DEFAULT 0,
  `project_is_free` tinyint(1) NOT NULL DEFAULT 0,
  `project_is_temp` tinyint(1) NOT NULL DEFAULT 0,
  `project_unban_count` tinyint(4) NOT NULL DEFAULT 0,
  `project_antierror` int(10) UNSIGNED NULL DEFAULT NULL,
  `project_attached` int(10) UNSIGNED NULL DEFAULT NULL,
  `project_passchange` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `project_vote_time` bigint(20) NOT NULL DEFAULT 0,
  `project_hwid` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_id`(`id`) USING BTREE,
  INDEX `idx_sha`(`sha_pass_hash`) USING BTREE,
  INDEX `idx_session`(`sessionkey`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Account System' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account
-- ----------------------------
INSERT INTO `account` VALUES (1, 'admin', '', '8301316d0d8448a34fa6d0c6bf1cbfa2b4a1a93a', 'A399CD5AE22D0CC215745B06363D9E899E93C7315D852D3E30495EB6C875A5298C7F5EC13F48B818', '237D1E405E5987542B8B8A431DFF28F57A1764A3450F7FEFAEB469B50EE72552', '8FADC318970A522BEC10D85A4393779DF04D1A9F8A95640F4DC6E7881B87DB2B', '', 'admin@localhost', '', '2026-07-13 21:34:36', '127.0.0.1', 0, 0, '2026-07-14 23:45:07', 0, 4, 0, '', '', 4, 'Win', 0, 0, NULL, NULL, NULL, 88390000, NULL, NULL, '', '', 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, 0, 0, '');

-- ----------------------------
-- Table structure for account_access
-- ----------------------------
DROP TABLE IF EXISTS `account_access`;
CREATE TABLE `account_access`  (
  `id` int(10) UNSIGNED NOT NULL,
  `gmlevel` tinyint(3) UNSIGNED NOT NULL,
  `RealmID` int(11) NOT NULL DEFAULT -1,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `RealmID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_access
-- ----------------------------
INSERT INTO `account_access` VALUES (1, 5, -1, NULL);

-- ----------------------------
-- Table structure for account_achievement
-- ----------------------------
DROP TABLE IF EXISTS `account_achievement`;
CREATE TABLE `account_achievement`  (
  `account` int(10) UNSIGNED NOT NULL,
  `guid` int(10) UNSIGNED NOT NULL,
  `achievement` smallint(5) UNSIGNED NOT NULL,
  `date` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`account`, `achievement`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_achievement
-- ----------------------------

-- ----------------------------
-- Table structure for account_achievement_progress
-- ----------------------------
DROP TABLE IF EXISTS `account_achievement_progress`;
CREATE TABLE `account_achievement_progress`  (
  `account` int(10) UNSIGNED NOT NULL,
  `criteria` smallint(5) UNSIGNED NOT NULL,
  `counter` bigint(20) UNSIGNED NOT NULL,
  `date` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`account`, `criteria`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_achievement_progress
-- ----------------------------

-- ----------------------------
-- Table structure for account_banned
-- ----------------------------
DROP TABLE IF EXISTS `account_banned`;
CREATE TABLE `account_banned`  (
  `id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Account id',
  `realm` int(11) NOT NULL,
  `bandate` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `unbandate` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `bannedby` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `banreason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `active` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`, `bandate`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Ban List' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_banned
-- ----------------------------

-- ----------------------------
-- Table structure for account_battle_pet
-- ----------------------------
DROP TABLE IF EXISTS `account_battle_pet`;
CREATE TABLE `account_battle_pet`  (
  `id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `accountId` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `species` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `nickname` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `xp` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `health` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `maxHealth` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `power` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `speed` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `quality` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `breed` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `flags` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_battle_pet
-- ----------------------------

-- ----------------------------
-- Table structure for account_battle_pet_slots
-- ----------------------------
DROP TABLE IF EXISTS `account_battle_pet_slots`;
CREATE TABLE `account_battle_pet_slots`  (
  `accountId` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `slot1` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `slot2` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `slot3` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `flags` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`accountId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_battle_pet_slots
-- ----------------------------

-- ----------------------------
-- Table structure for account_boost
-- ----------------------------
DROP TABLE IF EXISTS `account_boost`;
CREATE TABLE `account_boost`  (
  `id` int(11) NOT NULL DEFAULT 0,
  `realmid` int(11) UNSIGNED NOT NULL DEFAULT 1,
  `counter` int(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_boost
-- ----------------------------

-- ----------------------------
-- Table structure for account_data
-- ----------------------------
DROP TABLE IF EXISTS `account_data`;
CREATE TABLE `account_data`  (
  `accountId` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Account Identifier',
  `type` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `data` blob NOT NULL,
  PRIMARY KEY (`accountId`, `type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_data
-- ----------------------------

-- ----------------------------
-- Table structure for account_instance_times
-- ----------------------------
DROP TABLE IF EXISTS `account_instance_times`;
CREATE TABLE `account_instance_times`  (
  `accountId` int(10) UNSIGNED NOT NULL,
  `instanceId` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `releaseTime` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`accountId`, `instanceId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_instance_times
-- ----------------------------

-- ----------------------------
-- Table structure for account_muted
-- ----------------------------
DROP TABLE IF EXISTS `account_muted`;
CREATE TABLE `account_muted`  (
  `id` int(10) NOT NULL,
  `realmid` int(3) NOT NULL DEFAULT 0,
  `acc_id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `mute_acc` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `mute_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `mute_date` bigint(40) NOT NULL,
  `muted_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `mute_time` bigint(20) NOT NULL,
  `mute_reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `public_channels_only` tinyint(3) NOT NULL,
  PRIMARY KEY (`realmid`, `id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_muted
-- ----------------------------

-- ----------------------------
-- Table structure for account_premium
-- ----------------------------
DROP TABLE IF EXISTS `account_premium`;
CREATE TABLE `account_premium`  (
  `id` int(11) NOT NULL DEFAULT 0 COMMENT 'Account id',
  `setdate` bigint(40) NOT NULL DEFAULT 0,
  `unsetdate` bigint(40) NOT NULL DEFAULT 0,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`, `setdate`) USING BTREE,
  INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Premium Accounts' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of account_premium
-- ----------------------------

-- ----------------------------
-- Table structure for account_premium_panda
-- ----------------------------
DROP TABLE IF EXISTS `account_premium_panda`;
CREATE TABLE `account_premium_panda`  (
  `id` int(11) NOT NULL DEFAULT 0,
  `pveMode` tinyint(1) NOT NULL DEFAULT 0
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_premium_panda
-- ----------------------------

-- ----------------------------
-- Table structure for account_referred
-- ----------------------------
DROP TABLE IF EXISTS `account_referred`;
CREATE TABLE `account_referred`  (
  `id1` bigint(20) UNSIGNED NOT NULL COMMENT 'Referring Account',
  `id2` bigint(20) UNSIGNED NOT NULL COMMENT 'Referred Account',
  PRIMARY KEY (`id1`) USING BTREE,
  INDEX `id2`(`id2`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_referred
-- ----------------------------

-- ----------------------------
-- Table structure for account_spell
-- ----------------------------
DROP TABLE IF EXISTS `account_spell`;
CREATE TABLE `account_spell`  (
  `account` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `spell` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `active` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `disabled` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`account`, `spell`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_spell
-- ----------------------------

-- ----------------------------
-- Table structure for account_tutorial
-- ----------------------------
DROP TABLE IF EXISTS `account_tutorial`;
CREATE TABLE `account_tutorial`  (
  `accountId` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Account Identifier',
  `tut0` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tut1` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tut2` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tut3` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tut4` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tut5` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tut6` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tut7` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`accountId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_tutorial
-- ----------------------------

-- ----------------------------
-- Table structure for arena_game_id
-- ----------------------------
DROP TABLE IF EXISTS `arena_game_id`;
CREATE TABLE `arena_game_id`  (
  `game_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `realm_id` tinyint(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`game_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of arena_game_id
-- ----------------------------

-- ----------------------------
-- Table structure for arena_games
-- ----------------------------
DROP TABLE IF EXISTS `arena_games`;
CREATE TABLE `arena_games`  (
  `gameid` bigint(20) NOT NULL DEFAULT 0,
  `teamid` bigint(20) NOT NULL DEFAULT 0,
  `guid` bigint(20) NOT NULL DEFAULT 0,
  `changeType` int(11) NOT NULL,
  `ratingChange` int(11) NOT NULL,
  `teamRating` int(11) NOT NULL,
  `matchMakerRating` smallint(5) UNSIGNED NULL DEFAULT NULL,
  `damageDone` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `healingDone` int(11) NOT NULL,
  `damageTaken` int(11) NOT NULL,
  `healingTaken` int(11) NOT NULL,
  `killingBlows` int(11) NOT NULL,
  `damageAbsorbed` int(11) UNSIGNED NOT NULL,
  `timeControlled` int(11) UNSIGNED NOT NULL,
  `aurasDispelled` int(11) UNSIGNED NOT NULL,
  `aurasStolen` int(11) UNSIGNED NOT NULL,
  `highLatencyTimes` int(11) UNSIGNED NOT NULL,
  `spellsPrecast` int(11) UNSIGNED NOT NULL,
  `mapId` int(11) NOT NULL,
  `start` int(11) NOT NULL,
  `end` int(11) NOT NULL,
  `class` tinyint(3) UNSIGNED NULL DEFAULT NULL,
  `season` smallint(5) UNSIGNED NULL DEFAULT NULL,
  `type` tinyint(3) UNSIGNED NULL DEFAULT NULL,
  `realmid` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`gameid`, `teamid`, `guid`) USING BTREE,
  INDEX `idx__teamid`(`teamid`) USING BTREE,
  INDEX `idx__season__class__type`(`season`, `class`, `type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'WoWArmory Game Chart' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of arena_games
-- ----------------------------

-- ----------------------------
-- Table structure for arena_match_stat
-- ----------------------------
DROP TABLE IF EXISTS `arena_match_stat`;
CREATE TABLE `arena_match_stat`  (
  `realm` tinyint(3) UNSIGNED NOT NULL,
  `teamGuid` int(10) UNSIGNED NOT NULL,
  `teamName` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` tinyint(3) UNSIGNED NOT NULL,
  `teamRating` smallint(5) UNSIGNED NOT NULL,
  `player` int(10) UNSIGNED NOT NULL,
  `class` tinyint(3) UNSIGNED NOT NULL,
  `name` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `time` int(10) UNSIGNED NOT NULL,
  `mapID` smallint(5) UNSIGNED NOT NULL,
  `instanceID` int(10) UNSIGNED NOT NULL,
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`teamGuid`, `realm`, `player`, `instanceID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of arena_match_stat
-- ----------------------------

-- ----------------------------
-- Table structure for arena_team
-- ----------------------------
DROP TABLE IF EXISTS `arena_team`;
CREATE TABLE `arena_team`  (
  `arenaTeamId` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(24) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `captainGuid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `realmNumber` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `type` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `rating` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `matchMakerRating` smallint(5) UNSIGNED NOT NULL DEFAULT 1500,
  `seasonGames` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `seasonWins` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `weekGames` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `weekWins` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `rank` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `backgroundColor` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `emblemStyle` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `emblemColor` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `borderStyle` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `borderColor` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `season` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `deleted` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `realmid` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`arenaTeamId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of arena_team
-- ----------------------------

-- ----------------------------
-- Table structure for arena_team_member
-- ----------------------------
DROP TABLE IF EXISTS `arena_team_member`;
CREATE TABLE `arena_team_member`  (
  `arenaTeamId` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `guid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `realmid` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `personalRating` smallint(5) NOT NULL DEFAULT 0,
  `matchMakerRating` smallint(5) UNSIGNED NOT NULL DEFAULT 1500,
  `weekGames` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `weekWins` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `seasonGames` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `seasonWins` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `class` tinyint(3) UNSIGNED NOT NULL,
  `joined` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `removed` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `itemLevel` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `lastILvlCheck` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`arenaTeamId`, `guid`, `realmid`) USING BTREE,
  INDEX `guid`(`guid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of arena_team_member
-- ----------------------------

-- ----------------------------
-- Table structure for armory_game_chart
-- ----------------------------
DROP TABLE IF EXISTS `armory_game_chart`;
CREATE TABLE `armory_game_chart`  (
  `gameid` int(11) NOT NULL,
  `realmid` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `teamid` int(11) NOT NULL,
  `guid` int(11) NOT NULL,
  `changeType` int(11) NOT NULL,
  `ratingChange` int(11) NOT NULL,
  `teamRating` int(11) NOT NULL,
  `damageDone` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `healingDone` int(11) NOT NULL,
  `damageTaken` int(11) NOT NULL,
  `healingTaken` int(11) NOT NULL,
  `killingBlows` int(11) NOT NULL,
  `mapId` int(11) NOT NULL,
  `start` int(11) NOT NULL,
  `end` int(11) NOT NULL,
  `class` tinyint(3) UNSIGNED NULL DEFAULT NULL,
  `season` smallint(5) UNSIGNED NULL DEFAULT NULL,
  `type` tinyint(3) UNSIGNED NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of armory_game_chart
-- ----------------------------

-- ----------------------------
-- Table structure for autobroadcast
-- ----------------------------
DROP TABLE IF EXISTS `autobroadcast`;
CREATE TABLE `autobroadcast`  (
  `realmid` int(11) NOT NULL DEFAULT -1,
  `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `weight` tinyint(3) UNSIGNED NULL DEFAULT 1,
  `text` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`, `realmid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of autobroadcast
-- ----------------------------

-- ----------------------------
-- Table structure for battleground_games
-- ----------------------------
DROP TABLE IF EXISTS `battleground_games`;
CREATE TABLE `battleground_games`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `season` int(10) UNSIGNED NOT NULL,
  `realm_id` int(10) UNSIGNED NOT NULL,
  `map_id` int(10) UNSIGNED NOT NULL,
  `instance_id` int(10) UNSIGNED NOT NULL,
  `is_random_bg` tinyint(3) UNSIGNED NOT NULL,
  `winner` enum('H','A','N') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `start_time` int(10) UNSIGNED NOT NULL,
  `duration` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `realm_id`(`realm_id`) USING BTREE,
  INDEX `map_id`(`map_id`) USING BTREE,
  INDEX `season`(`season`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of battleground_games
-- ----------------------------

-- ----------------------------
-- Table structure for battleground_ladder_criteria
-- ----------------------------
DROP TABLE IF EXISTS `battleground_ladder_criteria`;
CREATE TABLE `battleground_ladder_criteria`  (
  `criteria` enum('Win','Loss','FastWin','Kills','ObjectiveCaptures','ObjectiveDefenses','DailyWins','DailyKills','SeasonKills','SeasonWinsAV','SeasonWinsWG','SeasonWinsAB','SeasonWinsEotS','SeasonWinsSotA','SeasonWinsIoC','TotalWins','TotalDraws','TotalLosses','TotalKills','TotalLeavesBeforeGame','TotalLeavesDuringGame') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Name of the column in `battleground_ladder_progress` if `type` is \'Daily\', \'Season\' or \'Statistic\'',
  `type` enum('Statistic','Season','Daily','Alterac Valley','Warsong Gulch','Arathi Basin','Eye of the Storm','Strand of the Ancients','Isle of Conquest') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'If not set - affects all battlegrounds, if set - overrides global setting only for the specified battleground. Only valid for battleground-specific `type`s',
  `param` int(11) NOT NULL DEFAULT 0,
  `name` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `cap` int(10) UNSIGNED NOT NULL COMMENT 'Maximum count of progress units a player can get',
  `ladder_points_per_progress` int(11) NOT NULL DEFAULT 0 COMMENT 'Repeatable ladder points reward for each unit of progress in this criteria',
  `ladder_points_for_cap` int(11) NOT NULL DEFAULT 0 COMMENT 'One-time ladder points reward for reaching progress cap in this criteria',
  `group_penalty_size` int(11) UNSIGNED NOT NULL DEFAULT 3 COMMENT 'Count of group members at which ladder points penalty from `group_penalty_percent` kicks in',
  `group_penalty_percent` int(11) NOT NULL DEFAULT 0 COMMENT 'Percentage modifier of ladder points for each player in the group above or equal to `group_penalty_size`',
  PRIMARY KEY (`criteria`, `type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of battleground_ladder_criteria
-- ----------------------------

-- ----------------------------
-- Table structure for battleground_ladder_rewards
-- ----------------------------
DROP TABLE IF EXISTS `battleground_ladder_rewards`;
CREATE TABLE `battleground_ladder_rewards`  (
  `season` int(10) UNSIGNED NOT NULL COMMENT 'Battleground season ID',
  `id` int(10) UNSIGNED NOT NULL COMMENT 'Incrementing number identifying this reward set',
  `top` float UNSIGNED NOT NULL COMMENT 'How many players will receive the reward. Depends on `type`',
  `type` enum('Players','Percents') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'Players' COMMENT 'Determines whether the `top` number or `top` percentage of players will receive the reward',
  `money_reward` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Amount in copper',
  `item_reward` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Format: itemid:count itemid:count ...',
  `loyalty_reward` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of Orbs of Loyalty',
  `premium_reward` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Duration in timestring format (e.g. \"30d5h42m10s\")',
  `title_reward` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Title ID',
  `mail_subject` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `mail_text` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`season`, `id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of battleground_ladder_rewards
-- ----------------------------

-- ----------------------------
-- Table structure for battleground_scores
-- ----------------------------
DROP TABLE IF EXISTS `battleground_scores`;
CREATE TABLE `battleground_scores`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each player that participated in the battleground',
  `game_id` int(10) UNSIGNED NOT NULL,
  `team` tinyint(3) UNSIGNED NOT NULL,
  `guid` int(10) UNSIGNED NOT NULL,
  `realm_id` int(10) UNSIGNED NOT NULL,
  `group_index` int(10) UNSIGNED NOT NULL,
  `ladder_points` int(10) NOT NULL,
  `killing_blows` int(10) UNSIGNED NOT NULL,
  `deaths` int(10) UNSIGNED NOT NULL,
  `honorable_kills` int(10) UNSIGNED NOT NULL,
  `damage_done` int(10) UNSIGNED NOT NULL,
  `healing_done` int(10) UNSIGNED NOT NULL,
  `damage_taken` int(10) UNSIGNED NOT NULL,
  `healing_taken` int(10) UNSIGNED NOT NULL,
  `bonus_honor` int(10) UNSIGNED NOT NULL,
  `graveyards_assaulted` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Alterac Valley',
  `graveyards_defended` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Alterac Valley',
  `towers_assaulted` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Alterac Valley',
  `towers_defended` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Alterac Valley',
  `mines_captured` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Alterac Valley',
  `leaders_killed` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Alterac Valley',
  `secondary_objective` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Alterac Valley',
  `flag_captures` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Warsong Gulch, Eye of the Storm',
  `flag_returns` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Warsong Gulch',
  `bases_assaulted` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Arathi Basin, Isle of Conquest',
  `bases_defended` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Arathi Basin, Isle of Conquest',
  `demolishers_destroyed` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Strand of the Ancients',
  `gates_destroyed` int(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Strand of the Ancients',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `game_id`(`game_id`) USING BTREE,
  INDEX `guid`(`guid`) USING BTREE,
  INDEX `realm_id`(`realm_id`) USING BTREE,
  CONSTRAINT `FK_battleground_scores_battleground_games` FOREIGN KEY (`game_id`) REFERENCES `battleground_games` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of battleground_scores
-- ----------------------------

-- ----------------------------
-- Table structure for battleground_seasons
-- ----------------------------
DROP TABLE IF EXISTS `battleground_seasons`;
CREATE TABLE `battleground_seasons`  (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `begin` int(10) UNSIGNED NOT NULL,
  `end` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of battleground_seasons
-- ----------------------------

-- ----------------------------
-- Table structure for battlenet_account_bans
-- ----------------------------
DROP TABLE IF EXISTS `battlenet_account_bans`;
CREATE TABLE `battlenet_account_bans`  (
  `id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Account id',
  `bandate` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `unbandate` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `bannedby` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `banreason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`, `bandate`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Ban List' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of battlenet_account_bans
-- ----------------------------

-- ----------------------------
-- Table structure for battlenet_accounts
-- ----------------------------
DROP TABLE IF EXISTS `battlenet_accounts`;
CREATE TABLE `battlenet_accounts`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `email` varchar(320) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sha_pass_hash` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `v` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `s` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `sessionKey` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `locked` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `last_login` timestamp NULL DEFAULT NULL,
  `online` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `last_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '127.0.0.1',
  `failed_logins` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `project_member_id` int(10) UNSIGNED NULL DEFAULT NULL,
  `project_is_temp` tinyint(1) NULL DEFAULT 0 COMMENT 'nighthold',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Account System' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of battlenet_accounts
-- ----------------------------

-- ----------------------------
-- Table structure for battlepay_log
-- ----------------------------
DROP TABLE IF EXISTS `battlepay_log`;
CREATE TABLE `battlepay_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `accountId` int(11) UNSIGNED NOT NULL,
  `characterGuid` int(10) NOT NULL DEFAULT 0,
  `realm` int(5) UNSIGNED NOT NULL,
  `item` int(10) NOT NULL DEFAULT 0,
  `price` int(5) UNSIGNED NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of battlepay_log
-- ----------------------------
INSERT INTO `battlepay_log` VALUES (1, 1, 1, 1, 110012, 900000, '2026-07-14 22:28:41');
INSERT INTO `battlepay_log` VALUES (2, 1, 1, 1, 23162, 120000, '2026-07-14 22:28:53');
INSERT INTO `battlepay_log` VALUES (3, 1, 1, 1, 23162, 120000, '2026-07-14 22:29:03');
INSERT INTO `battlepay_log` VALUES (4, 1, 1, 1, 76755, 300000, '2026-07-14 23:53:18');
INSERT INTO `battlepay_log` VALUES (5, 1, 1, 1, 44151, 170000, '2026-07-14 23:55:03');

-- ----------------------------
-- Table structure for bonus_rates
-- ----------------------------
DROP TABLE IF EXISTS `bonus_rates`;
CREATE TABLE `bonus_rates`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Autoincrementable ID',
  `realmid` int(11) NOT NULL DEFAULT -1 COMMENT 'RealmID for which the rates would be active. -1 for all realms',
  `active` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'If set to 0 - this bonus would not be loaded',
  `schedule` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '* * * * *' COMMENT 'Cron-style schedule defining the time for the bonus rates period. Multiple periods can be specified with a semicolon separated list',
  `multiplier` float NOT NULL DEFAULT 2 COMMENT 'Rate multiplier (i.e. 2 would change the rates to be twice their usual value during the bonus rates period)',
  `rates` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Space separated list of rate names as used in config (i.e. \"Rate.XP.Kill Rate.Honor\")',
  `start_announcement` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'Announcement displayed in chat for all online players when the bonus rate period starts',
  `end_announcement` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'Announcement displayed in chat for all online players when the bonus rate period ends',
  `active_announcement` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'Announcement displayed in chat for all players logging in whenever the bonus rate period is active',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of bonus_rates
-- ----------------------------

-- ----------------------------
-- Table structure for boost_promotion_executed
-- ----------------------------
DROP TABLE IF EXISTS `boost_promotion_executed`;
CREATE TABLE `boost_promotion_executed`  (
  `member_id` int(11) NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of boost_promotion_executed
-- ----------------------------

-- ----------------------------
-- Table structure for broadcast_strings
-- ----------------------------
DROP TABLE IF EXISTS `broadcast_strings`;
CREATE TABLE `broadcast_strings`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `text` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `next` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of broadcast_strings
-- ----------------------------

-- ----------------------------
-- Table structure for config
-- ----------------------------
DROP TABLE IF EXISTS `config`;
CREATE TABLE `config`  (
  `category` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `value` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `default` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `realmid` smallint(6) NOT NULL DEFAULT -1,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `note` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`name`, `realmid`) USING BTREE,
  INDEX `option`(`name`) USING BTREE,
  INDEX `category`(`category`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Here you can put the configs from the worldserver.conf file, so you can change without acessing the machine files.' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of config
-- ----------------------------
INSERT INTO `config` VALUES ('Players', 'AllowTwoSide.Interaction.Auction', '0', '0', 1, 'Merge all auction houses for players from different teams\nDefault: 0 (Not allowed)\n         1 (Allowed)', NULL);
INSERT INTO `config` VALUES ('Players', 'AllowTwoSide.Interaction.Chat', '0', '0', -1, 'Allow chat assembling between factions.\nDefault:     0', NULL);
INSERT INTO `config` VALUES ('AntiCheat', 'Anticheat.DetectionsEnabled', '27', '31', 1, 'Anticheat hack', NULL);
INSERT INTO `config` VALUES ('AntiCheat', 'Anticheat.ReportsForIngameWarnings', '70', '1', 1, 'Anticheat hack', NULL);
INSERT INTO `config` VALUES ('Rate', 'BonusRoll.LootChance', '31', '31', 1, 'Bonus Roll', NULL);
INSERT INTO `config` VALUES ('Dungeon Finder', 'DungeonFinder.CastDeserter', '0', '1', 1, 'Cast Deserter spell at players who leave DF-parties while the dungeons is in progress.\nDefault:     1', NULL);
INSERT INTO `config` VALUES ('Dungeon Finder', 'DungeonFinder.DPSNeeded', '1', '1', 1, 'Specifies how many players have to select dps role in order for the party to be eligible for a dungeon.\nDefault:     1', NULL);
INSERT INTO `config` VALUES ('Dungeon Finder', 'DungeonFinder.HealersNeeded', '1', '1', 1, 'Specifies how many players have to select healer role in order for the party to be eligible for a dungeon.\nDefault:     1', NULL);
INSERT INTO `config` VALUES ('Dungeon Finder', 'DungeonFinder.KeepQueuesInDungeon', 'true', '1', 1, 'Specifies how many players have to select healer role in order for the party to be eligible for a dungeon.\nDefault:     1', NULL);
INSERT INTO `config` VALUES ('Dungeon Finder', 'DungeonFinder.OverrideRolesRequired', 'true', '0', 1, 'If enabled all LFG role checks will use values from DungeonFinder.TanksNeeded, DungeonFinder.HealersNeeded and DungeonFinder.DPSNeeded to determine the number of players required in order for the party to be eligible for a dungeon. Overrides both group and raid dungeon values.\nDefault:     0', NULL);
INSERT INTO `config` VALUES ('Dungeon Finder', 'DungeonFinder.ShortageCheckInterval', '60', '60', 1, 'Specifies the interval in seconds at which shortage roles for a queue should be updated.\nDefault:     5', NULL);
INSERT INTO `config` VALUES ('Dungeon Finder', 'DungeonFinder.ShortagePercent', '50', '50', 1, 'Specifies at which percent of the ideal role representation ratio in a queue should it grant a Call to Arms reward\nDefault:     50', NULL);
INSERT INTO `config` VALUES ('Dungeon Finder', 'DungeonFinder.TanksNeeded', '1', '1', 1, 'Specifies how many players have to select tank role in order for the party to be eligible for a dungeon.\nDefault:     1', NULL);
INSERT INTO `config` VALUES ('LFR', 'LFR.LootChance', '100', '20', -1, 'Chance to get personal loot from any boss', NULL);
INSERT INTO `config` VALUES ('Rate', 'TargetPosRecalculateRange', '5', '5', 1, 'Range attack ', NULL);
INSERT INTO `config` VALUES ('Misc', 'VengeanceMultipier', '1', '1', -1, NULL, NULL);
INSERT INTO `config` VALUES ('Performance', 'Visibility.AINotifyDelay', '1000', '1000', 1, 'Description: delay (in milliseconds) between action and nearby AI reaction. Lower values may have\n             performance impact.\nDefault:     1000', NULL);
INSERT INTO `config` VALUES ('Performance', 'Visibility.RelocationLowerLimit', '10', '20', 1, 'Description: distance in yards. unit should pass that distance to trigger visibility update.\nDefault:     10', NULL);
INSERT INTO `config` VALUES ('Rate', 'XP.Gather.Difference', '10', '0', 1, '', NULL);
INSERT INTO `config` VALUES ('Rate', 'XP.Kill.Difference', '10', '0', 1, '', NULL);

-- ----------------------------
-- Table structure for creature_raid_respawn
-- ----------------------------
DROP TABLE IF EXISTS `creature_raid_respawn`;
CREATE TABLE `creature_raid_respawn`  (
  `playerGuid` int(10) UNSIGNED NOT NULL,
  `creatureGuid` int(10) UNSIGNED NOT NULL,
  `mapId` int(10) UNSIGNED NOT NULL,
  `respawnTime` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`playerGuid`, `creatureGuid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of creature_raid_respawn
-- ----------------------------

-- ----------------------------
-- Table structure for currency_transactions
-- ----------------------------
DROP TABLE IF EXISTS `currency_transactions`;
CREATE TABLE `currency_transactions`  (
  `realmid` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `guid` int(10) UNSIGNED NOT NULL,
  `unix_time` int(10) UNSIGNED NOT NULL,
  `operation` enum('LOOT_MOB','LOOT_ITEM','MAIL','QUEST_REWARD','TRADE','SELL_ITEM','GUILD_BANK','AUCTION','TRANSMOGRIFICATION') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `param` int(10) UNSIGNED NULL DEFAULT NULL,
  `attachments` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `amount_before` int(10) UNSIGNED NULL DEFAULT NULL,
  `amount_after` int(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_guid`(`guid`) USING BTREE,
  INDEX `idx_operation`(`operation`) USING BTREE,
  INDEX `idx_unix_time`(`unix_time`) USING BTREE,
  INDEX `idx_param`(`param`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of currency_transactions
-- ----------------------------
INSERT INTO `currency_transactions` VALUES (1, 93, 1, 1783951684, 'QUEST_REWARD', 28766, '', 0, 50);
INSERT INTO `currency_transactions` VALUES (1, 94, 1, 1783951711, 'LOOT_MOB', 49874, '', 50, 53);
INSERT INTO `currency_transactions` VALUES (1, 95, 1, 1783951721, 'LOOT_MOB', 49874, '', 53, 56);
INSERT INTO `currency_transactions` VALUES (1, 96, 1, 1783952998, 'LOOT_MOB', 49874, '', 56, 59);
INSERT INTO `currency_transactions` VALUES (1, 97, 1, 1783953009, 'LOOT_MOB', 49874, '', 59, 62);
INSERT INTO `currency_transactions` VALUES (1, 98, 1, 1783953022, 'LOOT_MOB', 49874, '', 62, 65);
INSERT INTO `currency_transactions` VALUES (1, 99, 1, 1783953034, 'LOOT_MOB', 49874, '', 65, 68);
INSERT INTO `currency_transactions` VALUES (1, 100, 1, 1783953052, 'LOOT_MOB', 49874, '', 68, 71);
INSERT INTO `currency_transactions` VALUES (1, 101, 1, 1783953066, 'LOOT_MOB', 49874, '', 71, 74);
INSERT INTO `currency_transactions` VALUES (1, 102, 1, 1783953087, 'QUEST_REWARD', 28774, '', 74, 114);
INSERT INTO `currency_transactions` VALUES (1, 103, 1, 1784039183, 'QUEST_REWARD', 29547, '', 114, 9914);
INSERT INTO `currency_transactions` VALUES (1, 104, 1, 1784039536, 'QUEST_REWARD', 29548, '', 212199514, 212297514);
INSERT INTO `currency_transactions` VALUES (1, 105, 1, 1784039541, 'QUEST_REWARD', 31732, '', 212297514, 212395514);
INSERT INTO `currency_transactions` VALUES (1, 106, 1, 1784039559, 'QUEST_REWARD', 31733, '', 212395514, 212493514);

-- ----------------------------
-- Table structure for gameobject_raid_respawn
-- ----------------------------
DROP TABLE IF EXISTS `gameobject_raid_respawn`;
CREATE TABLE `gameobject_raid_respawn`  (
  `playerGuid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `gameobjectGuid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `mapId` smallint(10) UNSIGNED NULL DEFAULT NULL,
  `respawnTime` int(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`playerGuid`, `gameobjectGuid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of gameobject_raid_respawn
-- ----------------------------

-- ----------------------------
-- Table structure for icore_stat
-- ----------------------------
DROP TABLE IF EXISTS `icore_stat`;
CREATE TABLE `icore_stat`  (
  `online` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `diff` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `uptime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `revision` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'Skyfire',
  PRIMARY KEY (`online`, `diff`, `uptime`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of icore_stat
-- ----------------------------

-- ----------------------------
-- Table structure for ip_banned
-- ----------------------------
DROP TABLE IF EXISTS `ip_banned`;
CREATE TABLE `ip_banned`  (
  `ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '127.0.0.1',
  `bandate` int(10) UNSIGNED NOT NULL,
  `unbandate` int(10) UNSIGNED NOT NULL,
  `bannedby` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '[Console]',
  `banreason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'no reason',
  PRIMARY KEY (`ip`, `bandate`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Banned IPs' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ip_banned
-- ----------------------------

-- ----------------------------
-- Table structure for logs
-- ----------------------------
DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs`  (
  `time` int(10) UNSIGNED NOT NULL,
  `realm` int(10) UNSIGNED NOT NULL,
  `type` tinyint(3) UNSIGNED NOT NULL,
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `string` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of logs
-- ----------------------------

-- ----------------------------
-- Table structure for mute_active
-- ----------------------------
DROP TABLE IF EXISTS `mute_active`;
CREATE TABLE `mute_active`  (
  `realmid` tinyint(3) NOT NULL,
  `account` int(11) NOT NULL,
  `mute_id` int(11) NOT NULL,
  `mute_timer` int(11) NOT NULL,
  PRIMARY KEY (`realmid`, `account`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of mute_active
-- ----------------------------

-- ----------------------------
-- Table structure for pandaria_token
-- ----------------------------
DROP TABLE IF EXISTS `pandaria_token`;
CREATE TABLE `pandaria_token`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` int(11) UNSIGNED NOT NULL,
  `character_guid` int(10) NOT NULL DEFAULT 0,
  `realm` int(5) UNSIGNED NOT NULL,
  `vp_count` int(5) UNSIGNED NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of pandaria_token
-- ----------------------------

-- ----------------------------
-- Table structure for pay_history
-- ----------------------------
DROP TABLE IF EXISTS `pay_history`;
CREATE TABLE `pay_history`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `orderNo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `synType` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `price` float(10, 2) NULL DEFAULT NULL,
  `time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `cpparam` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'not used, don\'t know how to make payment work.' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of pay_history
-- ----------------------------

-- ----------------------------
-- Table structure for project_betatesters
-- ----------------------------
DROP TABLE IF EXISTS `project_betatesters`;
CREATE TABLE `project_betatesters`  (
  `id` int(11) NOT NULL,
  `betatest_id` int(11) NOT NULL,
  `member_id` mediumint(8) NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk__project_betatesters__members1_idx`(`member_id`) USING BTREE,
  INDEX `fk__project_betatesters__account1_idx`(`account_id`) USING BTREE,
  INDEX `fk__project_betatesters__project_betatests1_idx`(`betatest_id`) USING BTREE,
  INDEX `fk__project_betatesters__project_betatest_accounts1_idx`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'used for betatesting and allowing players with ids.' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of project_betatesters
-- ----------------------------

-- ----------------------------
-- Table structure for project_member_premiums
-- ----------------------------
DROP TABLE IF EXISTS `project_member_premiums`;
CREATE TABLE `project_member_premiums`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` mediumint(8) NOT NULL,
  `setdate` bigint(40) NOT NULL,
  `unsetdate` bigint(40) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `card_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk__nighthold_member_premium__members1_idx`(`member_id`) USING BTREE,
  INDEX `fk__nighthold_member_premiums__nighthold_member_items1_idx`(`card_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Premium Members' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of project_member_premiums
-- ----------------------------

-- ----------------------------
-- Table structure for project_member_rewards
-- ----------------------------
DROP TABLE IF EXISTS `project_member_rewards`;
CREATE TABLE `project_member_rewards`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` int(10) UNSIGNED NOT NULL,
  `character_guid` int(10) UNSIGNED NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `realmid` int(10) UNSIGNED NOT NULL,
  `source_type` tinyint(3) UNSIGNED NOT NULL,
  `source_id` int(10) UNSIGNED NOT NULL,
  `reward_amount` int(10) UNSIGNED NOT NULL,
  `reward_date` int(10) UNSIGNED NOT NULL,
  `reward_day` int(10) UNSIGNED NOT NULL COMMENT 'Used only for indexing purposes',
  `processed` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `process_date` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `member_id_reward_day_source_type`(`member_id`, `reward_day`, `source_type`) USING BTREE,
  INDEX `idx__member_id`(`member_id`) USING BTREE,
  INDEX `idx__processed`(`processed`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Member Rewards' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of project_member_rewards
-- ----------------------------

-- ----------------------------
-- Table structure for project_member_settings
-- ----------------------------
DROP TABLE IF EXISTS `project_member_settings`;
CREATE TABLE `project_member_settings`  (
  `member_id` int(10) UNSIGNED NOT NULL,
  `setting` int(10) UNSIGNED NOT NULL COMMENT 'nightholdMemberInfo::Setting in core',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`member_id`, `setting`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Member Settings' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of project_member_settings
-- ----------------------------

-- ----------------------------
-- Table structure for promocodes
-- ----------------------------
DROP TABLE IF EXISTS `promocodes`;
CREATE TABLE `promocodes`  (
  `code` varchar(50) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'Latin letters, digits and dash symbol are allowed, case insensitive',
  `realmid` int(11) NOT NULL DEFAULT -1 COMMENT 'Realm the code can be redeemed on or -1 for any realm',
  `start_time` int(10) UNSIGNED NOT NULL COMMENT 'Activation UNIX timestamp, 0 if always active',
  `end_time` int(10) UNSIGNED NOT NULL COMMENT 'Expiration UNIX timestamp, 0 if never expires',
  `money` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Copper',
  `items` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Format: itemid:count itemid:count ...',
  `premium` tinytext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Duration in timestring format (e.g. \"30d5h42m10s\")',
  `redeemed` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 if the code was redeemed, 0 otherwise',
  `redeemer_guid` int(10) UNSIGNED NOT NULL COMMENT 'Character GUID that redeemed the code',
  `redeemer_realmid` int(10) UNSIGNED NOT NULL COMMENT 'Character\'s realm',
  `redeemer_account` int(10) UNSIGNED NOT NULL COMMENT 'Character\'s account',
  `redeemer_member` int(10) UNSIGNED NOT NULL COMMENT 'Character\'s nighthold member',
  PRIMARY KEY (`code`) USING BTREE,
  INDEX `realmid`(`realmid`) USING BTREE,
  INDEX `redeemed`(`redeemed`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'used for custom\r\ntodo: make this implement into blizzcms' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of promocodes
-- ----------------------------

-- ----------------------------
-- Table structure for promotion_auras
-- ----------------------------
DROP TABLE IF EXISTS `promotion_auras`;
CREATE TABLE `promotion_auras`  (
  `entry` int(11) UNSIGNED NOT NULL,
  `start_date` int(11) UNSIGNED NOT NULL,
  `lenght` int(11) UNSIGNED NOT NULL COMMENT 'Lenght in minutes',
  `active` tinyint(1) UNSIGNED NOT NULL,
  `comment` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`entry`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of promotion_auras
-- ----------------------------

-- ----------------------------
-- Table structure for rbac_account_groups
-- ----------------------------
DROP TABLE IF EXISTS `rbac_account_groups`;
CREATE TABLE `rbac_account_groups`  (
  `accountId` int(10) UNSIGNED NOT NULL COMMENT 'Account id',
  `groupId` int(10) UNSIGNED NOT NULL COMMENT 'Group id',
  `realmId` int(11) NOT NULL DEFAULT -1 COMMENT 'Realm Id, -1 means all',
  PRIMARY KEY (`accountId`, `groupId`, `realmId`) USING BTREE,
  INDEX `fk__rbac_account_groups__rbac_groups`(`groupId`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Account-Group relation' ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of rbac_account_groups
-- ----------------------------

-- ----------------------------
-- Table structure for rbac_account_permissions
-- ----------------------------
DROP TABLE IF EXISTS `rbac_account_permissions`;
CREATE TABLE `rbac_account_permissions`  (
  `accountId` int(10) UNSIGNED NOT NULL COMMENT 'Account id',
  `permissionId` int(10) UNSIGNED NOT NULL COMMENT 'Permission id',
  `granted` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Granted = 1, Denied = 0',
  `realmId` int(11) NOT NULL DEFAULT -1 COMMENT 'Realm Id, -1 means all',
  PRIMARY KEY (`accountId`, `permissionId`, `realmId`) USING BTREE,
  INDEX `fk__rbac_account_roles__rbac_permissions`(`permissionId`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Account-Permission relation' ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of rbac_account_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for realm_classes
-- ----------------------------
DROP TABLE IF EXISTS `realm_classes`;
CREATE TABLE `realm_classes`  (
  `realmId` int(11) NOT NULL,
  `class` tinyint(4) NOT NULL COMMENT 'Class Id',
  `expansion` tinyint(4) NOT NULL COMMENT 'Expansion for class activation',
  PRIMARY KEY (`realmId`, `class`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of realm_classes
-- ----------------------------

-- ----------------------------
-- Table structure for realm_diff_stats
-- ----------------------------
DROP TABLE IF EXISTS `realm_diff_stats`;
CREATE TABLE `realm_diff_stats`  (
  `realm_id` tinyint(3) UNSIGNED NOT NULL,
  `diff` mediumint(8) UNSIGNED NULL DEFAULT NULL,
  `min` mediumint(8) UNSIGNED NULL DEFAULT NULL,
  `max` mediumint(8) UNSIGNED NULL DEFAULT NULL,
  `unixtime` int(10) NOT NULL,
  PRIMARY KEY (`realm_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of realm_diff_stats
-- ----------------------------
INSERT INTO `realm_diff_stats` VALUES (1, 25, 1, 157, 1784044620);

-- ----------------------------
-- Table structure for realm_races
-- ----------------------------
DROP TABLE IF EXISTS `realm_races`;
CREATE TABLE `realm_races`  (
  `realmId` int(11) NOT NULL,
  `race` tinyint(4) NOT NULL COMMENT 'Race Id',
  `expansion` tinyint(4) NOT NULL COMMENT 'Expansion for race activation',
  PRIMARY KEY (`realmId`, `race`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of realm_races
-- ----------------------------

-- ----------------------------
-- Table structure for realmcharacters
-- ----------------------------
DROP TABLE IF EXISTS `realmcharacters`;
CREATE TABLE `realmcharacters`  (
  `realmid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `acctid` int(10) UNSIGNED NOT NULL,
  `numchars` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`realmid`, `acctid`) USING BTREE,
  INDEX `acctid`(`acctid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'How many characters accounts have' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of realmcharacters
-- ----------------------------
INSERT INTO `realmcharacters` VALUES (1, 1, 1);

-- ----------------------------
-- Table structure for realmlist
-- ----------------------------
DROP TABLE IF EXISTS `realmlist`;
CREATE TABLE `realmlist`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `project_shortname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `address` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '127.0.0.1',
  `port` int(11) NOT NULL DEFAULT 8085,
  `icon` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `color` tinyint(3) UNSIGNED NOT NULL DEFAULT 2,
  `timezone` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `allowedSecurityLevel` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `population` float UNSIGNED NOT NULL DEFAULT 0,
  `gamebuild` int(11) UNSIGNED NOT NULL DEFAULT 12340,
  `flag` int(11) NULL DEFAULT NULL,
  `project_hidden` tinyint(1) NOT NULL DEFAULT 0,
  `project_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `project_dbname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_dbworld` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_dbarchive` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_rates_min` tinyint(4) NOT NULL COMMENT 'project',
  `project_rates_max` tinyint(4) NOT NULL COMMENT 'project',
  `project_transfer_level_max` tinyint(4) NOT NULL DEFAULT 80,
  `project_transfer_items` enum('IGNORE','IMPORT','REPLACE','SELECT') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'IGNORE',
  `project_transfer_skills_spells` enum('IGNORE','IMPORT','REPLACE','SELECT') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'IGNORE',
  `project_transfer_glyphs` enum('IGNORE','IMPORT') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'IGNORE',
  `project_transfer_achievements` enum('IGNORE','IMPORT') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'IGNORE',
  `project_server_same` tinyint(1) NOT NULL DEFAULT 0,
  `project_server_settings` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_server_remote_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_accounts_detach` tinyint(1) NOT NULL DEFAULT 1,
  `project_setskills_value_max` smallint(6) NOT NULL DEFAULT 0,
  `project_chat_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `project_statistics_enabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Realm System' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of realmlist
-- ----------------------------
INSERT INTO `realmlist` VALUES (1, 'Pandaria 5.4.8', 'Pandaria 5.4.8', '127.0.0.1', 8085, 0, 2, 16, 0, 0, 18414, 34, 0, 1, 'characters', 'world', 'archive', 0, 0, 80, 'IGNORE', 'IGNORE', 'IGNORE', 'IGNORE', 0, '0', '0', 1, 0, 0, 0);

-- ----------------------------
-- Table structure for realmlist_proxy
-- ----------------------------
DROP TABLE IF EXISTS `realmlist_proxy`;
CREATE TABLE `realmlist_proxy`  (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'Must be different from `realmlist`.`name`, otherwise will override original realm\'s address and port',
  `address` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '127.0.0.1',
  `port` int(11) NOT NULL DEFAULT 8085,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of realmlist_proxy
-- ----------------------------

-- ----------------------------
-- Table structure for sql_update
-- ----------------------------
DROP TABLE IF EXISTS `sql_update`;
CREATE TABLE `sql_update`  (
  `file` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `realmid` tinyint(4) NOT NULL DEFAULT -1,
  `date` datetime NULL DEFAULT NULL,
  `result` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`file`, `realmid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sql_update
-- ----------------------------

-- ----------------------------
-- Table structure for uptime
-- ----------------------------
DROP TABLE IF EXISTS `uptime`;
CREATE TABLE `uptime`  (
  `realmid` int(10) UNSIGNED NOT NULL,
  `starttime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `uptime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `maxplayers` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `revision` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'SkyFire',
  PRIMARY KEY (`realmid`, `starttime`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Uptime system' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of uptime
-- ----------------------------
INSERT INTO `uptime` VALUES (1, 1783951291, 600, 1, 'Pandaria 5.4.8 Rev: 0 Release Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783952777, 0, 0, 'Pandaria 5.4.8 Rev: 0 Release Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783953380, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783954108, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783955326, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783955518, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783955613, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783955698, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783956163, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783956418, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783982474, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783983088, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783983383, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783983792, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783984385, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1783984486, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1784035045, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1784035348, 601, 1, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1784036392, 4201, 1, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1784040926, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1784041606, 601, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1784042600, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1784043269, 0, 0, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');
INSERT INTO `uptime` VALUES (1, 1784043899, 601, 1, 'Pandaria 5.4.8 Rev: 0 RelWithDebInfo Hash: Archive (Win64, little-endian)');

SET FOREIGN_KEY_CHECKS = 1;
