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

 Date: 16/07/2026 14:26:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ods_wenti_buy_ticket_people
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_buy_ticket_people`;
CREATE TABLE `ods_wenti_buy_ticket_people`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `num` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '证件号码',
  `type` int(11) NOT NULL COMMENT '证件类型 1：身份证，2：驾驶证',
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `sex` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
  `id_card_status` int(11) NULL DEFAULT 0 COMMENT '身份证验证状态 0-未验证 1-验证成功 2-姓名不匹配 3-失败',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 417 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '购票人' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_coupon_combination
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_coupon_combination`;
CREATE TABLE `ods_wenti_coupon_combination`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '关联时间',
  `status` int(2) NOT NULL COMMENT '路径',
  `create_time` datetime NOT NULL COMMENT '备注',
  `update_time` datetime NULL DEFAULT NULL COMMENT '礼包名称',
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SCENETYPE',
  `reType` int(2) NULL DEFAULT NULL COMMENT '商户ID',
  `reSource` int(2) NULL DEFAULT NULL COMMENT 'ID',
  `res_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `re_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型描述',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '范围描述',
  `bgName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型',
  `scenetype` int(2) NULL DEFAULT NULL COMMENT '名称',
  `merchant_id` int(11) NULL DEFAULT 1 COMMENT '编码ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券组合表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_coupon_combination_ref
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_coupon_combination_ref`;
CREATE TABLE `ods_wenti_coupon_combination_ref`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `start_time` datetime NULL DEFAULT NULL COMMENT 'ID',
  `end_time` datetime NULL DEFAULT NULL COMMENT 'ID',
  `typeDes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商城TICKETTYPE',
  `rangeDes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商城票',
  `type` int(2) NULL DEFAULT NULL COMMENT '商城TICKETGRANULARITY',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '大麦颗粒度',
  `codeId` int(10) NULL DEFAULT NULL COMMENT '大麦类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 87 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券组合关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_coupon_grant
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_coupon_grant`;
CREATE TABLE `ods_wenti_coupon_grant`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '大麦PROJECTID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 527 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券发放表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_coupon_grant_ref
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_coupon_grant_ref`;
CREATE TABLE `ods_wenti_coupon_grant_ref`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '创建人姓名',
  `grantId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '优惠券发放id',
  `userid` int(11) NOT NULL COMMENT '用户id',
  `shareNum` int(11) NOT NULL COMMENT '已分享数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 91 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券发放关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_coupon_range
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_coupon_range`;
CREATE TABLE `ods_wenti_coupon_range`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `traningVenueId` int(10) NULL DEFAULT NULL COMMENT '培训基地id',
  `traningTypeId` int(10) NULL DEFAULT NULL COMMENT '培训类型id',
  `traningCourseId` int(10) NULL DEFAULT NULL COMMENT '培训课程id',
  `traningGranularity` int(1) NULL DEFAULT NULL COMMENT '培训颗粒度，1_所有培训，2_培训基地,3_培训类型，4_培训课程',
  `goodsTypeId` int(10) NULL DEFAULT NULL COMMENT '商品类型id',
  `goodsId` int(10) NULL DEFAULT NULL COMMENT '商品id',
  `goodsGranularity` int(1) NULL DEFAULT NULL COMMENT '商品颗粒度，1_所有商品，2_类型，3_商品',
  `venueId` int(10) NULL DEFAULT NULL COMMENT '场馆id',
  `venuType` int(1) NULL DEFAULT NULL COMMENT '场馆类型1_全部，2_订场，3_购票',
  `sportId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运动类型id',
  `ticketId` int(10) NULL DEFAULT NULL COMMENT '票id',
  `venueGranularity` int(1) NULL DEFAULT NULL COMMENT '场馆颗粒度,1_所有场馆，2_运动类型，2_单张票',
  `activityTypeId` int(10) NULL DEFAULT NULL COMMENT '活动类型id',
  `activityId` int(10) NULL DEFAULT NULL COMMENT '活动id',
  `activityGranularity` int(1) NULL DEFAULT NULL COMMENT '活动颗粒度1_所有活动，2_活动类型，3_单个活动',
  `couponId` int(10) NOT NULL COMMENT '优惠券码id',
  `mallTickettype` int(10) NULL DEFAULT NULL COMMENT 'ISTRUE',
  `mallTicket` int(10) NULL DEFAULT NULL COMMENT 'ID',
  `mallTicketgranularity` int(10) NULL DEFAULT NULL COMMENT 'IOSXIMG',
  `card_id` int(10) NULL DEFAULT NULL COMMENT '线上办卡id',
  `damai_granularity` int(10) NULL DEFAULT NULL COMMENT 'GMTCREATED',
  `damai_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ID',
  `damai_project_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 281 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券适用范围表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_coupon_receive
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_coupon_receive`;
CREATE TABLE `ods_wenti_coupon_receive`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '更新时间',
  `ref_id` int(10) NOT NULL COMMENT '创建人',
  `userid` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券领取表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_activity_statistics
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_activity_statistics`;
CREATE TABLE `ods_wenti_j_activity_statistics`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `activity_id` int(11) NOT NULL COMMENT '活动id',
  `activity_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动名称',
  `type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型名称',
  `type_id` int(11) NOT NULL COMMENT '类型id',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `tag1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  `tag2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 328 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_address
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_address`;
CREATE TABLE `ods_wenti_j_address`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sex` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人姓名',
  `phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `area_id` int(11) NULL DEFAULT NULL COMMENT '地区',
  `street_id` int(11) NULL DEFAULT NULL COMMENT '街道',
  `pca_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户ID',
  `detailed_address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_default` int(11) NULL DEFAULT 0 COMMENT '是否为默认地址（0：不是，1：是）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 382 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '收货地址' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_coupon
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_coupon`;
CREATE TABLE `ods_wenti_j_coupon`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '更新时间',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否删除D',
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
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'ID',
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '已读状态1为已读',
  `prize_record_id` int(11) NULL DEFAULT NULL COMMENT '奖品发放记录id',
  `discount` decimal(7, 2) NULL DEFAULT NULL COMMENT '折扣',
  `couponCodeType` int(10) NULL DEFAULT 1 COMMENT '优惠券类型',
  `userange` int(10) NULL DEFAULT 0 COMMENT '使用范围',
  `grantId` int(10) NOT NULL DEFAULT 1 COMMENT '优惠券发放id',
  `combinationId` int(10) NULL DEFAULT NULL COMMENT 'BASEID',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT 'ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 446483 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_coupon_code
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_coupon_code`;
CREATE TABLE `ods_wenti_j_coupon_code`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '创建人姓名',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
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
  `discount` decimal(7, 2) NULL DEFAULT NULL COMMENT '编码名称',
  `couponCodeType` int(10) NULL DEFAULT 1 COMMENT 'ID',
  `userange` int(2) NULL DEFAULT 0 COMMENT 'STUFF名称',
  `userangeDesc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '使用范围描述',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 406 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠码' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_coupon_recive
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_coupon_recive`;
CREATE TABLE `ods_wenti_j_coupon_recive`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'MAINID',
  `coupon_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `coupon_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠方式',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '状态0.上架 1.下架',
  `coupon_range` int(1) NOT NULL DEFAULT 0 COMMENT '优惠券使用范围',
  `coupon_start_time` datetime NULL DEFAULT NULL COMMENT '优惠券有效开始时间',
  `coupon_end_time` datetime NOT NULL COMMENT '优惠券有效结束时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编辑人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `coupon_id` int(11) NOT NULL COMMENT '优惠券id',
  `coupon_num` int(11) NOT NULL COMMENT '优惠券发放数量',
  `recive_num` int(11) NOT NULL DEFAULT 0 COMMENT '领取数量',
  `grant_id` int(11) NOT NULL COMMENT '创建时间',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT 'ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券领取表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_coupon_recive_city_ref
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_coupon_recive_city_ref`;
CREATE TABLE `ods_wenti_j_coupon_recive_city_ref`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '创建时间',
  `recive_id` int(11) NOT NULL COMMENT '领券中心id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券领取城市关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_coupon_recive_ref
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_coupon_recive_ref`;
CREATE TABLE `ods_wenti_j_coupon_recive_ref`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '问题ID',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `recive_id` int(11) NOT NULL COMMENT '领券id',
  `create_time` datetime NOT NULL COMMENT '活动ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 264 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '优惠券领取关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_id_card_check_record
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_id_card_check_record`;
CREATE TABLE `ods_wenti_j_id_card_check_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'id_card',
  `member_id` int(11) NOT NULL DEFAULT 0 COMMENT 'member_id',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'phone',
  `type` int(11) NULL DEFAULT 1 COMMENT '1 老人2少年',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `code` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '成功为200（10000），其它为失败状态码',
  `company_type` int(11) NULL DEFAULT 1 COMMENT 'compay_type 1 天眼 2网易 3数据宝',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'code对应的说明描述',
  `result` int(1) NULL DEFAULT 1 COMMENT '0 一致（收费），1 不一致（收费），2 无记录（收费）',
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
  `check_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '验证结果描述信息',
  `birthday` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生日',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '籍贯',
  `task_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '本次请求数据标识，可以根据该标识在控制台进行数据查询',
  `reason_type` int(1) NULL DEFAULT 1 COMMENT '	原因详情，1：认证通过 2：输入姓名和身份证号不一致 3：查无此身份证 7：结果获取失败，请重试',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '	认证结果，1：认证通过，2：认证不通过， 0：待定(原因参考下方reasonType字段)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 145 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '身份证件记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_intelligent_info
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_intelligent_info`;
CREATE TABLE `ods_wenti_j_intelligent_info`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_type` int(11) NULL DEFAULT 1 COMMENT '1 :个人中心身份认证页面, 2:游泳馆购票页面, 3:游泳馆办卡页面, 4:免费票领取页, 5:体检报告上传页，6：个人中心身份认证页面',
  `detail_type` int(11) NULL DEFAULT 1 COMMENT '1.储值卡 2.次卡 3.时段卡, 4:散票，5：团体票，6：免费票，7：',
  `member_id` int(11) NOT NULL COMMENT 'h_member id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '智慧场馆收集数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_member
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_member`;
CREATE TABLE `ods_wenti_j_member`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
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
) ENGINE = InnoDB AUTO_INCREMENT = 1379211 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_member_free_ticket
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_member_free_ticket`;
CREATE TABLE `ods_wenti_j_member_free_ticket`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
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
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '核销人',
  `admin_check` int(11) NULL DEFAULT NULL COMMENT '后台核销',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 829 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户免费票记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_member_order
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_member_order`;
CREATE TABLE `ods_wenti_j_member_order`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NULL DEFAULT NULL,
  `venue_id` int(64) NULL DEFAULT NULL COMMENT '场馆id',
  `sport_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运动项目id',
  `cost` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '应付费用,包括调价和服务费',
  `discount_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠费用',
  `deducted_card_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '专项卡抵扣类型(2011储值卡,2012储值专项,202次卡)',
  `deducted_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '专项卡已抵扣金额',
  `share_deducted_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '分摊剩余抵扣金额',
  `pay_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '实付费用=应付费用-优惠',
  `service_charge` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `order_num` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方支付订单号',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态 ：\r\n（订场/游泳票）订单状态取值:0:待支付 2:已支付,待使用  3:未支付,支付超时 4:已支付已使用待评价  5.已支付未使用已过期  6:已退款  7:已评价 8:用户取消订单\r\n\r\n（商品/演艺票/赛事票）订单状态取值: 30：已下单待支付，31：已取消，32：支付超时，33：已支付待发货，34：已支付待自取，35：已发货待收货，36：已收货待评价，37：已取票待评价，38：退款中，39：退款成功，40：退款失败，41：已完成，42：关闭订单',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型 1_套餐2_订场 3 游泳票 4商品 5演艺 6赛事 7（自营）演艺周边 8（自营）赛事周边 9（自营）其他商品 10找课程',
  `pay_way` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式   1、支付宝   2、微信 3、小程序',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `order_time` timestamp NULL DEFAULT NULL COMMENT '订场时间, 向后台发起请求并且订场成功',
  `pay_param` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '阿里支付参数',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `used_points` int(11) NULL DEFAULT NULL COMMENT '使用积分',
  `consignee` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `consignee_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省id',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市id',
  `area_id` int(11) NULL DEFAULT NULL COMMENT '区id',
  `pca_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省市区名称',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人地址',
  `id_card` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份證',
  `is_pay` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已支付',
  `is_refund` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已退款',
  `is_send` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已发货',
  `take_way` int(11) NULL DEFAULT 0 COMMENT '获取方式（0：快递，1：自取，2：电子票）',
  `take_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '自取地址',
  `status_time` timestamp NULL DEFAULT NULL COMMENT '状态时间',
  `sys_remark` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '（后台）订单备注',
  `handle` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已经统计过报表',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id(当为全国时为0)',
  `commission` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '手续费',
  `channel_discount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '渠道优惠',
  `j_merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `j_merchant_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '商户号',
  `asyn_division_flag` tinyint(1) NULL DEFAULT 0 COMMENT '0.无需异步分账 1.需要异步分账',
  `asyn_sure` tinyint(1) NULL DEFAULT NULL COMMENT '0.未确认异步分账 1.已确认异步分账',
  `is_new` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0.旧订单  1.新订单',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9799 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '我的套餐' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_member_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_member_order_detail`;
