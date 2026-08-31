/*
 Navicat Premium Dump SQL

 Source Server         : 06-7
 Source Server Type    : MySQL
 Source Server Version : 50736 (5.7.36)
 Source Host           : 192.168.112.101:3306
 Source Schema         : vmdb

 Target Server Type    : MySQL
 Target Server Version : 50736 (5.7.36)
 File Encoding         : 65001

 Date: 17/07/2026 17:42:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ods_wenti_gate_link_lock
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_gate_link_lock`;
CREATE TABLE `ods_wenti_gate_link_lock`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` int(11) NULL DEFAULT NULL COMMENT '1-开闸 2-租柜 3-还柜 4-出闸',
  `gate_open_time` datetime NULL DEFAULT NULL COMMENT '开闸时间',
  `gate_close_time` datetime NULL DEFAULT NULL COMMENT '出闸时间',
  `lock_open_time` datetime NULL DEFAULT NULL COMMENT '开柜时间',
  `lock_close_time` datetime NULL DEFAULT NULL COMMENT '还柜时间',
  `gate_open_from` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '入闸方式 1-吞卡 2-刷卡 3-二维码 4-人脸',
  `track_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '二维码字符串',
  `out_track_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出闸二维码',
  `registed_palm` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否注册了掌纹',
  `gate_close_from` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出闸方式',
  `registed_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '注册掌纹设备',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '闸机租柜联动记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_card
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_card`;
CREATE TABLE `ods_wenti_h_card`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `card_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '卡号',
  `card_track` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '卡磁道',
  `card_status` int(11) NOT NULL COMMENT ' 卡状态（0.未使用，1.已使用）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_user_id` int(11) NULL DEFAULT NULL COMMENT '创建人id',
  `up_user_id` int(11) NULL DEFAULT NULL COMMENT '修改人id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `channel` int(10) NULL DEFAULT 1 COMMENT '数据来源渠道，1：pc，2：app，注意：与h_member_record表取值不一致',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `card_code_merchant_unique`(`merchant_id`, `card_code`) USING BTREE COMMENT '商户下卡号不能重复',
  UNIQUE INDEX `card_track_merchant_unique`(`merchant_id`, `card_track`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 119670 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '实体卡表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_card_vip
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_card_vip`;
CREATE TABLE `ods_wenti_h_card_vip`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `card_id` int(11) NOT NULL COMMENT '关联实体卡id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `is_valid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否消费验证',
  `is_work_cost` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否收取工本费',
  `order_num` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单号',
  `model_type` int(2) NULL DEFAULT NULL COMMENT '收费类型（1.办卡工本费 2.补卡工本费）',
  `is_main` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为主卡',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否可用（0停用 1可用）',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `last_enter_gate_date` datetime NULL DEFAULT '1999-12-01 00:00:00' COMMENT '最后一次入闸时间',
  `gmt_create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_create_user` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建人',
  `gmt_update_user` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人',
  `gmt_update_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `MEMBER_ID`(`member_id`) USING BTREE,
  INDEX `CARD_ID`(`card_id`) USING BTREE,
  INDEX `MERCHANT_ID`(`merchant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 81628 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员卡(实体卡绑定)表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_id_card_check_record
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_id_card_check_record`;
CREATE TABLE `ods_wenti_h_id_card_check_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'id_card',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'phone',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'user_name',
  `type` int(11) NULL DEFAULT 1 COMMENT '1 老人2少年',
  `code` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '成功为200（10000），其它为失败状态码',
  `company_type` int(11) NULL DEFAULT 1 COMMENT 'compay_type 1 天眼 2网易 3数据宝',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'code对应的说明描述',
  `result` int(1) NOT NULL DEFAULT 1 COMMENT '1-一致，2-不一致，3：异常情况',
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '	订单号',
  `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别',
  `check_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '验证结果描述信息',
  `birthday` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '	生日',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '	籍贯',
  `task_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '本次请求数据标识，可以根据该标识在控制台进行数据查询',
  `reason_type` int(1) NULL DEFAULT 1 COMMENT '	原因详情，1：认证通过 2：输入姓名和身份证号不一致 3：查无此身份证 7：结果获取失败，请重试',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '	认证结果，1：认证通过，2：认证不通过',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `source` int(11) NULL DEFAULT 1 COMMENT '来源 1:馆佳pc 2:一起吗',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 184 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'id_card校验表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_member
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_member`;
CREATE TABLE `ods_wenti_h_member`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `sex` int(11) NULL DEFAULT NULL COMMENT '性别（0女 1男）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '会员折扣',
  `card_id` int(11) NULL DEFAULT NULL COMMENT '关联实体卡id',
  `id_card` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号码',
  `birthday` datetime NULL DEFAULT NULL COMMENT '出生日期',
  `remarks` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '照片',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user_id` int(11) NOT NULL COMMENT '创建人员id',
  `up_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `up_user_id` int(11) NOT NULL COMMENT '修改人员id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `is_valid` tinyint(1) NULL DEFAULT 0 COMMENT '是否消费验证',
  `is_work_cost` tinyint(1) NULL DEFAULT 0 COMMENT '是否收取工本费',
  `order_num` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `model_type` int(2) NULL DEFAULT NULL COMMENT '收费类型（1.办卡工本费 2.补卡工本费）',
  `channel` int(10) NULL DEFAULT 1 COMMENT '数据来源渠道，1：pc，2：app',
  `is_success` tinyint(1) NULL DEFAULT 0 COMMENT '线上开卡是否注册成功（只对线上开卡有用）',
  `urgent_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '紧急联系人',
  `urgent_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '紧急联系人电话',
  `is_face_enable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '人脸是否可用 0-不可用 1-可用',
  `id_card_create_time` datetime NULL DEFAULT NULL COMMENT 'id_card上传时间',
  `report_create_time` datetime NULL DEFAULT NULL COMMENT '体检上传时间',
  `id_card_check` int(11) NULL DEFAULT 1 COMMENT ' id_card校验 1：未校验，2：已校验，3：过期，4：禁用',
  `id_card_expire_date` datetime NULL DEFAULT NULL COMMENT 'id_card有效期',
  `report_expire_date` datetime NULL DEFAULT NULL COMMENT '体检有效期',
  `report_check` int(11) NULL DEFAULT 1 COMMENT ' 体检校验 1：未上传， 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用',
  `signature` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '签名',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `merchant_phone_unique`(`merchant_id`, `phone`) USING BTREE,
  INDEX `card_id`(`card_id`) USING BTREE,
  INDEX `venue_id`(`venue_id`) USING BTREE,
  INDEX `create_user_id`(`create_user_id`) USING BTREE,
  INDEX `up_user_id`(`up_user_id`) USING BTREE,
  INDEX `phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 86803 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_member_card
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_member_card`;
CREATE TABLE `ods_wenti_h_member_card`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `card_vip_id` int(11) NULL DEFAULT NULL COMMENT '会员实体卡id',
  `balance` decimal(10, 2) NULL DEFAULT NULL COMMENT '余额/次',
  `present_balance` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '赠送余额',
  `start_effect_date` datetime NOT NULL COMMENT '开始有效期（创建日期）',
  `end_effect_date` datetime NOT NULL COMMENT '结束有效期（有效期至）',
  `status` int(11) NOT NULL COMMENT '状态（1.正常 2.停用 3.过期）',
  `card_sales_id` int(11) NOT NULL COMMENT '售卡id',
  `update_date` datetime NOT NULL COMMENT '修改时间',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_user_id` int(11) NOT NULL COMMENT '修改人',
  `create_user_id` int(11) NOT NULL COMMENT '创建人',
  `enable_date` datetime NULL DEFAULT NULL COMMENT '启用日期',
  `sluice_priority` tinyint(1) NOT NULL DEFAULT 0 COMMENT '入闸优先级（是否优先）',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `is_active` int(11) NOT NULL DEFAULT 0 COMMENT '是否激活（0未激活 1已激活）一起吗端使用',
  `last_end_effect_date` datetime NULL DEFAULT NULL COMMENT '记录修改前的有效期',
  `channel` int(10) NULL DEFAULT 1 COMMENT '数据来源渠道，1：pc，2：app',
  `owe_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否欠费',
  `prepaid_balance` decimal(10, 2) NULL DEFAULT NULL COMMENT '预收入余额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `member_card_index`(`member_id`, `card_sales_id`) USING BTREE,
  INDEX `card_index`(`card_vip_id`) USING BTREE,
  INDEX `venue_id`(`venue_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 68216 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员专项卡表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_member_card_refund
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_member_card_refund`;
CREATE TABLE `ods_wenti_h_member_card_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '会员id',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 0-审核中 1-审核通过 2-审核拒绝 3-已退款 4-已同意',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `apply_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申请手机号',
  `item_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名称',
  `refund_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `actual_refund_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '实际退款金额',
  `bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行名称',
  `bank_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行卡号',
  `bank_card_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行卡照片',
  `account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户名',
  `id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `id_card_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证照片',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_user_id` int(11) NULL DEFAULT NULL COMMENT '更新人',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `update_material` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否更新材料',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员卡退款申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_member_charge
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_member_charge`;
CREATE TABLE `ods_wenti_h_member_charge`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `card_vip_id` int(11) NULL DEFAULT NULL COMMENT '会员实体卡id',
  `card_sales_id` int(11) NOT NULL COMMENT '售卡id',
  `enable_date` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '启用日期',
  `recharge_numoramount` decimal(10, 2) NULL DEFAULT NULL COMMENT '充值金额/次',
  `present_numoramount` decimal(10, 2) NULL DEFAULT NULL COMMENT '赠送金额/次',
  `sell_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '售价',
  `order_num` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `is_used` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已使用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3132 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员充值记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_member_deducted
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_member_deducted`;
CREATE TABLE `ods_wenti_h_member_deducted`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `is_cancel` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否取消',
  `member_card_id` int(11) NOT NULL COMMENT '专项卡id',
  `deductedQuato` decimal(10, 2) NOT NULL COMMENT '抵扣额度',
  `order_num` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1134 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员卡抵扣记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_member_record
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_member_record`;
CREATE TABLE `ods_wenti_h_member_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_card_id` int(11) NOT NULL COMMENT '专项卡记录id',
  `type` int(11) NOT NULL COMMENT '类型（0.记账,1.退款 2.消费 3.充值）',
  `order_num` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '使用折扣',
  `amount_or_num` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额/次',
  `present` decimal(10, 2) NULL DEFAULT NULL COMMENT '赠送',
  `present_consume` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '赠送消费',
  `balance` decimal(10, 2) NULL DEFAULT NULL COMMENT '余额/次',
  `present_balance` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '赠送余额',
  `channel` int(11) NULL DEFAULT NULL COMMENT '渠道（1.网络 2.线下），注意：该字段与其他表取值不一致',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `op_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `op_user_id` int(11) NULL DEFAULT NULL COMMENT '操作人员id',
  `sell_price` decimal(13, 2) NULL DEFAULT NULL COMMENT '售价',
  `pay_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `consume_type` int(10) NULL DEFAULT 1 COMMENT '消费类型(0.记账,1.抵扣 2.签到 3.入闸)',
  `last_card_end_effect_date` datetime NULL DEFAULT NULL COMMENT '专项卡上一次有效期记录',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `status_time` datetime NULL DEFAULT NULL COMMENT '状态时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `member_card_id`(`member_card_id`) USING BTREE,
  INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7175 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员卡消费/充值流水表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for ods_wenti_h_member_report_approval
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_member_report_approval`;
CREATE TABLE `ods_wenti_h_member_report_approval`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '会员id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '证件号码',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '状态 1：未上传， 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用 ',
  `valid_date` datetime NULL DEFAULT NULL COMMENT '有效期',
  `approval_user_id` int(11) NULL DEFAULT NULL COMMENT '审核人id',
  `approval_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `attachment` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `uuid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'uuid',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user_id` int(11) NULL DEFAULT NULL COMMENT '创建人员id',
  `create_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `update_user_id` int(11) NULL DEFAULT NULL COMMENT '修改人员id',
  `update_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `source` int(11) NULL DEFAULT 1 COMMENT '来源 1:馆佳pc 2:一起吗',
  `is_deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `urgent_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '紧急联系人',
  `urgent_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '紧急联系人电话',
  `face_images` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '人脸照片',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `member_report_approval_query`(`merchant_id`, `venue_id`, `member_id`) USING BTREE,
  INDEX `member_report_approval_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户体检报告审核' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_enter_gate
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_enter_gate`;
CREATE TABLE `ods_wenti_m_enter_gate`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `type` int(11) NOT NULL COMMENT '1.单次卡 2.次卡 3.场次卡 4.二维码 5.时段卡 6.管理卡',
  `qr_code_type` int(11) NULL DEFAULT NULL COMMENT '二维码类型 1.散票 2.团体票 3.通票',
  `card_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '卡名',
  `item_id` int(11) NULL DEFAULT NULL COMMENT '不同类型对应不同id',
  `card_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '卡号/二维码',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `gate_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '闸机名',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `status` int(11) NOT NULL COMMENT '状态 1.正常  2.已撤回',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2432 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '入闸记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_group_ticket_no
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_group_ticket_no`;
CREATE TABLE `ods_wenti_m_group_ticket_no`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `sale_id` int(11) NULL DEFAULT NULL COMMENT '销售记录id',
  `pregeneration_id` int(11) NULL DEFAULT NULL COMMENT '预生成记录id',
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '票号',
  `random_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '随机码',
  `remain_num` int(11) NOT NULL COMMENT '剩余核销次数',
  `verify_num` int(11) NOT NULL DEFAULT 0 COMMENT '前台核销次数',
  `bingding_status` int(1) NOT NULL DEFAULT 0 COMMENT 'C端绑定状态 1：已绑定',
  `bingding_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'C端绑定绑定手机号',
  `enter_gate_num` int(11) NOT NULL DEFAULT 0 COMMENT '入闸核销次数',
  `status` int(11) NOT NULL COMMENT '状态 0：未激活 1：已激活 2：已使用 3：部分使用 4.已过期',
  `verify_time` datetime NULL DEFAULT NULL COMMENT '首次核销时间',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '是否已读',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_no`(`ticket_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 305739 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '团体票号表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_group_ticket_sale
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_group_ticket_sale`;
CREATE TABLE `ods_wenti_m_group_ticket_sale`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `ticket_id` int(11) NOT NULL COMMENT '团体票id',
  `ticket_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '团体票名',
  `ticket_type` int(11) NULL DEFAULT NULL COMMENT '1:单次票',
  `sport_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运动类型',
  `total` int(11) NOT NULL COMMENT '销售数量',
  `used` int(11) NULL DEFAULT 0 COMMENT '已使用数量',
  `status` int(11) NULL DEFAULT NULL COMMENT '票号状态 1：生成中 2：已生成',
  `price` decimal(20, 2) NULL DEFAULT NULL COMMENT '单价（折前）',
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否显示',
  `expire_date` date NULL DEFAULT NULL COMMENT '过期日期',
  `sale_way` int(11) NULL DEFAULT NULL COMMENT '销售方式 1：电子 2：纸质',
  `start_ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开始票号',
  `end_ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '结束票号',
  `sale_employee_id` int(11) NULL DEFAULT NULL COMMENT '销售人id',
  `sale_employee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '销售人名',
  `download_employee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最近下载人',
  `download_time` datetime NULL DEFAULT NULL COMMENT '最近下载时间',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `give_total` int(11) NOT NULL DEFAULT 0 COMMENT '赠送数量',
  `start_date` date NULL DEFAULT NULL COMMENT '开始日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1493 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '团体票销售记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_group_ticket_verify
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_group_ticket_verify`;
CREATE TABLE `ods_wenti_m_group_ticket_verify`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `ticket_no_id` int(11) NOT NULL COMMENT 'm_group_ticket_no id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_no`(`ticket_no_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 259 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '团体票号核销记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order`;
CREATE TABLE `ods_wenti_m_trade_order`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `order_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单类型',
  `order_type_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单类型名称',
  `order_item_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单项目类型',
  `is_account_business` tinyint(1) NULL DEFAULT 0 COMMENT '是否记账订单',
  `is_new_card` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为新卡(仅充值有效)',
  `order_ticket_type` int(11) NULL DEFAULT NULL COMMENT '售票订单票务类型 1：散票 2：团体票',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '会员id',
  `card_vip_id` int(11) NULL DEFAULT NULL COMMENT '会员vipId',
  `customer_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '客户手机号',
  `customer_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '客户名称',
  `sport_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '运动id',
  `sport_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '运动名称',
  `preorder_time` date NULL DEFAULT NULL COMMENT '预定日期',
  `order_time` datetime NULL DEFAULT NULL COMMENT '下单时间',
  `order_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下单备注',
  `order_quantity` int(11) NULL DEFAULT NULL COMMENT '订单数量',
  `order_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '订单金额',
  `merchant_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '商家优惠金额',
  `landlord_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '租主优惠金额',
  `deducted_card_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '抵扣卡类型',
  `deducted_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣金额',
  `deducted_prepaid_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣预收入金额(属于抵扣金额一部分)',
  `deducted_quato` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣额度',
  `list_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用于C端列表展示的一些数据',
  `pay_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `order_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单状态',
  `status_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '状态时间',
  `consume_time` datetime NULL DEFAULT NULL COMMENT '消费时间',
  `pay_way` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付方式',
  `is_mini_app_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否为小程序支付(兼容微信)',
  `pay_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '付款备注',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '付款时间',
  `pay_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付流水号',
  `origin_type` tinyint(1) NULL DEFAULT 0 COMMENT '来源类型(是否C端订单)',
  `fail_pay_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '付款失败备注',
  `cancel_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '取消备注',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '场馆名称',
  `mechant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `mechant_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '商户名称',
  `operator_id` int(11) NULL DEFAULT NULL COMMENT '操作id',
  `operator_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人名称',
  `is_hidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否查询隐藏',
  `is_discount` tinyint(1) NULL DEFAULT 0 COMMENT '是否需要输入折扣',
  `evaluated` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已评价',
  `is_switch` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已换场',
  `is_book_field` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是场地预定订单',
  `is_invoice` tinyint(1) NULL DEFAULT 0 COMMENT '是否已开发票',
  `link_order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '关联订单号',
  `team_bargain_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '拼团砍价优惠金额',
  `due_pay_amount` decimal(13, 2) NULL DEFAULT NULL COMMENT '实收金额',
  `is_update_status` tinyint(1) NULL DEFAULT NULL COMMENT '是否已更新状态（未付款、支付超时、系统自动退款、取消订单操作）',
  `hour_card_deducted` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '一起吗小时卡抵扣金额',
  `member_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '一起吗会员优惠金额',
  `leisure_card_deducted` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '一起吗闲时卡抵扣金额',
  `commission_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抽成金额',
  `base_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抽成门槛金额',
  `commission_percent` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抽成金额百分比',
  `data_type` int(10) NULL DEFAULT 2 COMMENT '1:老数据，2：新数据',
  `channel_discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '渠道优惠',
  `third_paid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否通过第三方支付',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE,
  INDEX `ik_merchant_id`(`mechant_id`) USING BTREE,
  INDEX `ik_link_order_num`(`link_order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2350979 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '交易订单主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_coupon
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_coupon`;
CREATE TABLE `ods_wenti_m_trade_order_coupon`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单号',
  `customer_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户手机号',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `coupon_id` int(11) NOT NULL COMMENT '商户优惠券id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `coupon_id`(`coupon_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 90 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '交易订单-优惠券使用表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_detail`;
CREATE TABLE `ods_wenti_m_trade_order_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `fee_item_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '消费项目类型(与订单类型一致,已废)',
  `item_id` int(10) NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '项目名称',
  `start_time` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '开始时间',
  `end_time` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '结束时间',
  `quantity` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '数量',
  `price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '单价',
  `merchant_discount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '商家优惠金额',
  `landlord_discount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '租主优惠金额',
  `due_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '应付合计',
  `amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '合计',
  `stat_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '统计标志',
  `market_id` int(11) NULL DEFAULT NULL COMMENT '商品收银时-商超id',
  `goods_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '商品收银时-商品成本金额',
  `is_new_card` tinyint(1) NULL DEFAULT 0 COMMENT '是否为新卡(仅充值有效)',
  `goods_receiver_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '批次号',
  `goods_sale_tax` decimal(12, 2) NULL DEFAULT NULL COMMENT '税率',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20648 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '交易订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_field
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_field`;
CREATE TABLE `ods_wenti_m_trade_order_field`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `order_detail_id` int(11) NULL DEFAULT 0 COMMENT '订单详情id',
  `field_detail_id` int(11) NOT NULL COMMENT '场地详情id',
  `field_id` int(11) NOT NULL COMMENT '场地id',
  `field_date` date NOT NULL COMMENT '预定日期',
  `field_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单场地状态',
  `customer_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '客户手机号',
  `customer_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '客户名称',
  `customer_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '客户预定备注',
  `locked_item` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '锁场项目',
  `locked_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '锁场备注',
  `origin_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '来源类型(是否C端订单)',
  `start_time` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开始时间',
  `end_time` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '结束时间',
  `fixed_id` int(11) NULL DEFAULT NULL COMMENT '固定场记录id',
  `lock_status` tinyint(1) NULL DEFAULT 0 COMMENT '锁场是否已收款',
  `type` int(2) NOT NULL DEFAULT 1 COMMENT '预定类型（0.会员预定 1.散客 2.票券）',
  `card_vip_id` int(11) NULL DEFAULT NULL COMMENT '会员卡id',
  `card_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '会员卡号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `detail_id_date_unique`(`field_detail_id`, `field_date`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55897 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易订单-场地预定表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_field_gate
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_field_gate`;
CREATE TABLE `ods_wenti_m_trade_order_field_gate`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `remain_num` int(11) NULL DEFAULT NULL COMMENT '剩余核销次数',
  `verify_num` int(11) NOT NULL DEFAULT 0 COMMENT '前台核销次数',
  `enter_gate_num` int(11) NOT NULL DEFAULT 0 COMMENT '入闸核销次数',
  `first_verify_time` datetime NULL DEFAULT NULL COMMENT '首次核销时间',
  `status` int(11) NULL DEFAULT NULL COMMENT '0:未使用 1:已使用 2:已过期 3:已退款',
  `field_id` int(11) NULL DEFAULT NULL COMMENT '场地id',
  `end_time` datetime NULL DEFAULT NULL COMMENT '有效使用过期结束时间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '有效使用过期开始时间',
  `door_enter_device` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '门禁可用设备',
  `door_remain_num` int(11) NULL DEFAULT NULL COMMENT '门禁可用次数',
  `door_enter_num` int(11) NULL DEFAULT NULL COMMENT '门禁进入次数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 612 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易订单-场地入闸核销表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_pay
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_pay`;
CREATE TABLE `ods_wenti_m_trade_order_pay`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单号',
  `pay_catetory` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付类别(1:CASH,2:卡,3:票)',
  `pay_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '支付类型',
  `pay_entity_id` int(11) NULL DEFAULT 0 COMMENT '支付实体id',
  `pay_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '支付金额',
  `pay_quota` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '支付额度',
  `pay_third_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '第三方支付流水号',
  `valid_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '卡对应价值',
  `refund_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '退款单号',
  `is_main_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否为主要支付',
  `is_refund` tinyint(1) NULL DEFAULT 0 COMMENT '是否退款',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ORDER_NUM`(`order_num`) USING BTREE,
  INDEX `REFUND_NUM`(`refund_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13310 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '交易订单支付表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_refund`;
CREATE TABLE `ods_wenti_m_trade_order_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `refund_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '退款单号',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `is_mini_app_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否为小程序支付(兼容微信)',
  `pay_way` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '支付方式',
  `refund_user_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退款人',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_trade_no` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '第三方退款流水号',
  `refund_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `deducted_card_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '抵扣卡类型',
  `deducted_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣金额',
  `deducted_quato` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣额度',
  `refund_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退款备注',
  `refund_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退款方式',
  `refund_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '退款参数',
  `refund_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '第三方返回响应',
  `fail_reason` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '第三方退款失败原因',
  `refund_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退款状态',
  `is_success` tinyint(1) NULL DEFAULT 0 COMMENT '退款是否成功',
  `audit_advise` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '审核意见',
  `audit_operator` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '审核人',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3894 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易订单退款表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_refund_offline
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_refund_offline`;
CREATE TABLE `ods_wenti_m_trade_order_refund_offline`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `refund_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '退款单号',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `pay_way` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '支付方式',
  `pay_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `refund_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退款备注',
  `refund_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退款方式',
  `order_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '订单类型',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '场馆名称',
  `refund_status` int(11) NULL DEFAULT 1 COMMENT '退款状态(1:成功，2：删除)',
  `audit_advise` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '审核意见',
  `audit_operator` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '审核人',
  `audit_id` int(11) NULL DEFAULT NULL COMMENT '审核人',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2911 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易订单线下退款表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_ticket
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_ticket`;
CREATE TABLE `ods_wenti_m_trade_order_ticket`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `ticket_id` int(11) NOT NULL COMMENT '散票id',
  `ticket_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '散票名',
  `ticket_attr` int(11) NULL DEFAULT NULL COMMENT '属性，1：成人 2：儿童 3：学生 4：老人 5：套票',
  `sport_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运动类型id',
  `num` int(11) NOT NULL COMMENT '数量',
  `price` decimal(20, 2) NULL DEFAULT NULL COMMENT '单价（折前）',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4917 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '散票订单详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_ticket_no
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_ticket_no`;
CREATE TABLE `ods_wenti_m_trade_order_ticket_no`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `order_ticket_id` int(11) NULL DEFAULT NULL COMMENT '订单售票id',
  `ticket_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '票号',
  `remain_num` int(11) NULL DEFAULT NULL COMMENT '剩余核销次数',
  `verify_num` int(11) NOT NULL DEFAULT 0 COMMENT '前台核销次数',
  `enter_gate_num` int(11) NOT NULL DEFAULT 0 COMMENT '入闸核销次数',
  `first_verify_time` datetime NULL DEFAULT NULL COMMENT '首次核销时间',
  `status` int(11) NULL DEFAULT NULL COMMENT '0:未使用 1:已使用 2:已过期 3:已退款',
  `expire_date` date NULL DEFAULT NULL COMMENT '有效使用过期结束时间',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读',
  `expire_start_date` date NULL DEFAULT NULL COMMENT '有效使用过期开始时间',
  `customer_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '客户手机号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_no`(`ticket_no`) USING BTREE,
  INDEX `ik_order_ticket_id`(`order_ticket_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3232 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '散票票号表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_ticket_verify
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_ticket_verify`;
CREATE TABLE `ods_wenti_m_trade_order_ticket_verify`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_ticket_no_id` int(11) NOT NULL COMMENT '散票票号id',
  `ticket_attr` int(11) NULL DEFAULT NULL COMMENT '属性，1：成人 2：儿童 3：学生 4：老人',
  `verify_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `is_verify` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已核销',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_no`(`order_ticket_no_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4783 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '散票核销表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_venue_customer
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_venue_customer`;
CREATE TABLE `ods_wenti_m_venue_customer`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `type` int(11) NOT NULL COMMENT '用户类型 1.非会员 2。场馆会员',
  `consume_num` int(11) NOT NULL DEFAULT 0 COMMENT '消费次数',
  `channel` int(11) NOT NULL COMMENT '渠道  1.B端  2.C端',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `last_consume_time` datetime NOT NULL COMMENT '最后消费时间',
  `register_time` datetime NULL DEFAULT NULL COMMENT '注册时间',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 797 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '场馆顾客表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_p_park_record
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_p_park_record`;
CREATE TABLE `ods_wenti_p_park_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `park_order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方停车订单号',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `merchant_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户名称',
  `is_member` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否是会员',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名称',
  `user_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户手机号',
  `car_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车牌号',
  `creat_time` datetime NULL DEFAULT NULL COMMENT '计费时间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '入场时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '离场时间',
  `park_time` int(11) NULL DEFAULT NULL COMMENT '停车时长',
  `park_time_format` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '停车时长',
  `pay_way` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式',
  `order_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '计费金额',
  `merchant_discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '商户优惠金额',
  `deducted_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '储值卡抵扣金额',
  `pay_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '实收金额',
  `third_total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '第三方总金额',
  `valid_time_len` int(11) NULL DEFAULT NULL COMMENT '有效支付时长秒数',
  `free_minute` int(11) NULL DEFAULT NULL COMMENT '免费时长分钟数',
  `pay_status` tinyint(1) NOT NULL COMMENT '0-未支付 1-已经支付',
  `ticket_id` int(11) NULL DEFAULT NULL COMMENT '停车券id',
  `deducted_hour` decimal(10, 1) NULL DEFAULT NULL COMMENT '抵扣时长',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_order_num`(`order_num`) USING BTREE COMMENT '订单号',
  INDEX `idx_phone`(`user_phone`) USING BTREE COMMENT '用户手机号'
) ENGINE = InnoDB AUTO_INCREMENT = 708 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '停车记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_p_park_ticket
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_p_park_ticket`;
CREATE TABLE `ods_wenti_p_park_ticket`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '临取券时生成的券码',
  `config_id` int(11) NOT NULL COMMENT '发券配置id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '停车券名',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `merchant_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户名称',
  `channel` tinyint(1) NOT NULL DEFAULT 0 COMMENT '渠道 0：线下，1：线上',
  `scene` tinyint(1) NOT NULL DEFAULT 0 COMMENT '发放场景，0：线下， 1：订场，2：售票，3：刷卡',
  `deducted_hour` decimal(10, 1) NOT NULL DEFAULT 0.0 COMMENT '抵扣时长',
  `is_member` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否会员， 0：否， 1：是',
  `user_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号',
  `car_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车牌号',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态 0：未使用  1：已使用  2：已过期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `service_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `soure_order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '停车券来源订单号',
  `soure_ticket_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '停车券来源票号',
  `soure_member_card_id` int(11) NULL DEFAULT NULL COMMENT '停车券来源卡号',
  `source_give_detail_id` int(11) NULL DEFAULT NULL COMMENT '赠送详情id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除 0：未删除 1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 275 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '停车券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_p_park_ticket_give_record
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_p_park_ticket_give_record`;
CREATE TABLE `ods_wenti_p_park_ticket_give_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '停车券码',
  `config_id` int(11) NOT NULL COMMENT '停车券配置id',
  `old_ticket_id` int(11) NULL DEFAULT NULL COMMENT '旧停车券id',
  `new_ticket_id` int(11) NULL DEFAULT NULL COMMENT '新停车券id',
  `create_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '赠送人手机号',
  `receive_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接收人手机号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '停车券赠送记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_sale_channel
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_sale_channel`;
CREATE TABLE `ods_wenti_theatre_sale_channel`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '分享者id',
  `phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分享者手机号',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `item_id` int(11) NOT NULL COMMENT '项目id',
  `item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名',
  `com_id` int(11) NULL DEFAULT NULL COMMENT '机构id',
  `com_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '机构编码',
  `wxacode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '小程序码',
  `source` int(11) NULL DEFAULT NULL COMMENT '来源，1-一起吗 2-剧院小程序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-分销' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_sale_channel_detail
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_sale_channel_detail`;
CREATE TABLE `ods_wenti_theatre_sale_channel_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `channel_id` int(11) NOT NULL COMMENT '分销渠道id',
  `channel_user_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分享者手机号',
  `channel_source` int(11) NULL DEFAULT NULL COMMENT '渠道来源',
  `channel_com_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '渠道公司名称',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `item_id` int(11) NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名称',
  `sell_id` int(11) NULL DEFAULT NULL COMMENT '场次id',
  `sell_start_time` datetime NULL DEFAULT NULL COMMENT '场次开始时间',
  `sell_end_time` datetime NULL DEFAULT NULL COMMENT '场次结束时间',
  `order_user_phone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下单用户手机号',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `status` int(11) NULL DEFAULT NULL COMMENT '订单状态',
  `order_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '订单金额',
  `pay_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '支付金额',
  `commission_ratio` int(11) NULL DEFAULT NULL COMMENT '佣金比例',
  `commission_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '佣金金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-场次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_ticket_discount
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_ticket_discount`;
CREATE TABLE `ods_wenti_theatre_ticket_discount`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `area_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '座位区域',
  `min_number` int(11) NULL DEFAULT NULL COMMENT '最少张数',
  `discount` decimal(2, 1) NULL DEFAULT NULL COMMENT '折扣',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 247 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-座位区折扣表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_ticket_item
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_ticket_item`;
CREATE TABLE `ods_wenti_theatre_ticket_item`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆',
  `venue_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场馆名',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目名',
  `longitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '经度',
  `latitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '维度',
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '缩略图',
  `info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '详情',
  `remind` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '须知',
  `is_deleted` tinyint(1) NULL DEFAULT NULL COMMENT '是否删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `third_project_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方项目id',
  `third_project_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方项目类型',
  `choose_seat_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否选座',
  `type` int(11) NOT NULL DEFAULT 1 COMMENT '项目类型 1-演艺 2-赛事',
  `banner_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'banner图片',
  `recommended_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '推荐图',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-演出项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_ticket_lock_log
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_ticket_lock_log`;
CREATE TABLE `ods_wenti_theatre_ticket_lock_log`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `sell_detail_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '售票明细id列表',
  `ticket_num` int(1) NULL DEFAULT NULL COMMENT '票数',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型 0-解锁 -1-锁定',
  `seat_info` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '座位信息',
  `sell_info` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场次信息',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `operator` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sell_id`(`sell_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-场次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_ticket_price
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_ticket_price`;
CREATE TABLE `ods_wenti_theatre_ticket_price`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `area_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '座位区域',
  `colour` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `plan_id` int(11) NULL DEFAULT NULL COMMENT '方案id',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `stock` int(10) NULL DEFAULT NULL COMMENT '无座时表示数量',
  `remaining_stock` int(10) NULL DEFAULT NULL COMMENT '剩余数量',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 227 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-座位区票价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_ticket_seat
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_ticket_seat`;
CREATE TABLE `ods_wenti_theatre_ticket_seat`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `seat_id` int(11) NULL DEFAULT NULL COMMENT '座位id',
  `num_x` int(11) NULL DEFAULT NULL COMMENT 'Y轴',
  `col_no` int(11) NULL DEFAULT NULL COMMENT '列号',
  `num_y` int(11) NULL DEFAULT NULL COMMENT 'X轴',
  `row_no` int(11) NULL DEFAULT NULL COMMENT '行号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '座位名',
  `area_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '价格分区',
  `is_side` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否间隔',
  `plan_id` int(11) NULL DEFAULT NULL COMMENT '区域方案',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18602 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-座位图' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_ticket_sell
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_ticket_sell`;
CREATE TABLE `ods_wenti_theatre_ticket_sell`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `item_id` int(11) NOT NULL COMMENT '演出项目id',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 1-上架 0-下架',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `settled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否结算',
  `plan_id` int(11) NULL DEFAULT NULL COMMENT '区域方案',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `sale_start_time` datetime NULL DEFAULT NULL COMMENT '售卖开始时间',
  `sale_end_time` datetime NULL DEFAULT NULL COMMENT '售卖结束时间',
  `third_project_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方项目id',
  `third_project_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方项目类型',
  `rule_type` int(11) NULL DEFAULT 0 COMMENT '实名规则 0非实名 1一票一证',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 94 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-场次详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_ticket_sell_detail
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_ticket_sell_detail`;
CREATE TABLE `ods_wenti_theatre_ticket_sell_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `seat_id` int(11) NULL DEFAULT NULL COMMENT '座位id',
  `seat_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '座位号',
  `seat_num_x` int(11) NULL DEFAULT NULL COMMENT '座位坐标X',
  `seat_num_y` int(11) NULL DEFAULT NULL COMMENT '座位坐标Y',
  `seat_row_no` int(11) NULL DEFAULT NULL COMMENT '座位排号',
  `seat_col_no` int(11) NULL DEFAULT NULL COMMENT '座位列号',
  `is_side` tinyint(1) NULL DEFAULT NULL COMMENT '是否边座',
  `area_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '座位区域',
  `area_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '座位区域',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 -1-锁定 0-正常 1-待付款 2-已付款 3-已核销 4-已过期',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `customer_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户手机号',
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户姓名',
  `cert_type` int(11) NULL DEFAULT NULL COMMENT '客户证件类型 1-身份证',
  `cert_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户证件号',
  `verify_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '票码',
  `verify_worker` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '核销工作人员',
  `verify_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `price_id` int(11) NULL DEFAULT NULL COMMENT '票价id',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `pay_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '实付金额',
  `discount` decimal(2, 1) NULL DEFAULT NULL COMMENT '折扣大小',
  `discount_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '折扣金额',
  `third_type` int(11) NULL DEFAULT NULL COMMENT '第三方类型 1-大麦 2-猫眼',
  `third_order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方订单号',
  `third_user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方用户信息',
  `channel_user_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分销手机号',
  `channel_com_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '渠道公司名称',
  `choose_seat_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否选座',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sell_id`(`sell_id`) USING BTREE,
  INDEX `idx_order`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46158 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-场次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_theatre_ticket_third_order
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_theatre_ticket_third_order`;
CREATE TABLE `ods_wenti_theatre_ticket_third_order`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `third_order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方订单号',
  `third_type` int(1) NULL DEFAULT NULL COMMENT '第三方类型',
  `order_time` datetime NULL DEFAULT NULL COMMENT '下单时间',
  `is_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否支付',
  `is_cancel` tinyint(1) NULL DEFAULT NULL COMMENT '是否退票',
  `total_amount` bigint(20) NULL DEFAULT NULL COMMENT '订单总金额',
  `real_amount` bigint(20) NULL DEFAULT NULL COMMENT '实付金额',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 123 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧场票务-第三方订单表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
