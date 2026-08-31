/*
 Navicat Premium Dump SQL

 Source Server         : 06-7
 Source Server Type    : MySQL
 Source Server Version : 50736 (5.7.36)
 Source Host           : 192.168.112.101:3306
 Source Schema         : jianengliang

 Target Server Type    : MySQL
 Target Server Version : 50736 (5.7.36)
 File Encoding         : 65001

 Date: 31/07/2026 17:37:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for j_venue_sport_tag_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_sport_tag_ref`;
CREATE TABLE `j_venue_sport_tag_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sport_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `venue_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_venue_id`(`venue_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 225442302 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue
-- ----------------------------
DROP TABLE IF EXISTS `j_venue`;
CREATE TABLE `j_venue`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jzy_venue_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'B端场馆id',
  `saas_venue_id` int(11) NULL DEFAULT NULL COMMENT 'SAAS端场馆id',
  `parent_venue_id` int(11) NULL DEFAULT NULL COMMENT '母馆id',
  `sport_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运动项目id',
  `venue_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆id',
  `sport_alias` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运动别名',
  `is_indoor` int(3) NULL DEFAULT NULL COMMENT '是否室内馆  1室内  2室外',
  `status` int(3) NULL DEFAULT NULL COMMENT '状态 1)上线 2)下线',
  `lowest_price` decimal(20, 2) NULL DEFAULT NULL COMMENT '最低价格',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `min_time` int(11) NULL DEFAULT NULL COMMENT '起订时间(分钟)',
  `max_time` int(11) NULL DEFAULT NULL COMMENT '最大可定时间(分钟)',
  `single_min_time` int(11) NULL DEFAULT NULL COMMENT '单个场地起订时间（分钟）',
  `comment_num` int(11) NOT NULL DEFAULT 0 COMMENT '评论数',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆图片',
  `support_refund` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支持退款',
  `refund_time` int(11) NULL DEFAULT NULL COMMENT '用户每月可退款次数',
  `sub_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆主页封面图',
  `sub_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆主页名字',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆地址',
  `longitude` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆经度',
  `latitude` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆纬度',
  `mobile` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `business_type` int(11) NULL DEFAULT NULL COMMENT '业务类型 2订场3售票',
  `has_field` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支持订场',
  `has_ticket` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支持订票',
  `reserve_days` int(11) NOT NULL DEFAULT 7 COMMENT '可提前预订天数',
  `reverse_type` int(11) NOT NULL DEFAULT 1 COMMENT '预定类型 1在线预定 2电话预定',
  `tags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签',
  `list_id` int(11) NULL DEFAULT NULL COMMENT '排序',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '同步站点,站点id(当为全国时为0)',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `district_id` int(11) NULL DEFAULT NULL COMMENT '区',
  `browse_num` int(11) NULL DEFAULT NULL COMMENT '浏览数',
  `open_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '营业时间',
  `is_show_price` int(11) NOT NULL DEFAULT 3 COMMENT '1:不显示 2：免费 3：收费',
  `help_reverse` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否可以帮用户电话预定',
  `platform` enum('APP','SAAS') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'APP' COMMENT '场馆平台',
  `merchant_id_from` int(11) NULL DEFAULT NULL COMMENT '来源站点',
  `venue_group` int(11) NULL DEFAULT 0 COMMENT '0.普通场馆 1.链接场馆',
  `is_hidden` int(11) NULL DEFAULT 0 COMMENT '列表是否隐藏 0.显示  1.隐藏',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2797 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'C端场馆' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_parent
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_parent`;
CREATE TABLE `j_venue_parent`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `lat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纬度',
  `lon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '经度',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列表页图片',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '场馆介绍',
  `explain_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款说明标题',
  `explain_txt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '退款说明内容',
  `lowest_price` decimal(20, 2) NULL DEFAULT NULL COMMENT '最低价格',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '同步站点id(来源 j_city_merchant 表主键)',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `district_id` int(11) NULL DEFAULT NULL COMMENT '区',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 1)上线 2)下线',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `recommend_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '推荐场馆id集',
  `merchant_id_from` int(11) NULL DEFAULT NULL COMMENT '来源站点',
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否隐藏',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_user
-- ----------------------------
DROP TABLE IF EXISTS `t_s_user`;
CREATE TABLE `t_s_user`  (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mobilePhone` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `officePhone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `signatureFile` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_date` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人id',
  `create_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人id',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_2cuji5h6yorrxgsr8ojndlmal`(`id`) USING BTREE,
  CONSTRAINT `t_s_user_ibfk_1` FOREIGN KEY (`id`) REFERENCES `t_s_base_user` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_log
-- ----------------------------
DROP TABLE IF EXISTS `t_s_log`;
CREATE TABLE `t_s_log`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `broswer` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `logcontent` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `loglevel` smallint(6) NULL DEFAULT NULL,
  `note` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `operatetime` datetime NOT NULL,
  `operatetype` smallint(6) NULL DEFAULT NULL,
  `userid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `FK_oe64k4852uylhyc5a00rfwtay`(`userid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_user_message
-- ----------------------------
DROP TABLE IF EXISTS `j_user_message`;
CREATE TABLE `j_user_message`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `pick_num` int(11) NOT NULL DEFAULT 0 COMMENT '点赞数',
  `pick_num_add` int(11) NOT NULL DEFAULT 0,
  `collect_num` int(11) NOT NULL DEFAULT 0 COMMENT '收藏数',
  `collect_num_add` int(11) NOT NULL DEFAULT 0,
  `comment_num_add` int(11) NOT NULL DEFAULT 0,
  `comment_num` int(11) NOT NULL DEFAULT 0 COMMENT '评论数',
  `follow_num_add` int(11) NOT NULL DEFAULT 0,
  `follow_num` int(11) NOT NULL DEFAULT 0 COMMENT '关注数',
  `exchange_num_add` int(11) NOT NULL DEFAULT 0,
  `exchange_num` int(11) NOT NULL DEFAULT 0 COMMENT '兑换消息',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 318 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_activity_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_activity_statistics`;
CREATE TABLE `j_activity_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NOT NULL COMMENT '活动id',
  `activity_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '活动名称',
  `type_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '类型名称',
  `type_id` int(11) NOT NULL COMMENT '类型id',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tag2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 336 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_iteam_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_iteam_statistics`;
CREATE TABLE `j_iteam_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iteam` int(11) NOT NULL DEFAULT 0 COMMENT '所属板块',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tag2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `iteam_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '板块名称',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2610 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_token
-- ----------------------------
DROP TABLE IF EXISTS `j_token`;
CREATE TABLE `j_token`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `access_token` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '验证口令',
  `expires` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '口令有效期',
  `last_signin_ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '最后登录IP',
  `last_signin_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后登录时间',
  `is_check_client` tinyint(1) NULL DEFAULT 0 COMMENT '是否核销端TOKEN(0为一起吗APP,1为核销端用户)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 649 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'token' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member
-- ----------------------------
DROP TABLE IF EXISTS `j_member`;
CREATE TABLE `j_member`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `phone` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '注册手机',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `nick_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `birthday` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生日',
  `age` int(3) NULL DEFAULT NULL COMMENT '年龄',
  `province` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '市',
  `area` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '区',
  `sex` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '性别  0不明 1男 2女',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户头像',
  `rank` int(11) NULL DEFAULT 0 COMMENT '用户等级ID(0.普通会员，1场馆管理员，2培训机构管理员，3商户管理员，4系统平台管理员)枚举体现',
  `is_audit` int(11) NULL DEFAULT 0 COMMENT '是否审核(0否，1是)',
  `login_num` int(11) NULL DEFAULT 0 COMMENT '登录次数',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '上次登录时间',
  `this_login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '本次登录时间',
  `energy_volume_num` int(11) NULL DEFAULT 0 COMMENT '能量卷数量',
  `depart_discount_num` int(11) NULL DEFAULT 0 COMMENT '场地抵扣券数量',
  `is_blacklist` tinyint(1) NULL DEFAULT 0 COMMENT '是否黑名单 0不是  1是',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `guess_status` int(3) NULL DEFAULT 1 COMMENT '竞猜开关 0 关 1 开',
  `default_image_index` int(11) NULL DEFAULT 0 COMMENT '默认头像索引',
  `source` int(11) NOT NULL DEFAULT 0 COMMENT '用户来源 1 android 2 ios 3 小程序  4后台录入',
  `register_source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '注册来源(子场馆id)',
  `signature` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '个性签名',
  `is_vip` int(2) NOT NULL DEFAULT 0 COMMENT '是否是加V用户(0-不是,1-子场馆关联用户,2-个人加V用户)',
  `jwh_vip` int(2) NOT NULL DEFAULT 0 COMMENT '佳文荟会员 0-否 1-是 2-已过期',
  `venue_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '场馆id',
  `member_rate` decimal(5, 1) NOT NULL DEFAULT 1.8 COMMENT '用户权重',
  `content_rate` decimal(5, 1) NOT NULL DEFAULT 1.8 COMMENT '内容权重',
  `member_status` int(2) NOT NULL DEFAULT 1 COMMENT '会员状态(1-正常,2-封禁)',
  `mini_qrcode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小程序分享二维码',
  `id_card_create_time` datetime NULL DEFAULT NULL COMMENT 'id_card上传时间',
  `report_create_time` datetime NULL DEFAULT NULL COMMENT '体检上传时间',
  `id_card_check` int(11) NULL DEFAULT 1 COMMENT ' id_card校验 1：未校验，2：已校验，3：过期，4：禁用',
  `id_card_expire_date` datetime NULL DEFAULT NULL COMMENT 'id_card有效期',
  `report_expire_date` datetime NULL DEFAULT NULL COMMENT '体检有效期',
  `id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'id_card',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '姓名',
  `report_check` int(11) NULL DEFAULT 1 COMMENT ' 体检校验 1：未上传， 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用',
  `child_check` int(11) NULL DEFAULT 1 COMMENT ' 儿童校验 1：未校验， 2：已校验，3：过期，4：禁用',
  `child_check_expire_date` datetime NULL DEFAULT NULL COMMENT '儿童id_card有效期',
  `child_id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '儿童id_card',
  `child_birthday` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '儿童生日',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_venue_id`(`venue_id`) USING BTREE,
  INDEX `phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1379218 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods`;
CREATE TABLE `mall_goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `goods_essence` int(11) NOT NULL DEFAULT 1 COMMENT '商品实质 1：渠道商品，2：赛事演艺票，3：优惠券 4：自营商品 5：线下兑换',
  `goods_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `subtitle` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '副标题',
  `des` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '简述',
  `brand_id` int(11) NULL DEFAULT NULL COMMENT '品牌id',
  `model` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ticket_type` int(11) NULL DEFAULT NULL COMMENT '票务类型 1演唱会 2赛事',
  `relate_type` int(11) NULL DEFAULT NULL COMMENT '自营商品分类 1:演唱会周边 2：赛事周边 3：其他',
  `des_img` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '简述图片',
  `buy_notice_intro` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '购票须知简介',
  `buy_notice_detail` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '购票须知详情',
  `show_time` datetime NULL DEFAULT NULL COMMENT '演出时间（排序）',
  `hold_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '演出时间（展示）',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `is_take` tinyint(1) NOT NULL DEFAULT 0 COMMENT '取票方式：自取',
  `is_express` tinyint(1) NOT NULL DEFAULT 0 COMMENT '取票方式：快递',
  `is_elec_ticket` tinyint(1) NOT NULL DEFAULT 0 COMMENT '取票方式：电子票',
  `is_real` int(1) NOT NULL DEFAULT 0 COMMENT '实名认证 0：不需要，1：一证一票，2：一证多票',
  `take_address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自取地址',
  `is_recommend` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否推荐',
  `type_ids` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品分类id集',
  `type_names` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `title1` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '赛事演艺详情标题一',
  `title2` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '赛事演艺详情标题二',
  `sup_ids` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商id集',
  `sup_names` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `websites` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品网址（多个网址，英文逗号分割）',
  `first_img` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品首图',
  `img_urls` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品图片（最多5个图片地址，英文逗号分割）',
  `label` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签（中文，逗号分割）',
  `info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商品详情（富文本）',
  `highest_sprice` decimal(8, 2) NULL DEFAULT NULL COMMENT '最高售价',
  `highest_oprice` decimal(8, 2) NULL DEFAULT NULL COMMENT '最高原价',
  `lowest_sprice` decimal(8, 2) NULL DEFAULT NULL COMMENT '最高售价',
  `lowest_oprice` decimal(8, 2) NULL DEFAULT NULL COMMENT '最低售价价',
  `lowest_points` int(11) NULL DEFAULT NULL COMMENT '最少积分',
  `total_storege` int(11) NOT NULL DEFAULT 0 COMMENT '总库存',
  `sold_num` int(11) NOT NULL DEFAULT 0 COMMENT '已售数量',
  `sell_way` int(11) NOT NULL DEFAULT 1 COMMENT '（商品售卖方式，1：金钱，2：积分，3：积分+金钱 4:步数 5：拉新人数）',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0：删除，1：待上架，2：已上架，3：已下架 4:已结束',
  `is_inside` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否内部商品',
  `points_section` int(11) NULL DEFAULT NULL COMMENT '积分商品所属板块 1：邀请有礼 2：限时兑换 3：积分商城',
  `sequence` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `buy_num_limit` int(11) NULL DEFAULT 0 COMMENT '购买数量限制',
  `lng` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经度',
  `lat` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '纬度',
  `sell_start_time` datetime NULL DEFAULT NULL COMMENT '开售开始时间',
  `sell_end_time` datetime NULL DEFAULT NULL COMMENT '开售结束时间',
  `presell_start_time` datetime NULL DEFAULT NULL COMMENT '预售开始时间',
  `presell_end_time` datetime NULL DEFAULT NULL COMMENT '预售结束时间',
  `price_tag` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '价格标签',
  `price_tag_des` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '价格标签描述',
  `price_tag_start_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '价格标签开始时间',
  `price_tag_end_time` datetime NULL DEFAULT NULL COMMENT '价格标签结束时间',
  `points_ex_start_time` datetime NULL DEFAULT NULL COMMENT '积分线下兑换开始时间',
  `points_ex_end_time` datetime NULL DEFAULT NULL COMMENT '积分线下兑换结束时间',
  `points_ex_memo` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '积分线下兑换使用方式说明',
  `ticketId` int(11) NULL DEFAULT NULL COMMENT '砍价活动票id',
  `source` int(11) NULL DEFAULT 1,
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id(当为全国时为0)',
  `percentage` int(11) NULL DEFAULT 0 COMMENT '抽成比例',
  `j_merchant_id` int(11) NULL DEFAULT NULL COMMENT '银联商户id',
  PRIMARY KEY (`id`) USING BTREE,
  FULLTEXT INDEX `goods_name`(`goods_name`)
) ENGINE = InnoDB AUTO_INCREMENT = 371 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '（App）商城商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_third
-- ----------------------------
DROP TABLE IF EXISTS `j_member_third`;
CREATE TABLE `j_member_third`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `third_type` int(2) NOT NULL COMMENT '第三方类型(1-微信,2-支付宝)',
  `third_source` int(2) NOT NULL COMMENT '第三方注册来源(1-小程序,2-微信公众号)',
  `third_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '第三方id(微信为openid)',
  `union_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第三方唯一id(微信为unionid)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 225 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '会员第三方登录绑定表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_spec_ref
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_spec_ref`;
CREATE TABLE `mall_goods_spec_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `spec_id` int(11) NOT NULL COMMENT '（一级）规格id',
  `spec_names` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '二级规格名称集',
  `spec_ids` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '二级规格id集（程序生成）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1522 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '（app商城）商品规格关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_sku`;
CREATE TABLE `mall_goods_sku`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku_names` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'sku组合名称(二级规格名称)：黑色,XL',
  `sku_keys` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'sku组合key(二级规格id集)',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `num` int(11) NOT NULL DEFAULT 0 COMMENT '商品数量',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `sell_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '售价',
  `points` int(11) NULL DEFAULT NULL COMMENT '所需积分',
  `serial_num` int(11) NULL DEFAULT 1 COMMENT 'SKU序号',
  `is_query_hidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否查询隐藏',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `goods_id`(`goods_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 574 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '（App）商城商品sku表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_platform_activity
-- ----------------------------
DROP TABLE IF EXISTS `j_platform_activity`;
CREATE TABLE `j_platform_activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '活动名称',
  `category_id` int(11) NULL DEFAULT 0 COMMENT '活动分类id',
  `category_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '活动分类名称',
  `venue_id` int(11) NULL DEFAULT NULL,
  `venue_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `introduction` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '介绍',
  `pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '需支付金额',
  `free_sign` tinyint(1) NULL DEFAULT 0 COMMENT '是否免费',
  `least_nums` int(10) NULL DEFAULT 0 COMMENT '至少报名人数',
  `sign_up_nums` int(10) NULL DEFAULT 0 COMMENT '报名人数',
  `sign_up_attrs` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '报名填报信息',
  `thumb_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图',
  `boostrap_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '首页图片',
  `list_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列表图片',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `sign_up_start_time` datetime NULL DEFAULT NULL COMMENT '报名开始时间',
  `sign_up_end_time` datetime NULL DEFAULT NULL COMMENT '报名结束时间',
  `release_start_time` datetime NULL DEFAULT NULL COMMENT '自行发布时间',
  `release_end_time` datetime NULL DEFAULT NULL COMMENT '自行下线时间',
  `activity_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '活动状态',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `district_id` int(11) NULL DEFAULT NULL COMMENT '区',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆地址',
  `longitude` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆经度',
  `latitude` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆纬度',
  `create_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL,
  `percentage` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '抽成比例',
  `j_merchant_id` int(11) NULL DEFAULT NULL COMMENT '银联商户id',
  `show_list` int(11) NULL DEFAULT 1 COMMENT '是否小程序列表展示 1-是 2-否',
  `sign_up_num_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否展示报名人数 1-是 0-否',
  `label` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 215 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_statistics`;
CREATE TABLE `j_venue_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `venue_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '场馆名称',
  `venue_type` int(1) NOT NULL COMMENT '场馆类型',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `tg1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段',
  `tg2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段',
  `venue_id` int(10) NOT NULL COMMENT '场馆id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2536 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_article
-- ----------------------------
DROP TABLE IF EXISTS `j_article`;
CREATE TABLE `j_article`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `s_title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '副标题',
  `img` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `author` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `venue_pid` int(11) NULL DEFAULT NULL COMMENT '父级场馆id',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态  0.关闭 1.正常',
  `update_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `only_content` int(11) NOT NULL DEFAULT 0 COMMENT '是否只显示文章内容（1：是，0：否）',
  `browse_num` int(11) NOT NULL DEFAULT 0 COMMENT '浏览数',
  `comment_num` int(11) NOT NULL DEFAULT 0 COMMENT '评论数',
  `support_num` int(11) NOT NULL DEFAULT 0 COMMENT '支持数',
  `unsupport_num` int(11) NOT NULL DEFAULT 0 COMMENT '不支持数',
  `start_time` datetime NULL DEFAULT NULL,
  `end_time` datetime NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id(当为全国时为0)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文章表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_article_content
-- ----------------------------
DROP TABLE IF EXISTS `j_article_content`;
CREATE TABLE `j_article_content`  (
  `id` int(11) NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文章内容表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_kaisa_activity
-- ----------------------------
DROP TABLE IF EXISTS `j_kaisa_activity`;
CREATE TABLE `j_kaisa_activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '活动名称',
  `start_time` datetime NOT NULL COMMENT '活动开始时间',
  `end_time` datetime NOT NULL COMMENT '活动结束时间',
  `sign_start_time` datetime NOT NULL COMMENT '报名开始时间',
  `sign_end_time` datetime NOT NULL COMMENT '报名结束时间',
  `index_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '活动首页图片',
  `thumbnail_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '缩略图',
  `activity_detail` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '活动详情',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '活动状态 0.下线 1.上线',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '编辑人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_platform_activity_person
-- ----------------------------
DROP TABLE IF EXISTS `j_platform_activity_person`;
CREATE TABLE `j_platform_activity_person`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(10) NULL DEFAULT 0 COMMENT '活动id',
  `user_id` int(10) NULL DEFAULT 0 COMMENT '用户id',
  `account` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称',
  `sign_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登记名称',
  `sign_phone` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登记手机号',
  `sign_card_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登记证件类型',
  `sign_card_no` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登记证件号',
  `sign_equip_size` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登记装备尺寸',
  `sign_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登记备注',
  `sign_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '报名状态',
  `sign_item_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '报名项目状态',
  `sign_gift_bag_id` int(10) NULL DEFAULT 0 COMMENT '礼包id',
  `due_pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '应支付金额',
  `pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实际支付金额',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `pay_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '支付状态 0-未支付 1-已支付 2-已退款 3-退款审核中',
  `sign_time` datetime NULL DEFAULT NULL COMMENT '报名时间',
  `free_sign` tinyint(1) NULL DEFAULT 0 COMMENT '是否免费',
  `order_num` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '订单号',
  `mid` int(10) NULL DEFAULT NULL,
  `emergency_contact` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '紧急联系人',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 637 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名-报名者' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_send_prize_record
-- ----------------------------
DROP TABLE IF EXISTS `j_send_prize_record`;
CREATE TABLE `j_send_prize_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `send_prize_id` int(11) NULL DEFAULT NULL COMMENT 'j_send_prize id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '目标用户',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发放时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `use_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '核销方',
  `is_use` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否核销',
  `is_pop` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否弹窗',
  `is_view` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for register_window
-- ----------------------------
DROP TABLE IF EXISTS `register_window`;
CREATE TABLE `register_window`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 152 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_sms
-- ----------------------------
DROP TABLE IF EXISTS `j_sms`;
CREATE TABLE `j_sms`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `template_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模板代码',
  `sign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '签名',
  `is_send` tinyint(1) NULL DEFAULT NULL COMMENT '是否发送',
  `is_success` tinyint(1) NULL DEFAULT NULL COMMENT '是否发送成功',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '失败原因',
  `params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '短信参数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '短信发送记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_id_card_check_record
-- ----------------------------
DROP TABLE IF EXISTS `j_id_card_check_record`;
CREATE TABLE `j_id_card_check_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_card` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'id_card',
  `member_id` int(11) NOT NULL DEFAULT 0 COMMENT 'member_id',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'phone',
  `type` int(11) NULL DEFAULT 1 COMMENT '1 老人2少年',
  `user_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `code` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '成功为200（10000），其它为失败状态码',
  `company_type` int(11) NULL DEFAULT 1 COMMENT 'compay_type 1 天眼 2网易 3数据宝',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'code对应的说明描述',
  `result` int(1) NULL DEFAULT 1 COMMENT '0 一致（收费），1 不一致（收费），2 无记录（收费）',
  `order_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `sex` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `check_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验证结果描述信息',
  `birthday` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生日',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '籍贯',
  `task_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '本次请求数据标识，可以根据该标识在控制台进行数据查询',
  `reason_type` int(1) NULL DEFAULT 1 COMMENT '	原因详情，1：认证通过 2：输入姓名和身份证号不一致 3：查无此身份证 7：结果获取失败，请重试',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '	认证结果，1：认证通过，2：认证不通过， 0：待定(原因参考下方reasonType字段)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 146 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '身份证件记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_verification_code
-- ----------------------------
DROP TABLE IF EXISTS `j_verification_code`;
CREATE TABLE `j_verification_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id号',
  `phone` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验证码  ',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `phone_unique`(`phone`) USING BTREE COMMENT '验证码表手机号唯一, 只允许存在一条'
) ENGINE = InnoDB AUTO_INCREMENT = 249 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_sku_rd_records
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_sku_rd_records`;
CREATE TABLE `mall_goods_sku_rd_records`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NULL DEFAULT NULL,
  `sku_id` int(11) NULL DEFAULT NULL,
  `num` int(11) NULL DEFAULT NULL COMMENT '出入库数量',
  `type` int(11) NULL DEFAULT NULL COMMENT '0 入库 1出库',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品出入库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_ex_stuff
-- ----------------------------
DROP TABLE IF EXISTS `j_ex_stuff`;
CREATE TABLE `j_ex_stuff`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stuff_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 物品名称',
  `days` int(11) NULL DEFAULT NULL COMMENT '有效天数 ，0表示不限制天数',
  `rec_type` int(11) NULL DEFAULT 0 COMMENT '领取方式  0.不限 1.注册 2.积分兑换',
  `req_points` int(11) NULL DEFAULT NULL COMMENT '所需积分',
  `unit_des` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `ex_num_limit` int(11) NOT NULL DEFAULT 0 COMMENT '兑换数量限制（0：不限制）',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态  0.关闭 1.正常 2.假删除',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0 COMMENT '总数量 0表示不限制数量',
  `ex_amount` int(11) NOT NULL DEFAULT 0 COMMENT '已兑换数量',
  `use_amount` int(11) NOT NULL DEFAULT 0 COMMENT '已使用数量',
  `expire_amount` int(11) NOT NULL DEFAULT 0 COMMENT '过期数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '  兑换物品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_coupon_code
-- ----------------------------
DROP TABLE IF EXISTS `j_coupon_code`;
CREATE TABLE `j_coupon_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '优惠券金额',
  `full_cut_price` decimal(7, 2) NULL DEFAULT NULL COMMENT '满减金额',
  `req_points` int(11) NULL DEFAULT NULL COMMENT '所需积分',
  `rec_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '领取方式   1.注册 2.积分兑换 3.发老用户 4.自定义发放',
  `scene_type` tinyint(4) NOT NULL COMMENT '适用场景 0.全场通用 1.订场售票',
  `days` int(11) NULL DEFAULT 0 COMMENT '有效天数 ，0表示不限制天数',
  `amount` int(11) NULL DEFAULT 0 COMMENT '总数量 0表示不限制数量',
  `ex_amount` int(11) NULL DEFAULT 0 COMMENT '已兑换数量',
  `use_amount` int(11) NULL DEFAULT 0 COMMENT '已使用数量',
  `user_type` int(11) NULL DEFAULT NULL COMMENT '用户类型 1：所有 2：根据注册时间段',
  `reg_start_time` datetime NULL DEFAULT NULL COMMENT '注册开始时间',
  `reg_end_time` datetime NULL DEFAULT NULL COMMENT '注册结束时间',
  `expire_amount` int(11) NULL DEFAULT 0 COMMENT '过期数量',
  `send_start_time` datetime NULL DEFAULT NULL COMMENT '发放开始时间',
  `send_end_time` datetime NULL DEFAULT NULL COMMENT '发放结束时间',
  `start_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '优惠码的有效开始时间（在此时间之后才可领取）',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '优惠码的有效时间',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态  0.禁用 1.启用 2.假删除',
  `update_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `discount` decimal(7, 2) NULL DEFAULT NULL,
  `couponCodeType` int(10) NULL DEFAULT 1,
  `userange` int(2) NULL DEFAULT 0,
  `userangeDesc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '使用范围描述',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 410 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠码' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_range
-- ----------------------------
DROP TABLE IF EXISTS `coupon_range`;
CREATE TABLE `coupon_range`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `traningVenueId` int(10) NULL DEFAULT NULL COMMENT '培训基地id',
  `traningTypeId` int(10) NULL DEFAULT NULL COMMENT '培训类型id',
  `traningCourseId` int(10) NULL DEFAULT NULL COMMENT '培训课程id',
  `traningGranularity` int(1) NULL DEFAULT NULL COMMENT '培训颗粒度，1_所有培训，2_培训基地,3_培训类型，4_培训课程',
  `goodsTypeId` int(10) NULL DEFAULT NULL COMMENT '商品类型id',
  `goodsId` int(10) NULL DEFAULT NULL COMMENT '商品id',
  `goodsGranularity` int(1) NULL DEFAULT NULL COMMENT '商品颗粒度，1_所有商品，2_类型，3_商品',
  `venueId` int(10) NULL DEFAULT NULL COMMENT '场馆id',
  `venuType` int(1) NULL DEFAULT NULL COMMENT '场馆类型1_全部，2_订场，3_购票',
  `sportId` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运动类型id',
  `ticketId` int(10) NULL DEFAULT NULL COMMENT '票id',
  `venueGranularity` int(1) NULL DEFAULT NULL COMMENT '场馆颗粒度,1_所有场馆，2_运动类型，2_单张票',
  `activityTypeId` int(10) NULL DEFAULT NULL COMMENT '活动类型id',
  `activityId` int(10) NULL DEFAULT NULL COMMENT '活动id',
  `activityGranularity` int(1) NULL DEFAULT NULL COMMENT '活动颗粒度1_所有活动，2_活动类型，3_单个活动',
  `couponId` int(10) NOT NULL COMMENT '优惠券码id',
  `mallTickettype` int(10) NULL DEFAULT NULL,
  `mallTicket` int(10) NULL DEFAULT NULL,
  `mallTicketgranularity` int(10) NULL DEFAULT NULL,
  `card_id` int(10) NULL DEFAULT NULL COMMENT '线上办卡id',
  `damai_granularity` int(10) NULL DEFAULT NULL,
  `damai_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `damai_project_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 285 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_send_prize
-- ----------------------------
DROP TABLE IF EXISTS `j_send_prize`;
CREATE TABLE `j_send_prize`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动名称',
  `should_num` int(11) NULL DEFAULT NULL COMMENT '应发数量',
  `real_num` int(11) NULL DEFAULT NULL COMMENT '实发数量',
  `prize_type` int(11) NULL DEFAULT NULL COMMENT '奖品类型 1：线下礼品 2：邮寄礼品 3：线下优惠券 4：线上优惠券 5：积分',
  `send_status` int(11) NULL DEFAULT NULL COMMENT '发送状态 0：发送中 1：已发送',
  `failure_num` int(11) NULL DEFAULT NULL COMMENT '失败数量',
  `opt_user` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人',
  `use_num` int(11) NULL DEFAULT NULL COMMENT '使用数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `target_user` int(11) NULL DEFAULT NULL COMMENT '目标用户 1.excel  2.手动输入 3。新注册用户',
  `enable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '启用，禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发放奖品记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_message
-- ----------------------------
DROP TABLE IF EXISTS `j_message`;
CREATE TABLE `j_message`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '消息编号',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户编号',
  `content` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '消息内容',
  `type` int(3) NULL DEFAULT NULL COMMENT '0：系统消息，1：订单消息，2：商城消息',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '消息是否已读,0.未读 1.已读 2.用户已清除',
  `des` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `push_status` int(11) NULL DEFAULT NULL COMMENT '（第三方推送消息）推送状态 0：失败，1成功',
  `send_status` int(11) NULL DEFAULT NULL COMMENT '（短信发送消息）发送状态 0：失败，1成功',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `extra_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '跳转用额外参数',
  `extra_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '跳转用额外类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5396 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '我的消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_prize_detail
-- ----------------------------
DROP TABLE IF EXISTS `j_prize_detail`;
CREATE TABLE `j_prize_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `send_prize_id` int(11) NULL DEFAULT NULL COMMENT 'j_send_prize id',
  `prize_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品名称',
  `start_date` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '有效期开始',
  `end_date` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '有效期结束',
  `use_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用地点',
  `use_venue` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '适用场馆',
  `express_company` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递公司',
  `express_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递单号',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '说明',
  `worth` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '价值',
  `coupon_id` int(11) NULL DEFAULT NULL COMMENT '优惠券id',
  `coupon_num` int(11) NULL DEFAULT NULL COMMENT '优惠券数量',
  `points` int(11) NULL DEFAULT NULL COMMENT '积分',
  `reg_start_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送时间开始',
  `reg_end_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送时间结束',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_prize_id`(`send_prize_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `j_member_order_detail`;
CREATE TABLE `j_member_order_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `swim_ticket_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '游泳票描述',
  `swim_ticket_expire_date` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '游泳票有效期',
  `field_time_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订场时间描述',
  `field_num_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订场数量描述',
  `packages_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '套餐价格',
  `field_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '场地价格',
  `swim_ticket_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '游泳票价格',
  `user_remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户购买备注',
  `take_remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户取票备注',
  `close_remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单关闭备注',
  `goods_take_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '搭配商品领取码',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4569 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_order
-- ----------------------------
DROP TABLE IF EXISTS `j_member_order`;
CREATE TABLE `j_member_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NULL DEFAULT NULL,
  `venue_id` int(64) NULL DEFAULT NULL COMMENT '场馆id',
  `sport_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运动项目id',
  `cost` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '应付费用,包括调价和服务费',
  `discount_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠费用',
  `deducted_card_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '专项卡抵扣类型(2011储值卡,2012储值专项,202次卡)',
  `deducted_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '专项卡已抵扣金额',
  `share_deducted_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '分摊剩余抵扣金额',
  `pay_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '实付费用=应付费用-优惠',
  `service_charge` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `order_num` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `trade_no` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第三方支付订单号',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态 ：\r\n（订场/游泳票）订单状态取值:0:待支付 2:已支付,待使用  3:未支付,支付超时 4:已支付已使用待评价  5.已支付未使用已过期  6:已退款  7:已评价 8:用户取消订单\r\n\r\n（商品/演艺票/赛事票）订单状态取值: 30：已下单待支付，31：已取消，32：支付超时，33：已支付待发货，34：已支付待自取，35：已发货待收货，36：已收货待评价，37：已取票待评价，38：退款中，39：退款成功，40：退款失败，41：已完成，42：关闭订单',
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '类型 1_套餐2_订场 3 游泳票 4商品 5演艺 6赛事 7（自营）演艺周边 8（自营）赛事周边 9（自营）其他商品 10找课程',
  `pay_way` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付方式   1、支付宝   2、微信 3、小程序',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `order_time` timestamp NULL DEFAULT NULL COMMENT '订场时间, 向后台发起请求并且订场成功',
  `pay_param` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '阿里支付参数',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `used_points` int(11) NULL DEFAULT NULL COMMENT '使用积分',
  `consignee` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `consignee_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省id',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市id',
  `area_id` int(11) NULL DEFAULT NULL COMMENT '区id',
  `pca_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省市区名称',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人地址',
  `id_card` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份證',
  `is_pay` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已支付',
  `is_refund` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已退款',
  `is_send` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已发货',
  `take_way` int(11) NULL DEFAULT 0 COMMENT '获取方式（0：快递，1：自取，2：电子票）',
  `take_address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自取地址',
  `status_time` timestamp NULL DEFAULT NULL COMMENT '状态时间',
  `sys_remark` varchar(3000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '（后台）订单备注',
  `handle` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已经统计过报表',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id(当为全国时为0)',
  `commission` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '手续费',
  `channel_discount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '渠道优惠',
  `j_merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `j_merchant_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '商户号',
  `asyn_division_flag` tinyint(1) NULL DEFAULT 0 COMMENT '0.无需异步分账 1.需要异步分账',
  `asyn_sure` tinyint(1) NULL DEFAULT NULL COMMENT '0.未确认异步分账 1.已确认异步分账',
  `is_new` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0.旧订单  1.新订单',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9801 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '我的套餐' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_platform_activity_goods
-- ----------------------------
DROP TABLE IF EXISTS `j_platform_activity_goods`;
CREATE TABLE `j_platform_activity_goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `mall_goods_id` int(11) NULL DEFAULT 0 COMMENT '商超商品id',
  `mall_goods_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '商品名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 467 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名关联商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_platform_activity_gift_bag
-- ----------------------------
DROP TABLE IF EXISTS `j_platform_activity_gift_bag`;
CREATE TABLE `j_platform_activity_gift_bag`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `gift_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '礼包名称',
  `gift_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '礼包单价',
  `gift_pic_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '图片地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 261 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名关联礼包' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_platform_activity_bonus
-- ----------------------------
DROP TABLE IF EXISTS `j_platform_activity_bonus`;
CREATE TABLE `j_platform_activity_bonus`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `bonus_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '奖品类型',
  `bonus_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '奖品名称',
  `bonus_id` int(10) NULL DEFAULT 0 COMMENT '奖品id',
  `bonus_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '奖品价值',
  `bonus_count` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '奖品数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 80 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名关联奖品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_activity_merchant_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_activity_merchant_ref`;
CREATE TABLE `j_activity_merchant_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `activity_id` int(11) NOT NULL COMMENT '活动id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 221 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_guanjia
-- ----------------------------
DROP TABLE IF EXISTS `j_order_guanjia`;
CREATE TABLE `j_order_guanjia`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单类型',
  `status` int(11) NULL DEFAULT NULL COMMENT '订单状态',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '馆佳订单号',
  `is_give_points` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已送过积分',
  `user_id` int(11) NOT NULL COMMENT '下单用户id',
  `coupon_id` bigint(11) NULL DEFAULT NULL COMMENT '优惠券id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5965 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '馆佳的订单记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_coupon
-- ----------------------------
DROP TABLE IF EXISTS `j_coupon`;
CREATE TABLE `j_coupon`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code_id` int(11) NOT NULL COMMENT '优惠码id',
  `rec_type` tinyint(4) NULL DEFAULT 0 COMMENT '领取方式1.注册 2.积分兑换 3.发老用户 4.金服注册赠送 5.自定义发放',
  `scene_type` tinyint(4) NULL DEFAULT NULL COMMENT '适用范围 0.全场通用 1.订场售票',
  `use_type` tinyint(4) NULL DEFAULT 0 COMMENT '使用场景 未使用_0,订场_2,游泳票_3,渠道商品订单_4,演艺票订单_5,赛事票订单_6',
  `full_cut_price` decimal(7, 2) NULL DEFAULT NULL COMMENT '满减',
  `price` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '金额',
  `start_time` datetime NULL DEFAULT NULL COMMENT '优惠券有效开始时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '优惠券的有效结束时间',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态  1：未使用 2：已使用',
  `user_id` int(11) NOT NULL COMMENT '会员id',
  `is_pop` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否需要弹窗提示 1:需要',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '已读状态1为已读',
  `prize_record_id` int(11) NULL DEFAULT NULL COMMENT '奖品发放记录id',
  `discount` decimal(7, 2) NULL DEFAULT NULL COMMENT '折扣',
  `couponCodeType` int(10) NULL DEFAULT 1 COMMENT '优惠券类型',
  `userange` int(10) NULL DEFAULT 0 COMMENT '使用范围',
  `grantId` int(10) NOT NULL DEFAULT 1 COMMENT '优惠券发放id',
  `combinationId` int(10) NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 455484 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_visa_sub_order
-- ----------------------------
DROP TABLE IF EXISTS `j_visa_sub_order`;
CREATE TABLE `j_visa_sub_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `m_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '子商户号',
  `sub_order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '子订单号',
  `total_amount` decimal(11, 2) NOT NULL COMMENT '子商户分账金额',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 270 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_card_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_order_card_ref`;
CREATE TABLE `j_order_card_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_card_id` int(11) NOT NULL COMMENT '用户卡id',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0.未支付 1.已支付',
  `type` int(11) NOT NULL COMMENT '0.充值,1.续费',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_time_card
-- ----------------------------
DROP TABLE IF EXISTS `j_member_time_card`;
CREATE TABLE `j_member_time_card`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `card_id` int(11) NOT NULL COMMENT '闲时卡售卖id',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '卡状态 0_待激活 1_已激活 2_已过期',
  `expire_time` datetime NOT NULL COMMENT '卡过期时间',
  `stime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '可用时段开始时间',
  `etime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '可用时段结束时间',
  `type` int(11) NOT NULL COMMENT '卡类型',
  `limit_num` int(11) NOT NULL COMMENT '单日使用限制次数',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `discount_time` decimal(10, 2) NOT NULL COMMENT '单次使用可抵扣最大时长',
  `card_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '卡名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for lesson_spec_ref
-- ----------------------------
DROP TABLE IF EXISTS `lesson_spec_ref`;
CREATE TABLE `lesson_spec_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lesson_id` int(11) NOT NULL COMMENT '商品id',
  `spec_id` int(11) NOT NULL COMMENT '（一级）规格id',
  `spec_names` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '二级规格名称集',
  `spec_ids` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '二级规格id集（程序生成）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程规格关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for lesson_sku
-- ----------------------------
DROP TABLE IF EXISTS `lesson_sku`;
CREATE TABLE `lesson_sku`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku_names` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'sku组合名称(二级规格名称)：黑色,XL',
  `sku_keys` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'sku组合key(二级规格id集)',
  `lesson_id` int(11) NOT NULL COMMENT '课程id',
  `num` int(11) NOT NULL DEFAULT 0 COMMENT '数量',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `sell_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '售价',
  `base_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程sku表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for lesson_base_ref
-- ----------------------------
DROP TABLE IF EXISTS `lesson_base_ref`;
CREATE TABLE `lesson_base_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lesson_id` int(11) NULL DEFAULT NULL,
  `base_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 227 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程基地关联' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for lesson
-- ----------------------------
DROP TABLE IF EXISTS `lesson`;
CREATE TABLE `lesson`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程标题',
  `small_pic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小图',
  `imgs` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '轮播图（多张）',
  `brand_id` int(11) NULL DEFAULT NULL COMMENT '课程品牌id',
  `type_id` int(11) NULL DEFAULT NULL COMMENT '课程分类id',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '课程介绍',
  `coach_des` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '教练介绍',
  `highest_sprice` decimal(8, 2) NULL DEFAULT NULL COMMENT '最高售价',
  `highest_oprice` decimal(8, 2) NULL DEFAULT NULL COMMENT '最高原价',
  `lowest_sprice` decimal(8, 2) NULL DEFAULT NULL COMMENT '最高售价',
  `lowest_oprice` decimal(8, 2) NULL DEFAULT NULL COMMENT '最低售价价',
  `is_top` int(255) NULL DEFAULT NULL COMMENT '是否置顶 0：否 1：是',
  `status` int(11) NULL DEFAULT NULL COMMENT '0：删除 1：待上线  2：上线 3：下线',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_combination
-- ----------------------------
DROP TABLE IF EXISTS `coupon_combination`;
CREATE TABLE `coupon_combination`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(2) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `reType` int(2) NULL DEFAULT NULL,
  `reSource` int(2) NULL DEFAULT NULL,
  `res_time` datetime NULL DEFAULT NULL,
  `re_time` datetime NULL DEFAULT NULL,
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `bgName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `scenetype` int(2) NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_grant
-- ----------------------------
DROP TABLE IF EXISTS `coupon_grant`;
CREATE TABLE `coupon_grant`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `couponId` int(10) NOT NULL COMMENT '优惠券id',
  `sceneType` int(1) NOT NULL COMMENT '发放场景',
  `status` int(1) NOT NULL COMMENT '0_禁用，1_启用',
  `createTime` datetime NOT NULL COMMENT '创建时间',
  `createUser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `updateUser` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `updateTime` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `coupon_startTime` datetime NULL DEFAULT NULL COMMENT '优惠券有效开始时间',
  `coupon_endTime` datetime NULL DEFAULT NULL COMMENT '优惠券有效结束时间',
  `transaction_type` int(10) NULL DEFAULT NULL COMMENT '交易类型,1_全部交易，2_场馆交易,3_商城交易，4_票务交易，5_活动交易,6_培训交易',
  `share_num` int(10) NULL DEFAULT NULL COMMENT '每次交易分享个数',
  `user_startTime` datetime NULL DEFAULT NULL COMMENT '用户注册开始时间',
  `user_endTime` datetime NULL DEFAULT NULL COMMENT '用户注册结束时间',
  `user_range` int(10) NULL DEFAULT NULL COMMENT '用户注册渠道1_全部，2_小程序，3_IOS,4_Android,5_其它',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `user_type` int(10) NULL DEFAULT 3 COMMENT '用户范围 1.全部 2.按注册时间和注册渠道 3.按导入名单',
  `bgId` int(11) NULL DEFAULT NULL COMMENT '礼包id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 529 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_combination_ref
-- ----------------------------
DROP TABLE IF EXISTS `coupon_combination_ref`;
CREATE TABLE `coupon_combination_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` datetime NULL DEFAULT NULL,
  `end_time` datetime NULL DEFAULT NULL,
  `typeDes` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rangeDes` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `type` int(2) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `codeId` int(10) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 88 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_base_user
-- ----------------------------
DROP TABLE IF EXISTS `t_s_base_user`;
CREATE TABLE `t_s_base_user`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `activitiSync` smallint(6) NULL DEFAULT NULL,
  `browser` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `realname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `signature` blob NULL,
  `status` smallint(6) NULL DEFAULT NULL,
  `userkey` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `username` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `departid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `delete_flag` smallint(6) NULL DEFAULT NULL COMMENT '删除状态',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `FK_15jh1g4iem1857546ggor42et`(`departid`) USING BTREE,
  INDEX `index_login`(`password`, `username`) USING BTREE,
  INDEX `idx_deleteflg`(`delete_flag`) USING BTREE,
  CONSTRAINT `t_s_base_user_ibfk_1` FOREIGN KEY (`departid`) REFERENCES `t_s_depart` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_member_report
-- ----------------------------
DROP TABLE IF EXISTS `t_member_report`;
CREATE TABLE `t_member_report`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_count` bigint(20) NOT NULL COMMENT '会员总数',
  `report_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日期',
  `report_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_section_item
-- ----------------------------
DROP TABLE IF EXISTS `j_section_item`;
CREATE TABLE `j_section_item`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `s_title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '副标题',
  `sec_id` int(11) NOT NULL,
  `img` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  `label` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `to_type` int(4) NULL DEFAULT NULL COMMENT '跳转类型  1.文章  2.列表 3.h5跳转',
  `to_param` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '跳转参数',
  `position_order` tinyint(4) NULL DEFAULT 0 COMMENT '排序',
  `start_time` datetime NULL DEFAULT NULL COMMENT '有效开始日期',
  `end_time` datetime NULL DEFAULT NULL COMMENT '有效结束日期',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态  0.禁用 1.启用',
  `update_name` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `create_name` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `goodsTitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '分区大标题',
  `tag_img` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签图片',
  `tag_color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '副标题颜色',
  `tag_img_status` int(1) NULL DEFAULT NULL,
  `goodsTitleTagColor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `goodsTitleTag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 261 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版块项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_advert
-- ----------------------------
DROP TABLE IF EXISTS `j_order_advert`;
CREATE TABLE `j_order_advert`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告名称',
  `type` int(11) NOT NULL COMMENT '交易类型',
  `show_start_time` datetime NOT NULL COMMENT '显示开始时间',
  `show_end_time` datetime NOT NULL COMMENT '显示结束时间',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0.上线 1.删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `user_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_advert_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_advert_ref`;
CREATE TABLE `j_advert_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '名称',
  `t_id` int(11) NOT NULL COMMENT '配置id',
  `type` int(11) NOT NULL COMMENT '1.商品 2.场馆 3.活动 4.banner',
  `advert_id` int(11) NOT NULL COMMENT '广告位id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_coupon
-- ----------------------------
DROP TABLE IF EXISTS `j_order_coupon`;
CREATE TABLE `j_order_coupon`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `coupon_id` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 692 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_sport
-- ----------------------------
DROP TABLE IF EXISTS `j_sport`;
CREATE TABLE `j_sport`  (
  `id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'uuid',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '1_上线,2下线',
  `icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `sort_num` int(11) NOT NULL DEFAULT 100 COMMENT '排序号',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_b` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是B端的运动类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '运动项目类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_coupon_recive_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_coupon_recive_ref`;
CREATE TABLE `j_coupon_recive_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `recive_id` int(11) NOT NULL COMMENT '领券id',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 264 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_coupon_recive
-- ----------------------------
DROP TABLE IF EXISTS `j_coupon_recive`;
CREATE TABLE `j_coupon_recive`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `coupon_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '优惠方式',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '状态0.上架 1.下架',
  `coupon_range` int(1) NOT NULL DEFAULT 0 COMMENT '优惠券使用范围',
  `coupon_start_time` datetime NULL DEFAULT NULL COMMENT '优惠券有效开始时间',
  `coupon_end_time` datetime NOT NULL COMMENT '优惠券有效结束时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '编辑人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `coupon_id` int(11) NOT NULL COMMENT '优惠券id',
  `coupon_num` int(11) NOT NULL COMMENT '优惠券发放数量',
  `recive_num` int(11) NOT NULL DEFAULT 0 COMMENT '领取数量',
  `grant_id` int(11) NOT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_ticket_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_ticket_statistics`;
CREATE TABLE `j_ticket_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL COMMENT '赛事演绎票id',
  `ticket_type` int(11) NOT NULL DEFAULT 0 COMMENT '0_赛事，1_演绎',
  `ticket_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '赛事演绎票名',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tag2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 358 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_activityGoods_stock
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_activityGoods_stock`;
CREATE TABLE `j_venue_activityGoods_stock`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `activityGoodsId` int(11) NOT NULL COMMENT '免费票商品id',
  `type` int(11) NOT NULL COMMENT '免费票类型',
  `stock` int(11) NOT NULL COMMENT '免费票类型库存',
  `activity_stock` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 204 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_activity_goods
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_activity_goods`;
CREATE TABLE `j_venue_activity_goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `type` int(11) NULL DEFAULT NULL COMMENT '商品类型',
  `activity_id` int(11) NULL DEFAULT NULL COMMENT '活动id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `storege_num` int(11) NULL DEFAULT NULL COMMENT '库存数量',
  `time_type` int(11) NULL DEFAULT NULL COMMENT '时间类型 1：时间段 2：重复时间',
  `sell_week_day` int(11) NULL DEFAULT NULL COMMENT '可售星期天数',
  `sell_start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '可售开始时间',
  `sell_end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '可售结束时间',
  `refresh_storage_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '库存刷新时间',
  `avail_stock` int(11) NULL DEFAULT NULL COMMENT '可售库存',
  `use_week_day` int(11) NULL DEFAULT NULL COMMENT '可用星期天数',
  `use_start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '可用开始时间',
  `use_end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '可用结束时间',
  `create_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 0：禁用，1：启用，2：假删除',
  `goods_type` int(2) NULL DEFAULT NULL COMMENT '商品类型（1、普通商品，2、积分）',
  `integral_num` int(10) NULL DEFAULT NULL COMMENT '送积分数',
  `prize_rate` float(10, 4) NULL DEFAULT NULL COMMENT '中奖概率',
  `prize_show` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中奖提示',
  `goods_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `ticket_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '免费票类型',
  `rec_limit` int(11) NOT NULL DEFAULT 1 COMMENT '领取限制 1:一周一次 2：一天一次',
  `sport_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '运动类型id',
  `merchant_id_from` int(11) NULL DEFAULT NULL,
  `hidden_stock` int(11) NOT NULL DEFAULT 0 COMMENT '是否隐藏库存 0.显示 1.隐藏',
  `is_subscribe` int(11) NOT NULL DEFAULT 0 COMMENT '0.非预约 1.预约',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 290 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '场馆活动商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_activity
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_activity`;
CREATE TABLE `j_venue_activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动名称',
  `venue_parent_id` int(11) NULL DEFAULT NULL COMMENT '母馆id',
  `start_time` datetime NULL DEFAULT NULL COMMENT '活动开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '活动结束时间',
  `introduction` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '介绍',
  `list_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列表图片',
  `content_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '内容图片',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 0：禁用，1：启用，2：假删除',
  `create_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `act_type` int(2) NULL DEFAULT 1 COMMENT '活动类型(1.免费票，2.幸运抽奖,3-积分抽奖)',
  `introduction_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动介绍图片',
  `merchant_id` int(11) NULL DEFAULT NULL,
  `merchant_id_from` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 177 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '场馆活动' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_check_user
-- ----------------------------
DROP TABLE IF EXISTS `j_check_user`;
CREATE TABLE `j_check_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login_phone` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录手机',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录密码',
  `real_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '真实名称',
  `type_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型名称',
  `is_admin` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否管理员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_mall_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_mall_statistics`;
CREATE TABLE `j_mall_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) NOT NULL COMMENT '分类id',
  `type_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `goods_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tag2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 497 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_upload_file_return
-- ----------------------------
DROP TABLE IF EXISTS `j_upload_file_return`;
CREATE TABLE `j_upload_file_return`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `file_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件名',
  `is_return` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0.未回盘 1.已回盘',
  `upload_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '上传时间',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_settlement_report
-- ----------------------------
DROP TABLE IF EXISTS `j_settlement_report`;
CREATE TABLE `j_settlement_report`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_group_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商户集团编号',
  `enterprise_user_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '企业用户号',
  `payee_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '收款人名称',
  `bank_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '开户行名称',
  `bank_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '开户行行号',
  `card_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '开户行账号',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `union_merchant_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '银联商户号',
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '订单类目',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名称',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户手机号',
  `status_time` datetime NOT NULL COMMENT '订单完成时间',
  `order_amount` decimal(10, 2) NOT NULL COMMENT '订单金额',
  `merchant_discount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '商户优惠',
  `landlord_discount` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '平台优惠',
  `channel_discount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付渠道优惠',
  `deducted_amount` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '抵扣金额',
  `deducted_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '抵扣方式',
  `pay_amount` decimal(11, 2) NOT NULL COMMENT '实收金额',
  `third_trade_fee` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '第三方交易手续费',
  `commission_amount` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '平台服务费',
  `settlement_amount` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '结算金额',
  `share_amount` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '佳兆业分润金额',
  `pay_way` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '支付方式',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0.银联待结算 1.银联结算中 2.银联结算成功 3.结算失败 4.结算前退款',
  `order_time` datetime NOT NULL COMMENT '下单时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `settlement_date` datetime NOT NULL COMMENT '结算日期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `union_merchant_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '银联商户名称',
  `union_merchant_id` int(11) NOT NULL DEFAULT 0 COMMENT '0.一起吗线上默认商户',
  `share_status` int(1) NOT NULL DEFAULT 0 COMMENT '分润状态 0.待结算 1.结算中 2.结算成功 3.结算失败 4.结算前退款',
  `order_status` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '订单状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_prize_detail
-- ----------------------------
DROP TABLE IF EXISTS `user_prize_detail`;
CREATE TABLE `user_prize_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户抽奖详情id',
  `user_id` int(20) NULL DEFAULT NULL COMMENT '用户id',
  `goods_id` int(10) NULL DEFAULT NULL COMMENT '商品id',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联订单号',
  `op_time` datetime NULL DEFAULT NULL COMMENT '抽奖时间',
  `is_prize` int(2) NULL DEFAULT NULL COMMENT '抽奖情况（1.未中奖，2.中奖）',
  `activity_id` int(11) NULL DEFAULT NULL COMMENT '抽奖活动id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12614 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_points_records
-- ----------------------------
DROP TABLE IF EXISTS `j_points_records`;
CREATE TABLE `j_points_records`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号',
  `points` bigint(11) NULL DEFAULT NULL COMMENT '积分值',
  `record_time` datetime NULL DEFAULT NULL COMMENT '记录时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `platform` int(11) NULL DEFAULT NULL COMMENT '0-一起吗 1-馆佳 2-乐火',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `merchant_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户名称',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场馆名称',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `unique_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '唯一识别id（如订单id，与此确保不会重复增加积分）',
  `goods_amount` decimal(11, 2) NULL DEFAULT NULL,
  `goods_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `goods_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `send_success` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否推送成功',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `send_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '推送结果',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27400 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员积分（获取和消费）记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_merchant_item_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_merchant_item_ref`;
CREATE TABLE `j_merchant_item_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `merchant_id` int(11) NOT NULL COMMENT '站点id',
  `item_id` int(11) NOT NULL COMMENT '板块id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_draw_goods
-- ----------------------------
DROP TABLE IF EXISTS `j_draw_goods`;
CREATE TABLE `j_draw_goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `draw_id` int(11) NOT NULL COMMENT '活动id',
  `type` int(1) NOT NULL DEFAULT 1 COMMENT '1.商品 2.积分 3.优惠券',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '奖品名称',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '奖品图片',
  `stock` int(11) NULL DEFAULT NULL COMMENT '奖品库存',
  `real_stock` int(11) NULL DEFAULT NULL COMMENT '实时库存',
  `probability` decimal(17, 16) NOT NULL COMMENT '中奖概率',
  `point` int(11) NULL DEFAULT NULL COMMENT '积分',
  `coupon_id` int(11) NULL DEFAULT NULL COMMENT '优惠券id',
  `grant_id` int(11) NULL DEFAULT NULL COMMENT '优惠券发放id',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0.上线 1.删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `j_member_order_refund`;
CREATE TABLE `j_member_order_refund`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `pay_way` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式',
  `refund_order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款单号',
  `refund_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退款人',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_trade_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方退款流水号',
  `refund_amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `refund_type` int(11) NULL DEFAULT NULL COMMENT '退款方式 1原渠道退回',
  `refund_response` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方返回响应',
  `refund_param` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款参数',
  `is_success` tinyint(1) NULL DEFAULT NULL COMMENT '是否成功',
  `fail_reason` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '失败原因',
  `refund_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款备注',
  `status` int(11) NULL DEFAULT 0 COMMENT '0：待审核，1：同意，2，拒绝',
  `check_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人员',
  `check_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `refuse_reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `sup_is_refund` int(11) NULL DEFAULT NULL COMMENT '是否收到商户退款 0：否，1：是',
  `sup_refund_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '商户退款金额',
  `is_only_goods` tinyint(1) NULL DEFAULT 0 COMMENT '是否只退搭配',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `key.order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 172503 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_pay_log
-- ----------------------------
DROP TABLE IF EXISTS `j_pay_log`;
CREATE TABLE `j_pay_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `refund_order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退单号',
  `pay_way` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '金额',
  `type` int(11) NULL DEFAULT NULL COMMENT '1：付款 2：退款',
  `trade_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方流水号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1864 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '第三方交易流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_m_goods
-- ----------------------------
DROP TABLE IF EXISTS `j_order_m_goods`;
CREATE TABLE `j_order_m_goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `goods_id` int(11) NULL DEFAULT NULL COMMENT '商品id',
  `goods_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `sku_id` int(11) NULL DEFAULT NULL,
  `sku_info` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格组合',
  `sell_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '售价',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `service_charge` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `goods_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  `goods_num` int(11) NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 1：已下单，2：已取消，3：退款中，4：退款失败，5：退款成功',
  `took` int(11) NOT NULL DEFAULT 0 COMMENT '是否已取票 0未取 1已取',
  `is_elec_ticket` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为电子票',
  `take_time` datetime NULL DEFAULT NULL COMMENT '取票时间',
  `take_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '领取备注',
  `check_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '核发人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ORDER_NUM_INDEX`(`order_num`) USING BTREE,
  INDEX `GOODS_ID_INDEX`(`goods_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1995 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户（商城）订单商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_m_elec_ticket
-- ----------------------------
DROP TABLE IF EXISTS `j_order_m_elec_ticket`;
CREATE TABLE `j_order_m_elec_ticket`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `order_goods_id` int(11) NULL DEFAULT NULL COMMENT '商城订单物品id',
  `goods_id` int(11) NULL DEFAULT NULL COMMENT '商城商品id',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '订单号',
  `ticket_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `ticket_num` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '票码',
  `random_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '随机码',
  `ticket_use_condition` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '票限制条件',
  `ticket_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `checked_user_id` int(11) NULL DEFAULT NULL COMMENT '核销端用户id',
  `checked_user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '核销人名称',
  `checked_time` datetime NULL DEFAULT NULL,
  `generate_id` int(11) NULL DEFAULT NULL COMMENT '手动生成id',
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '是否已读',
  `is_generate` tinyint(1) NULL DEFAULT 0 COMMENT '是否手动生成',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ORDER_NUM_INDEX`(`order_num`) USING BTREE,
  INDEX `TICKET_NUM_INDEX`(`ticket_num`) USING BTREE,
  INDEX `TAKS_STATUS`(`ticket_status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13581 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_btp
-- ----------------------------
DROP TABLE IF EXISTS `j_order_btp`;
CREATE TABLE `j_order_btp`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `btp_id` int(11) NULL DEFAULT NULL COMMENT '购票人id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单购票人关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for theatre_sale_channel
-- ----------------------------
DROP TABLE IF EXISTS `theatre_sale_channel`;
CREATE TABLE `theatre_sale_channel`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '分享者id',
  `phone` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分享者手机号',
  `venue_id` int(11) NULL DEFAULT NULL,
  `item_id` int(11) NOT NULL COMMENT '项目id',
  `item_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '项目名',
  `wxacode` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '小程序码',
  `source` int(11) NULL DEFAULT NULL COMMENT '来源，1-一起吗 2-剧院小程序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '剧场票务-分销' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for theatre_sale_channel_detail
-- ----------------------------
DROP TABLE IF EXISTS `theatre_sale_channel_detail`;
CREATE TABLE `theatre_sale_channel_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `channel_user_phone` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分享者手机号',
  `channel_source` int(11) NULL DEFAULT NULL,
  `venue_id` int(11) NULL DEFAULT NULL,
  `item_id` int(11) NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '项目名称',
  `sell_id` int(11) NULL DEFAULT NULL COMMENT '场次id',
  `sell_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sell_start_time` datetime NULL DEFAULT NULL COMMENT '场次开始时间',
  `sell_end_time` datetime NULL DEFAULT NULL COMMENT '场次结束时间',
  `order_user_phone` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '下单用户手机号',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `goods_num` int(11) NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL COMMENT '订单状态',
  `order_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '订单金额',
  `pay_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '支付金额',
  `commission_ratio` int(11) NULL DEFAULT NULL COMMENT '佣金比例',
  `commission_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '佣金金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '剧场票务-场次表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for j_member_black_list
-- ----------------------------
DROP TABLE IF EXISTS `j_member_black_list`;
CREATE TABLE `j_member_black_list`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `delete_time` datetime NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_member_id`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户答题记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_function
-- ----------------------------
DROP TABLE IF EXISTS `t_s_function`;
CREATE TABLE `t_s_function`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `functioniframe` smallint(6) NULL DEFAULT NULL,
  `functionlevel` smallint(6) NULL DEFAULT NULL,
  `functionname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `functionorder` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `functionurl` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `parentfunctionid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `iconid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `desk_iconid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `functiontype` smallint(6) NULL DEFAULT NULL,
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人id',
  `create_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人id',
  `update_date` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `FK_brd7b3keorj8pmxcv8bpahnxp`(`parentfunctionid`) USING BTREE,
  INDEX `FK_q5tqo3v4ltsp1pehdxd59rccx`(`iconid`) USING BTREE,
  INDEX `FK_gbdacaoju6d5u53rp4jo4rbs9`(`desk_iconid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for zoningimg
-- ----------------------------
DROP TABLE IF EXISTS `zoningimg`;
CREATE TABLE `zoningimg`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `type` int(10) NOT NULL COMMENT '类型',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备注名称',
  `img_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '缩略图片地址',
  `status` int(10) NOT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for team_people
-- ----------------------------
DROP TABLE IF EXISTS `team_people`;
CREATE TABLE `team_people`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `userid` int(10) NOT NULL COMMENT '参与用户id',
  `payStatus` int(1) NOT NULL COMMENT '支付状态0_待支付，1_已支付，2_已支付成团，3_退款中，4_退款成功，5_支付超时,6.用户取消支付',
  `orderNum` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `createTime` datetime NOT NULL COMMENT '参与时间',
  `teamid` int(10) NOT NULL COMMENT '团id',
  `updateTime` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 482 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for team_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `team_goods_sku`;
CREATE TABLE `team_goods_sku`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '表主键',
  `goods_team_id` int(11) NULL DEFAULT 0 COMMENT '拼团商品id',
  `activity_stock` int(11) NULL DEFAULT 0 COMMENT '拼团库存',
  `team_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '拼团价格',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品id',
  `sku_id` int(11) NULL DEFAULT 0 COMMENT 'skuid',
  `original_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '原价',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '拼团商品规格信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for team_detail
-- ----------------------------
DROP TABLE IF EXISTS `team_detail`;
CREATE TABLE `team_detail`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `goods_teamid` int(10) NOT NULL COMMENT '拼团id',
  `userid` int(10) NOT NULL COMMENT '发起人id',
  `shareNum` int(10) NOT NULL COMMENT '分享次数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `status` int(1) NOT NULL COMMENT '拼团状态(0：拼团中，1：已成团，2：失败)，3，未支付',
  `joinNum` int(10) NULL DEFAULT 1 COMMENT '参团人数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 388 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_venue_repository
-- ----------------------------
DROP TABLE IF EXISTS `t_venue_repository`;
CREATE TABLE `t_venue_repository`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `jzy_venue_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '老B端场馆ID',
  `venue_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '场馆名',
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '场馆缩略图',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省id',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市id',
  `district_id` int(11) NULL DEFAULT NULL COMMENT '区id',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `lon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '经度',
  `lat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '纬度',
  `c_status` int(11) NOT NULL DEFAULT 0 COMMENT '是否上线C端 0：下线 1：上线',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '场馆联系电话',
  `is_allow_refund` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否允许退款',
  `is_allow_c_refund` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否允许一起吗发起退款',
  `advance_days` int(11) NULL DEFAULT NULL COMMENT '可提前几天订场',
  `revenue_target` decimal(20, 2) NULL DEFAULT NULL COMMENT '营收目标',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `vip_advance_days` int(11) NULL DEFAULT NULL COMMENT '会员可提前订场天数',
  `advance_type` int(11) NULL DEFAULT 1 COMMENT '线上订场类型，1：不按照每周，2：每周',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '场馆表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_version
-- ----------------------------
DROP TABLE IF EXISTS `t_s_version`;
CREATE TABLE `t_s_version`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `loginpage` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `versioncode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `versionname` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `versionnum` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_user_org
-- ----------------------------
DROP TABLE IF EXISTS `t_s_user_org`;
CREATE TABLE `t_s_user_org`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `org_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `index_user_id`(`user_id`) USING BTREE,
  INDEX `index_org_id`(`org_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_user_city
-- ----------------------------
DROP TABLE IF EXISTS `t_s_user_city`;
CREATE TABLE `t_s_user_city`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `city_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_typegroup
-- ----------------------------
DROP TABLE IF EXISTS `t_s_typegroup`;
CREATE TABLE `t_s_typegroup`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `typegroupcode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `typegroupname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_type
-- ----------------------------
DROP TABLE IF EXISTS `t_s_type`;
CREATE TABLE `t_s_type`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `typecode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `typename` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `typepid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `typegroupid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `FK_nw2b22gy7plh7pqows186odmq`(`typepid`) USING BTREE,
  INDEX `FK_3q40mr4ebtd0cvx79matl39x1`(`typegroupid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_timetask
-- ----------------------------
DROP TABLE IF EXISTS `t_s_timetask`;
CREATE TABLE `t_s_timetask`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CREATE_BY` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `CREATE_DATE` datetime NULL DEFAULT NULL,
  `CREATE_NAME` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `CRON_EXPRESSION` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `IS_EFFECT` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `IS_START` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TASK_DESCRIBE` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TASK_ID` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `UPDATE_BY` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `UPDATE_DATE` datetime NULL DEFAULT NULL,
  `UPDATE_NAME` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_territory
-- ----------------------------
DROP TABLE IF EXISTS `t_s_territory`;
CREATE TABLE `t_s_territory`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `territorycode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `territorylevel` smallint(6) NOT NULL,
  `territoryname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `territory_pinyin` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `territorysort` varchar(3) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `x_wgs84` double NOT NULL,
  `y_wgs84` double NOT NULL,
  `territoryparentid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_sms_template_sql
-- ----------------------------
DROP TABLE IF EXISTS `t_s_sms_template_sql`;
CREATE TABLE `t_s_sms_template_sql`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  `code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '配置CODE',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '配置名称',
  `sql_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务SQLID',
  `template_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '消息模本ID',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建日期',
  `create_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人登录名称',
  `create_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人名称',
  `update_date` datetime NULL DEFAULT NULL COMMENT '更新日期',
  `update_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人登录名称',
  `update_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_sms_template
-- ----------------------------
DROP TABLE IF EXISTS `t_s_sms_template`;
CREATE TABLE `t_s_sms_template`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  `template_type` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '模板类型',
  `template_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '模板名称',
  `template_content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '模板内容',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建日期',
  `create_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人登录名称',
  `create_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人名称',
  `update_date` datetime NULL DEFAULT NULL COMMENT '更新日期',
  `update_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人登录名称',
  `update_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_sms_sql
-- ----------------------------
DROP TABLE IF EXISTS `t_s_sms_sql`;
CREATE TABLE `t_s_sms_sql`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  `sql_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'SQL名称',
  `sql_content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'SQL内容',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建日期',
  `create_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人登录名称',
  `create_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人名称',
  `update_date` datetime NULL DEFAULT NULL COMMENT '更新日期',
  `update_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人登录名称',
  `update_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_sms
-- ----------------------------
DROP TABLE IF EXISTS `t_s_sms`;
CREATE TABLE `t_s_sms`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人名称',
  `create_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人登录名称',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建日期',
  `update_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人名称',
  `update_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人登录名称',
  `update_date` datetime NULL DEFAULT NULL COMMENT '更新日期',
  `es_title` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '消息标题',
  `es_type` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '消息类型',
  `es_sender` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发送人',
  `es_receiver` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接收人',
  `es_content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容',
  `es_sendtime` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `es_status` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发送状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_role_user
-- ----------------------------
DROP TABLE IF EXISTS `t_s_role_user`;
CREATE TABLE `t_s_role_user`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `roleid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `userid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `FK_n2ucxeorvpjy7qhnmuem01kbx`(`roleid`) USING BTREE,
  INDEX `FK_d4qb5xld2pfb0bkjx9iwtolda`(`userid`) USING BTREE,
  CONSTRAINT `t_s_role_user_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `t_s_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `t_s_role_user_ibfk_2` FOREIGN KEY (`roleid`) REFERENCES `t_s_role` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_role_org
-- ----------------------------
DROP TABLE IF EXISTS `t_s_role_org`;
CREATE TABLE `t_s_role_org`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `org_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `role_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_role_function
-- ----------------------------
DROP TABLE IF EXISTS `t_s_role_function`;
CREATE TABLE `t_s_role_function`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `operation` varchar(10000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `functionid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `roleid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `datarule` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `FK_fvsillj2cxyk5thnuu625urab`(`functionid`) USING BTREE,
  INDEX `FK_9dww3p4w8jwvlrgwhpitsbfif`(`roleid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_role
-- ----------------------------
DROP TABLE IF EXISTS `t_s_role`;
CREATE TABLE `t_s_role`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `rolecode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rolename` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `update_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_date` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人id',
  `create_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人id',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_operation
-- ----------------------------
DROP TABLE IF EXISTS `t_s_operation`;
CREATE TABLE `t_s_operation`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `operationcode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `operationicon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `operationname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` smallint(6) NULL DEFAULT NULL,
  `functionid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `iconid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `operationtype` smallint(6) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `FK_pceuy41wr2fjbcilyc7mk3m1f`(`functionid`) USING BTREE,
  INDEX `FK_ny5de7922l39ta2pkhyspd5f`(`iconid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_notice_read_user
-- ----------------------------
DROP TABLE IF EXISTS `t_s_notice_read_user`;
CREATE TABLE `t_s_notice_read_user`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'ID',
  `notice_id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通告ID',
  `user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通告已读用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_notice_authority_user
-- ----------------------------
DROP TABLE IF EXISTS `t_s_notice_authority_user`;
CREATE TABLE `t_s_notice_authority_user`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'ID',
  `notice_id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通告ID',
  `user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '授权用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通告授权用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_notice_authority_role
-- ----------------------------
DROP TABLE IF EXISTS `t_s_notice_authority_role`;
CREATE TABLE `t_s_notice_authority_role`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'ID',
  `notice_id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通告ID',
  `role_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '授权角色ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通告授权角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_notice
-- ----------------------------
DROP TABLE IF EXISTS `t_s_notice`;
CREATE TABLE `t_s_notice`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'ID',
  `notice_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通知标题',
  `notice_content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '通知公告内容',
  `notice_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通知公告类型（1：通知，2:公告）',
  `notice_level` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通告授权级别（1:全员，2：角色，3：用户）',
  `notice_term` datetime NULL DEFAULT NULL COMMENT '阅读期限',
  `create_user` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_muti_lang
-- ----------------------------
DROP TABLE IF EXISTS `t_s_muti_lang`;
CREATE TABLE `t_s_muti_lang`  (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  `lang_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '语言主键',
  `lang_context` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '内容',
  `lang_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '语言',
  `create_date` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人编号',
  `create_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人姓名',
  `update_date` datetime NULL DEFAULT NULL COMMENT '更新日期',
  `update_by` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人编号',
  `update_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_langkey_langcode`(`lang_key`, `lang_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_icon
-- ----------------------------
DROP TABLE IF EXISTS `t_s_icon`;
CREATE TABLE `t_s_icon`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `extend` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `iconclas` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `content` blob NULL,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `path` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `type` smallint(6) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_depart
-- ----------------------------
DROP TABLE IF EXISTS `t_s_depart`;
CREATE TABLE `t_s_depart`  (
  `ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `departname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `parentdepartid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `org_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `org_type` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mobile` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `fax` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `FK_knnm3wb0bembwvm0il7tf6686`(`parentdepartid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_data_source
-- ----------------------------
DROP TABLE IF EXISTS `t_s_data_source`;
CREATE TABLE `t_s_data_source`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `db_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `driver_class` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `db_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `db_password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `db_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `db_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_s_data_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_s_data_rule`;
CREATE TABLE `t_s_data_rule`  (
  `id` varchar(96) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rule_name` varchar(96) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rule_column` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rule_conditions` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rule_value` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_date` datetime NULL DEFAULT NULL,
  `create_by` varchar(96) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_name` varchar(96) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_date` datetime NULL DEFAULT NULL,
  `update_by` varchar(96) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_name` varchar(96) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `functionId` varchar(96) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_jzy_venue
-- ----------------------------
DROP TABLE IF EXISTS `t_jzy_venue`;
CREATE TABLE `t_jzy_venue`  (
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '场馆编号',
  `venue_name` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆名称',
  `parentdepart_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '归属中心id',
  `parentdepart_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '归属中心',
  `is_indoor` int(3) NULL DEFAULT NULL COMMENT '是否室内馆  1室内  2室外',
  `link_name` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆访问路径',
  `licence` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '营业执照图片',
  `code` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组织机构代码',
  `tax` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '税务登记证',
  `identity_card` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '法人身份证',
  `other_licence` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其他证件',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户编号',
  `responsible_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人姓名',
  `responsible_duties` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人职务',
  `responsible_id_card` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人身份证',
  `operate_licence` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '授权运营书图片',
  `list_id` int(11) NULL DEFAULT NULL COMMENT '排序号',
  `is_close` int(11) NOT NULL DEFAULT 1 COMMENT '是否关闭 1_开启  2_关闭',
  `system_audit_status` int(11) NOT NULL DEFAULT 3 COMMENT '平台审核状态 1_通过  2_未通过  3_待定',
  `parent_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上层组织架构编码',
  `province_id` int(32) NULL DEFAULT NULL COMMENT '省编号',
  `city_id` int(32) NULL DEFAULT NULL COMMENT '城市编号',
  `district_id` int(32) NULL DEFAULT NULL COMMENT '区编号',
  `image` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆图片',
  `address` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆地址',
  `longitude` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆经度',
  `latitude` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆纬度',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `mobile` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `business_type` int(11) NULL DEFAULT NULL COMMENT '业务类型 2订场3售票',
  `max_ticket_num` int(11) NULL DEFAULT 0 COMMENT '最大订票数',
  `expire_days` int(11) NULL DEFAULT 0 COMMENT '游泳有效期(天)',
  `tags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'B端场馆' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for snail_code
-- ----------------------------
DROP TABLE IF EXISTS `snail_code`;
CREATE TABLE `snail_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `goodsId` int(11) NOT NULL COMMENT '商品id',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '票码使用状态0.待售,1.已售待使用',
  `userid` int(10) NULL DEFAULT NULL,
  `orderNum` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '票码',
  `start_time` datetime NOT NULL COMMENT '有效期开售时间',
  `end_time` datetime NOT NULL COMMENT '有效期结束时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备用字段1',
  `tag2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备用字段2',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sh_area
-- ----------------------------
DROP TABLE IF EXISTS `sh_area`;
CREATE TABLE `sh_area`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(11) NULL DEFAULT NULL COMMENT '父id',
  `shortname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '简称',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  `merger_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '全称',
  `level` int(11) NULL DEFAULT NULL COMMENT '层级 0 1 2 省市区县',
  `pinyin` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拼音',
  `code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '长途区号',
  `zip_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮编',
  `first` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '首字母',
  `lng` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经度',
  `lat` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '纬度',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `is_municipality` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否直辖市',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '城市图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3750 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '地区表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_search_topic_relation
-- ----------------------------
DROP TABLE IF EXISTS `s_c_search_topic_relation`;
CREATE TABLE `s_c_search_topic_relation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `topic_id` int(11) NOT NULL COMMENT '话题id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_topicId`(`topic_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户动态搜索话题关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_search_topic
-- ----------------------------
DROP TABLE IF EXISTS `s_c_search_topic`;
CREATE TABLE `s_c_search_topic`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `topic_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '话题名称',
  `topic_remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '话题备注',
  `topic_status` int(11) NOT NULL COMMENT '上架状态(1-上架,2-下架)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编辑用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '搜素话题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_search_record
-- ----------------------------
DROP TABLE IF EXISTS `s_c_search_record`;
CREATE TABLE `s_c_search_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `search_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '搜素内容',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `index_memberId_searchName`(`search_name`, `member_id`) USING BTREE,
  INDEX `index_memberId`(`member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 429 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户搜素记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_uninterest
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_uninterest`;
CREATE TABLE `s_c_note_uninterest`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_memberId`(`member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户不感兴趣动态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_tag_show
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_tag_show`;
CREATE TABLE `s_c_note_tag_show`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tag_id` int(11) NOT NULL COMMENT '标签id',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0.启用 1.禁用',
  `tag_sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `tag_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标签名称',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态标签展示表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_tag_relation
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_tag_relation`;
CREATE TABLE `s_c_note_tag_relation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `tag_id` int(11) NOT NULL COMMENT '标签id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_tagId`(`tag_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10731 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户动态标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_tag_parent_childern
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_tag_parent_childern`;
CREATE TABLE `s_c_note_tag_parent_childern`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `p_id` int(11) NOT NULL COMMENT '父标签id',
  `child_id` int(11) NOT NULL COMMENT '子标签id',
  `status` int(11) NOT NULL COMMENT '0.启用 1.禁用',
  `sort` int(11) NOT NULL DEFAULT 1 COMMENT '排序',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_tag_content
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_tag_content`;
CREATE TABLE `s_c_note_tag_content`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tag_id` int(11) NOT NULL COMMENT '标签id',
  `tag_content` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签内容',
  `sort` int(2) NOT NULL DEFAULT 2 COMMENT '排序',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `add_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编辑用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 611 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态标签内容表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_tag
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_tag`;
CREATE TABLE `s_c_note_tag`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tag_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名称',
  `tag_remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `type` int(11) NOT NULL DEFAULT 0 COMMENT '0.父类  1.子类',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `add_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编辑用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态标签表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_support
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_support`;
CREATE TABLE `s_c_note_support`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `member_id` int(11) NOT NULL COMMENT '点赞用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_noteId`(`note_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1901 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态点赞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_statistics
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_statistics`;
CREATE TABLE `s_c_note_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `statisic_time` datetime NOT NULL COMMENT '统计时间点',
  `click_num` int(11) NOT NULL COMMENT '点击次数',
  `share_num` int(11) NOT NULL COMMENT '分享次数',
  `collect_num` int(11) NOT NULL COMMENT '收藏次数',
  `support_num` int(11) NOT NULL COMMENT '点赞次数',
  `comment_num` int(11) NOT NULL COMMENT '评论回复数',
  `hot_num` int(11) NOT NULL COMMENT '热度值',
  `hot_sum` int(11) NOT NULL COMMENT '总热度值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `index_note_time`(`note_id`, `statisic_time`) USING BTREE,
  INDEX `index_noteId`(`note_id`) USING BTREE,
  INDEX `index_statisicTime`(`statisic_time`) USING BTREE,
  INDEX `index_hot_sum`(`hot_sum`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 96928997 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_report
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_report`;
CREATE TABLE `s_c_note_report`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `report_classify` int(2) NOT NULL COMMENT '举报分类(1-动态,2-评论,3-回复,4-用户)',
  `classify_id` int(11) NOT NULL COMMENT '分类id(动态id或者评论id或者回复id或者用户id)',
  `report_content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `report_member_id` int(11) NOT NULL COMMENT '被举报用户id',
  `report_type` int(2) NOT NULL COMMENT '举报类型(1-广告内容,2-不友善内容,垃圾信息,4-违法违规内容,5-其他)',
  `report_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `report_img` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '举报图片证据',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `deal_status` int(2) NOT NULL COMMENT '处理状态(1-未处理,2-已处理)',
  `deal_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `deal_memo` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理说明',
  `deal_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理人',
  `is_inform` int(2) NOT NULL COMMENT '处理结果是否通知给被举报用户(1-通知,2-不通知)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '动态举报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_relation
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_relation`;
CREATE TABLE `s_c_note_relation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '类型 1.场馆 2.活动 3.演艺 4.赛事 5.商品 6.拼团 7.砍价 8.文章 9.竞猜',
  `relation_id` int(11) NULL DEFAULT NULL COMMENT '管理id',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `bus_type` int(11) NOT NULL DEFAULT 0 COMMENT '0.动态 1.广告',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `r_type_id` int(11) NULL DEFAULT NULL COMMENT '关联类型id',
  `p_venue` tinyint(1) NULL DEFAULT 0 COMMENT '是否母馆',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 576 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_message
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_message`;
CREATE TABLE `s_c_note_message`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `message_type` int(2) NOT NULL COMMENT '消息类型(1-评论动态 2-点赞动态,3-收藏动态,4-回复评论,5-点赞评论,6-回复回复,7-点赞回复,8-关注用户)',
  `message_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `message_type_id` int(11) NULL DEFAULT NULL COMMENT '类型id(评论、回复则为当前类型id,收藏、点赞则为被点赞、被收藏类型id,发起关注用户id)',
  `note_id` int(11) NULL DEFAULT NULL COMMENT '动态id',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片url',
  `comment_id` int(11) NULL DEFAULT NULL COMMENT '被评论id',
  `reply_id` int(11) NULL DEFAULT NULL COMMENT '被回复id',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '用户id(被评论、点赞对象)',
  `from_member_id` int(11) NULL DEFAULT NULL COMMENT '发起用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_read` int(2) NOT NULL DEFAULT 0 COMMENT '是否已读(0-未读,1-已读)',
  `read_id` int(11) NULL DEFAULT NULL COMMENT '读取id(用于已读去重)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_memberId`(`member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6396 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '动态消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_draft
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_draft`;
CREATE TABLE `s_c_note_draft`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '动态内容',
  `imgs` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片(多个用,隔开)',
  `imgs_ratio` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片比例(多个用,隔开)',
  `video` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '视频',
  `venue_id` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆id(多个用,隔开)',
  `venue_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆类型(1-母馆,2-子馆)',
  `longitude` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经度',
  `latitude` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '纬度',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_memberId`(`member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态草稿表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_comment_support
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_comment_support`;
CREATE TABLE `s_c_note_comment_support`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `comment_id` int(11) NOT NULL COMMENT '评论id',
  `member_id` int(11) NOT NULL COMMENT '点赞用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_commentId`(`comment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 263 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态评论点赞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_comment_reply_support
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_comment_reply_support`;
CREATE TABLE `s_c_note_comment_reply_support`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `reply_id` int(11) NOT NULL COMMENT '回复id',
  `member_id` int(11) NOT NULL COMMENT '点赞用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_replyId`(`reply_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态评论回复点赞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_comment_reply
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_comment_reply`;
CREATE TABLE `s_c_note_comment_reply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `comment_id` int(11) NOT NULL COMMENT '评论id',
  `reply_type` int(2) NOT NULL COMMENT '回复类型(1-回复评论,2-回复回复)',
  `to_reply_id` int(11) NOT NULL COMMENT '回复目标id(回复评论为评论id，回复回复为回复父id)',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `to_member_id` int(11) NOT NULL COMMENT '目标用户id',
  `to_nick_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '冗余目标用户昵称',
  `to_is_author` int(2) NOT NULL DEFAULT 0 COMMENT '目标用户是否是作者(1-是,0-不是)',
  `from_member_id` int(11) NOT NULL COMMENT '回复用户id',
  `from_nick_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '冗余回复用户昵称',
  `from_avatar` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '冗余回复用户头像',
  `from_is_author` int(2) NOT NULL DEFAULT 0 COMMENT '是回复用户否是作者(1-是,0-不是)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_commentId`(`comment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 195 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '动态评论回复表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_comment
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_comment`;
CREATE TABLE `s_c_note_comment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `from_member_id` int(11) NOT NULL COMMENT '评论用户id',
  `is_author` int(2) NOT NULL DEFAULT 0 COMMENT '是否是作者(1-是,0-不是)',
  `reply_num` int(11) NOT NULL DEFAULT 1 COMMENT '单条评论下的回复数(默认为1，包含当前评论)',
  `from_nick_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '冗余评论用户昵称',
  `from_avatar` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '冗余评论用户头像',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_noteId`(`note_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1831 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '动态评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_collect
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_collect`;
CREATE TABLE `s_c_note_collect`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `member_id` int(11) NOT NULL COMMENT '收藏用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_memberId`(`member_id`) USING BTREE,
  INDEX `index_noteId`(`note_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 282 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '动态收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_browse
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_browse`;
CREATE TABLE `s_c_note_browse`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `note_id` int(11) NOT NULL COMMENT '动态id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_noteId`(`note_id`) USING BTREE,
  INDEX `index_memberId`(`member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13128 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户浏览动态记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note_advert
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note_advert`;
CREATE TABLE `s_c_note_advert`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '广告id',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告标题',
  `type` int(11) NOT NULL DEFAULT 0 COMMENT '0.图文 1.视频',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '广告封面图片',
  `r_type` int(11) NOT NULL COMMENT '1.场馆 2.活动 3.演艺 4.赛事 5.商品 6.拼团 7.砍价 8.文章 9.竞猜',
  `r_id` int(11) NOT NULL COMMENT '关联id',
  `r_type_id` int(11) NULL DEFAULT NULL COMMENT '关联类型id',
  `tag_p_id` int(11) NOT NULL COMMENT '标签父id',
  `tag_c_id` int(11) NULL DEFAULT NULL COMMENT '关联标签子id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '更新人',
  `status` int(11) NOT NULL COMMENT '0.待发布 1.已发布 2.已屏蔽 3.已删除',
  `is_top` int(11) NOT NULL DEFAULT 0 COMMENT '0.未置顶 1.已置顶',
  `pick_num` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `district_id` int(11) NULL DEFAULT NULL COMMENT '区',
  `video` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '视频',
  `video_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '视频图片',
  `start_time` datetime NULL DEFAULT NULL COMMENT '显示开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '显示结束时间',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '视频内容',
  `p_venue` tinyint(1) NULL DEFAULT 0 COMMENT '是否母馆',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_note
-- ----------------------------
DROP TABLE IF EXISTS `s_c_note`;
CREATE TABLE `s_c_note`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `content_type` int(2) NOT NULL COMMENT '动态类型(1-图片,2-视频)',
  `imgs` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片(多个用,隔开)',
  `imgs_ratio` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片宽高比(多个用,隔开)',
  `video` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '视频',
  `venue_id` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆id(多个用,隔开)',
  `venue_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆类型(0-母馆,1-子馆)',
  `longitude` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经度',
  `latitude` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '纬度',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `content_status` int(2) NOT NULL COMMENT '动态状态(1-正常,2-屏蔽,3-删除)',
  `click_num` int(11) NOT NULL DEFAULT 0 COMMENT '点击数',
  `share_num` int(11) NOT NULL DEFAULT 0 COMMENT '分享数',
  `support_num` int(11) NOT NULL DEFAULT 0 COMMENT '点赞数',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `deal_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `deal_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理用户',
  `recomment_sort` int(2) NULL DEFAULT 0 COMMENT '是否推荐置顶(0-否,1-是)',
  `tag_sort` int(11) NULL DEFAULT 0 COMMENT '是否标签置顶(0-否,其他值-标签id)',
  `recomment_enable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否可以出现在推荐页',
  `recomment_time` datetime NULL DEFAULT NULL COMMENT '推荐置顶时间',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `district_id` int(11) NULL DEFAULT NULL COMMENT '区',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `start_time` datetime NULL DEFAULT NULL COMMENT '显示开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '显示结束时间',
  `tag_p_id` int(11) NULL DEFAULT NULL COMMENT '标签父id',
  `tag_c_id` int(11) NULL DEFAULT NULL COMMENT '关联标签子id',
  `publish_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发布账号',
  `recomment_num` int(11) NULL DEFAULT NULL COMMENT '置顶排序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_memberId`(`member_id`) USING BTREE,
  FULLTEXT INDEX `index_content`(`content`)
) ENGINE = InnoDB AUTO_INCREMENT = 5382 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '社交用户动态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_member_uninterest
-- ----------------------------
DROP TABLE IF EXISTS `s_c_member_uninterest`;
CREATE TABLE `s_c_member_uninterest`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `uninterest_member_id` int(11) NOT NULL COMMENT '不感兴趣会员id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '会员不感兴趣用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_member_follow
-- ----------------------------
DROP TABLE IF EXISTS `s_c_member_follow`;
CREATE TABLE `s_c_member_follow`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_id` int(11) NOT NULL COMMENT '用户id(被关注者)',
  `follow_member_id` int(11) NOT NULL COMMENT '粉丝id',
  `is_mutual` int(2) NOT NULL DEFAULT 2 COMMENT '是否互相关注(1-互相关注,2-单向关注)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `index_member_relation`(`member_id`, `follow_member_id`) USING BTREE,
  INDEX `index_memberId`(`member_id`) USING BTREE,
  INDEX `index_followMemberId`(`follow_member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 843 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户关注表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for s_c_cooperation
-- ----------------------------
DROP TABLE IF EXISTS `s_c_cooperation`;
CREATE TABLE `s_c_cooperation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `contact_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系人名称',
  `contact_tel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系电话',
  `contact_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系地址',
  `contact_content` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合作事宜',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `deal_status` int(2) NOT NULL COMMENT '处理状态(1-未处理,2-已处理)',
  `deal_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `deal_memo` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理说明',
  `deal_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '合作信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for register_activity_user
-- ----------------------------
DROP TABLE IF EXISTS `register_activity_user`;
CREATE TABLE `register_activity_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL COMMENT '用户id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '姓名',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号',
  `register_time` datetime NOT NULL COMMENT '注册时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成任务时间',
  `num` int(11) NOT NULL DEFAULT 0 COMMENT '完成任务数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for p_park_customer
-- ----------------------------
DROP TABLE IF EXISTS `p_park_customer`;
CREATE TABLE `p_park_customer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名称',
  `user_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户手机号',
  `car_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车牌号',
  `is_yellow_car` tinyint(1) NULL DEFAULT NULL COMMENT '是否黄牌车',
  `is_new_enegry` tinyint(1) NULL DEFAULT NULL COMMENT '是否新能源车',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_virtual` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否无牌车生成的虚拟车牌',
  `certificate_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '无牌车生成的凭证号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_phone`(`user_phone`) USING BTREE COMMENT '用户手机号'
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for no_tickets_reg
-- ----------------------------
DROP TABLE IF EXISTS `no_tickets_reg`;
CREATE TABLE `no_tickets_reg`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NULL DEFAULT NULL,
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `reg_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `reg_info` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL COMMENT '0：未处理 1：已发短信',
  `show_merchat_id` int(11) NULL DEFAULT NULL COMMENT '销售站点id',
  `j_merchant_id` int(11) NULL DEFAULT NULL COMMENT '银联商户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '缺票登记' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for member_answer_activity
-- ----------------------------
DROP TABLE IF EXISTS `member_answer_activity`;
CREATE TABLE `member_answer_activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questionId` int(11) NOT NULL,
  `optionId` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `activityId` int(11) NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1432 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_supplier
-- ----------------------------
DROP TABLE IF EXISTS `mall_supplier`;
CREATE TABLE `mall_supplier`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '供应商id',
  `supplier_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商名称',
  `des` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '简述',
  `source` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源',
  `contact_way` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `website` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '网址',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省id',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市id',
  `area_id` int(11) NULL DEFAULT NULL COMMENT '区id',
  `address` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_enable` int(11) NOT NULL DEFAULT 1 COMMENT '状态（0：启用，1禁用）',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '（App）商城供应商' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_spec
-- ----------------------------
DROP TABLE IF EXISTS `mall_spec`;
CREATE TABLE `mall_spec`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '规格id',
  `spec_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '规格名称',
  `des` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '简述',
  `is_enable` int(11) NOT NULL DEFAULT 1 COMMENT '1：启用，0：禁用 2：假删除',
  `sequence` int(11) NOT NULL COMMENT '排序',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '（App）商城规格表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `mall_shopping_cart`;
CREATE TABLE `mall_shopping_cart`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `sku_info` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sku组合',
  `sku_id` int(11) NOT NULL COMMENT 'sku组合id',
  `goods_num` int(11) NOT NULL DEFAULT 1 COMMENT '商品数量',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商城购物车' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_type_ref
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_type_ref`;
CREATE TABLE `mall_goods_type_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `type_id` int(11) NOT NULL COMMENT '商品分类id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 717 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '（App）商城商品及商品分类关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_type
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_type`;
CREATE TABLE `mall_goods_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品分类id',
  `type_name` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `pid` int(11) NULL DEFAULT NULL COMMENT '父id',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `sequence` int(11) NOT NULL COMMENT '排序',
  `des` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '简述',
  `is_enable` int(11) NOT NULL DEFAULT 1 COMMENT '1：启用，0禁用',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '（App）商城商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_ticket_record
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_ticket_record`;
CREATE TABLE `mall_goods_ticket_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '项目名称',
  `record_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成号',
  `ticket_category` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '票种',
  `ticket_use_condition` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '使用时间',
  `ticket_amount` int(11) NOT NULL COMMENT '票数量',
  `good_id` int(11) NULL DEFAULT NULL COMMENT '商城商品id',
  `good_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商城商品名称',
  `expire_time` datetime NOT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `package_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下载包地址',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_supplier_ref
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_supplier_ref`;
CREATE TABLE `mall_goods_supplier_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '供应商id',
  `supplier_id` int(11) NOT NULL COMMENT '供应商id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 376 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '（App）商城商品供应商关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_send_msg
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_send_msg`;
CREATE TABLE `mall_goods_send_msg`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `main_id` int(11) NOT NULL,
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `get_tickets_time` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `get_tickets_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `send_msg_time` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_related
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_related`;
CREATE TABLE `mall_goods_related`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NULL DEFAULT NULL COMMENT '商品id',
  `related_goods_id` int(11) NULL DEFAULT NULL COMMENT '周边商品id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 230 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '演艺赛事商品周边商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_ex_stuff
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_ex_stuff`;
CREATE TABLE `mall_goods_ex_stuff`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stuff_id` int(11) NOT NULL COMMENT '兑换物品id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `stuff_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT ' ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品和兑换物品关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_goods_ccode
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods_ccode`;
CREATE TABLE `mall_goods_ccode`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL,
  `code_id` int(11) NOT NULL,
  `code_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `coupon_start_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '优惠券有效期开始时间',
  `coupon_end_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '优惠券有效期结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商城商品优惠关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_discount_people
-- ----------------------------
DROP TABLE IF EXISTS `mall_discount_people`;
CREATE TABLE `mall_discount_people`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id主键',
  `userId` int(10) NOT NULL COMMENT '用户id',
  `goodsId` int(10) NOT NULL COMMENT '商品id',
  `belongUser` int(10) NULL DEFAULT NULL COMMENT '砍价商品发起人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `price` decimal(10, 2) NOT NULL COMMENT '砍价金额',
  `status` int(10) NULL DEFAULT NULL COMMENT '用户支付状态0未支付1已支付2已结束3支付超时4退款',
  `orderNum` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `bid` int(11) NOT NULL COMMENT '砍价id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 752 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mall_brand
-- ----------------------------
DROP TABLE IF EXISTS `mall_brand`;
CREATE TABLE `mall_brand`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '品牌id',
  `brand_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '品牌名称',
  `des` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '简述',
  `sequence` int(11) NOT NULL COMMENT '排序',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '（App）商城品牌表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for lesson_type
-- ----------------------------
DROP TABLE IF EXISTS `lesson_type`;
CREATE TABLE `lesson_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程分类名称',
  `img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户端“未选中”的状态显示的图片',
  `cimg` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户端“选中”的状态显示的图片',
  `sequence` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '排序',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL COMMENT '0：禁用 1：启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for lesson_training_base
-- ----------------------------
DROP TABLE IF EXISTS `lesson_training_base`;
CREATE TABLE `lesson_training_base`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程训练基地名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '训练基地地址',
  `lng` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '经度',
  `lat` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纬度',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '（关联）场馆id',
  `venue_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '（关联）场馆名称',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL COMMENT '0：禁用 1：启用',
  `sequence` int(11) NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程训练基地' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for lesson_brand
-- ----------------------------
DROP TABLE IF EXISTS `lesson_brand`;
CREATE TABLE `lesson_brand`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程品牌名称',
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '品牌介绍',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL COMMENT '0：禁用 1：启用 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程品牌' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for kaisa_user
-- ----------------------------
DROP TABLE IF EXISTS `kaisa_user`;
CREATE TABLE `kaisa_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `traded` int(11) NOT NULL,
  `company` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 318984 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jwh_vip_order
-- ----------------------------
DROP TABLE IF EXISTS `jwh_vip_order`;
CREATE TABLE `jwh_vip_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆名',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户手机号',
  `type` int(11) NULL DEFAULT NULL COMMENT '1-馆佳订单 2-乐火订单',
  `order_num` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `order_type_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单类型',
  `item_name` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单项目名称',
  `status` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单状态',
  `order_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '订单金额',
  `deducted_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '抵扣金额',
  `pay_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '支付金额',
  `jwh_vip_discount` decimal(11, 2) NULL DEFAULT NULL COMMENT '佳文荟优惠',
  `other_discount` decimal(11, 2) NULL DEFAULT NULL COMMENT '其他优惠',
  `use_jwh_vip_discount` tinyint(1) NOT NULL COMMENT '是否使用优惠',
  `sport_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运动类型',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for jwh_vip
-- ----------------------------
DROP TABLE IF EXISTS `jwh_vip`;
CREATE TABLE `jwh_vip`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `charge_order_num` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值记录订单号',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态 0-待生效 1-生效中 2-已完成',
  `start_time` datetime NULL DEFAULT NULL COMMENT '有效期开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '有效期结束时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_visa_merchant
-- ----------------------------
DROP TABLE IF EXISTS `j_visa_merchant`;
CREATE TABLE `j_visa_merchant`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `platform` int(11) NOT NULL DEFAULT 0 COMMENT '商户来源0.馆佳  1.一起吗  2.乐火',
  `visa_merchant_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '银联商户名称',
  `visa_merchant_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '银联商户号',
  `visa_merchant_card_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '银联商户银行卡号',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '0.禁用 1.启用 2.删除',
  `merchant_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '馆佳商户名称',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '馆佳商户id',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '更新人',
  `resource` int(11) NOT NULL COMMENT '0.馆佳 2.乐火',
  `resource_id` int(11) NOT NULL COMMENT '来源端id',
  `is_online` int(1) NOT NULL DEFAULT 0 COMMENT '0.线下商户 1.线上商户',
  `visa_tid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '银联商户终端号',
  `share_proportion` decimal(11, 2) NOT NULL DEFAULT 100.00 COMMENT '分润比例',
  `merchant_group_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商户集团编号',
  `enterprise_user_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '企业用户号',
  `payee_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '收款人名称',
  `bank_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '开户行名称',
  `bank_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '开户行行号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_vip_member_card
-- ----------------------------
DROP TABLE IF EXISTS `j_vip_member_card`;
CREATE TABLE `j_vip_member_card`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `type` int(11) NOT NULL DEFAULT 0 COMMENT '0.运动达人 1.运动玩家',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `card_id` int(11) NOT NULL COMMENT '卡售卖id',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0.待激活 1.已激活 2.已过期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_vip_iteam
-- ----------------------------
DROP TABLE IF EXISTS `j_vip_iteam`;
CREATE TABLE `j_vip_iteam`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `iteam_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '板块名称',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '板块图片',
  `num` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `des` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '详细描述',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0_上线，1_下线',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `iteam_index` int(1) NOT NULL DEFAULT 1 COMMENT '板块名称对应排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_vip_card_order_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_vip_card_order_ref`;
CREATE TABLE `j_vip_card_order_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_card_id` int(11) NOT NULL COMMENT '用户卡片id',
  `type` int(1) NOT NULL COMMENT '0.充值 1.续费',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_vip
-- ----------------------------
DROP TABLE IF EXISTS `j_vip`;
CREATE TABLE `j_vip`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `level` int(1) NOT NULL DEFAULT 0 COMMENT '0.运动达人 1.运动玩家',
  `card_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '卡名称',
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '价格',
  `card_day` int(10) NOT NULL DEFAULT 10 COMMENT '会员日默认每月10号',
  `des` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '卡片描述',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0.上线 1.下线',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '卡片图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_version
-- ----------------------------
DROP TABLE IF EXISTS `j_version`;
CREATE TABLE `j_version`  (
  `id` int(11) NOT NULL,
  `version_num` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '版本号',
  `url` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '下载地址',
  `message` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '版本信息',
  `version_update` int(3) NULL DEFAULT NULL COMMENT '是否强制更新 0 不是 1 是',
  `create_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '版本接口' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_ticket
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_ticket`;
CREATE TABLE `j_venue_ticket`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '票名',
  `ticket_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'B端ID',
  `unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位',
  `limit_num` int(11) NULL DEFAULT NULL COMMENT '限购数',
  `expire_days` int(11) NULL DEFAULT NULL COMMENT '有效天数',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '说明',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `type` int(11) NOT NULL DEFAULT 1 COMMENT '散票类型： 1:普通 2：一大一小 3：两大一小',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 188 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_service_relate
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_service_relate`;
CREATE TABLE `j_venue_service_relate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `service_id` int(11) NULL DEFAULT NULL COMMENT '服务id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3720 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '保存场馆所支持的服务' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_service
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_service`;
CREATE TABLE `j_venue_service`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签名称',
  `service_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签图片',
  `type` int(11) NOT NULL DEFAULT 1 COMMENT '1:服务与设施 2：自定义标签',
  `status` int(11) NOT NULL DEFAULT 2 COMMENT '1：上线 2：下线',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '场馆服务设施字典' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_reserve
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_reserve`;
CREATE TABLE `j_venue_reserve`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `venue_id` int(11) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预定时间',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户电话',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预定备注',
  `sex` int(11) NULL DEFAULT NULL COMMENT '1 男 2女',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `handle_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '处理人',
  `handle_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '处理备注',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0 待处理 1已处理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户电话预定场馆表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_price_temp
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_price_temp`;
CREATE TABLE `j_venue_price_temp`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `idle_percent` decimal(20, 2) NULL DEFAULT NULL COMMENT '闲时百分比',
  `busy_percent` decimal(20, 2) NULL DEFAULT NULL COMMENT '忙时百分比',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台调价模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_price_tag
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_price_tag`;
CREATE TABLE `j_venue_price_tag`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL,
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `des` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `use_validity` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否启用有效期',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 583 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_open_time
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_open_time`;
CREATE TABLE `j_venue_open_time`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL,
  `des` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `start_hour` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业开始时间 小时',
  `start_min` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业开始时间 分钟',
  `end_hour` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业结束时间 小时',
  `end_min` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业结束时间 分钟',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 541 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '场馆营业时间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_intro
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_intro`;
CREATE TABLE `j_venue_intro`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `type` int(11) NULL DEFAULT NULL COMMENT '图片类型 2轮播图',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 985 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '场馆图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_detail
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_detail`;
CREATE TABLE `j_venue_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `service_intro` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `in_notes` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `idle_percent` decimal(20, 2) NOT NULL DEFAULT 100.00 COMMENT '闲时调价百分比',
  `busy_percent` decimal(20, 2) NOT NULL DEFAULT 100.00 COMMENT '忙时调价百分比',
  `cut_idle_percent` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '闲时分成百分比',
  `cut_busy_percent` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '忙时分成百分比',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `venueId`(`venue_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 181 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_cut_temp
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_cut_temp`;
CREATE TABLE `j_venue_cut_temp`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `idle_percent` decimal(20, 2) NULL DEFAULT NULL COMMENT '闲时百分比',
  `busy_percent` decimal(20, 2) NULL DEFAULT NULL COMMENT '忙时百分比',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台分成模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_activity_tag
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_activity_tag`;
CREATE TABLE `j_venue_activity_tag`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL,
  `use_validity` tinyint(1) NULL DEFAULT NULL COMMENT '是否启用有效期',
  `des` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '场馆活动标签' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_venue_activity_merchant_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_venue_activity_merchant_ref`;
CREATE TABLE `j_venue_activity_merchant_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `activity_id` int(11) NOT NULL COMMENT '活动id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `merchant_id_from` int(11) NULL DEFAULT NULL COMMENT '来源站点',
  `update_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_date` datetime NULL DEFAULT NULL,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_date` datetime NULL DEFAULT NULL,
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` smallint(6) NULL DEFAULT NULL,
  `delete_flag` smallint(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动商户关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_token_sso
-- ----------------------------
DROP TABLE IF EXISTS `j_token_sso`;
CREATE TABLE `j_token_sso`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) NOT NULL COMMENT '用户id',
  `sso_user_id` int(10) NULL DEFAULT NULL COMMENT 'sso用户id',
  `sso_token` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sso口令验证',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26584 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_time_card_venue_sport
-- ----------------------------
DROP TABLE IF EXISTS `j_time_card_venue_sport`;
CREATE TABLE `j_time_card_venue_sport`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `sport_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运动类型id',
  `card_id` int(11) NOT NULL COMMENT '闲时卡售卖id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_time_card_use
-- ----------------------------
DROP TABLE IF EXISTS `j_time_card_use`;
CREATE TABLE `j_time_card_use`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `card_id` int(11) NOT NULL COMMENT '用户卡id',
  `discount` decimal(10, 2) NOT NULL COMMENT '抵扣时长',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `venue_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '场馆名称',
  `open_time` datetime NOT NULL COMMENT '开场时间',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `order_time` datetime NOT NULL COMMENT '消费时间',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `status` int(11) NOT NULL COMMENT '0.未抵扣 1.已抵扣',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_time_card
-- ----------------------------
DROP TABLE IF EXISTS `j_time_card`;
CREATE TABLE `j_time_card`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `type` int(11) NOT NULL DEFAULT 0 COMMENT '0.日卡 1.周卡 2.月卡 3.季卡 4.年卡',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '卡名称',
  `price` decimal(10, 2) NOT NULL COMMENT '定价',
  `des` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '说明',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0.上架 1.下架 2.删除',
  `stime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '可用时段开始时间',
  `etime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '可用时段结束时间',
  `discount_time` decimal(10, 2) NOT NULL DEFAULT 1.00 COMMENT '单次使用最大抵扣时长/小时',
  `limit_num` int(11) NOT NULL COMMENT '单日使用限制/次',
  `sport_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '运动类型名称',
  `venue_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '场馆名称',
  `venue_range` int(11) NOT NULL COMMENT '0.全部场馆 1.部分场馆',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `j_merchant_id` int(11) NULL DEFAULT NULL COMMENT '银联商户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_ticket_img
-- ----------------------------
DROP TABLE IF EXISTS `j_ticket_img`;
CREATE TABLE `j_ticket_img`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '票类图片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_sup_order
-- ----------------------------
DROP TABLE IF EXISTS `j_sup_order`;
CREATE TABLE `j_sup_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商id',
  `order_num` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `sup_order_num` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '（供应商）订单号',
  `sup_order_account` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '（供应商）下单账号',
  `logistics_id` int(11) NULL DEFAULT NULL COMMENT '（供应商）物流公司id',
  `logistics_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '（供应商）物流公司名称',
  `logistics_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '（供应商）运单号',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `return_logistics_id` int(11) NULL DEFAULT NULL COMMENT '退回供应商物流公司id',
  `return_logistics_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退回供应商物流公司名称',
  `return_logistics_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退回供应商物流单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 172 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '供应商订单信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_step_config
-- ----------------------------
DROP TABLE IF EXISTS `j_step_config`;
CREATE TABLE `j_step_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `config` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '步数相关配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_sms_template
-- ----------------------------
DROP TABLE IF EXISTS `j_sms_template`;
CREATE TABLE `j_sms_template`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sms_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模板名称',
  `sms_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '模板code',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '阿里云短信吗模板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_share_config
-- ----------------------------
DROP TABLE IF EXISTS `j_share_config`;
CREATE TABLE `j_share_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section` int(20) NULL DEFAULT NULL COMMENT '位置',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分享配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_service_charge
-- ----------------------------
DROP TABLE IF EXISTS `j_service_charge`;
CREATE TABLE `j_service_charge`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '服务费类型',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务费名称',
  `amount` decimal(10, 2) NOT NULL COMMENT '服务费金额',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '服务费' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_section_item_list
-- ----------------------------
DROP TABLE IF EXISTS `j_section_item_list`;
CREATE TABLE `j_section_item_list`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL COMMENT '板块项目id',
  `param_id` int(11) NOT NULL COMMENT '文章id/商品id/子场馆id',
  `to_type` int(11) NOT NULL COMMENT '自定义链接：0,单篇文章：1,文章列表：2,文章分类：3,商品：4,商品列表：5,商品分类：6,母场馆主页：7,子场馆详情：8,子场馆列表：9',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 979 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '板块项目列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_section
-- ----------------------------
DROP TABLE IF EXISTS `j_section`;
CREATE TABLE `j_section`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `page` int(11) NULL DEFAULT NULL COMMENT '归属页面',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态  0.关闭 1.正常',
  `update_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版块表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_report_check_record
-- ----------------------------
DROP TABLE IF EXISTS `j_report_check_record`;
CREATE TABLE `j_report_check_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT 'h_member id',
  `venue_id` int(11) NOT NULL COMMENT 'venue_id id',
  `imgs` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片(多个用,隔开)',
  `uuid` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'uuid',
  `id_card` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'id_card',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'phone',
  `user_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `status` int(11) NULL DEFAULT 2 COMMENT ' 体检校验 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用',
  `urgent_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '紧急联系人',
  `urgent_phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '紧急联系人电话',
  `face_images` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '人脸照片',
  `reason` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `report_expire_date` datetime NULL DEFAULT NULL COMMENT '体检有效期',
  `source` int(11) NOT NULL DEFAULT 0 COMMENT '用户来源 1app2后台录入',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 325 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '体检报告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_recommend_bargain_team
-- ----------------------------
DROP TABLE IF EXISTS `j_recommend_bargain_team`;
CREATE TABLE `j_recommend_bargain_team`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '表主键',
  `bargain_id` int(10) NULL DEFAULT 0 COMMENT '砍价商品id',
  `goods_team_id` int(10) NULL DEFAULT 0 COMMENT '拼团商品id',
  `recommended_type` int(10) NOT NULL COMMENT '推荐类型,2_拼团,1_砍价',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `status` int(10) NOT NULL DEFAULT 0 COMMENT '0_推荐中,1_已经停止',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '砍价商品和团购商品推荐记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_question_season
-- ----------------------------
DROP TABLE IF EXISTS `j_question_season`;
CREATE TABLE `j_question_season`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名称',
  `season_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '赛季名称',
  `homepage_bg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '答题首页',
  `grade_bg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '等级展示图',
  `rank_bg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '排行榜底图',
  `rule_bg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '答题规则图',
  `question_bg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '答题底图',
  `rule` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规则',
  `star_num` int(11) NULL DEFAULT NULL COMMENT '每个段位的星数',
  `right_num` int(11) NULL DEFAULT NULL COMMENT '正确数',
  `group_num` int(11) NULL DEFAULT NULL COMMENT '每组题数',
  `high_start_point` int(11) NULL DEFAULT NULL COMMENT '最高段位后获星送分',
  `grade_setting` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '段位设置',
  `share_content` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分享内容',
  `share_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分享图片',
  `status` int(11) NULL DEFAULT NULL COMMENT '0：下线 1:上线',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `seasonFlag` int(1) NULL DEFAULT 0 COMMENT '0.原来答题活动，1.新增答题活动',
  `create_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建ren',
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '编辑人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `user_num` int(11) NULL DEFAULT 0 COMMENT '参与总人数',
  `new_user_num` int(11) NULL DEFAULT 0 COMMENT '新用户人数',
  `limit_time` int(11) NULL DEFAULT 40,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '答题赛季' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_question_invite
-- ----------------------------
DROP TABLE IF EXISTS `j_question_invite`;
CREATE TABLE `j_question_invite`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '被邀请人id',
  `invite_member_id` int(11) NOT NULL COMMENT '邀请人id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_member_id`(`member_id`, `invite_member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '答题邀请关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_question_invitation
-- ----------------------------
DROP TABLE IF EXISTS `j_question_invitation`;
CREATE TABLE `j_question_invitation`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `userid` int(10) NOT NULL DEFAULT 0 COMMENT '用户id',
  `new_userid` int(10) NOT NULL DEFAULT 0 COMMENT '被邀请人id',
  `create_time` datetime NOT NULL,
  `activity_id` int(10) NOT NULL COMMENT '活动id',
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_question
-- ----------------------------
DROP TABLE IF EXISTS `j_question`;
CREATE TABLE `j_question`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `season_id` int(11) NULL DEFAULT NULL COMMENT '赛季id',
  `grade` int(11) NULL DEFAULT NULL COMMENT '段位级别',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7601 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '题库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_pub_image
-- ----------------------------
DROP TABLE IF EXISTS `j_pub_image`;
CREATE TABLE `j_pub_image`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `big_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '大图',
  `small_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小图',
  `update_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发布页图片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_prize_verification
-- ----------------------------
DROP TABLE IF EXISTS `j_prize_verification`;
CREATE TABLE `j_prize_verification`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '兑换方',
  `exchange_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '兑换码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '核销人' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_points_task_member
-- ----------------------------
DROP TABLE IF EXISTS `j_points_task_member`;
CREATE TABLE `j_points_task_member`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `task_id` int(11) NOT NULL COMMENT '任务id(1-完善信息,2-互动有礼,3-呼朋唤友,4-首次下单,5-分享动态)',
  `task_type` int(2) NULL DEFAULT NULL COMMENT '任务类型(当task=2时,1-点赞,2-评论)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `INDEX_MEMBERID`(`member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 738 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '会员积分任务关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_points_task
-- ----------------------------
DROP TABLE IF EXISTS `j_points_task`;
CREATE TABLE `j_points_task`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id(1-完善信息,2-互动有礼,3-呼朋唤友,4-首次下单,5-分享动态)',
  `task_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `memo` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务说明',
  `sort` int(2) NOT NULL COMMENT '排序',
  `task_logo` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务Logo',
  `points_logo` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '积分Logo',
  `operate_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作名称',
  `replace_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '替换操作名称(任务完成后)',
  `jump_type` int(2) NOT NULL COMMENT '跳转页面(0-不跳转,1-个人资料页面,2-动态列表页面,3-邀请好友页面,4-找场地页面)',
  `status` int(2) NOT NULL COMMENT '是否有效(1-有效,2-无效)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '积分任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_points_rules
-- ----------------------------
DROP TABLE IF EXISTS `j_points_rules`;
CREATE TABLE `j_points_rules`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '规则名称',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则内容',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '积分规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_points_ratio
-- ----------------------------
DROP TABLE IF EXISTS `j_points_ratio`;
CREATE TABLE `j_points_ratio`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则名称',
  `img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `cost_amount` decimal(8, 0) NOT NULL COMMENT '消费金额',
  `get_points` int(11) NOT NULL COMMENT '获得积分',
  `ratio_des` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '兑换比例描述（消费每满多少元换1积分）',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态 0：禁用，1：启用',
  `jump_page` int(11) NULL DEFAULT NULL COMMENT '跳转页面 ',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '积分比例' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_points_ex_detail
-- ----------------------------
DROP TABLE IF EXISTS `j_points_ex_detail`;
CREATE TABLE `j_points_ex_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `ex_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '兑换地址',
  `ex_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '兑换码',
  `is_show` int(2) NOT NULL COMMENT '是否显示(1-显示,2-隐藏)',
  `ex_num` int(10) NULL DEFAULT 0 COMMENT '兑换次数',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '积分线下兑换商品详细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_point_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_point_statistics`;
CREATE TABLE `j_point_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(10) NOT NULL COMMENT '积分商品类型',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `goods_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tag2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 171 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_platform_vip
-- ----------------------------
DROP TABLE IF EXISTS `j_platform_vip`;
CREATE TABLE `j_platform_vip`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '平台会员等级名称',
  `card_level` int(10) NOT NULL DEFAULT 1 COMMENT '会员等级',
  `card_time` int(11) NOT NULL DEFAULT 1 COMMENT '卡有效期年',
  `overdue_level` int(10) NOT NULL DEFAULT 1 COMMENT '过期降级数',
  `card_price` decimal(10, 0) NOT NULL DEFAULT 0 COMMENT '需消费',
  `keep_price` decimal(10, 0) NOT NULL DEFAULT 0 COMMENT '保级需消费',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL,
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0.上线 1.下线',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_platform_activity_extra_attr
-- ----------------------------
DROP TABLE IF EXISTS `j_platform_activity_extra_attr`;
CREATE TABLE `j_platform_activity_extra_attr`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attr_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '名称',
  `attr_enums` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '信息序列',
  `sorted_num` int(11) NULL DEFAULT 0 COMMENT '排序值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名信息项' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_platform_activity_category
-- ----------------------------
DROP TABLE IF EXISTS `j_platform_activity_category`;
CREATE TABLE `j_platform_activity_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '活动分类名称',
  `sorted_num` int(11) NOT NULL DEFAULT 0 COMMENT '排序值',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_ticket_valid
-- ----------------------------
DROP TABLE IF EXISTS `j_order_ticket_valid`;
CREATE TABLE `j_order_ticket_valid`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `ticket_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '票号',
  `operator_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '核销人员id',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '核销人员名称',
  `type` int(11) NULL DEFAULT NULL COMMENT '票类型,与B端use_condition保持一致',
  `ticket_type` int(11) NULL DEFAULT NULL COMMENT '1：成人单次 2:一大一小 3:两大一小',
  `is_valid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已核销',
  `valid_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_num`(`ticket_num`) USING BTREE,
  INDEX `ik_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 500 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '散票核销记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_ticket
-- ----------------------------
DROP TABLE IF EXISTS `j_order_ticket`;
CREATE TABLE `j_order_ticket`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'B端卡ID',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `ticket_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票号',
  `ticket_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票名',
  `type` int(11) NULL DEFAULT NULL COMMENT '票类型,与B端use_condition保持一致',
  `ticket_type` int(11) NULL DEFAULT NULL COMMENT '1：成人单次 2:一大一小 3:两大一小',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `status` int(11) NULL DEFAULT NULL COMMENT '使用状态 0 未使用 1已使用 2已过期',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用说明',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `expire_time` timestamp NULL DEFAULT NULL COMMENT '截止有效时间',
  `remain_num` int(11) NOT NULL DEFAULT 0 COMMENT '剩余核销次数',
  `exchange_time` timestamp NULL DEFAULT NULL COMMENT '兑换时间',
  `price` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '价格(不包含服务费)',
  `service_charge` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `deducted_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '票最终分摊的抵扣金额',
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '已读状态1为已读',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_num`(`order_num`) USING BTREE,
  INDEX `ik_ticket_num`(`ticket_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2057 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '游泳票生成表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_report_detail
-- ----------------------------
DROP TABLE IF EXISTS `j_order_report_detail`;
CREATE TABLE `j_order_report_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jzy_venue_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'B端场馆id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `type` int(11) NOT NULL COMMENT '类型 1.搭配 2.订场 3.散票',
  `status` int(11) NOT NULL COMMENT '1.付款 2.已完成 3.退款 4.过期',
  `ori_price` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '原价',
  `sell_price` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '售价',
  `platform_gain` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '平台分成',
  `venue_gain` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '场馆分成',
  `service_charge` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `discount_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠券',
  `deducted_card_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '专项卡抵扣类型(2011储值卡,2012储值专项,202次卡)',
  `deducted_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '专项卡已抵扣金额',
  `goods_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '搭配价格',
  `pay_way` int(11) NOT NULL COMMENT '支付方式',
  `pay_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '实收款',
  `refund_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '退款金额',
  `order_date` datetime NOT NULL COMMENT '订单时间',
  `status_date` datetime NOT NULL COMMENT '状态时间',
  `is_gate_valid` tinyint(4) NULL DEFAULT 0 COMMENT '是否闸机核销',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_number`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 908064 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订场汇总报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_lesson
-- ----------------------------
DROP TABLE IF EXISTS `j_order_lesson`;
CREATE TABLE `j_order_lesson`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `lesson_id` int(11) NULL DEFAULT NULL COMMENT '课程id',
  `lesson_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程名',
  `lesson_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程图片',
  `brand_id` int(11) NULL DEFAULT NULL COMMENT '品牌id',
  `brand_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '品牌名称',
  `base_id` int(11) NULL DEFAULT NULL COMMENT '基地id',
  `base_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '基地名',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报名人名',
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报名人手机',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报名备注',
  `sell_price` decimal(20, 2) NULL DEFAULT NULL COMMENT '售价',
  `original_price` decimal(20, 2) NULL DEFAULT NULL COMMENT '原价',
  `service_charge` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 0：待参与 1：已参与',
  `sku_id` int(11) NULL DEFAULT NULL,
  `sku_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 194 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_field
-- ----------------------------
DROP TABLE IF EXISTS `j_order_field`;
CREATE TABLE `j_order_field`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `buss_date` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开场日期',
  `start_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开场时间',
  `end_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结束时间',
  `item_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场地名称',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售单价(不包含服务费)',
  `ori_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原单价(不包含服务费)',
  `service_charge` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `cut_ratio` decimal(10, 2) NULL DEFAULT NULL COMMENT '平台抽成比例',
  `field_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场地id',
  `price_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '价格id',
  `push` int(3) NULL DEFAULT NULL COMMENT '是否已推送提示开场',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2078 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '已订场地' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_evaluate
-- ----------------------------
DROP TABLE IF EXISTS `j_order_evaluate`;
CREATE TABLE `j_order_evaluate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `sport_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运动类型id',
  `content` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `score` int(11) NULL DEFAULT NULL COMMENT '分数',
  `anonymous` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否匿名',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单描述',
  `is_checked` int(11) NULL DEFAULT 0 COMMENT '0待审 1通过 2不通过',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1149 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_card_expense
-- ----------------------------
DROP TABLE IF EXISTS `j_order_card_expense`;
CREATE TABLE `j_order_card_expense`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '订单号',
  `vip_card_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '专项卡id(与B端一致)',
  `vip_card_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '专项卡号(与B端一致)',
  `card_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '虚拟卡号(与B端一致)',
  `vip_card_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '专项卡类型(201-储值卡,202-次卡)',
  `deducted_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '已抵扣金额',
  `spend_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '卡已使用额度',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_cancel` varchar(1) CHARACTER SET utf8 COLLATE utf8_icelandic_ci NOT NULL DEFAULT '0' COMMENT '是否取消(0-正常,1-已取消)',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '取消时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ORDER_NUM_INDEX`(`order_num`, `is_cancel`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 157 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_order_b_goods
-- ----------------------------
DROP TABLE IF EXISTS `j_order_b_goods`;
CREATE TABLE `j_order_b_goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `goods_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'B端商品 id(t_jzy_warehouse_goods)',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `goods_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品单位',
  `goods_price` decimal(20, 2) NULL DEFAULT NULL COMMENT '商品单价',
  `num` int(11) NULL DEFAULT NULL COMMENT '购买数量',
  `amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '总金额',
  `images` varchar(666) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 0未使用 1已使用 2过期 3已退款',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  `exchange_time` datetime NULL DEFAULT NULL COMMENT '领取时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3628 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_option_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_option_statistics`;
CREATE TABLE `j_option_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `op_id` int(11) NOT NULL COMMENT '操作id',
  `op_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '操作名称',
  `page_id` int(11) NOT NULL DEFAULT 0 COMMENT '所属页面0_我的,1_步步有奖',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tag2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 188 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_note_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_note_statistics`;
CREATE TABLE `j_note_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` int(10) NOT NULL COMMENT '标签',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户手机号',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户昵称',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '动态内容',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `pick_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '点赞量',
  `note_id` int(11) NOT NULL COMMENT '动态内容id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '点击站点id',
  `tg1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  `tg2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备用字段2',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_note_id`(`note_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1277 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_message_type
-- ----------------------------
DROP TABLE IF EXISTS `j_message_type`;
CREATE TABLE `j_message_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '消息类型名称',
  `type` int(3) NULL DEFAULT NULL COMMENT '消息类型 1.能量卷购买详情 2.补给兑换详情 3订场详情 4套餐详情 5 宝石详情 6 活动消息',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片',
  `status` varchar(3) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '1 上线 2下线',
  `create_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_merchant_bargain_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_merchant_bargain_ref`;
CREATE TABLE `j_merchant_bargain_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bragain_id` int(11) NOT NULL COMMENT '砍价id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_wx_palm
-- ----------------------------
DROP TABLE IF EXISTS `j_member_wx_palm`;
CREATE TABLE `j_member_wx_palm`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `third_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '第三方id(微信为openid)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `member_id_key`(`member_id`) USING BTREE,
  INDEX `idx_open_id`(`third_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '腾讯掌纹注册用户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_step_bonus_record
-- ----------------------------
DROP TABLE IF EXISTS `j_member_step_bonus_record`;
CREATE TABLE `j_member_step_bonus_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `account` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号账号',
  `nickname` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '昵称',
  `rule_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相应规则',
  `get_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '获取类型(1,积分,2优惠券)',
  `get_points` int(255) NULL DEFAULT NULL COMMENT '获取的积分',
  `coupon_id` int(11) NULL DEFAULT NULL COMMENT '获取的优惠券id',
  `coupon_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '获取的优惠券名称',
  `create_time` datetime NULL DEFAULT NULL COMMENT '获取时间',
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '类型(0,自动发放)',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  `is_deleted` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 90 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_step
-- ----------------------------
DROP TABLE IF EXISTS `j_member_step`;
CREATE TABLE `j_member_step`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `step_num` int(11) NOT NULL DEFAULT 0 COMMENT '运动获得步数',
  `date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日期',
  `distance` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '距离',
  `point` int(11) NOT NULL COMMENT '积分',
  `is_take` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已领取积分',
  `other_step_num` int(11) NOT NULL DEFAULT 0 COMMENT '其余途径获得步数',
  `used_step_num` int(11) NOT NULL DEFAULT 0 COMMENT '已使用的步数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_member_step`(`member_id`, `date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2077 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户运动步数记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_share_note
-- ----------------------------
DROP TABLE IF EXISTS `j_member_share_note`;
CREATE TABLE `j_member_share_note`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户分享动态记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_question_answer
-- ----------------------------
DROP TABLE IF EXISTS `j_member_question_answer`;
CREATE TABLE `j_member_question_answer`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `activityId` int(10) NOT NULL DEFAULT 0 COMMENT '活动id',
  `point` int(10) NOT NULL COMMENT '当前积分',
  `userid` int(10) NOT NULL COMMENT '用户id',
  `energy` int(10) NOT NULL DEFAULT 0 COMMENT '当前能量值',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `cumulative_energy` int(10) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_points_records
-- ----------------------------
DROP TABLE IF EXISTS `j_member_points_records`;
CREATE TABLE `j_member_points_records`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `points_action` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '积分行为',
  `type` int(11) NOT NULL COMMENT '记录分类 1：获取，2：消费',
  `points_val` int(11) NOT NULL COMMENT '积分值',
  `record_time` datetime NOT NULL COMMENT '记录时间',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `get_way` int(11) NULL DEFAULT NULL COMMENT '获取方式 0：用户注册 1：签到，2：场馆预订，3：游泳购票，4：商城购物，5：演出购票，6：赛事购票，7：周边商品购买，8：抽奖活动',
  `consume_way` int(11) NULL DEFAULT NULL COMMENT '消费方式 1：积分兑换 2:积分抽奖',
  `is_pop` tinyint(1) NULL DEFAULT 0 COMMENT '是否需要弹窗提示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27324 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员积分（获取和消费）记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_points_ex_records
-- ----------------------------
DROP TABLE IF EXISTS `j_member_points_ex_records`;
CREATE TABLE `j_member_points_ex_records`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `goods_essence` int(11) NOT NULL DEFAULT 1 COMMENT '商品实质 1：渠道商品，2：赛事演艺票，3：优惠券 4：自营商品 5：线下兑换',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `goods_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `goods_num` int(11) NULL DEFAULT NULL COMMENT '（兑换）商品数量',
  `sell_way` int(11) NULL DEFAULT NULL COMMENT '兑换方式',
  `points` int(11) NULL DEFAULT NULL COMMENT '积分数',
  `sku_info` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格组合信息',
  `sku_id` int(11) NULL DEFAULT NULL COMMENT '规格组合id',
  `ex_time` datetime NULL DEFAULT NULL COMMENT '兑换（领取）时间',
  `logistics_id` int(11) NULL DEFAULT NULL COMMENT '物流公司id',
  `logistics_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司名称',
  `logistics_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运单号',
  `confirm_user` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货人',
  `confirm_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `consignee` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `consignee_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省id',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市id',
  `area_id` int(11) NULL DEFAULT NULL COMMENT '区id',
  `pca_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省市区名称',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人地址',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 1：兑换中，2：已兑换，3：(物品）未领取，4：(物品）已领取',
  `ex_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '兑换码',
  `use_time` datetime NULL DEFAULT NULL COMMENT '（兑换码）使用时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '（兑换码）过期时间',
  `unit_des` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 单位',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 371 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员积分兑换记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_order_logistics
-- ----------------------------
DROP TABLE IF EXISTS `j_member_order_logistics`;
CREATE TABLE `j_member_order_logistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `logistics_id` int(11) NOT NULL COMMENT '物流公司id',
  `logistics_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '物流公司名称',
  `logistics_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运单号',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL,
  `update_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `return_logistics_id` int(11) NULL DEFAULT NULL COMMENT '用户退货物流公司id',
  `return_logistics_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户退货物流公司名称',
  `return_logistics_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户退货物流单号',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '收货时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ORDER_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户订单物流消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_latest_sign
-- ----------------------------
DROP TABLE IF EXISTS `j_member_latest_sign`;
CREATE TABLE `j_member_latest_sign`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `latest_sign_time` datetime NOT NULL COMMENT '最近一次签到时间',
  `sign_days` int(11) NOT NULL COMMENT '连续签到天数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 165 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户最近一次签到表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_invite
-- ----------------------------
DROP TABLE IF EXISTS `j_member_invite`;
CREATE TABLE `j_member_invite`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invite_user_id` int(11) NOT NULL COMMENT '邀请人',
  `new_user_id` int(11) NOT NULL COMMENT '被邀请人',
  `invite_user_points` int(11) NOT NULL DEFAULT 0 COMMENT '邀请人获得积分',
  `new_user_points` int(11) NOT NULL DEFAULT 0 COMMENT '被邀请人获得积分',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '邀请时间',
  `is_use` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否被用于兑换商品',
  `goodsId` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户拉新表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_free_ticket
-- ----------------------------
DROP TABLE IF EXISTS `j_member_free_ticket`;
CREATE TABLE `j_member_free_ticket`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NULL DEFAULT NULL COMMENT '会员id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报名人名字',
  `venue_activity_goods_id` int(11) NULL DEFAULT NULL COMMENT '场馆活动商品id',
  `id_card` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `id_type` int(11) NULL DEFAULT 1 COMMENT '1.中国居民身份证 2.港澳居民身份证 3.台湾居民身份证',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '领取码',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '领取时间',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态  1：待使用，2：已使用，3：用户取消 4:过期',
  `status_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '状态时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '到期时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '核销人id',
  `use_begin_time` datetime NULL DEFAULT NULL COMMENT '使用开始时间',
  `use_end_time` datetime NULL DEFAULT NULL COMMENT '使用结束时间',
  `use_cond` int(20) NULL DEFAULT NULL COMMENT '卡限制类型,与B端UseCond保持一致',
  `ticket_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '免费票类型',
  `batch_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '套票批次码，用于标识套票',
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '已读状态1为已读',
  `update_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '核销人',
  `admin_check` int(11) NULL DEFAULT NULL COMMENT '后台核销',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 829 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户免费票记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_formid
-- ----------------------------
DROP TABLE IF EXISTS `j_member_formid`;
CREATE TABLE `j_member_formid`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `formid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `scene` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '使用场景',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_used` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已使用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '保存formid用于小程序推送消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_member_answer
-- ----------------------------
DROP TABLE IF EXISTS `j_member_answer`;
CREATE TABLE `j_member_answer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `num` int(11) NULL DEFAULT NULL COMMENT '保星卡数量',
  `total_num` int(11) NULL DEFAULT NULL COMMENT '保星卡总数',
  `score` int(11) NULL DEFAULT NULL,
  `current_grade` int(11) NULL DEFAULT NULL COMMENT '当前段位',
  `current_star` int(11) NULL DEFAULT NULL COMMENT '当前星数',
  `highest_grade` int(11) NULL DEFAULT NULL COMMENT '最高达到段位',
  `highest_star` int(11) NULL DEFAULT NULL COMMENT '最高达到星数',
  `current_right_num` int(11) NULL DEFAULT NULL COMMENT '当前已答对题数',
  `current_error_num` int(11) NULL DEFAULT NULL COMMENT '当前已答错题数',
  `upgrade_time` datetime NULL DEFAULT NULL COMMENT '升级时间',
  `points` int(11) NULL DEFAULT NULL COMMENT '总共获得积分',
  `status` int(11) NULL DEFAULT NULL COMMENT '答题状态',
  `season_id` int(11) NULL DEFAULT NULL COMMENT '赛季id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_member_id`(`member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 435 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户答题记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_logistics
-- ----------------------------
DROP TABLE IF EXISTS `j_logistics`;
CREATE TABLE `j_logistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `des` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态 1：启用，0：禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '物流信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_kaisa_activity_sku
-- ----------------------------
DROP TABLE IF EXISTS `j_kaisa_activity_sku`;
CREATE TABLE `j_kaisa_activity_sku`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sex` int(1) NOT NULL DEFAULT 0 COMMENT '0.男子 1.女子',
  `kilometre` int(11) NOT NULL DEFAULT 0 COMMENT '公里数',
  `activity_id` int(11) NOT NULL COMMENT '活动id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 92 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_kaisa_activity_person
-- ----------------------------
DROP TABLE IF EXISTS `j_kaisa_activity_person`;
CREATE TABLE `j_kaisa_activity_person`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `activity_id` int(11) NOT NULL COMMENT '活动id',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始跑步时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束跑步时间',
  `msec` bigint(20) NULL DEFAULT NULL COMMENT '总用时毫秒数',
  `sku_id` int(11) NOT NULL COMMENT '报名项目id',
  `kilometre` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '已经跑步公里数',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '报名人姓名',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '报名人手机号',
  `company` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '报名人单位',
  `locus_point` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '轨迹点',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0.未开始 1.已开始未结束 3.已结束',
  `recive_medal` int(1) NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `step` int(11) NULL DEFAULT 0 COMMENT '步数',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '轨迹图',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 167 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_invite_rule
-- ----------------------------
DROP TABLE IF EXISTS `j_invite_rule`;
CREATE TABLE `j_invite_rule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '规则',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '老拉新规则管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_intelligent_info
-- ----------------------------
DROP TABLE IF EXISTS `j_intelligent_info`;
CREATE TABLE `j_intelligent_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_type` int(11) NULL DEFAULT 1 COMMENT '1 :个人中心身份认证页面, 2:游泳馆购票页面, 3:游泳馆办卡页面, 4:免费票领取页, 5:体检报告上传页，6：个人中心身份认证页面',
  `detail_type` int(11) NULL DEFAULT 1 COMMENT '1.储值卡 2.次卡 3.时段卡, 4:散票，5：团体票，6：免费票，7：',
  `member_id` int(11) NOT NULL COMMENT 'h_member id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '智慧场馆收集数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_guidance
-- ----------------------------
DROP TABLE IF EXISTS `j_guidance`;
CREATE TABLE `j_guidance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `image_url` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '引导页url',
  `create_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '引导页' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_guess_support
-- ----------------------------
DROP TABLE IF EXISTS `j_guess_support`;
CREATE TABLE `j_guess_support`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guess_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `support_type` int(11) NULL DEFAULT NULL COMMENT '支持类型1：蓝 2：红 3：平',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_notice` tinyint(1) NOT NULL DEFAULT 0 COMMENT '中奖是否通知',
  `is_prize` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否中奖',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`guess_id`, `user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 158 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '竞猜用户支持表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_guess_statistics
-- ----------------------------
DROP TABLE IF EXISTS `j_guess_statistics`;
CREATE TABLE `j_guess_statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guess_id` int(11) NOT NULL COMMENT '竞猜id',
  `guess_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '项目名称',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `update_time` datetime NOT NULL,
  `create_time` datetime NOT NULL,
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tag2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 139 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_guess_result
-- ----------------------------
DROP TABLE IF EXISTS `j_guess_result`;
CREATE TABLE `j_guess_result`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guess_id` int(11) NOT NULL COMMENT '竞猜id',
  `blue_score` int(11) NULL DEFAULT NULL COMMENT '蓝方得分',
  `red_score` int(11) NULL DEFAULT NULL COMMENT '红方得分',
  `win_type` int(11) NULL DEFAULT NULL COMMENT '胜利方：1：蓝 2：红 3：平',
  `prize_num` int(11) NULL DEFAULT NULL COMMENT '中奖人数',
  `prize_id` int(11) NULL DEFAULT NULL COMMENT '奖品id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '竞猜结果' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_guess_comment_vote
-- ----------------------------
DROP TABLE IF EXISTS `j_guess_comment_vote`;
CREATE TABLE `j_guess_comment_vote`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guess_id` int(11) NULL DEFAULT NULL COMMENT '竞猜id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `comment_id` int(11) NULL DEFAULT NULL COMMENT '评论id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_comment_id`(`user_id`, `comment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '竞猜评论点赞记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_guess_comment
-- ----------------------------
DROP TABLE IF EXISTS `j_guess_comment`;
CREATE TABLE `j_guess_comment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guess_id` int(11) NULL DEFAULT NULL COMMENT '竞猜id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '评论内容',
  `is_hidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否隐藏',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `vote_num` int(11) NOT NULL DEFAULT 0 COMMENT '点赞数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_guess_id`(`guess_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '竞猜评论' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_guess
-- ----------------------------
DROP TABLE IF EXISTS `j_guess`;
CREATE TABLE `j_guess`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '竞猜标题',
  `bg_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '背景图片',
  `blue` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '蓝方名称',
  `blue_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '蓝方logo',
  `red` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '红方名称',
  `red_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '红方logo',
  `is_tie` tinyint(1) NULL DEFAULT NULL COMMENT '是否有平局',
  `summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '简介',
  `rule` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规则',
  `online_time` datetime NULL DEFAULT NULL COMMENT '上线时间',
  `offline_time` datetime NULL DEFAULT NULL COMMENT '下线时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '投票结束时间',
  `prev_guess_id` int(11) NULL DEFAULT NULL COMMENT '上轮结果',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '竞猜表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_goods_team_merchant_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_goods_team_merchant_ref`;
CREATE TABLE `j_goods_team_merchant_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_team_id` int(11) NOT NULL COMMENT '商品拼团id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_give_step
-- ----------------------------
DROP TABLE IF EXISTS `j_give_step`;
CREATE TABLE `j_give_step`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL COMMENT '被邀请人id',
  `invite_user_id` int(11) NULL DEFAULT NULL COMMENT '邀请人id',
  `user_step` int(11) NULL DEFAULT NULL COMMENT '被邀请人获得的步数',
  `invite_user_step` int(11) NULL DEFAULT NULL COMMENT '邀请人获得的步数',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型：1，老拉新 2.召回老用户',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '步数赠送记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_get_points_set
-- ----------------------------
DROP TABLE IF EXISTS `j_get_points_set`;
CREATE TABLE `j_get_points_set`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '积分代码',
  `description` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `first_point` int(11) NULL DEFAULT 0 COMMENT '首次获得积分',
  `points` int(11) NULL DEFAULT 0 COMMENT '之后获得积分',
  `points_limit` int(11) NULL DEFAULT 0 COMMENT '积分获取上限',
  `status` int(11) NULL DEFAULT 0 COMMENT '状态 0：禁用 1：启用',
  `price` int(11) NULL DEFAULT 0 COMMENT '每满x元获得points分',
  `create_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '积分签到设置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_fun_style
-- ----------------------------
DROP TABLE IF EXISTS `j_fun_style`;
CREATE TABLE `j_fun_style`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型名',
  `order_num` int(11) NOT NULL COMMENT '顺序',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片',
  `business_type` int(11) NOT NULL COMMENT '业务类型 1订场 2培训 3赛事 4演艺/电影',
  `status` int(11) NULL DEFAULT 1 COMMENT '1上线 2下线',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '首页功能类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_feedback
-- ----------------------------
DROP TABLE IF EXISTS `j_feedback`;
CREATE TABLE `j_feedback`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `context` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `handle_result` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理结果',
  `handle_user` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理人员',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `status` int(11) NOT NULL COMMENT '状态 1：未处理，2：已处理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '意见反馈' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_extension_event_tracking_detail
-- ----------------------------
DROP TABLE IF EXISTS `j_extension_event_tracking_detail`;
CREATE TABLE `j_extension_event_tracking_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆名称',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题',
  `user_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `open_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `item_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_extension_event_tracking
-- ----------------------------
DROP TABLE IF EXISTS `j_extension_event_tracking`;
CREATE TABLE `j_extension_event_tracking`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `format_date` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `activity_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动名称',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '场馆名称',
  `discount_template` int(11) NULL DEFAULT NULL COMMENT '优惠模板',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题',
  `request_number` int(11) NULL DEFAULT NULL COMMENT '点击次数',
  `request_member` int(11) NULL DEFAULT NULL COMMENT '点击人数',
  `new_member` int(11) NULL DEFAULT NULL COMMENT '新用户数',
  `old_member` int(11) NULL DEFAULT NULL COMMENT '老用户数',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_draw_chance
-- ----------------------------
DROP TABLE IF EXISTS `j_draw_chance`;
CREATE TABLE `j_draw_chance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `draw_id` int(11) NOT NULL COMMENT '活动id',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0.未抽奖 1.已抽奖',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 180 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_draw_activity
-- ----------------------------
DROP TABLE IF EXISTS `j_draw_activity`;
CREATE TABLE `j_draw_activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '活动名称',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `bg_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '背景图片',
  `rule_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '规则图片',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0.下线 1.上线',
  `enter_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '入口图片',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_user` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_damai_type_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_damai_type_ref`;
CREATE TABLE `j_damai_type_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_classify_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '大麦二级分类编码',
  `sub_classify_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '大麦二级编码名称',
  `jzy_type_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '自定义分类名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_damai_reg
-- ----------------------------
DROP TABLE IF EXISTS `j_damai_reg`;
CREATE TABLE `j_damai_reg`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '大麦项目id',
  `perform_id` int(11) NOT NULL COMMENT '大麦场次id',
  `price_id` int(11) NOT NULL COMMENT '大麦价格id',
  `project_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '大麦项目名称',
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '大麦项目类型',
  `perform_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '场次名称',
  `price_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '价格名称',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登记手机号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0_未处理 1_已处理 2_处理失败',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_damai_price
-- ----------------------------
DROP TABLE IF EXISTS `j_damai_price`;
CREATE TABLE `j_damai_price`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '项目id',
  `perform_id` int(11) NOT NULL COMMENT '场次id',
  `max_stock` int(11) NOT NULL DEFAULT 0 COMMENT '售卖最大库存',
  `price` decimal(11, 2) NOT NULL DEFAULT 0.00 COMMENT '价格',
  `price_id` int(11) NOT NULL COMMENT '大麦价格id',
  `price_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '价格名称',
  `price_type` int(11) NOT NULL DEFAULT 0 COMMENT '票品的类型 0普通单票 1套票',
  `able_sell` int(11) NOT NULL COMMENT '0.不可售 1.可售',
  `combine_num` int(11) NULL DEFAULT 0 COMMENT '套票数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2550758 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_damai_perform
-- ----------------------------
DROP TABLE IF EXISTS `j_damai_perform`;
CREATE TABLE `j_damai_perform`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `project_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '大麦项目id',
  `start_time` datetime NOT NULL COMMENT '演出开售时间',
  `end_time` datetime NOT NULL COMMENT '演出结束时间',
  `perform_id` int(11) NOT NULL COMMENT '大麦场次id',
  `perform_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '大麦场次名称',
  `perform_status` int(11) NOT NULL COMMENT '0：创建中 10：已创建 20：待销售 30：销售中 40：场次取消 50：场次结束',
  `is_one_order_one_card` int(11) NOT NULL DEFAULT 0 COMMENT '一单一证 0：不是，1：是',
  `is_one_ticket_one_card` int(11) NOT NULL DEFAULT 0 COMMENT '一票一证 0：不是，1：是',
  `is_real_name_enter` int(11) NOT NULL DEFAULT 0 COMMENT '是否实名制入场 0：不是，1：是',
  `issue_enter_modes_list` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '入场方式入场方式 1纸质票入场 2电子票入场（1,2都支持）',
  `issue_ticket_modes_list` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '	出票方式 1纸质票 2静态二维码电子票 3动态二维码电子票 4身份证电子票 5 短信码电子票',
  `take_ticket_types` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '取票方式 1无纸化 2自助换票 3快递配送 4 上门自取',
  `sale_type` int(11) NOT NULL DEFAULT 0 COMMENT '销售设置 0开票 1预售',
  `perform_type` int(11) NOT NULL DEFAULT 1 COMMENT '1 单场次，2 多次通票，3 单次通票',
  `reserve_seat` int(11) NOT NULL DEFAULT 0 COMMENT '是否对号入座 0：不对号入座 1：对号入座 2：对区入座',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 152479 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_damai_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `j_damai_order_detail`;
CREATE TABLE `j_damai_order_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `project_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '大麦项目id',
  `perform_id` int(11) NOT NULL COMMENT '场次id',
  `take_ticket_type` int(11) NOT NULL COMMENT '取票类型',
  `rela_name_info` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实名信息',
  `take_ticket_adress` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '快递地址',
  `damai_order_num` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '大麦订单号',
  `express_fee` decimal(10, 2) NULL DEFAULT NULL,
  `price_id` int(11) NULL DEFAULT NULL,
  `num` int(11) NULL DEFAULT NULL,
  `take_peice` decimal(11, 2) NULL DEFAULT NULL COMMENT '快递费',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 387 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_damai_city
-- ----------------------------
DROP TABLE IF EXISTS `j_damai_city`;
CREATE TABLE `j_damai_city`  (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `abbreviation` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  `level` int(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_customer_service_info
-- ----------------------------
DROP TABLE IF EXISTS `j_customer_service_info`;
CREATE TABLE `j_customer_service_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `des` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0 COMMENT '赛事_0,演艺_1,APP客服_2,商城_3,运动管家_4,商城运营_5,订场运营_6,场馆客服_7,找课程客服_8',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '0：禁用，1：启用',
  `start_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客服开始时间',
  `end_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客服结束时间',
  `create_time` datetime NULL DEFAULT NULL,
  `create_name` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_name` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客服信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_coupon_recive_city_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_coupon_recive_city_ref`;
CREATE TABLE `j_coupon_recive_city_ref`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recive_id` int(11) NOT NULL COMMENT '领券中心id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_city_merchant
-- ----------------------------
DROP TABLE IF EXISTS `j_city_merchant`;
CREATE TABLE `j_city_merchant`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `province` int(11) NOT NULL DEFAULT 0 COMMENT '0.全国',
  `city` int(11) NOT NULL COMMENT '0.全国 其它值为城市id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商户名称',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '状态 0.启用 1.禁用',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `tag1` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备用字段1',
  `tag2` int(11) NULL DEFAULT NULL COMMENT '备用字段2',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_card_type_limit
-- ----------------------------
DROP TABLE IF EXISTS `j_card_type_limit`;
CREATE TABLE `j_card_type_limit`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jzy_venue_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'B端场馆Id',
  `sport_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '运动id',
  `card_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '被限制的卡类型',
  `is_limit` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否限制同步到C端',
  `exclude_venue_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '排除的场馆id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_base_damai_item
-- ----------------------------
DROP TABLE IF EXISTS `j_base_damai_item`;
CREATE TABLE `j_base_damai_item`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `project_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '大麦项目id',
  `project_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '大麦项目名称',
  `sub_classify_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '大麦二级分类编码',
  `show_pic` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '演出海报',
  `show_detail` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '演出详情',
  `show_start_time` datetime NOT NULL COMMENT '演出开售时间',
  `show_end_time` datetime NOT NULL COMMENT '销售结束时间',
  `limit_notice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '限购说明',
  `is_has_seat` int(11) NOT NULL DEFAULT 0 COMMENT '是否有座： 0=无座 1=有座',
  `real_name_notice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '实名制购票提示',
  `children_notice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '儿童购票说明',
  `policy_of_return` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '退换政策',
  `entrance_notice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '入场说明',
  `eticket_notice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '电子票入场提示',
  `self_get_ticket_notice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '自助取票说明',
  `deposit_info` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '寄存说明',
  `prohibited_items` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '禁止携带物品说明',
  `artists` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '艺人JSON',
  `ip_card` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '品牌JSON',
  `perform_time_detail_list` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '演出时间说明',
  `post_city` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '发货城市',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '1_上架 0_下架',
  `d_status` int(11) NOT NULL DEFAULT 0 COMMENT '大麦项目状态0：创建中 10：已创建 20：待销售 30：销售中 40：项目取消 50：项目结束',
  `show_city_id` int(11) NOT NULL DEFAULT 0 COMMENT '演出城市id',
  `show_city_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '演出城市名称',
  `project_type` int(11) NOT NULL DEFAULT 0 COMMENT '项目类型 0:普通项目 1:预售项目 2:先付先抢-先付项目 3:先付先抢-先抢项目 4:搭售项目 5:超级票',
  `show_venue_id` int(11) NOT NULL COMMENT '演出场馆id',
  `show_venue_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '演出场馆名称',
  `show_venue_address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '场馆地址',
  `is_test` int(11) NOT NULL DEFAULT 0 COMMENT '是否测试项目 0-正式项目 1-测试项目',
  `lat` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '纬度',
  `lng` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '经度',
  `show_time_start` datetime NULL DEFAULT NULL COMMENT '场次演出最早开始时间',
  `show_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '演出时间段',
  `low_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最低价格',
  `online_time` datetime NULL DEFAULT NULL COMMENT '上线时间',
  `pickup_address_list` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '取票地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_bargain
-- ----------------------------
DROP TABLE IF EXISTS `j_bargain`;
CREATE TABLE `j_bargain`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '表主键',
  `goods_id` int(10) NOT NULL COMMENT '商品id',
  `max_Originalprice` decimal(20, 2) NOT NULL COMMENT '最高原价',
  `min_Originalprice` decimal(20, 2) NOT NULL COMMENT '最低原价',
  `activity_stock` int(10) NOT NULL COMMENT '活动库存',
  `start_time` datetime NOT NULL COMMENT '活动开始时间',
  `end_time` datetime NOT NULL COMMENT '活动结束时间',
  `goodsType` int(10) NOT NULL COMMENT '商品来源',
  `min_disCountPrice` decimal(20, 2) NOT NULL COMMENT '最低砍价金额',
  `max_disCountPrice` decimal(20, 2) NOT NULL COMMENT '最高砍价金额',
  `min_people` int(10) NOT NULL COMMENT '最低砍价人数',
  `max_people` int(10) NOT NULL COMMENT '最高砍价人数',
  `min_onePrice` decimal(20, 2) NOT NULL COMMENT '单刀最低砍价金额',
  `min_systemPrice` decimal(20, 2) NOT NULL COMMENT '系统刀最小金额',
  `max_systemPrice` decimal(20, 2) NOT NULL COMMENT '系统刀最大砍价金额',
  `goodsName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `createTime` datetime NOT NULL COMMENT '创建时间',
  `updateTime` datetime NULL DEFAULT NULL COMMENT '修改时间',
  `status` int(10) NOT NULL DEFAULT 1 COMMENT '0_待上架,1_已上架,2_已下架',
  `originalprice_range` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '原价区间',
  `discount_range` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '砍后价区间',
  `num` int(11) NULL DEFAULT 0 COMMENT '单人单价商品每天可砍次数',
  `merchant_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_article_type
-- ----------------------------
DROP TABLE IF EXISTS `j_article_type`;
CREATE TABLE `j_article_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态  0.关闭 1.正常',
  `update_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文章分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_article_ref
-- ----------------------------
DROP TABLE IF EXISTS `j_article_ref`;
CREATE TABLE `j_article_ref`  (
  `type_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  UNIQUE INDEX `index_1`(`type_id`, `article_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文章分类关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_app_version
-- ----------------------------
DROP TABLE IF EXISTS `j_app_version`;
CREATE TABLE `j_app_version`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '版本号',
  `last_force_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上一次强制更新版本',
  `client` enum('Android','IOS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '客户端类型',
  `update_intro` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新说明',
  `is_pop` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否弹窗',
  `down_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下载链接',
  `update_type` int(11) NULL DEFAULT NULL COMMENT '1：普通更新 2：强制更新',
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'APP版本表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_app_bootstrap_page
-- ----------------------------
DROP TABLE IF EXISTS `j_app_bootstrap_page`;
CREATE TABLE `j_app_bootstrap_page`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型：1：节气 2：活动 3：节日',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 1：待启动 2：已作废 3：启动中',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '启动页',
  `iosximg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `iosplusimg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `pub_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `online_time` datetime NULL DEFAULT NULL COMMENT '自动发布时间',
  `offline_time` datetime NULL DEFAULT NULL COMMENT '自动下线时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'app启动页配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_answer
-- ----------------------------
DROP TABLE IF EXISTS `j_answer`;
CREATE TABLE `j_answer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `content` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_true` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28541 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '答案' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_address
-- ----------------------------
DROP TABLE IF EXISTS `j_address`;
CREATE TABLE `j_address`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sex` varchar(6) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人姓名',
  `phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `area_id` int(11) NULL DEFAULT NULL COMMENT '地区',
  `street_id` int(11) NULL DEFAULT NULL COMMENT '街道',
  `pca_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `detailed_address` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_default` int(11) NULL DEFAULT 0 COMMENT '是否为默认地址（0：不是，1：是）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 382 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '收货地址' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_activity_status
-- ----------------------------
DROP TABLE IF EXISTS `j_activity_status`;
CREATE TABLE `j_activity_status`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `type` int(11) NOT NULL COMMENT '1.订场 2.拼团 3.邀请好友 4.步数 5.竞猜',
  `pop` int(11) NOT NULL COMMENT '是否弹窗',
  `send` int(11) NOT NULL COMMENT '是否赠送积分 0.未赠送 1.已赠送',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for j_activity_login
-- ----------------------------
DROP TABLE IF EXISTS `j_activity_login`;
CREATE TABLE `j_activity_login`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `last_login_time` datetime NOT NULL COMMENT '上一次签到时间',
  `count` int(11) NOT NULL COMMENT '连续签到天数',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `data_type` int(1) NOT NULL DEFAULT 1 COMMENT '1.老数据 2.新数据',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for goods_team
-- ----------------------------
DROP TABLE IF EXISTS `goods_team`;
CREATE TABLE `goods_team`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '表主键',
  `goodsId` int(10) NOT NULL COMMENT '商品id',
  `activity_stock` int(10) NULL DEFAULT NULL COMMENT '活动库存',
  `goods_percentage` decimal(10, 0) NULL DEFAULT NULL COMMENT '商品价格百分比',
  `validity_time` int(11) NOT NULL COMMENT '单团有效时间',
  `start_time` datetime NOT NULL COMMENT '活动开始时间',
  `end_time` datetime NOT NULL COMMENT '活动结束时间',
  `goods_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `status` int(1) NOT NULL COMMENT '0_待上架，1_上架，2_结束',
  `goodsType` int(1) NOT NULL COMMENT '商品类型',
  `max_originalprice` decimal(10, 2) NOT NULL COMMENT '商品最高原价',
  `min_originalprice` decimal(10, 2) NOT NULL COMMENT '商品最低原价',
  `max_teamPrice` decimal(10, 2) NOT NULL COMMENT '拼团成功最高价',
  `min_teamPrice` decimal(10, 2) NOT NULL COMMENT '拼团成功最低价',
  `originalprice_range` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '原价区间',
  `teamprice_range` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '团后价区间',
  `team_peopleNum` int(10) NOT NULL COMMENT '单团成团人数',
  `max_team` int(255) NOT NULL COMMENT '最大成团数',
  `merchant_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 120 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for good_merchant_synchronize
-- ----------------------------
DROP TABLE IF EXISTS `good_merchant_synchronize`;
CREATE TABLE `good_merchant_synchronize`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` int(11) NULL DEFAULT NULL COMMENT '商品id',
  `old_merchant_id` int(11) NULL DEFAULT NULL COMMENT '原来的站点id',
  `new_merchant_id` int(11) NULL DEFAULT NULL COMMENT '新的站点id',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态值 0表示删除 1表示正常',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人名字',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 130 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目同步记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_honor_team
-- ----------------------------
DROP TABLE IF EXISTS `game_honor_team`;
CREATE TABLE `game_honor_team`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '团队名称',
  `logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '团队logo',
  `leader` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '团队队长',
  `leader_phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `company_group` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集团',
  `area` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '赛区',
  `is_same_group` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否同一集团  0-否 1-是',
  `create_id` int(11) NOT NULL COMMENT '创建人id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '王者荣耀团队' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_honor_member
-- ----------------------------
DROP TABLE IF EXISTS `game_honor_member`;
CREATE TABLE `game_honor_member`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `team_id` int(11) NOT NULL COMMENT '团队id',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `real_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名字',
  `game_role` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色  1-上单 2-中单 3-打野 4-射手 5-辅助 6-替补',
  `age` int(1) NULL DEFAULT NULL COMMENT '年龄',
  `game_region` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '游戏大区',
  `game_age` int(1) NULL DEFAULT NULL COMMENT '游戏年龄',
  `game_segment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '游戏段位',
  `mobile_model` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机型号',
  `mobile_platform` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机平台',
  `good_at_heroes` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '擅长英雄',
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `company_group` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属集团',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT NULL,
  `is_deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '王者荣耀成员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_company_group
-- ----------------------------
DROP TABLE IF EXISTS `game_company_group`;
CREATE TABLE `game_company_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '集团名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '公司集团列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for game_activity
-- ----------------------------
DROP TABLE IF EXISTS `game_activity`;
CREATE TABLE `game_activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '活动名称',
  `introduction` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '介绍',
  `thumb_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图',
  `boostrap_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '首页图片',
  `list_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列表图片',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `sign_up_start_time` datetime NULL DEFAULT NULL COMMENT '报名开始时间',
  `sign_up_end_time` datetime NULL DEFAULT NULL COMMENT '报名结束时间',
  `activity_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '活动状态 0-下线 1-上线',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for find_at_set
-- ----------------------------
DROP TABLE IF EXISTS `find_at_set`;
CREATE TABLE `find_at_set`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type_id` int(11) NOT NULL COMMENT '文章分类id',
  `type_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文章分类名称',
  `sequence` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '状态 0：禁用，1：启用',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 668 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发现文章分类设置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_member_templet
-- ----------------------------
DROP TABLE IF EXISTS `cr_member_templet`;
CREATE TABLE `cr_member_templet`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组员模板名称',
  `enter_info` varchar(6000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报名信息',
  `create_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)组员模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_group_member
-- ----------------------------
DROP TABLE IF EXISTS `cr_group_member`;
CREATE TABLE `cr_group_member`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member__temp_id` int(11) NULL DEFAULT NULL COMMENT '组员模板id',
  `group_id` int(11) NULL DEFAULT NULL COMMENT '组别id',
  `num` int(11) NULL DEFAULT NULL COMMENT '人数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)组别组员模板关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_group
-- ----------------------------
DROP TABLE IF EXISTS `cr_group`;
CREATE TABLE `cr_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '组别名称',
  `enter_price` decimal(10, 2) NOT NULL COMMENT '报名信息',
  `disclaimer` varchar(8000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '免责声明',
  `create_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)组别' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_game_vehicle
-- ----------------------------
DROP TABLE IF EXISTS `cr_game_vehicle`;
CREATE TABLE `cr_game_vehicle`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上车地点',
  `num` int(11) NULL DEFAULT NULL COMMENT '座位数',
  `game_id` int(11) NULL DEFAULT NULL COMMENT '赛事id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)赛事班车配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_game_group
-- ----------------------------
DROP TABLE IF EXISTS `cr_game_group`;
CREATE TABLE `cr_game_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NULL DEFAULT NULL COMMENT '赛事id',
  `group_id` int(11) NULL DEFAULT NULL COMMENT '组别id',
  `num` int(11) NULL DEFAULT NULL COMMENT ' 数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)赛事组别配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_game_equipment
-- ----------------------------
DROP TABLE IF EXISTS `cr_game_equipment`;
CREATE TABLE `cr_game_equipment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '装备领取地址',
  `game_id` int(11) NULL DEFAULT NULL COMMENT '赛事id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)赛事装备（领取地址）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_game_clothes
-- ----------------------------
DROP TABLE IF EXISTS `cr_game_clothes`;
CREATE TABLE `cr_game_clothes`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NULL DEFAULT NULL COMMENT '赛事id',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格',
  `des` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '说明',
  `stock` int(11) NULL DEFAULT NULL COMMENT '初始库存',
  `left_stock` int(11) NULL DEFAULT NULL COMMENT '剩余库存',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)赛事赛服配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_game
-- ----------------------------
DROP TABLE IF EXISTS `cr_game`;
CREATE TABLE `cr_game`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '比赛项目名称',
  `province_id` int(11) NULL DEFAULT NULL,
  `city_id` int(11) NULL DEFAULT NULL,
  `title1` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题一',
  `thumbnail1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图1',
  `abstract1` varchar(600) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '摘要1',
  `info1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `title2` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题二',
  `thumbnail2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图2',
  `abstract2` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '摘要2',
  `info2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `hold_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '举办时间',
  `hold_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '举办地址',
  `lng` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经度',
  `lat` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '纬度',
  `highest_price` decimal(8, 2) NULL DEFAULT NULL COMMENT '最高价',
  `lowest_price` decimal(8, 2) NULL DEFAULT NULL COMMENT '最低价',
  `is_coupon` int(11) NOT NULL DEFAULT 0 COMMENT '是否有优惠码 1：有，0：无',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0：下线，1：上线，2：删除',
  `sequence` int(11) NULL DEFAULT NULL COMMENT '排序',
  `enter_start_time` datetime NULL DEFAULT NULL COMMENT '报名开始时间',
  `enter_end_time` datetime NULL DEFAULT NULL COMMENT '报名结束时间',
  `vehicle_service` int(11) NULL DEFAULT NULL COMMENT '交通服务 0：无，1：有',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)赛事' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cr_coupon_code
-- ----------------------------
DROP TABLE IF EXISTS `cr_coupon_code`;
CREATE TABLE `cr_coupon_code`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '优惠码名称',
  `type` int(4) NOT NULL DEFAULT 0 COMMENT '类型  1.费用全免 2.其他折扣',
  `full_cut_price` decimal(7, 2) NULL DEFAULT NULL COMMENT '满减金额',
  `price` decimal(7, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠券金额',
  `amount` int(11) NULL DEFAULT 0 COMMENT '总数量 0表示不限制数量',
  `ex_amount` int(11) NULL DEFAULT 0 COMMENT '已发放数量',
  `use_amount` int(11) NULL DEFAULT 0 COMMENT '已使用数量',
  `game_id` int(11) NULL DEFAULT NULL COMMENT '关联比赛id',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态  0.禁用 1.启用 2.假删除',
  `create_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '(CoupleRun)优惠码' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_receive
-- ----------------------------
DROP TABLE IF EXISTS `coupon_receive`;
CREATE TABLE `coupon_receive`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `ref_id` int(10) NOT NULL,
  `userid` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_grant_ref
-- ----------------------------
DROP TABLE IF EXISTS `coupon_grant_ref`;
CREATE TABLE `coupon_grant_ref`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `grantId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '优惠券发放id',
  `userid` int(11) NOT NULL COMMENT '用户id',
  `shareNum` int(11) NOT NULL COMMENT '已分享数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 91 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for com_redirect_link_record
-- ----------------------------
DROP TABLE IF EXISTS `com_redirect_link_record`;
CREATE TABLE `com_redirect_link_record`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type` int(10) NOT NULL COMMENT '1-商业 2-酒店',
  `user_id` int(10) NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for buy_ticket_people
-- ----------------------------
DROP TABLE IF EXISTS `buy_ticket_people`;
CREATE TABLE `buy_ticket_people`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `num` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '证件号码',
  `type` int(11) NOT NULL COMMENT '证件类型 1：身份证，2：驾驶证',
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `sex` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
  `id_card_status` int(11) NULL DEFAULT 0 COMMENT '身份证验证状态 0-未验证 1-验证成功 2-姓名不匹配 3-失败',
  `create_time` datetime NOT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 417 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '购票人' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for article_merchant_synchronize
-- ----------------------------
DROP TABLE IF EXISTS `article_merchant_synchronize`;
CREATE TABLE `article_merchant_synchronize`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `article_id` int(11) NOT NULL COMMENT '文章id',
  `old_merchant_id` int(11) NULL DEFAULT NULL COMMENT '原来的站点id',
  `new_merchant_id` int(11) NULL DEFAULT NULL COMMENT '新的站点id',
  `status` int(11) NULL DEFAULT 1 COMMENT '状态值 0表示删除 1表示正常',
  `create_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人名字',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文章同步记录表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