CREATE TABLE `ods_wenti_j_member_order_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `swim_ticket_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '游泳票描述',
  `swim_ticket_expire_date` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '游泳票有效期',
  `field_time_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订场时间描述',
  `field_num_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订场数量描述',
  `packages_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '套餐价格',
  `field_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '场地价格',
  `swim_ticket_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '游泳票价格',
  `user_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户购买备注',
  `take_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户取票备注',
  `close_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单关闭备注',
  `goods_take_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '搭配商品领取码',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4568 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员订单明细表 （只有游泳票！）看数据判断' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_member_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_member_order_refund`;
CREATE TABLE `ods_wenti_j_member_order_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `pay_way` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式',
  `refund_order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款单号',
  `refund_user` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款人',
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
  `check_user` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人员',
  `check_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `refuse_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `sup_is_refund` int(11) NULL DEFAULT NULL COMMENT '是否收到商户退款 0：否，1：是',
  `sup_refund_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '商户退款金额',
  `is_only_goods` tinyint(1) NULL DEFAULT 0 COMMENT '是否只退搭配',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `key.order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 172503 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员订单退款表（是否是多个平台的退款）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_member_third
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_member_third`;
CREATE TABLE `ods_wenti_j_member_third`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `third_type` int(2) NOT NULL COMMENT '第三方类型(1-微信,2-支付宝)',
  `third_source` int(2) NOT NULL COMMENT '第三方注册来源(1-小程序,2-微信公众号)',
  `third_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '第三方id(微信为openid)',
  `union_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方唯一id(微信为unionid)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 216 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员第三方登录绑定表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_member_time_card
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_member_time_card`;
CREATE TABLE `ods_wenti_j_member_time_card`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `card_id` int(11) NOT NULL COMMENT '闲时卡售卖id',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '卡状态 0_待激活 1_已激活 2_已过期',
  `expire_time` datetime NOT NULL COMMENT '卡过期时间',
  `stime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '可用时段开始时间',
  `etime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '可用时段结束时间',
  `type` int(11) NOT NULL COMMENT '卡类型',
  `limit_num` int(11) NOT NULL COMMENT '单日使用限制次数',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `discount_time` decimal(10, 2) NOT NULL COMMENT '单次使用可抵扣最大时长',
  `card_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员次卡表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_order_btp
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_order_btp`;
CREATE TABLE `ods_wenti_j_order_btp`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `btp_id` int(11) NULL DEFAULT NULL COMMENT '购票人id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单购票人关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_order_card_expense
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_order_card_expense`;
CREATE TABLE `ods_wenti_j_order_card_expense`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '订单号',
  `vip_card_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '专项卡id(与B端一致)',
  `vip_card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '专项卡号(与B端一致)',
  `card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '虚拟卡号(与B端一致)',
  `vip_card_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '专项卡类型(201-储值卡,202-次卡)',
  `deducted_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '已抵扣金额',
  `spend_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '卡已使用额度',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_cancel` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_icelandic_ci NOT NULL DEFAULT '0' COMMENT '是否取消(0-正常,1-已取消)',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '取消时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ORDER_NUM_INDEX`(`order_num`, `is_cancel`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 157 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '卡消费表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_order_coupon
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_order_coupon`;
CREATE TABLE `ods_wenti_j_order_coupon`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `coupon_id` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 692 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单优惠券表（是否是馆佳单独的优惠券）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_order_field
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_order_field`;
CREATE TABLE `ods_wenti_j_order_field`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `buss_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开场日期',
  `start_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开场时间',
  `end_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结束时间',
  `item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场地名称',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售单价(不包含服务费)',
  `ori_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原单价(不包含服务费)',
  `service_charge` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `cut_ratio` decimal(10, 2) NULL DEFAULT NULL COMMENT '平台抽成比例',
  `field_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场地id',
  `price_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '价格id',
  `push` int(3) NULL DEFAULT NULL COMMENT '是否已推送提示开场',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2078 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '已订场地' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_order_guanjia
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_order_guanjia`;
CREATE TABLE `ods_wenti_j_order_guanjia`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
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
) ENGINE = InnoDB AUTO_INCREMENT = 5961 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '馆佳的订单记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_order_ticket
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_order_ticket`;
CREATE TABLE `ods_wenti_j_order_ticket`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'B端卡ID',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `ticket_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '票号',
  `ticket_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '票名',
  `type` int(11) NULL DEFAULT NULL COMMENT '票类型,与B端use_condition保持一致',
  `ticket_type` int(11) NULL DEFAULT NULL COMMENT '1：成人单次 2:一大一小 3:两大一小',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `status` int(11) NULL DEFAULT NULL COMMENT '使用状态 0 未使用 1已使用 2已过期',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用说明',
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
) ENGINE = InnoDB AUTO_INCREMENT = 2057 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '游泳票生成表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_order_ticket_valid
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_order_ticket_valid`;
CREATE TABLE `ods_wenti_j_order_ticket_valid`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
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
-- Table structure for ods_wenti_j_platform_activity
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_platform_activity`;
CREATE TABLE `ods_wenti_j_platform_activity`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '活动名称',
  `category_id` int(11) NULL DEFAULT 0 COMMENT '活动分类id',
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '活动分类名称',
  `venue_id` int(11) NULL DEFAULT NULL,
  `venue_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '介绍',
  `pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '需支付金额',
  `free_sign` tinyint(1) NULL DEFAULT 0 COMMENT '是否免费',
  `least_nums` int(10) NULL DEFAULT 0 COMMENT '至少报名人数',
  `sign_up_nums` int(10) NULL DEFAULT 0 COMMENT '报名人数',
  `sign_up_attrs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '报名填报信息',
  `thumb_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '缩略图',
  `boostrap_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '首页图片',
  `list_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列表图片',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `sign_up_start_time` datetime NULL DEFAULT NULL COMMENT '报名开始时间',
  `sign_up_end_time` datetime NULL DEFAULT NULL COMMENT '报名结束时间',
  `release_start_time` datetime NULL DEFAULT NULL COMMENT '自行发布时间',
  `release_end_time` datetime NULL DEFAULT NULL COMMENT '自行下线时间',
  `activity_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '活动状态',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `district_id` int(11) NULL DEFAULT NULL COMMENT '区',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场馆地址',
  `longitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场馆经度',
  `latitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场馆纬度',
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
) ENGINE = InnoDB AUTO_INCREMENT = 213 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_platform_activity_bonus
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_platform_activity_bonus`;
CREATE TABLE `ods_wenti_j_platform_activity_bonus`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `bonus_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '奖品类型',
  `bonus_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '奖品名称',
  `bonus_id` int(10) NULL DEFAULT 0 COMMENT '奖品id',
  `bonus_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '奖品价值',
  `bonus_count` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '奖品数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 75 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名关联奖品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_platform_activity_category
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_platform_activity_category`;
CREATE TABLE `ods_wenti_j_platform_activity_category`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动分类名称',
  `sorted_num` int(11) NOT NULL DEFAULT 0 COMMENT '排序值',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_platform_activity_extra_attr
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_platform_activity_extra_attr`;
CREATE TABLE `ods_wenti_j_platform_activity_extra_attr`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attr_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '名称',
  `attr_enums` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '信息序列',
  `sorted_num` int(11) NULL DEFAULT 0 COMMENT '排序值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名信息项' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_platform_activity_gift_bag
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_platform_activity_gift_bag`;
CREATE TABLE `ods_wenti_j_platform_activity_gift_bag`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `gift_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '礼包名称',
  `gift_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '礼包单价',
  `gift_pic_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图片地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 260 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名关联礼包' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_platform_activity_goods
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_platform_activity_goods`;
CREATE TABLE `ods_wenti_j_platform_activity_goods`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `mall_goods_id` int(11) NULL DEFAULT 0 COMMENT '商超商品id',
  `mall_goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '商品名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 457 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名关联商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_platform_activity_person
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_platform_activity_person`;
CREATE TABLE `ods_wenti_j_platform_activity_person`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(10) NULL DEFAULT 0 COMMENT '活动id',
  `user_id` int(10) NULL DEFAULT 0 COMMENT '用户id',
  `account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称',
  `sign_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登记名称',
  `sign_phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登记手机号',
  `sign_card_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登记证件类型',
  `sign_card_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登记证件号',
  `sign_equip_size` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登记装备尺寸',
  `sign_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登记备注',
  `sign_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '报名状态',
  `sign_item_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '报名项目状态',
  `sign_gift_bag_id` int(10) NULL DEFAULT 0 COMMENT '礼包id',
  `due_pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '应支付金额',
  `pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实际支付金额',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `pay_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '支付状态 0-未支付 1-已支付 2-已退款 3-退款审核中',
  `sign_time` datetime NULL DEFAULT NULL COMMENT '报名时间',
  `free_sign` tinyint(1) NULL DEFAULT 0 COMMENT '是否免费',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '订单号',
  `mid` int(10) NULL DEFAULT NULL,
  `emergency_contact` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '紧急联系人',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 636 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动报名-报名者' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_points_records
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_points_records`;
CREATE TABLE `ods_wenti_j_points_records`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号',
  `points` bigint(11) NULL DEFAULT NULL COMMENT '积分值',
  `record_time` datetime NULL DEFAULT NULL COMMENT '记录时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `platform` int(11) NULL DEFAULT NULL COMMENT '0-一起吗 1-馆佳 2-乐火',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `merchant_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户名称',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场馆名称',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `unique_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '唯一识别id（如订单id，与此确保不会重复增加积分）',
  `goods_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '商品数量',
  `goods_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `goods_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品描述',
  `send_success` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否推送成功',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `send_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '推送结果',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27400 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员积分（获取和消费）记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_prize_detail
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_prize_detail`;
CREATE TABLE `ods_wenti_j_prize_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
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
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '奖品明细表（不对，给场馆寄票/优惠券？）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_report_check_record
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_report_check_record`;
CREATE TABLE `ods_wenti_j_report_check_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT 'h_member id',
  `venue_id` int(11) NOT NULL COMMENT 'venue_id id',
  `imgs` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片(多个用,隔开)',
  `uuid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'uuid',
  `id_card` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'id_card',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'phone',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `status` int(11) NULL DEFAULT 2 COMMENT ' 体检校验 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用',
  `urgent_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '紧急联系人',
  `urgent_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '紧急联系人电话',
  `face_images` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '人脸照片',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `report_expire_date` datetime NULL DEFAULT NULL COMMENT '体检有效期',
  `source` int(11) NOT NULL DEFAULT 0 COMMENT '用户来源 1app2后台录入',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 325 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '体检报告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_send_prize
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_send_prize`;
CREATE TABLE `ods_wenti_j_send_prize`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
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
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发放奖品记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_send_prize_record
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_send_prize_record`;
CREATE TABLE `ods_wenti_j_send_prize_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
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
) ENGINE = InnoDB AUTO_INCREMENT = 126 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '奖品发放记录表（发送目标用户，是否核销、已读等）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_time_card_use
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_time_card_use`;
CREATE TABLE `ods_wenti_j_time_card_use`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `card_id` int(11) NOT NULL COMMENT '用户卡id',
  `discount` decimal(10, 2) NOT NULL COMMENT '抵扣时长',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `venue_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '场馆名称',
  `open_time` datetime NOT NULL COMMENT '开场时间',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `order_time` datetime NOT NULL COMMENT '消费时间',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `status` int(11) NOT NULL COMMENT '0.未抵扣 1.已抵扣',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '次卡使用表（绑定卡id，不直接绑定用户）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_j_venue_reserve
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_j_venue_reserve`;
CREATE TABLE `ods_wenti_j_venue_reserve`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
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
-- Table structure for ods_wenti_p_park_customer
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_p_park_customer`;
CREATE TABLE `ods_wenti_p_park_customer`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名称',
  `user_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户手机号',
  `car_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车牌号',
  `is_yellow_car` tinyint(1) NULL DEFAULT NULL COMMENT '是否黄牌车',
  `is_new_enegry` tinyint(1) NULL DEFAULT NULL COMMENT '是否新能源车',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_virtual` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否无牌车生成的虚拟车牌',
  `certificate_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '无牌车生成的凭证号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_phone`(`user_phone`) USING BTREE COMMENT '用户手机号'
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '停车场客户表（只有一个场馆接入）' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
