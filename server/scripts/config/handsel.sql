
-- ----------------------------
-- 创建数据库
-- ----------------------------
CREATE DATABASE IF NOT EXISTS `handsel_record`;

USE `handsel_record`;

-- ----------------------------
-- 创建用户表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `user` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(63) NOT NULL,
  `password` varchar(32) NOT NULL DEFAULT '',
  `realname` varchar(63) DEFAULT '',
  `mobile` varchar(11) DEFAULT '',
  `email` varchar(32) DEFAULT '',
  `disabled` smallint(1) NOT NULL DEFAULT 0,
  `createdate` datetime NULL,
  PRIMARY KEY (`id`, `name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- 用户
BEGIN;
INSERT INTO `user`(`name`, `password`, `realname`) VALUES ('admin', 'c4ca4238a0b923820dcc509a6f75849b', 'admin');
INSERT INTO `user`(`name`, `password`, `realname`) VALUES ('test', 'c4ca4238a0b923820dcc509a6f75849b', 'test');
INSERT INTO `user`(`name`, `password`, `realname`) VALUES ('zhangsan', 'c4ca4238a0b923820dcc509a6f75849b', '张三');
COMMIT;

-- ----------------------------
-- Table structure for user_token
-- ----------------------------
CREATE TABLE IF NOT EXISTS `user_token` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NULL,
  `user_name` varchar(63) NOT NULL,
  `begin_date` datetime NULL,
  `end_date` datetime NULL,
  `deleted` char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;


-- ----------------------------
-- Table structure for user_action
-- ----------------------------
CREATE TABLE IF NOT EXISTS `user_action` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_name` varchar(63) NOT NULL,
  `type` varchar(32) NOT NULL,
  `result` smallint(1) NOT NULL,
  `msg` varchar(64) NOT NULL,
  `date` datetime NULL,
  `device_info` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for relation
-- ----------------------------
CREATE TABLE IF NOT EXISTS `relation` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(16) NOT NULL,
  PRIMARY KEY (`id`, `name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- relation
BEGIN;
INSERT INTO `relation`(`name`) VALUES ('亲戚');
INSERT INTO `relation`(`name`) VALUES ('朋友');
INSERT INTO `relation`(`name`) VALUES ('同学');
COMMIT;

-- ----------------------------
-- Table structure for gift
-- ----------------------------
CREATE TABLE IF NOT EXISTS `gift` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(16) NOT NULL,
  `price` float NULL,
  `isDefault` char(1) DEFAULT '0',
  PRIMARY KEY (`id`, `name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- gift
BEGIN;
INSERT INTO `gift`(`name`, `isDefault`) VALUES ('金圣', '1');
INSERT INTO `gift`(`name`) VALUES ('中华');
COMMIT;


-- ----------------------------
-- Table structure for banquet
-- ----------------------------
CREATE TABLE IF NOT EXISTS `banquet` (
  `id` smallint(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(16) NOT NULL,
  `create_date` datetime NOT NULL,
  `update` datetime NULL,
  `note` text NULL,
  `show_relation` char(1) DEFAULT '1',
  `show_gift` char(1) DEFAULT '1',
  PRIMARY KEY (`id`, `name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- banquet
-- BEGIN;
-- INSERT INTO `banquet`(`name`, `create_date`) VALUES ('陈凝泽周岁', '20201030');
-- INSERT INTO `banquet`(`name`, `create_date`) VALUES ('陈凝玥出生', '20201030');
-- COMMIT;