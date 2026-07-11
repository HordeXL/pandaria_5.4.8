/*
SQLyog Community v12.14 (64 bit)
MySQL - 5.5.62 : Database - auth
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`auth` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `auth`;

/*Table structure for table `account` */

DROP TABLE IF EXISTS `account`;

CREATE TABLE `account` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `username` varchar(32) NOT NULL DEFAULT '',
  `battlenet_account` varchar(32) NOT NULL DEFAULT '',
  `sha_pass_hash` varchar(40) NOT NULL DEFAULT '',
  `sessionkey` varchar(80) NOT NULL DEFAULT '',
  `v` varchar(64) NOT NULL DEFAULT '',
  `s` varchar(64) NOT NULL DEFAULT '',
  `token_key` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `reg_mail` varchar(255) NOT NULL DEFAULT '',
  `joindate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_ip` varchar(15) NOT NULL DEFAULT '127.0.0.1',
  `failed_logins` int(10) unsigned NOT NULL DEFAULT '0',
  `locked` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `last_login` timestamp NULL DEFAULT NULL,
  `online` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `expansion` tinyint(3) unsigned NOT NULL DEFAULT '4',
  `mutetime` bigint(20) NOT NULL DEFAULT '0',
  `mutereason` varchar(255) NOT NULL DEFAULT '',
  `muteby` varchar(50) NOT NULL DEFAULT '',
  `locale` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `os` varchar(4) NOT NULL DEFAULT '',
  `recruiter` int(10) unsigned NOT NULL DEFAULT '0',
  `project_member_id` int(30) unsigned NOT NULL DEFAULT '0',
  `rank` int(5) DEFAULT NULL,
  `staff_id` int(5) DEFAULT NULL,
  `vp` int(5) DEFAULT NULL,
  `dp` int(10) NOT NULL DEFAULT '0',
  `isactive` varchar(50) DEFAULT NULL,
  `activation` varchar(256) DEFAULT NULL,
  `invited_by` varchar(32) NOT NULL DEFAULT '',
  `inv_friend_acc` varchar(32) NOT NULL DEFAULT '',
  `rewarded` int(4) NOT NULL DEFAULT '0',
  `flags` int(5) NOT NULL DEFAULT '0',
  `gmlevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `active_realm_id` int(11) unsigned NOT NULL DEFAULT '0',
  `online_mute_timer` bigint(20) unsigned NOT NULL DEFAULT '0',
  `active_mute_id` int(11) unsigned NOT NULL DEFAULT '0',
  `project_verified` tinyint(1) NOT NULL DEFAULT '0',
  `cash` int(10) NOT NULL DEFAULT '0',
  `project_is_free` tinyint(1) NOT NULL DEFAULT '0',
  `project_is_temp` tinyint(1) NOT NULL DEFAULT '0',
  `project_unban_count` tinyint(4) NOT NULL DEFAULT '0',
  `project_antierror` int(10) unsigned DEFAULT NULL,
  `project_attached` int(10) unsigned DEFAULT NULL,
  `project_passchange` int(10) unsigned NOT NULL DEFAULT '0',
  `project_vote_time` bigint(20) NOT NULL DEFAULT '0',
  `project_hwid` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_username` (`username`),
  KEY `idx_id` (`id`) USING BTREE,
  KEY `idx_sha` (`sha_pass_hash`) USING BTREE,
  KEY `idx_session` (`sessionkey`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Account System';

/*Data for the table `account` */

/*Table structure for table `account_access` */

DROP TABLE IF EXISTS `account_access`;

CREATE TABLE `account_access` (
  `id` int(10) unsigned NOT NULL,
  `gmlevel` tinyint(3) unsigned NOT NULL,
  `RealmID` int(11) NOT NULL DEFAULT '-1',
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`RealmID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_access` */

/*Table structure for table `account_achievement` */

DROP TABLE IF EXISTS `account_achievement`;

CREATE TABLE `account_achievement` (
  `account` int(10) unsigned NOT NULL,
  `guid` int(10) unsigned NOT NULL,
  `achievement` smallint(5) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`account`,`achievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_achievement` */

/*Table structure for table `account_achievement_progress` */

DROP TABLE IF EXISTS `account_achievement_progress`;

CREATE TABLE `account_achievement_progress` (
  `account` int(10) unsigned NOT NULL,
  `criteria` smallint(5) unsigned NOT NULL,
  `counter` bigint(20) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`account`,`criteria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_achievement_progress` */

/*Table structure for table `account_banned` */

DROP TABLE IF EXISTS `account_banned`;

CREATE TABLE `account_banned` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account id',
  `realm` int(11) NOT NULL,
  `bandate` int(10) unsigned NOT NULL DEFAULT '0',
  `unbandate` int(10) unsigned NOT NULL DEFAULT '0',
  `bannedby` varchar(50) NOT NULL,
  `banreason` varchar(255) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ban List';

/*Data for the table `account_banned` */

/*Table structure for table `account_battle_pet` */

DROP TABLE IF EXISTS `account_battle_pet`;

CREATE TABLE `account_battle_pet` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `accountId` int(10) unsigned NOT NULL DEFAULT '0',
  `species` smallint(5) unsigned NOT NULL DEFAULT '0',
  `nickname` varchar(16) NOT NULL DEFAULT '',
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `xp` smallint(5) unsigned NOT NULL DEFAULT '0',
  `health` smallint(5) unsigned NOT NULL DEFAULT '0',
  `maxHealth` smallint(5) unsigned NOT NULL DEFAULT '0',
  `power` smallint(5) unsigned NOT NULL DEFAULT '0',
  `speed` smallint(5) unsigned NOT NULL DEFAULT '0',
  `quality` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `breed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `flags` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_battle_pet` */

/*Table structure for table `account_battle_pet_slots` */

DROP TABLE IF EXISTS `account_battle_pet_slots`;

CREATE TABLE `account_battle_pet_slots` (
  `accountId` int(10) unsigned NOT NULL DEFAULT '0',
  `slot1` bigint(20) unsigned NOT NULL DEFAULT '0',
  `slot2` bigint(20) unsigned NOT NULL DEFAULT '0',
  `slot3` bigint(20) unsigned NOT NULL DEFAULT '0',
  `flags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_battle_pet_slots` */

/*Table structure for table `account_boost` */

DROP TABLE IF EXISTS `account_boost`;

CREATE TABLE `account_boost` (
  `id` int(11) NOT NULL DEFAULT '0',
  `realmid` int(11) unsigned NOT NULL DEFAULT '1',
  `counter` int(1) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_boost` */

/*Table structure for table `account_data` */

DROP TABLE IF EXISTS `account_data`;

CREATE TABLE `account_data` (
  `accountId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account Identifier',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  PRIMARY KEY (`accountId`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_data` */

/*Table structure for table `account_instance_times` */

DROP TABLE IF EXISTS `account_instance_times`;

CREATE TABLE `account_instance_times` (
  `accountId` int(10) unsigned NOT NULL,
  `instanceId` int(10) unsigned NOT NULL DEFAULT '0',
  `releaseTime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountId`,`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_instance_times` */

/*Table structure for table `account_muted` */

DROP TABLE IF EXISTS `account_muted`;

CREATE TABLE `account_muted` (
  `id` int(10) NOT NULL,
  `realmid` int(3) NOT NULL DEFAULT '0',
  `acc_id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `mute_acc` varchar(32) COLLATE utf8_bin NOT NULL,
  `mute_name` varchar(50) COLLATE utf8_bin NOT NULL,
  `mute_date` bigint(40) NOT NULL,
  `muted_by` varchar(50) COLLATE utf8_bin NOT NULL,
  `mute_time` bigint(20) NOT NULL,
  `mute_reason` varchar(255) COLLATE utf8_bin NOT NULL,
  `public_channels_only` tinyint(3) NOT NULL,
  PRIMARY KEY (`realmid`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `account_muted` */

/*Table structure for table `account_premium` */

DROP TABLE IF EXISTS `account_premium`;

CREATE TABLE `account_premium` (
  `id` int(11) NOT NULL DEFAULT '0' COMMENT 'Account id',
  `setdate` bigint(40) NOT NULL DEFAULT '0',
  `unsetdate` bigint(40) NOT NULL DEFAULT '0',
  `active` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`setdate`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Premium Accounts';

/*Data for the table `account_premium` */

/*Table structure for table `account_premium_panda` */

DROP TABLE IF EXISTS `account_premium_panda`;

CREATE TABLE `account_premium_panda` (
  `id` int(11) NOT NULL DEFAULT '0',
  `pveMode` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_premium_panda` */

/*Table structure for table `account_referred` */

DROP TABLE IF EXISTS `account_referred`;

CREATE TABLE `account_referred` (
  `id1` bigint(20) unsigned NOT NULL COMMENT 'Referring Account',
  `id2` bigint(20) unsigned NOT NULL COMMENT 'Referred Account',
  PRIMARY KEY (`id1`),
  KEY `id2` (`id2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_referred` */

/*Table structure for table `account_spell` */

DROP TABLE IF EXISTS `account_spell`;

CREATE TABLE `account_spell` (
  `account` int(10) unsigned NOT NULL DEFAULT '0',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `disabled` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`account`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_spell` */

/*Table structure for table `account_tutorial` */

DROP TABLE IF EXISTS `account_tutorial`;

CREATE TABLE `account_tutorial` (
  `accountId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account Identifier',
  `tut0` int(10) unsigned NOT NULL DEFAULT '0',
  `tut1` int(10) unsigned NOT NULL DEFAULT '0',
  `tut2` int(10) unsigned NOT NULL DEFAULT '0',
  `tut3` int(10) unsigned NOT NULL DEFAULT '0',
  `tut4` int(10) unsigned NOT NULL DEFAULT '0',
  `tut5` int(10) unsigned NOT NULL DEFAULT '0',
  `tut6` int(10) unsigned NOT NULL DEFAULT '0',
  `tut7` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `account_tutorial` */

/*Table structure for table `addons` */

DROP TABLE IF EXISTS `addons`;

CREATE TABLE `addons` (
  `name` varchar(120) NOT NULL DEFAULT '',
  `crc` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Addons';

/*Data for the table `addons` */

insert  into `addons`(`name`,`crc`) values 
('Blizzard_AchievementUI',1276933997),
('Blizzard_ArchaeologyUI',1276933997),
('Blizzard_ArenaUI',1276933997),
('Blizzard_AuctionUI',1276933997),
('Blizzard_AuthChallengeUI',1276933997),
('Blizzard_BarbershopUI',1276933997),
('Blizzard_BattlefieldMinimap',1276933997),
('Blizzard_BindingUI',1276933997),
('Blizzard_BlackMarketUI',1276933997),
('Blizzard_Calendar',1276933997),
('Blizzard_ChallengesUI',1276933997),
('Blizzard_ClientSavedVariables',1276933997),
('Blizzard_CombatLog',1276933997),
('Blizzard_CombatText',1276933997),
('Blizzard_CompactRaidFrames',1276933997),
('Blizzard_CUFProfiles',1276933997),
('Blizzard_DebugTools',1276933997),
('Blizzard_EncounterJournal',1276933997),
('Blizzard_GlyphUI',1276933997),
('Blizzard_GMChatUI',1276933997),
('Blizzard_GMSurveyUI',1276933997),
('Blizzard_GuildBankUI',1276933997),
('Blizzard_GuildControlUI',1276933997),
('Blizzard_GuildUI',1276933997),
('Blizzard_InspectUI',1276933997),
('Blizzard_ItemAlterationUI',1276933997),
('Blizzard_ItemSocketingUI',1276933997),
('Blizzard_ItemUpgradeUI',1276933997),
('Blizzard_LookingForGuildUI',1276933997),
('Blizzard_MacroUI',1276933997),
('Blizzard_MovePad',1276933997),
('Blizzard_PetBattleUI',1276933997),
('Blizzard_PetJournal',1276933997),
('Blizzard_PVPUI',1276933997),
('Blizzard_QuestChoice',1276933997),
('Blizzard_RaidUI',1276933997),
('Blizzard_ReforgingUI',1276933997),
('Blizzard_StoreUI',1276933997),
('Blizzard_TalentUI',1276933997),
('Blizzard_TimeManager',1276933997),
('Blizzard_TokenUI',1276933997),
('Blizzard_TradeSkillUI',1276933997),
('Blizzard_TrainerUI',1276933997),
('Blizzard_VoidStorageUI',1276933997);

/*Table structure for table `arena_game_id` */

DROP TABLE IF EXISTS `arena_game_id`;

CREATE TABLE `arena_game_id` (
  `game_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `realm_id` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `arena_game_id` */

/*Table structure for table `arena_games` */

DROP TABLE IF EXISTS `arena_games`;

CREATE TABLE `arena_games` (
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `teamid` bigint(20) NOT NULL DEFAULT '0',
  `guid` bigint(20) NOT NULL DEFAULT '0',
  `changeType` int(11) NOT NULL,
  `ratingChange` int(11) NOT NULL,
  `teamRating` int(11) NOT NULL,
  `matchMakerRating` smallint(5) unsigned DEFAULT NULL,
  `damageDone` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `healingDone` int(11) NOT NULL,
  `damageTaken` int(11) NOT NULL,
  `healingTaken` int(11) NOT NULL,
  `killingBlows` int(11) NOT NULL,
  `damageAbsorbed` int(11) unsigned NOT NULL,
  `timeControlled` int(11) unsigned NOT NULL,
  `aurasDispelled` int(11) unsigned NOT NULL,
  `aurasStolen` int(11) unsigned NOT NULL,
  `highLatencyTimes` int(11) unsigned NOT NULL,
  `spellsPrecast` int(11) unsigned NOT NULL,
  `mapId` int(11) NOT NULL,
  `start` int(11) NOT NULL,
  `end` int(11) NOT NULL,
  `class` tinyint(3) unsigned DEFAULT NULL,
  `season` smallint(5) unsigned DEFAULT NULL,
  `type` tinyint(3) unsigned DEFAULT NULL,
  `realmid` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`gameid`,`teamid`,`guid`),
  KEY `idx__teamid` (`teamid`),
  KEY `idx__season__class__type` (`season`,`class`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='WoWArmory Game Chart';

/*Data for the table `arena_games` */

/*Table structure for table `arena_match_stat` */

DROP TABLE IF EXISTS `arena_match_stat`;

CREATE TABLE `arena_match_stat` (
  `realm` tinyint(3) unsigned NOT NULL,
  `teamGuid` int(10) unsigned NOT NULL,
  `teamName` text NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `teamRating` smallint(5) unsigned NOT NULL,
  `player` int(10) unsigned NOT NULL,
  `class` tinyint(3) unsigned NOT NULL,
  `name` text NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `mapID` smallint(5) unsigned NOT NULL,
  `instanceID` int(10) unsigned NOT NULL,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`teamGuid`,`realm`,`player`,`instanceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `arena_match_stat` */

/*Table structure for table `arena_team` */

DROP TABLE IF EXISTS `arena_team`;

CREATE TABLE `arena_team` (
  `arenaTeamId` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(24) NOT NULL,
  `captainGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `realmNumber` int(10) unsigned NOT NULL DEFAULT '1',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating` smallint(5) unsigned NOT NULL DEFAULT '0',
  `matchMakerRating` smallint(5) unsigned NOT NULL DEFAULT '1500',
  `seasonGames` smallint(5) unsigned NOT NULL DEFAULT '0',
  `seasonWins` smallint(5) unsigned NOT NULL DEFAULT '0',
  `weekGames` smallint(5) unsigned NOT NULL DEFAULT '0',
  `weekWins` smallint(5) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `backgroundColor` int(10) unsigned NOT NULL DEFAULT '0',
  `emblemStyle` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `emblemColor` int(10) unsigned NOT NULL DEFAULT '0',
  `borderStyle` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `borderColor` int(10) unsigned NOT NULL DEFAULT '0',
  `season` int(10) unsigned NOT NULL DEFAULT '0',
  `created` int(10) unsigned NOT NULL DEFAULT '0',
  `deleted` int(10) unsigned NOT NULL DEFAULT '0',
  `realmid` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`arenaTeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `arena_team` */

/*Table structure for table `arena_team_member` */

DROP TABLE IF EXISTS `arena_team_member`;

CREATE TABLE `arena_team_member` (
  `arenaTeamId` int(10) unsigned NOT NULL DEFAULT '0',
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `realmid` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `personalRating` smallint(5) NOT NULL DEFAULT '0',
  `matchMakerRating` smallint(5) unsigned NOT NULL DEFAULT '1500',
  `weekGames` smallint(5) unsigned NOT NULL DEFAULT '0',
  `weekWins` smallint(5) unsigned NOT NULL DEFAULT '0',
  `seasonGames` smallint(5) unsigned NOT NULL DEFAULT '0',
  `seasonWins` smallint(5) unsigned NOT NULL DEFAULT '0',
  `name` varchar(12) NOT NULL,
  `class` tinyint(3) unsigned NOT NULL,
  `joined` int(10) unsigned NOT NULL DEFAULT '0',
  `removed` int(10) unsigned NOT NULL DEFAULT '0',
  `itemLevel` smallint(5) unsigned NOT NULL DEFAULT '0',
  `lastILvlCheck` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`arenaTeamId`,`guid`,`realmid`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `arena_team_member` */

/*Table structure for table `armory_character_stats` */

DROP TABLE IF EXISTS `armory_character_stats`;

CREATE TABLE `armory_character_stats` (
  `guid` int(11) NOT NULL,
  `data` longtext NOT NULL,
  `item_level` smallint(5) unsigned DEFAULT NULL,
  `gear_score` smallint(5) unsigned DEFAULT NULL,
  `achievement_points` smallint(5) unsigned DEFAULT NULL,
  `save_date` int(11) DEFAULT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='World of Warcraft Armory table';

/*Data for the table `armory_character_stats` */

/*Table structure for table `armory_game_chart` */

DROP TABLE IF EXISTS `armory_game_chart`;

CREATE TABLE `armory_game_chart` (
  `gameid` int(11) NOT NULL,
  `realmid` tinyint(3) unsigned NOT NULL DEFAULT '1',
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
  `class` tinyint(3) unsigned DEFAULT NULL,
  `season` smallint(5) unsigned DEFAULT NULL,
  `type` tinyint(3) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `armory_game_chart` */

/*Table structure for table `auctionhouse` */

DROP TABLE IF EXISTS `auctionhouse`;

CREATE TABLE `auctionhouse` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `auctioneerguid` int(10) unsigned NOT NULL DEFAULT '0',
  `itemguid` int(10) unsigned NOT NULL DEFAULT '0',
  `itemowner` int(10) unsigned NOT NULL DEFAULT '0',
  `buyoutprice` int(10) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `buyguid` int(10) unsigned NOT NULL DEFAULT '0',
  `lastbid` int(10) unsigned NOT NULL DEFAULT '0',
  `startbid` int(10) unsigned NOT NULL DEFAULT '0',
  `deposit` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_guid` (`itemguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `auctionhouse` */

/*Table structure for table `autobroadcast` */

DROP TABLE IF EXISTS `autobroadcast`;

CREATE TABLE `autobroadcast` (
  `realmid` int(11) NOT NULL DEFAULT '-1',
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `weight` tinyint(3) unsigned DEFAULT '1',
  `text` longtext NOT NULL,
  PRIMARY KEY (`id`,`realmid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `autobroadcast` */

/*Table structure for table `banned_addons` */

DROP TABLE IF EXISTS `banned_addons`;

CREATE TABLE `banned_addons` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Version` varchar(255) NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `idx_name_ver` (`Name`,`Version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `banned_addons` */

/*Table structure for table `battleground_games` */

DROP TABLE IF EXISTS `battleground_games`;

CREATE TABLE `battleground_games` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `season` int(10) unsigned NOT NULL,
  `realm_id` int(10) unsigned NOT NULL,
  `map_id` int(10) unsigned NOT NULL,
  `instance_id` int(10) unsigned NOT NULL,
  `is_random_bg` tinyint(3) unsigned NOT NULL,
  `winner` enum('H','A','N') NOT NULL,
  `start_time` int(10) unsigned NOT NULL,
  `duration` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `realm_id` (`realm_id`),
  KEY `map_id` (`map_id`),
  KEY `season` (`season`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `battleground_games` */

/*Table structure for table `battleground_ladder_criteria` */

DROP TABLE IF EXISTS `battleground_ladder_criteria`;

CREATE TABLE `battleground_ladder_criteria` (
  `criteria` enum('Win','Loss','FastWin','Kills','ObjectiveCaptures','ObjectiveDefenses','DailyWins','DailyKills','SeasonKills','SeasonWinsAV','SeasonWinsWG','SeasonWinsAB','SeasonWinsEotS','SeasonWinsSotA','SeasonWinsIoC','TotalWins','TotalDraws','TotalLosses','TotalKills','TotalLeavesBeforeGame','TotalLeavesDuringGame') NOT NULL COMMENT 'Name of the column in `battleground_ladder_progress` if `type` is ''Daily'', ''Season'' or ''Statistic''',
  `type` enum('Statistic','Season','Daily','Alterac Valley','Warsong Gulch','Arathi Basin','Eye of the Storm','Strand of the Ancients','Isle of Conquest') NOT NULL COMMENT 'If not set - affects all battlegrounds, if set - overrides global setting only for the specified battleground. Only valid for battleground-specific `type`s',
  `param` int(11) NOT NULL DEFAULT '0',
  `name` tinytext NOT NULL,
  `cap` int(10) unsigned NOT NULL COMMENT 'Maximum count of progress units a player can get',
  `ladder_points_per_progress` int(11) NOT NULL DEFAULT '0' COMMENT 'Repeatable ladder points reward for each unit of progress in this criteria',
  `ladder_points_for_cap` int(11) NOT NULL DEFAULT '0' COMMENT 'One-time ladder points reward for reaching progress cap in this criteria',
  `group_penalty_size` int(11) unsigned NOT NULL DEFAULT '3' COMMENT 'Count of group members at which ladder points penalty from `group_penalty_percent` kicks in',
  `group_penalty_percent` int(11) NOT NULL DEFAULT '0' COMMENT 'Percentage modifier of ladder points for each player in the group above or equal to `group_penalty_size`',
  PRIMARY KEY (`criteria`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `battleground_ladder_criteria` */

/*Table structure for table `battleground_ladder_rewards` */

DROP TABLE IF EXISTS `battleground_ladder_rewards`;

CREATE TABLE `battleground_ladder_rewards` (
  `season` int(10) unsigned NOT NULL COMMENT 'Battleground season ID',
  `id` int(10) unsigned NOT NULL COMMENT 'Incrementing number identifying this reward set',
  `top` float unsigned NOT NULL COMMENT 'How many players will receive the reward. Depends on `type`',
  `type` enum('Players','Percents') NOT NULL DEFAULT 'Players' COMMENT 'Determines whether the `top` number or `top` percentage of players will receive the reward',
  `money_reward` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Amount in copper',
  `item_reward` tinytext NOT NULL COMMENT 'Format: itemid:count itemid:count ...',
  `loyalty_reward` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of Orbs of Loyalty',
  `premium_reward` tinytext NOT NULL COMMENT 'Duration in timestring format (e.g. "30d5h42m10s")',
  `title_reward` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Title ID',
  `mail_subject` tinytext NOT NULL,
  `mail_text` text NOT NULL,
  PRIMARY KEY (`season`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `battleground_ladder_rewards` */

/*Table structure for table `battleground_scores` */

DROP TABLE IF EXISTS `battleground_scores`;

CREATE TABLE `battleground_scores` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each player that participated in the battleground',
  `game_id` int(10) unsigned NOT NULL,
  `team` tinyint(3) unsigned NOT NULL,
  `guid` int(10) unsigned NOT NULL,
  `realm_id` int(10) unsigned NOT NULL,
  `group_index` int(10) unsigned NOT NULL,
  `ladder_points` int(10) NOT NULL,
  `killing_blows` int(10) unsigned NOT NULL,
  `deaths` int(10) unsigned NOT NULL,
  `honorable_kills` int(10) unsigned NOT NULL,
  `damage_done` int(10) unsigned NOT NULL,
  `healing_done` int(10) unsigned NOT NULL,
  `damage_taken` int(10) unsigned NOT NULL,
  `healing_taken` int(10) unsigned NOT NULL,
  `bonus_honor` int(10) unsigned NOT NULL,
  `graveyards_assaulted` int(10) unsigned DEFAULT NULL COMMENT 'Alterac Valley',
  `graveyards_defended` int(10) unsigned DEFAULT NULL COMMENT 'Alterac Valley',
  `towers_assaulted` int(10) unsigned DEFAULT NULL COMMENT 'Alterac Valley',
  `towers_defended` int(10) unsigned DEFAULT NULL COMMENT 'Alterac Valley',
  `mines_captured` int(10) unsigned DEFAULT NULL COMMENT 'Alterac Valley',
  `leaders_killed` int(10) unsigned DEFAULT NULL COMMENT 'Alterac Valley',
  `secondary_objective` int(10) unsigned DEFAULT NULL COMMENT 'Alterac Valley',
  `flag_captures` int(10) unsigned DEFAULT NULL COMMENT 'Warsong Gulch, Eye of the Storm',
  `flag_returns` int(10) unsigned DEFAULT NULL COMMENT 'Warsong Gulch',
  `bases_assaulted` int(10) unsigned DEFAULT NULL COMMENT 'Arathi Basin, Isle of Conquest',
  `bases_defended` int(10) unsigned DEFAULT NULL COMMENT 'Arathi Basin, Isle of Conquest',
  `demolishers_destroyed` int(10) unsigned DEFAULT NULL COMMENT 'Strand of the Ancients',
  `gates_destroyed` int(10) unsigned DEFAULT NULL COMMENT 'Strand of the Ancients',
  PRIMARY KEY (`id`),
  KEY `game_id` (`game_id`),
  KEY `guid` (`guid`),
  KEY `realm_id` (`realm_id`),
  CONSTRAINT `FK_battleground_scores_battleground_games` FOREIGN KEY (`game_id`) REFERENCES `battleground_games` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `battleground_scores` */

/*Table structure for table `battleground_seasons` */

DROP TABLE IF EXISTS `battleground_seasons`;

CREATE TABLE `battleground_seasons` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `begin` int(10) unsigned NOT NULL,
  `end` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `battleground_seasons` */

/*Table structure for table `battlenet_account_bans` */

DROP TABLE IF EXISTS `battlenet_account_bans`;

CREATE TABLE `battlenet_account_bans` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account id',
  `bandate` int(10) unsigned NOT NULL DEFAULT '0',
  `unbandate` int(10) unsigned NOT NULL DEFAULT '0',
  `bannedby` varchar(50) NOT NULL,
  `banreason` varchar(255) NOT NULL,
  PRIMARY KEY (`id`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ban List';

/*Data for the table `battlenet_account_bans` */

/*Table structure for table `battlenet_accounts` */

DROP TABLE IF EXISTS `battlenet_accounts`;

CREATE TABLE `battlenet_accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `email` varchar(320) NOT NULL,
  `sha_pass_hash` varchar(64) NOT NULL DEFAULT '',
  `v` varchar(256) NOT NULL DEFAULT '',
  `s` varchar(64) NOT NULL DEFAULT '',
  `sessionKey` varchar(128) NOT NULL DEFAULT '',
  `locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `last_login` timestamp NULL DEFAULT NULL,
  `online` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `last_ip` varchar(15) NOT NULL DEFAULT '127.0.0.1',
  `failed_logins` int(10) unsigned NOT NULL DEFAULT '0',
  `project_member_id` int(10) unsigned DEFAULT NULL,
  `project_is_temp` tinyint(1) DEFAULT '0' COMMENT 'nighthold',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Account System';

/*Data for the table `battlenet_accounts` */

/*Table structure for table `battlepay_log` */

DROP TABLE IF EXISTS `battlepay_log`;

CREATE TABLE `battlepay_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accountId` int(11) unsigned NOT NULL,
  `characterGuid` int(10) NOT NULL DEFAULT '0',
  `realm` int(5) unsigned NOT NULL,
  `item` int(10) NOT NULL DEFAULT '0',
  `price` int(5) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `battlepay_log` */

/*Table structure for table `blackmarket_auctions` */

DROP TABLE IF EXISTS `blackmarket_auctions`;

CREATE TABLE `blackmarket_auctions` (
  `auctionId` int(10) unsigned NOT NULL DEFAULT '0',
  `templateId` int(10) unsigned NOT NULL DEFAULT '0',
  `startTime` int(10) unsigned NOT NULL DEFAULT '0',
  `endTime` int(10) unsigned NOT NULL DEFAULT '0',
  `currentBidder` int(10) unsigned NOT NULL DEFAULT '0',
  `currentBid` bigint(10) unsigned NOT NULL DEFAULT '0',
  `minIncrement` bigint(10) unsigned NOT NULL DEFAULT '0',
  `numBids` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`auctionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `blackmarket_auctions` */

insert  into `blackmarket_auctions`(`auctionId`,`templateId`,`startTime`,`endTime`,`currentBidder`,`currentBid`,`minIncrement`,`numBids`) values 
(1,39,1638017710,1638136663,0,300000000,15000000,0),
(2,156,1637979306,1638107974,0,450000000,22500000,0),
(3,498,1638016604,1638057172,0,15000000,750000,0),
(4,2,1637965145,1638100071,0,300000000,15000000,0),
(5,10,1638004823,1638048417,0,300000000,15000000,0),
(6,142,1637947885,1638055225,0,600000000,30000000,0),
(7,43,1638014382,1638063621,0,300000000,15000000,0),
(8,5,1638010386,1638076969,0,300000000,15000000,0),
(9,54,1638009276,1638081568,0,300000000,15000000,0),
(10,59,1638035451,1638200383,0,300000000,15000000,0),
(11,101,1637881226,1638049592,0,30000,10000,0),
(12,35,1637891607,1638058746,0,300000000,15000000,0);

/*Table structure for table `bonus_rates` */

DROP TABLE IF EXISTS `bonus_rates`;

CREATE TABLE `bonus_rates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Autoincrementable ID',
  `realmid` int(11) NOT NULL DEFAULT '-1' COMMENT 'RealmID for which the rates would be active. -1 for all realms',
  `active` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'If set to 0 - this bonus would not be loaded',
  `schedule` varchar(50) NOT NULL DEFAULT '* * * * *' COMMENT 'Cron-style schedule defining the time for the bonus rates period. Multiple periods can be specified with a semicolon separated list',
  `multiplier` float NOT NULL DEFAULT '2' COMMENT 'Rate multiplier (i.e. 2 would change the rates to be twice their usual value during the bonus rates period)',
  `rates` text NOT NULL COMMENT 'Space separated list of rate names as used in config (i.e. "Rate.XP.Kill Rate.Honor")',
  `start_announcement` tinytext COMMENT 'Announcement displayed in chat for all online players when the bonus rate period starts',
  `end_announcement` tinytext COMMENT 'Announcement displayed in chat for all online players when the bonus rate period ends',
  `active_announcement` tinytext COMMENT 'Announcement displayed in chat for all players logging in whenever the bonus rate period is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bonus_rates` */

/*Table structure for table `boost_promotion_executed` */

DROP TABLE IF EXISTS `boost_promotion_executed`;

CREATE TABLE `boost_promotion_executed` (
  `member_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `boost_promotion_executed` */

/*Table structure for table `broadcast_strings` */

DROP TABLE IF EXISTS `broadcast_strings`;

CREATE TABLE `broadcast_strings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `next` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `broadcast_strings` */

/*Table structure for table `bugreport` */

DROP TABLE IF EXISTS `bugreport`;

CREATE TABLE `bugreport` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `type` longtext NOT NULL,
  `content` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Debug System';

/*Data for the table `bugreport` */

/*Table structure for table `calendar_events` */

DROP TABLE IF EXISTS `calendar_events`;

CREATE TABLE `calendar_events` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `creator` int(10) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '4',
  `dungeon` int(10) NOT NULL DEFAULT '-1',
  `eventtime` int(10) unsigned NOT NULL DEFAULT '0',
  `flags` int(10) unsigned NOT NULL DEFAULT '0',
  `time2` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `calendar_events` */

/*Table structure for table `calendar_invites` */

DROP TABLE IF EXISTS `calendar_invites`;

CREATE TABLE `calendar_invites` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `event` bigint(20) unsigned NOT NULL DEFAULT '0',
  `invitee` int(10) unsigned NOT NULL DEFAULT '0',
  `sender` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `statustime` int(10) unsigned NOT NULL DEFAULT '0',
  `rank` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `text` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `calendar_invites` */

/*Table structure for table `channels` */

DROP TABLE IF EXISTS `channels`;

CREATE TABLE `channels` (
  `name` varchar(128) NOT NULL,
  `team` int(10) unsigned NOT NULL,
  `announce` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `ownership` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `password` varchar(32) DEFAULT NULL,
  `bannedList` text,
  `lastUsed` int(10) unsigned NOT NULL,
  PRIMARY KEY (`name`,`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Channel System';

/*Data for the table `channels` */

/*Table structure for table `config` */

DROP TABLE IF EXISTS `config`;

CREATE TABLE `config` (
  `category` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` text,
  `default` text,
  `realmid` smallint(6) NOT NULL DEFAULT '-1',
  `description` text,
  `note` text,
  PRIMARY KEY (`name`,`realmid`),
  KEY `option` (`name`),
  KEY `category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Here you can put the configs from the worldserver.conf file, so you can change without acessing the machine files.';

/*Data for the table `config` */

insert  into `config`(`category`,`name`,`value`,`default`,`realmid`,`description`,`note`) values 
('Players','AllowTwoSide.Interaction.Auction','0','0',1,'Merge all auction houses for players from different teams\nDefault: 0 (Not allowed)\n         1 (Allowed)',NULL),
('Players','AllowTwoSide.Interaction.Chat','0','0',-1,'Allow chat assembling between factions.\nDefault:     0',NULL),
('AntiCheat','Anticheat.DetectionsEnabled','27','31',1,'Anticheat hack',NULL),
('AntiCheat','Anticheat.ReportsForIngameWarnings','70','1',1,'Anticheat hack',NULL),
('Rate','BonusRoll.LootChance','31','31',1,'Bonus Roll',NULL),
('Dungeon Finder','DungeonFinder.CastDeserter','0','1',1,'Cast Deserter spell at players who leave DF-parties while the dungeons is in progress.\nDefault:     1',NULL),
('Dungeon Finder','DungeonFinder.DPSNeeded','1','1',1,'Specifies how many players have to select dps role in order for the party to be eligible for a dungeon.\nDefault:     1',NULL),
('Dungeon Finder','DungeonFinder.HealersNeeded','1','1',1,'Specifies how many players have to select healer role in order for the party to be eligible for a dungeon.\nDefault:     1',NULL),
('Dungeon Finder','DungeonFinder.KeepQueuesInDungeon','true','1',1,'Specifies how many players have to select healer role in order for the party to be eligible for a dungeon.\nDefault:     1',NULL),
('Dungeon Finder','DungeonFinder.OverrideRolesRequired','true','0',1,'If enabled all LFG role checks will use values from DungeonFinder.TanksNeeded, DungeonFinder.HealersNeeded and DungeonFinder.DPSNeeded to determine the number of players required in order for the party to be eligible for a dungeon. Overrides both group and raid dungeon values.\nDefault:     0',NULL),
('Dungeon Finder','DungeonFinder.ShortageCheckInterval','60','60',1,'Specifies the interval in seconds at which shortage roles for a queue should be updated.\nDefault:     5',NULL),
('Dungeon Finder','DungeonFinder.ShortagePercent','50','50',1,'Specifies at which percent of the ideal role representation ratio in a queue should it grant a Call to Arms reward\nDefault:     50',NULL),
('Dungeon Finder','DungeonFinder.TanksNeeded','1','1',1,'Specifies how many players have to select tank role in order for the party to be eligible for a dungeon.\nDefault:     1',NULL),
('LFR','LFR.LootChance','100','20',-1,'Chance to get personal loot from any boss',NULL),
('Rate','TargetPosRecalculateRange','5','5',1,'Range attack ',NULL),
('Misc','VengeanceMultipier','1','1',-1,NULL,NULL),
('Performance','Visibility.AINotifyDelay','1000','1000',1,'Description: delay (in milliseconds) between action and nearby AI reaction. Lower values may have\n             performance impact.\nDefault:     1000',NULL),
('Performance','Visibility.RelocationLowerLimit','10','20',1,'Description: distance in yards. unit should pass that distance to trigger visibility update.\nDefault:     10',NULL),
('Rate','XP.Gather.Difference','10','0',1,'',NULL),
('Rate','XP.Kill.Difference','10','0',1,'',NULL);

/*Table structure for table `corpse` */

DROP TABLE IF EXISTS `corpse`;

CREATE TABLE `corpse` (
  `corpseGuid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `mapId` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
  `phaseMask` int(10) unsigned NOT NULL DEFAULT '1',
  `displayId` int(10) unsigned NOT NULL DEFAULT '0',
  `itemCache` text NOT NULL,
  `bytes1` int(10) unsigned NOT NULL DEFAULT '0',
  `bytes2` int(10) unsigned NOT NULL DEFAULT '0',
  `flags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dynFlags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `corpseType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `instanceId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Instance Identifier',
  PRIMARY KEY (`corpseGuid`),
  KEY `idx_type` (`corpseType`),
  KEY `idx_instance` (`instanceId`),
  KEY `idx_player` (`guid`),
  KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Death System';

/*Data for the table `corpse` */

/*Table structure for table `creature_raid_respawn` */

DROP TABLE IF EXISTS `creature_raid_respawn`;

CREATE TABLE `creature_raid_respawn` (
  `playerGuid` int(10) unsigned NOT NULL,
  `creatureGuid` int(10) unsigned NOT NULL,
  `mapId` int(10) unsigned NOT NULL,
  `respawnTime` int(10) unsigned NOT NULL,
  PRIMARY KEY (`playerGuid`,`creatureGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `creature_raid_respawn` */

/*Table structure for table `creature_respawn` */

DROP TABLE IF EXISTS `creature_respawn`;

CREATE TABLE `creature_respawn` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `respawnTime` int(10) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(10) unsigned NOT NULL DEFAULT '0',
  `instanceId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Instance Identifier',
  PRIMARY KEY (`guid`,`instanceId`),
  KEY `idx_instance` (`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Grid Loading System';

/*Data for the table `creature_respawn` */

/*Table structure for table `custom_transmogrification` */

DROP TABLE IF EXISTS `custom_transmogrification`;

CREATE TABLE `custom_transmogrification` (
  `GUID` int(10) unsigned NOT NULL COMMENT 'Item guidLow',
  `FakeEntry` int(10) unsigned NOT NULL COMMENT 'Item entry',
  `Owner` int(10) unsigned NOT NULL COMMENT 'Player guidLow',
  PRIMARY KEY (`GUID`),
  KEY `Owner` (`Owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='6_2';

/*Data for the table `custom_transmogrification` */

/*Table structure for table `custom_transmogrification_sets` */

DROP TABLE IF EXISTS `custom_transmogrification_sets`;

CREATE TABLE `custom_transmogrification_sets` (
  `Owner` int(10) unsigned NOT NULL COMMENT 'Player guidlow',
  `PresetID` tinyint(3) unsigned NOT NULL COMMENT 'Preset identifier',
  `SetName` text COMMENT 'SetName',
  `SetData` text COMMENT 'Slot1 Entry1 Slot2 Entry2',
  PRIMARY KEY (`Owner`,`PresetID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='6_1';

/*Data for the table `custom_transmogrification_sets` */

/*Table structure for table `daily_players_reports` */

DROP TABLE IF EXISTS `daily_players_reports`;

CREATE TABLE `daily_players_reports` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `creation_time` int(10) unsigned NOT NULL DEFAULT '0',
  `average` float NOT NULL DEFAULT '0',
  `total_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `speed_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fly_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `jump_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `waterwalk_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `teleportplane_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `climb_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `daily_players_reports` */

/*Table structure for table `executed_services` */

DROP TABLE IF EXISTS `executed_services`;

CREATE TABLE `executed_services` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('rename','change_acc','customize','change_race','change_class','change_prof','char_restore','guild_rename','unban','level_down','marketplace','transfer','boost','item_restore') NOT NULL,
  `guid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '(player or guild)',
  `old_data` text NOT NULL,
  `new_data` text NOT NULL,
  `execute_date` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `executed_services` */

/*Table structure for table `fake_items` */

DROP TABLE IF EXISTS `fake_items`;

CREATE TABLE `fake_items` (
  `guid` int(11) NOT NULL,
  `fakeEntry` int(11) NOT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `fake_items` */

/*Table structure for table `game_event_condition_save` */

DROP TABLE IF EXISTS `game_event_condition_save`;

CREATE TABLE `game_event_condition_save` (
  `eventEntry` tinyint(3) unsigned NOT NULL,
  `condition_id` int(10) unsigned NOT NULL DEFAULT '0',
  `done` float DEFAULT '0',
  PRIMARY KEY (`eventEntry`,`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `game_event_condition_save` */

/*Table structure for table `game_event_save` */

DROP TABLE IF EXISTS `game_event_save`;

CREATE TABLE `game_event_save` (
  `eventEntry` tinyint(3) unsigned NOT NULL,
  `state` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `next_start` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`eventEntry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `game_event_save` */

/*Table structure for table `gameobject_raid_respawn` */

DROP TABLE IF EXISTS `gameobject_raid_respawn`;

CREATE TABLE `gameobject_raid_respawn` (
  `playerGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `gameobjectGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(10) unsigned DEFAULT NULL,
  `respawnTime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`playerGuid`,`gameobjectGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `gameobject_raid_respawn` */

/*Table structure for table `gameobject_respawn` */

DROP TABLE IF EXISTS `gameobject_respawn`;

CREATE TABLE `gameobject_respawn` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `respawnTime` int(10) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(10) unsigned NOT NULL DEFAULT '0',
  `instanceId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Instance Identifier',
  PRIMARY KEY (`guid`,`instanceId`),
  KEY `idx_instance` (`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Grid Loading System';

/*Data for the table `gameobject_respawn` */

/*Table structure for table `gm_subsurveys` */

DROP TABLE IF EXISTS `gm_subsurveys`;

CREATE TABLE `gm_subsurveys` (
  `surveyId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subsurveyId` int(10) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  PRIMARY KEY (`surveyId`,`subsurveyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

/*Data for the table `gm_subsurveys` */

/*Table structure for table `gm_surveys` */

DROP TABLE IF EXISTS `gm_surveys`;

CREATE TABLE `gm_surveys` (
  `surveyId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `mainSurvey` int(10) unsigned NOT NULL DEFAULT '0',
  `overallComment` longtext NOT NULL,
  `createTime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`surveyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

/*Data for the table `gm_surveys` */

/*Table structure for table `gm_tickets` */

DROP TABLE IF EXISTS `gm_tickets`;

CREATE TABLE `gm_tickets` (
  `ticketId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier of ticket creator',
  `name` varchar(12) NOT NULL COMMENT 'Name of ticket creator',
  `message` text NOT NULL,
  `createTime` int(10) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(5) unsigned NOT NULL DEFAULT '0',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `lastModifiedTime` int(10) unsigned NOT NULL DEFAULT '0',
  `closedBy` int(10) NOT NULL DEFAULT '0',
  `assignedTo` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'GUID of admin to whom ticket is assigned',
  `comment` text NOT NULL,
  `response` text NOT NULL,
  `completed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `escalated` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `viewed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `haveTicket` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ticketId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

/*Data for the table `gm_tickets` */

/*Table structure for table `group_completed_challenges` */

DROP TABLE IF EXISTS `group_completed_challenges`;

CREATE TABLE `group_completed_challenges` (
  `map` int(10) unsigned NOT NULL,
  `attemptId` int(10) unsigned NOT NULL DEFAULT '0',
  `completion_time` int(10) unsigned NOT NULL DEFAULT '0',
  `completion_date` int(10) unsigned NOT NULL DEFAULT '0',
  `medal_earned` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `group_members` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `member_1_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_1_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `member_2_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_2_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `member_3_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_3_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `member_4_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_4_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `member_5_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_5_spec` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`map`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `group_completed_challenges` */

/*Table structure for table `group_instance` */

DROP TABLE IF EXISTS `group_instance`;

CREATE TABLE `group_instance` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `instance` int(10) unsigned NOT NULL DEFAULT '0',
  `permanent` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`instance`),
  KEY `instance` (`instance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `group_instance` */

/*Table structure for table `group_member` */

DROP TABLE IF EXISTS `group_member`;

CREATE TABLE `group_member` (
  `guid` int(10) unsigned NOT NULL,
  `memberGuid` int(10) unsigned NOT NULL,
  `memberFlags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `subgroup` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `roles` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`memberGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Groups';

/*Data for the table `group_member` */

/*Table structure for table `groups` */

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `guid` int(10) unsigned NOT NULL,
  `leaderGuid` int(10) unsigned NOT NULL,
  `lootMethod` tinyint(3) unsigned NOT NULL,
  `looterGuid` int(10) unsigned NOT NULL,
  `lootThreshold` tinyint(3) unsigned NOT NULL,
  `icon1` int(10) unsigned NOT NULL,
  `icon2` int(10) unsigned NOT NULL,
  `icon3` int(10) unsigned NOT NULL,
  `icon4` int(10) unsigned NOT NULL,
  `icon5` int(10) unsigned NOT NULL,
  `icon6` int(10) unsigned NOT NULL,
  `icon7` int(10) unsigned NOT NULL,
  `icon8` int(10) unsigned NOT NULL,
  `groupType` tinyint(3) unsigned NOT NULL,
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `raiddifficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `slot` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`guid`),
  KEY `leaderGuid` (`leaderGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Groups';

/*Data for the table `groups` */

/*Table structure for table `guild` */

DROP TABLE IF EXISTS `guild`;

CREATE TABLE `guild` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(24) NOT NULL DEFAULT '',
  `leaderguid` int(10) unsigned NOT NULL DEFAULT '0',
  `EmblemStyle` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `EmblemColor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `BorderStyle` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `BorderColor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `BackgroundColor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `info` text NOT NULL,
  `motd` varchar(128) NOT NULL DEFAULT '',
  `createdate` int(10) unsigned NOT NULL DEFAULT '0',
  `BankMoney` bigint(20) unsigned NOT NULL DEFAULT '0',
  `level` int(10) unsigned DEFAULT '1',
  `experience` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

/*Data for the table `guild` */

/*Table structure for table `guild_achievement` */

DROP TABLE IF EXISTS `guild_achievement`;

CREATE TABLE `guild_achievement` (
  `guildId` int(10) unsigned NOT NULL,
  `achievement` smallint(5) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL DEFAULT '0',
  `guids` text NOT NULL,
  PRIMARY KEY (`guildId`,`achievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_achievement` */

/*Table structure for table `guild_achievement_progress` */

DROP TABLE IF EXISTS `guild_achievement_progress`;

CREATE TABLE `guild_achievement_progress` (
  `guildId` int(10) unsigned NOT NULL,
  `criteria` smallint(5) unsigned NOT NULL,
  `counter` bigint(20) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL DEFAULT '0',
  `completedGuid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildId`,`criteria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_achievement_progress` */

/*Table structure for table `guild_bank_eventlog` */

DROP TABLE IF EXISTS `guild_bank_eventlog`;

CREATE TABLE `guild_bank_eventlog` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Guild Identificator',
  `LogGuid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Log record identificator - auxiliary column',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Guild bank TabId',
  `EventType` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Event type',
  `PlayerGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `ItemOrMoney` int(10) unsigned NOT NULL DEFAULT '0',
  `ItemStackCount` smallint(5) unsigned NOT NULL DEFAULT '0',
  `DestTabId` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Destination Tab Id',
  `TimeStamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`,`TabId`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_PlayerGuid` (`PlayerGuid`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_bank_eventlog` */

/*Table structure for table `guild_bank_item` */

DROP TABLE IF EXISTS `guild_bank_item`;

CREATE TABLE `guild_bank_item` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SlotId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `item_guid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`TabId`,`SlotId`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_item_guid` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_bank_item` */

/*Table structure for table `guild_bank_right` */

DROP TABLE IF EXISTS `guild_bank_right`;

CREATE TABLE `guild_bank_right` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rid` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `gbright` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SlotPerDay` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`TabId`,`rid`),
  KEY `guildid_key` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_bank_right` */

/*Table structure for table `guild_bank_tab` */

DROP TABLE IF EXISTS `guild_bank_tab`;

CREATE TABLE `guild_bank_tab` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `TabName` varchar(16) NOT NULL DEFAULT '',
  `TabIcon` varchar(100) NOT NULL DEFAULT '',
  `TabText` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`guildid`,`TabId`),
  KEY `guildid_key` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_bank_tab` */

/*Table structure for table `guild_challenges` */

DROP TABLE IF EXISTS `guild_challenges`;

CREATE TABLE `guild_challenges` (
  `guild_id` int(11) unsigned NOT NULL,
  `dungeon` smallint(3) unsigned NOT NULL DEFAULT '0',
  `raid` smallint(3) unsigned NOT NULL DEFAULT '0',
  `rated_bg` smallint(3) unsigned NOT NULL DEFAULT '0',
  `scenario` smallint(3) unsigned NOT NULL DEFAULT '0',
  `dungeon_challenge` smallint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_challenges` */

/*Table structure for table `guild_completed_challenges` */

DROP TABLE IF EXISTS `guild_completed_challenges`;

CREATE TABLE `guild_completed_challenges` (
  `map` int(10) unsigned NOT NULL,
  `guildId` int(10) unsigned NOT NULL,
  `attemptId` int(10) unsigned NOT NULL DEFAULT '0',
  `completion_time` int(10) unsigned NOT NULL DEFAULT '0',
  `completion_date` int(10) unsigned NOT NULL DEFAULT '0',
  `medal_earned` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `guild_members` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `member_1_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_1_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `member_2_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_2_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `member_3_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_3_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `member_4_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_4_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `member_5_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `member_5_spec` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`map`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_completed_challenges` */

/*Table structure for table `guild_eventlog` */

DROP TABLE IF EXISTS `guild_eventlog`;

CREATE TABLE `guild_eventlog` (
  `guildid` int(10) unsigned NOT NULL COMMENT 'Guild Identificator',
  `LogGuid` int(10) unsigned NOT NULL COMMENT 'Log record identificator - auxiliary column',
  `EventType` tinyint(3) unsigned NOT NULL COMMENT 'Event type',
  `PlayerGuid1` int(10) unsigned NOT NULL COMMENT 'Player 1',
  `PlayerGuid2` int(10) unsigned NOT NULL COMMENT 'Player 2',
  `NewRank` tinyint(3) unsigned NOT NULL COMMENT 'New rank(in case promotion/demotion)',
  `TimeStamp` int(10) unsigned NOT NULL COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`),
  KEY `Idx_PlayerGuid1` (`PlayerGuid1`),
  KEY `Idx_PlayerGuid2` (`PlayerGuid2`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild Eventlog';

/*Data for the table `guild_eventlog` */

/*Table structure for table `guild_finder_applicant` */

DROP TABLE IF EXISTS `guild_finder_applicant`;

CREATE TABLE `guild_finder_applicant` (
  `guildId` int(10) unsigned DEFAULT NULL,
  `playerGuid` int(10) unsigned DEFAULT NULL,
  `availability` tinyint(3) unsigned DEFAULT '0',
  `classRole` tinyint(3) unsigned DEFAULT '0',
  `interests` tinyint(3) unsigned DEFAULT '0',
  `comment` varchar(255) DEFAULT NULL,
  `submitTime` int(10) unsigned DEFAULT NULL,
  UNIQUE KEY `guildId` (`guildId`,`playerGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_finder_applicant` */

/*Table structure for table `guild_finder_guild_settings` */

DROP TABLE IF EXISTS `guild_finder_guild_settings`;

CREATE TABLE `guild_finder_guild_settings` (
  `guildId` int(10) unsigned NOT NULL,
  `availability` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `classRoles` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `interests` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `listed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`guildId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_finder_guild_settings` */

/*Table structure for table `guild_member` */

DROP TABLE IF EXISTS `guild_member`;

CREATE TABLE `guild_member` (
  `guildid` int(10) unsigned NOT NULL COMMENT 'Guild Identificator',
  `guid` int(10) unsigned NOT NULL,
  `rank` tinyint(3) unsigned NOT NULL,
  `pnote` varchar(31) NOT NULL DEFAULT '',
  `offnote` varchar(31) NOT NULL DEFAULT '',
  `achievement_points` smallint(5) unsigned NOT NULL DEFAULT '0',
  `first_prof_skill` smallint(5) unsigned NOT NULL DEFAULT '0',
  `first_prof_value` smallint(5) unsigned NOT NULL DEFAULT '0',
  `first_prof_rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `first_prof_recipes` text,
  `second_prof_skill` smallint(5) unsigned NOT NULL DEFAULT '0',
  `second_prof_value` smallint(5) unsigned NOT NULL DEFAULT '0',
  `second_prof_rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `second_prof_recipes` text,
  UNIQUE KEY `guid_key` (`guid`),
  KEY `guildid_key` (`guildid`),
  KEY `guildid_rank_key` (`guildid`,`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

/*Data for the table `guild_member` */

/*Table structure for table `guild_member_withdraw` */

DROP TABLE IF EXISTS `guild_member_withdraw`;

CREATE TABLE `guild_member_withdraw` (
  `guid` int(10) unsigned NOT NULL,
  `tab0` int(10) unsigned NOT NULL DEFAULT '0',
  `tab1` int(10) unsigned NOT NULL DEFAULT '0',
  `tab2` int(10) unsigned NOT NULL DEFAULT '0',
  `tab3` int(10) unsigned NOT NULL DEFAULT '0',
  `tab4` int(10) unsigned NOT NULL DEFAULT '0',
  `tab5` int(10) unsigned NOT NULL DEFAULT '0',
  `tab6` int(10) unsigned NOT NULL DEFAULT '0',
  `tab7` int(10) unsigned NOT NULL DEFAULT '0',
  `money` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild Member Daily Withdraws';

/*Data for the table `guild_member_withdraw` */

/*Table structure for table `guild_newslog` */

DROP TABLE IF EXISTS `guild_newslog`;

CREATE TABLE `guild_newslog` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Guild Identificator',
  `LogGuid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Log record identificator - auxiliary column',
  `EventType` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Event type',
  `PlayerGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `Flags` int(10) unsigned NOT NULL DEFAULT '0',
  `Value` int(10) unsigned NOT NULL DEFAULT '0',
  `TimeStamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_PlayerGuid` (`PlayerGuid`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_newslog` */

/*Table structure for table `guild_rank` */

DROP TABLE IF EXISTS `guild_rank`;

CREATE TABLE `guild_rank` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `rindex` tinyint(3) unsigned NOT NULL,
  `rid` tinyint(3) unsigned NOT NULL,
  `rname` varchar(20) NOT NULL DEFAULT '',
  `rights` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `BankMoneyPerDay` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`rid`),
  KEY `Idx_rid` (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

/*Data for the table `guild_rank` */

/*Table structure for table `guild_reputation` */

DROP TABLE IF EXISTS `guild_reputation`;

CREATE TABLE `guild_reputation` (
  `guid` int(10) unsigned NOT NULL,
  `guild` int(10) unsigned NOT NULL,
  `reputation` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `guild_reputation` */

/*Table structure for table `icore_stat` */

DROP TABLE IF EXISTS `icore_stat`;

CREATE TABLE `icore_stat` (
  `online` smallint(5) unsigned NOT NULL DEFAULT '0',
  `diff` smallint(5) unsigned NOT NULL DEFAULT '0',
  `uptime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `revision` varchar(255) NOT NULL DEFAULT 'Skyfire',
  PRIMARY KEY (`online`,`diff`,`uptime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `icore_stat` */

/*Table structure for table `instance` */

DROP TABLE IF EXISTS `instance`;

CREATE TABLE `instance` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `map` smallint(5) unsigned NOT NULL DEFAULT '0',
  `resettime` int(10) unsigned NOT NULL DEFAULT '0',
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `lfg` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `completedEncounters` int(10) unsigned NOT NULL DEFAULT '0',
  `data` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `map` (`map`),
  KEY `resettime` (`resettime`),
  KEY `difficulty` (`difficulty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `instance` */

/*Table structure for table `instance_reset` */

DROP TABLE IF EXISTS `instance_reset`;

CREATE TABLE `instance_reset` (
  `mapid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `resettime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`mapid`,`difficulty`),
  KEY `difficulty` (`difficulty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `instance_reset` */

/*Table structure for table `ip_banned` */

DROP TABLE IF EXISTS `ip_banned`;

CREATE TABLE `ip_banned` (
  `ip` varchar(15) NOT NULL DEFAULT '127.0.0.1',
  `bandate` int(10) unsigned NOT NULL,
  `unbandate` int(10) unsigned NOT NULL,
  `bannedby` varchar(50) NOT NULL DEFAULT '[Console]',
  `banreason` varchar(255) NOT NULL DEFAULT 'no reason',
  PRIMARY KEY (`ip`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Banned IPs';

/*Data for the table `ip_banned` */

/*Table structure for table `item_deleted` */

DROP TABLE IF EXISTS `item_deleted`;

CREATE TABLE `item_deleted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_guid` int(11) NOT NULL,
  `old_item_guid` int(11) NOT NULL,
  `item_entry` int(11) NOT NULL,
  `item_count` int(11) NOT NULL,
  `delete_date` int(11) NOT NULL,
  `delete_type` int(11) NOT NULL,
  `restored` tinyint(1) NOT NULL DEFAULT '0',
  `restore_date` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `owner_guid_old_item_guid` (`owner_guid`,`old_item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `item_deleted` */

/*Table structure for table `item_instance` */

DROP TABLE IF EXISTS `item_instance`;

CREATE TABLE `item_instance` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `itemEntry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `owner_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `creatorGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `giftCreatorGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  `duration` int(10) NOT NULL DEFAULT '0',
  `charges` tinytext,
  `flags` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `enchantments` text NOT NULL,
  `randomPropertyId` smallint(5) NOT NULL DEFAULT '0',
  `reforgeID` int(10) NOT NULL DEFAULT '0',
  `transmogrifyId` int(10) NOT NULL DEFAULT '0',
  `upgradeID` int(10) NOT NULL DEFAULT '0',
  `durability` smallint(5) unsigned NOT NULL DEFAULT '0',
  `playedTime` int(10) unsigned NOT NULL DEFAULT '0',
  `text` text,
  `pet_species` int(11) unsigned NOT NULL,
  `pet_breed` int(11) unsigned NOT NULL,
  `pet_quality` int(11) unsigned NOT NULL,
  `pet_level` int(11) unsigned NOT NULL,
  PRIMARY KEY (`guid`),
  KEY `idx_owner_guid` (`owner_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Item System';

/*Data for the table `item_instance` */

/*Table structure for table `item_loot_items` */

DROP TABLE IF EXISTS `item_loot_items`;

CREATE TABLE `item_loot_items` (
  `container_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'guid of container (item_instance.guid)',
  `item_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'loot item entry (item_instance.itemEntry)',
  `item_count` int(10) NOT NULL DEFAULT '0' COMMENT 'stack size',
  `follow_rules` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'follow loot rules',
  `ffa` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'free-for-all',
  `blocked` tinyint(1) NOT NULL DEFAULT '0',
  `counted` tinyint(1) NOT NULL DEFAULT '0',
  `under_threshold` tinyint(1) NOT NULL DEFAULT '0',
  `needs_quest` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'quest drop',
  `rnd_prop` int(10) NOT NULL DEFAULT '0' COMMENT 'random enchantment added when originally rolled',
  `rnd_suffix` int(10) NOT NULL DEFAULT '0' COMMENT 'random suffix added when originally rolled'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `item_loot_items` */

/*Table structure for table `item_loot_money` */

DROP TABLE IF EXISTS `item_loot_money`;

CREATE TABLE `item_loot_money` (
  `container_id` int(10) NOT NULL DEFAULT '0' COMMENT 'guid of container (item_instance.guid)',
  `money` int(10) NOT NULL DEFAULT '0' COMMENT 'money loot (in copper)'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `item_loot_money` */

/*Table structure for table `item_refund_instance` */

DROP TABLE IF EXISTS `item_refund_instance`;

CREATE TABLE `item_refund_instance` (
  `item_guid` int(10) unsigned NOT NULL COMMENT 'Item GUID',
  `player_guid` int(10) unsigned NOT NULL COMMENT 'Player GUID',
  `paidMoney` int(10) unsigned NOT NULL DEFAULT '0',
  `paidExtendedCost` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_guid`,`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Item Refund System';

/*Data for the table `item_refund_instance` */

/*Table structure for table `item_soulbound_trade_data` */

DROP TABLE IF EXISTS `item_soulbound_trade_data`;

CREATE TABLE `item_soulbound_trade_data` (
  `itemGuid` int(10) unsigned NOT NULL COMMENT 'Item GUID',
  `allowedPlayers` text NOT NULL COMMENT 'Space separated GUID list of players who can receive this item in trade',
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Item Refund System';

/*Data for the table `item_soulbound_trade_data` */

/*Table structure for table `lag_reports` */

DROP TABLE IF EXISTS `lag_reports`;

CREATE TABLE `lag_reports` (
  `reportId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `lagType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(5) unsigned NOT NULL DEFAULT '0',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `latency` int(10) unsigned NOT NULL DEFAULT '0',
  `createTime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`reportId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

/*Data for the table `lag_reports` */

/*Table structure for table `lfg_data` */

DROP TABLE IF EXISTS `lfg_data`;

CREATE TABLE `lfg_data` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `dungeon` int(10) unsigned NOT NULL DEFAULT '0',
  `state` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='LFG Data';

/*Data for the table `lfg_data` */

/*Table structure for table `logs` */

DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs` (
  `time` int(10) unsigned NOT NULL,
  `realm` int(10) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `string` text CHARACTER SET latin1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `logs` */

/*Table structure for table `mail` */

DROP TABLE IF EXISTS `mail`;

CREATE TABLE `mail` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `messageType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stationery` tinyint(3) NOT NULL DEFAULT '41',
  `mailTemplateId` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sender` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  `receiver` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  `subject` longtext,
  `body` longtext,
  `has_items` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `expire_time` int(10) unsigned NOT NULL DEFAULT '0',
  `deliver_time` int(10) unsigned NOT NULL DEFAULT '0',
  `money` bigint(20) unsigned NOT NULL DEFAULT '0',
  `cod` bigint(20) unsigned NOT NULL DEFAULT '0',
  `checked` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Mail System';

/*Data for the table `mail` */

/*Table structure for table `mail_items` */

DROP TABLE IF EXISTS `mail_items`;

CREATE TABLE `mail_items` (
  `mail_id` int(10) unsigned NOT NULL DEFAULT '0',
  `item_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `receiver` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  PRIMARY KEY (`item_guid`),
  KEY `idx_receiver` (`receiver`),
  KEY `idx_mail_id` (`mail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

/*Data for the table `mail_items` */

/*Table structure for table `mute_active` */

DROP TABLE IF EXISTS `mute_active`;

CREATE TABLE `mute_active` (
  `realmid` tinyint(3) NOT NULL,
  `account` int(11) NOT NULL,
  `mute_id` int(11) NOT NULL,
  `mute_timer` int(11) NOT NULL,
  PRIMARY KEY (`realmid`,`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `mute_active` */

/*Table structure for table `pandaria_token` */

DROP TABLE IF EXISTS `pandaria_token`;

CREATE TABLE `pandaria_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `account_id` int(11) unsigned NOT NULL,
  `character_guid` int(10) NOT NULL DEFAULT '0',
  `realm` int(5) unsigned NOT NULL,
  `vp_count` int(5) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Data for the table `pandaria_token` */

/*Table structure for table `pay_history` */

DROP TABLE IF EXISTS `pay_history`;

CREATE TABLE `pay_history` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `orderNo` varchar(255) DEFAULT NULL,
  `synType` varchar(16) DEFAULT NULL,
  `status` varchar(64) DEFAULT NULL,
  `price` float(10,2) DEFAULT NULL,
  `time` varchar(32) DEFAULT NULL,
  `cpparam` varchar(256) DEFAULT NULL,
  `username` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='not used, don''t know how to make payment work.';

/*Data for the table `pay_history` */

/*Table structure for table `pet_aura` */

DROP TABLE IF EXISTS `pet_aura`;

CREATE TABLE `pet_aura` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `slot` tinyint(3) unsigned NOT NULL,
  `caster_guid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `item_guid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `effect_mask` int(10) unsigned NOT NULL DEFAULT '0',
  `recalculate_mask` int(10) unsigned DEFAULT '0',
  `stackcount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `maxduration` int(11) NOT NULL DEFAULT '0',
  `remaintime` int(11) NOT NULL DEFAULT '0',
  `remaincharges` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`caster_guid`,`item_guid`,`spell`,`effect_mask`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pet_aura` */

/*Table structure for table `pet_aura_effect` */

DROP TABLE IF EXISTS `pet_aura_effect`;

CREATE TABLE `pet_aura_effect` (
  `guid` int(10) unsigned NOT NULL,
  `slot` tinyint(3) unsigned NOT NULL,
  `effect` tinyint(3) unsigned NOT NULL,
  `base_amount` int(10) NOT NULL DEFAULT '0',
  `amount` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`slot`,`effect`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pet_aura_effect` */

/*Table structure for table `pet_spell` */

DROP TABLE IF EXISTS `pet_spell`;

CREATE TABLE `pet_spell` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Spell Identifier',
  `active` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Pet System';

/*Data for the table `pet_spell` */

/*Table structure for table `pet_spell_cooldown` */

DROP TABLE IF EXISTS `pet_spell_cooldown`;

CREATE TABLE `pet_spell_cooldown` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier, Low part',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Spell Identifier',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `category_end` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pet_spell_cooldown` */

/*Table structure for table `petition` */

DROP TABLE IF EXISTS `petition`;

CREATE TABLE `petition` (
  `ownerguid` int(10) unsigned NOT NULL,
  `petitionguid` int(10) unsigned DEFAULT '0',
  `name` varchar(24) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ownerguid`,`type`),
  UNIQUE KEY `index_ownerguid_petitionguid` (`ownerguid`,`petitionguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

/*Data for the table `petition` */

/*Table structure for table `petition_sign` */

DROP TABLE IF EXISTS `petition_sign`;

CREATE TABLE `petition_sign` (
  `ownerguid` int(10) unsigned NOT NULL,
  `petitionguid` int(10) unsigned NOT NULL DEFAULT '0',
  `playerguid` int(10) unsigned NOT NULL DEFAULT '0',
  `player_account` int(10) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`petitionguid`,`playerguid`),
  KEY `Idx_playerguid` (`playerguid`),
  KEY `Idx_ownerguid` (`ownerguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

/*Data for the table `petition_sign` */

/*Table structure for table `players_reports_status` */

DROP TABLE IF EXISTS `players_reports_status`;

CREATE TABLE `players_reports_status` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `creation_time` int(10) unsigned NOT NULL DEFAULT '0',
  `average` float NOT NULL DEFAULT '0',
  `total_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `speed_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fly_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `jump_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `waterwalk_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `teleportplane_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `climb_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `players_reports_status` */

/*Table structure for table `pool_quest_save` */

DROP TABLE IF EXISTS `pool_quest_save`;

CREATE TABLE `pool_quest_save` (
  `pool_id` int(10) unsigned NOT NULL DEFAULT '0',
  `quest_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pool_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `pool_quest_save` */

/*Table structure for table `project_betatesters` */

DROP TABLE IF EXISTS `project_betatesters`;

CREATE TABLE `project_betatesters` (
  `id` int(11) NOT NULL,
  `betatest_id` int(11) NOT NULL,
  `member_id` mediumint(8) NOT NULL,
  `account_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk__project_betatesters__members1_idx` (`member_id`) USING BTREE,
  KEY `fk__project_betatesters__account1_idx` (`account_id`) USING BTREE,
  KEY `fk__project_betatesters__project_betatests1_idx` (`betatest_id`) USING BTREE,
  KEY `fk__project_betatesters__project_betatest_accounts1_idx` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='used for betatesting and allowing players with ids.';

/*Data for the table `project_betatesters` */

/*Table structure for table `project_member_premiums` */

DROP TABLE IF EXISTS `project_member_premiums`;

CREATE TABLE `project_member_premiums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` mediumint(8) NOT NULL,
  `setdate` bigint(40) NOT NULL,
  `unsetdate` bigint(40) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `card_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk__nighthold_member_premium__members1_idx` (`member_id`),
  KEY `fk__nighthold_member_premiums__nighthold_member_items1_idx` (`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Premium Members';

/*Data for the table `project_member_premiums` */

/*Table structure for table `project_member_rewards` */

DROP TABLE IF EXISTS `project_member_rewards`;

CREATE TABLE `project_member_rewards` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(10) unsigned NOT NULL,
  `character_guid` int(10) unsigned NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `realmid` int(10) unsigned NOT NULL,
  `source_type` tinyint(3) unsigned NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `reward_amount` int(10) unsigned NOT NULL,
  `reward_date` int(10) unsigned NOT NULL,
  `reward_day` int(10) unsigned NOT NULL COMMENT 'Used only for indexing purposes',
  `processed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `process_date` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `member_id_reward_day_source_type` (`member_id`,`reward_day`,`source_type`),
  KEY `idx__member_id` (`member_id`),
  KEY `idx__processed` (`processed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Member Rewards';

/*Data for the table `project_member_rewards` */

/*Table structure for table `project_member_settings` */

DROP TABLE IF EXISTS `project_member_settings`;

CREATE TABLE `project_member_settings` (
  `member_id` int(10) unsigned NOT NULL,
  `setting` int(10) unsigned NOT NULL COMMENT 'nightholdMemberInfo::Setting in core',
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`member_id`,`setting`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Member Settings';

/*Data for the table `project_member_settings` */

/*Table structure for table `promocodes` */

DROP TABLE IF EXISTS `promocodes`;

CREATE TABLE `promocodes` (
  `code` varchar(50) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'Latin letters, digits and dash symbol are allowed, case insensitive',
  `realmid` int(11) NOT NULL DEFAULT '-1' COMMENT 'Realm the code can be redeemed on or -1 for any realm',
  `start_time` int(10) unsigned NOT NULL COMMENT 'Activation UNIX timestamp, 0 if always active',
  `end_time` int(10) unsigned NOT NULL COMMENT 'Expiration UNIX timestamp, 0 if never expires',
  `money` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Copper',
  `items` tinytext NOT NULL COMMENT 'Format: itemid:count itemid:count ...',
  `premium` tinytext NOT NULL COMMENT 'Duration in timestring format (e.g. "30d5h42m10s")',
  `redeemed` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '1 if the code was redeemed, 0 otherwise',
  `redeemer_guid` int(10) unsigned NOT NULL COMMENT 'Character GUID that redeemed the code',
  `redeemer_realmid` int(10) unsigned NOT NULL COMMENT 'Character''s realm',
  `redeemer_account` int(10) unsigned NOT NULL COMMENT 'Character''s account',
  `redeemer_member` int(10) unsigned NOT NULL COMMENT 'Character''s nighthold member',
  PRIMARY KEY (`code`),
  KEY `realmid` (`realmid`),
  KEY `redeemed` (`redeemed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='used for custom\r\ntodo: make this implement into blizzcms';

/*Data for the table `promocodes` */

/*Table structure for table `promotion_auras` */

DROP TABLE IF EXISTS `promotion_auras`;

CREATE TABLE `promotion_auras` (
  `entry` int(11) unsigned NOT NULL,
  `start_date` int(11) unsigned NOT NULL,
  `lenght` int(11) unsigned NOT NULL COMMENT 'Lenght in minutes',
  `active` tinyint(1) unsigned NOT NULL,
  `comment` text NOT NULL,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `promotion_auras` */

/*Table structure for table `rated_pvp_info` */

DROP TABLE IF EXISTS `rated_pvp_info`;

CREATE TABLE `rated_pvp_info` (
  `guid` int(10) unsigned NOT NULL,
  `slot` tinyint(3) unsigned NOT NULL,
  `season` smallint(5) unsigned NOT NULL,
  `rank` smallint(5) unsigned DEFAULT '0',
  `rating` smallint(5) unsigned DEFAULT '0',
  `matchmaker_rating` smallint(5) unsigned DEFAULT '0',
  `week_best` smallint(5) unsigned DEFAULT '0',
  `week_games` smallint(5) unsigned DEFAULT '0',
  `week_wins` smallint(5) unsigned DEFAULT '0',
  `season_best` smallint(5) unsigned DEFAULT '0',
  `season_games` smallint(5) unsigned DEFAULT '0',
  `season_wins` smallint(5) unsigned DEFAULT '0',
  `last_week_best` smallint(5) unsigned DEFAULT '0',
  `bonus_reward` tinyint(1) NOT NULL DEFAULT '0',
  `win_streak` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`slot`,`season`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `rated_pvp_info` */

/*Table structure for table `rbac_account_groups` */

DROP TABLE IF EXISTS `rbac_account_groups`;

CREATE TABLE `rbac_account_groups` (
  `accountId` int(10) unsigned NOT NULL COMMENT 'Account id',
  `groupId` int(10) unsigned NOT NULL COMMENT 'Group id',
  `realmId` int(11) NOT NULL DEFAULT '-1' COMMENT 'Realm Id, -1 means all',
  PRIMARY KEY (`accountId`,`groupId`,`realmId`),
  KEY `fk__rbac_account_groups__rbac_groups` (`groupId`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Account-Group relation';

/*Data for the table `rbac_account_groups` */

/*Table structure for table `rbac_account_permissions` */

DROP TABLE IF EXISTS `rbac_account_permissions`;

CREATE TABLE `rbac_account_permissions` (
  `accountId` int(10) unsigned NOT NULL COMMENT 'Account id',
  `permissionId` int(10) unsigned NOT NULL COMMENT 'Permission id',
  `granted` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Granted = 1, Denied = 0',
  `realmId` int(11) NOT NULL DEFAULT '-1' COMMENT 'Realm Id, -1 means all',
  PRIMARY KEY (`accountId`,`permissionId`,`realmId`),
  KEY `fk__rbac_account_roles__rbac_permissions` (`permissionId`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Account-Permission relation';

/*Data for the table `rbac_account_permissions` */

/*Table structure for table `realm_classes` */

DROP TABLE IF EXISTS `realm_classes`;

CREATE TABLE `realm_classes` (
  `realmId` int(11) NOT NULL,
  `class` tinyint(4) NOT NULL COMMENT 'Class Id',
  `expansion` tinyint(4) NOT NULL COMMENT 'Expansion for class activation',
  PRIMARY KEY (`realmId`,`class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `realm_classes` */

/*Table structure for table `realm_diff_stats` */

DROP TABLE IF EXISTS `realm_diff_stats`;

CREATE TABLE `realm_diff_stats` (
  `realm_id` tinyint(3) unsigned NOT NULL,
  `diff` mediumint(8) unsigned DEFAULT NULL,
  `min` mediumint(8) unsigned DEFAULT NULL,
  `max` mediumint(8) unsigned DEFAULT NULL,
  `unixtime` int(10) NOT NULL,
  PRIMARY KEY (`realm_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `realm_diff_stats` */

/*Table structure for table `realm_races` */

DROP TABLE IF EXISTS `realm_races`;

CREATE TABLE `realm_races` (
  `realmId` int(11) NOT NULL,
  `race` tinyint(4) NOT NULL COMMENT 'Race Id',
  `expansion` tinyint(4) NOT NULL COMMENT 'Expansion for race activation',
  PRIMARY KEY (`realmId`,`race`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `realm_races` */

/*Table structure for table `realmcharacters` */

DROP TABLE IF EXISTS `realmcharacters`;

CREATE TABLE `realmcharacters` (
  `realmid` int(10) unsigned NOT NULL DEFAULT '0',
  `acctid` int(10) unsigned NOT NULL,
  `numchars` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`realmid`,`acctid`),
  KEY `acctid` (`acctid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='How many characters accounts have';

/*Data for the table `realmcharacters` */

/*Table structure for table `realmlist` */

DROP TABLE IF EXISTS `realmlist`;

CREATE TABLE `realmlist` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `project_shortname` varchar(32) NOT NULL,
  `address` varchar(32) NOT NULL DEFAULT '127.0.0.1',
  `port` int(11) NOT NULL DEFAULT '8085',
  `icon` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `color` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `timezone` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `allowedSecurityLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `population` float unsigned NOT NULL DEFAULT '0',
  `gamebuild` int(11) unsigned NOT NULL DEFAULT '12340',
  `flag` int(11) DEFAULT NULL,
  `project_hidden` tinyint(1) NOT NULL DEFAULT '0',
  `project_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `project_dbname` varchar(32) NOT NULL,
  `project_dbworld` varchar(32) NOT NULL,
  `project_dbarchive` varchar(32) NOT NULL,
  `project_rates_min` tinyint(4) NOT NULL COMMENT 'project',
  `project_rates_max` tinyint(4) NOT NULL COMMENT 'project',
  `project_transfer_level_max` tinyint(4) NOT NULL DEFAULT '80',
  `project_transfer_items` enum('IGNORE','IMPORT','REPLACE','SELECT') NOT NULL DEFAULT 'IGNORE',
  `project_transfer_skills_spells` enum('IGNORE','IMPORT','REPLACE','SELECT') NOT NULL DEFAULT 'IGNORE',
  `project_transfer_glyphs` enum('IGNORE','IMPORT') NOT NULL DEFAULT 'IGNORE',
  `project_transfer_achievements` enum('IGNORE','IMPORT') NOT NULL DEFAULT 'IGNORE',
  `project_server_same` tinyint(1) NOT NULL DEFAULT '0',
  `project_server_settings` varchar(32) NOT NULL,
  `project_server_remote_path` varchar(255) NOT NULL,
  `project_accounts_detach` tinyint(1) NOT NULL DEFAULT '1',
  `project_setskills_value_max` smallint(6) NOT NULL DEFAULT '0',
  `project_chat_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `project_statistics_enabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Realm System';

/*Data for the table `realmlist` */

insert  into `realmlist`(`id`,`name`,`project_shortname`,`address`,`port`,`icon`,`color`,`timezone`,`allowedSecurityLevel`,`population`,`gamebuild`,`flag`,`project_hidden`,`project_enabled`,`project_dbname`,`project_dbworld`,`project_dbarchive`,`project_rates_min`,`project_rates_max`,`project_transfer_level_max`,`project_transfer_items`,`project_transfer_skills_spells`,`project_transfer_glyphs`,`project_transfer_achievements`,`project_server_same`,`project_server_settings`,`project_server_remote_path`,`project_accounts_detach`,`project_setskills_value_max`,`project_chat_enabled`,`project_statistics_enabled`) values 
(1,'Pandaria 5.4.8','Pandaria 5.4.8','127.0.0.1',8085,0,2,1,0,0,18414,32,0,1,'characters','world','archive',0,0,80,'IGNORE','IGNORE','IGNORE','IGNORE',0,'0','0',1,0,0,0);

/*Table structure for table `realmlist_proxy` */

DROP TABLE IF EXISTS `realmlist_proxy`;

CREATE TABLE `realmlist_proxy` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Must be different from `realmlist`.`name`, otherwise will override original realm''s address and port',
  `address` varchar(32) NOT NULL DEFAULT '127.0.0.1',
  `port` int(11) NOT NULL DEFAULT '8085',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

/*Data for the table `realmlist_proxy` */

/*Table structure for table `reserved_name` */

DROP TABLE IF EXISTS `reserved_name`;

CREATE TABLE `reserved_name` (
  `name` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player Reserved Names';

/*Data for the table `reserved_name` */

/*Table structure for table `sql_update` */

DROP TABLE IF EXISTS `sql_update`;

CREATE TABLE `sql_update` (
  `file` varchar(50) CHARACTER SET latin1 NOT NULL,
  `realmid` tinyint(4) NOT NULL DEFAULT '-1',
  `date` datetime DEFAULT NULL,
  `result` longtext,
  PRIMARY KEY (`file`,`realmid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sql_update` */

/*Table structure for table `ticket_bug` */

DROP TABLE IF EXISTS `ticket_bug`;

CREATE TABLE `ticket_bug` (
  `ticketId` int(10) unsigned NOT NULL,
  `playerGuid` bigint(20) unsigned NOT NULL,
  `bugNote` text NOT NULL,
  `ticketCreateTime` int(10) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(5) unsigned NOT NULL DEFAULT '0',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `closedBy` bigint(20) NOT NULL DEFAULT '0',
  `assignedTo` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'GUID of admin to whom ticket is assigned',
  `comment` text NOT NULL,
  PRIMARY KEY (`ticketId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ticket_bug` */

/*Table structure for table `uptime` */

DROP TABLE IF EXISTS `uptime`;

CREATE TABLE `uptime` (
  `realmid` int(10) unsigned NOT NULL,
  `starttime` int(10) unsigned NOT NULL DEFAULT '0',
  `uptime` int(10) unsigned NOT NULL DEFAULT '0',
  `maxplayers` smallint(5) unsigned NOT NULL DEFAULT '0',
  `revision` varchar(255) NOT NULL DEFAULT 'SkyFire',
  PRIMARY KEY (`realmid`,`starttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Uptime system';

/*Data for the table `uptime` */

/*Table structure for table `warden_action` */

DROP TABLE IF EXISTS `warden_action`;

CREATE TABLE `warden_action` (
  `wardenId` smallint(5) unsigned NOT NULL,
  `action` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`wardenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `warden_action` */

/*Table structure for table `worldstates` */

DROP TABLE IF EXISTS `worldstates`;

CREATE TABLE `worldstates` (
  `entry` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(10) unsigned NOT NULL DEFAULT '0',
  `comment` tinytext,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Variable Saves';

/*Data for the table `worldstates` */

insert  into `worldstates`(`entry`,`value`,`comment`) values 
(3781,9000000,NULL),
(3801,0,NULL),
(3802,1,NULL),
(4546,0,NULL),
(12562,1,NULL),
(20001,1638331200,NULL),
(20002,1638264194,NULL),
(20003,1638075600,NULL),
(20006,1638075600,NULL),
(20007,1638313200,NULL),
(20008,13,NULL),
(20009,8,NULL),
(20050,5,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
