/*
 Navicat Premium Dump SQL

 Source Server         : 06-7
 Source Server Type    : MySQL
 Source Server Version : 50736 (5.7.36)
 Source Host           : 192.168.112.101:3306
 Source Schema         : training

 Target Server Type    : MySQL
 Target Server Version : 50736 (5.7.36)
 File Encoding         : 65001

 Date: 17/07/2026 17:15:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `card_code_merchant_unique`(`venue_id`, `card_code`) USING BTREE COMMENT '商户下卡号不能重复',
  UNIQUE INDEX `card_track_merchant_unique`(`venue_id`, `card_track`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 123037 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '实体卡表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_h_member_course_refund
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_h_member_course_refund`;
CREATE TABLE `ods_wenti_h_member_course_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 0-审核中 1-审核通过 2-审核拒绝 3-已退款 4-已同意',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申请人手机号',
  `apply_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '报名人手机号，以逗号相隔',
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
  `item_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目',
  `item_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名，以逗号相隔',
  `update_material` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否更新材料',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员课程退款申请表' ROW_FORMAT = DYNAMIC;

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
  `customer_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '客户手机号',
  `customer_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '客户名称',
  `student_id` int(11) NULL DEFAULT NULL COMMENT '学生id',
  `order_time` datetime NULL DEFAULT NULL COMMENT '下单时间',
  `order_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下单备注',
  `order_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '订单金额',
  `merchant_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '商家优惠金额',
  `landlord_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '租主优惠金额',
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
  `pay_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '第三方支付参数',
  `create_order_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '下单参数',
  `origin_type` tinyint(1) NULL DEFAULT 0 COMMENT '来源类型(是否C端订单)',
  `fail_pay_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '付款失败备注',
  `cancel_remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '取消备注',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '基地id',
  `venue_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '基地名称',
  `mechant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `mechant_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '商户名称',
  `operator_id` int(11) NULL DEFAULT NULL COMMENT '操作id',
  `operator_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人名称',
  `is_hidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否查询隐藏',
  `evaluated` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已评价',
  `active_status` int(1) NULL DEFAULT NULL COMMENT '是否已激活',
  `active_time` datetime NULL DEFAULT NULL COMMENT '激活时间',
  `sex` int(11) NULL DEFAULT NULL COMMENT '1男2女',
  `sickness` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否有疾病',
  `id_card` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '下单身份证号',
  `commission_amount` decimal(13, 2) NULL DEFAULT NULL COMMENT '抽成金额',
  `base_amount` decimal(13, 2) NULL DEFAULT NULL COMMENT '抽成门槛金额',
  `commission_percent` decimal(13, 2) NULL DEFAULT NULL COMMENT '抽成金额百分比',
  `data_type` int(10) NULL DEFAULT 2 COMMENT '1:老数据，2：新数据',
  `channel_discount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '第三方支付渠道交易优惠（渠道优惠）',
  `jwh_vip_discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '佳文荟折扣',
  `is_jwh_vip` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是佳文荟会员订单',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE,
  INDEX `ik_merchant_id`(`mechant_id`) USING BTREE,
  INDEX `v`(`venue_id`) USING BTREE,
  INDEX `s`(`student_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 114721 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'order_status:              PAYING(\"100\", \"未付款\"),  PAID_FIELD(\"101\", \"已付款\"), PAY_CLOSE(\"102\",\"支付超时\"), CANCEL(\"103\",\"取消订单\"), FINISHED(\"200\", \"已完成\"), REFUNDED(\"300\", \"退款完成\"), REFUNDING(\"301\",\"退款中\") COMMENT = '交易订单主表';\r\nactive_status:    NOT_ACTIVE(0, \"待激活\"), ACTIVE(1, \"已激活\"),CANCEL(2,\"已取消\"),REFUND(3,\"已退款\");' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_course
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_course`;
CREATE TABLE `ods_wenti_m_trade_order_course`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `student_id` int(11) NULL DEFAULT NULL COMMENT '学员id',
  `course_id` int(11) NOT NULL COMMENT '课程id',
  `spec_id` int(11) NOT NULL COMMENT '规格id',
  `course_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '课程名',
  `spec_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规格名',
  `num` int(11) NOT NULL COMMENT '数量',
  `status` int(11) NOT NULL COMMENT '状态',
  `ori_amount` decimal(20, 2) NOT NULL COMMENT '总金额',
  `discount` decimal(20, 2) NOT NULL COMMENT '优惠金额',
  `amount` decimal(20, 2) NOT NULL COMMENT '实收金额',
  `total_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总课时',
  `remain_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '剩余课时',
  `remain_amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '剩余金额',
  `is_one_card` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是一卡通',
  `active_type` int(11) NULL DEFAULT NULL COMMENT '激活类型 1：单课程 2：多课程',
  `active_way` int(11) NULL DEFAULT NULL COMMENT '激活方式 1：择期激活 2：首次使用激活',
  `valid_days` int(11) NULL DEFAULT NULL COMMENT '有效天数',
  `start_date` date NULL DEFAULT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '截止日期',
  `course_status` int(11) NOT NULL DEFAULT 1 COMMENT '课程状态：0已完成 1进行中',
  `transfer_from_id` int(11) NULL DEFAULT 0 COMMENT '转课之前的订单详情记录id（m_trade_order_course表的id）',
  `period` int(11) NULL DEFAULT 1 COMMENT '用户相同课程期数',
  `finish_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `status_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '状态时间（下单或者转课）',
  `first_course` tinyint(1) NULL DEFAULT 0 COMMENT '优先卡',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `nn`(`order_num`) USING BTREE,
  INDEX `idx_student`(`student_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49881 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单课程信息表\r\nstatus:                   NOT_ACTIVE(0, \"待激活\"), ACTIVE(1, \"已激活\"), CANCEL(2,\"已取消\"), REFUND(3,\"已退款\"),TRANSFER(4,\"已转课\") COMMENT = '交易订单-课程明细表';\r\ncourse_status:        FINISHED(0, \"已完成\"), IN_PROGRESS(1, \"进行中\");' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_trade_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_trade_order_detail`;
CREATE TABLE `ods_wenti_m_trade_order_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `item_id` int(10) NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '项目名称',
  `quantity` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '数量',
  `price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '单价',
  `merchant_discount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '商家优惠金额',
  `landlord_discount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '租主优惠金额',
  `due_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '应付合计',
  `amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '合计',
  `market_id` int(11) NULL DEFAULT NULL COMMENT '商超id',
  `goods_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '商品收银时-商品成本金额',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 853 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '交易订单-项目明细表' ROW_FORMAT = Dynamic;

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
  `operation_type` int(2) NULL DEFAULT 1 COMMENT '1:退钱，2：不退钱',
  `status` int(11) NULL DEFAULT 1 COMMENT '1:正常，2：删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 276 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易订单退款表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_m_transfer_course_record
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_m_transfer_course_record`;
CREATE TABLE `ods_wenti_m_transfer_course_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `course_id` int(11) NULL DEFAULT NULL COMMENT '转课后的新课程的课程id，t_course',
  `order_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '转课生成的订单号',
  `old_order_course_id` int(11) NULL DEFAULT NULL COMMENT '原课程的订单明细id,m_trade_order_course',
  `order_course_id` int(11) NULL DEFAULT NULL COMMENT '新课程的订单明细id,m_trade_order_course',
  `need_to_pay` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '转课差价（用户需要支付金额）',
  `course_remain_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '原课程剩余金额，m_trade_order_course',
  `course_remain_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '原订单剩余课时，m_trade_order_course',
  `sale_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '现在课程销售金额（t_course_spec表）',
  `spec_id` int(11) NULL DEFAULT NULL COMMENT '转课后新课程的规格id（t_course_spec表）',
  `class_hour` decimal(10, 2) NULL DEFAULT NULL COMMENT '转课后新课程的课时（t_course_spec表）',
  `student_id` int(11) NULL DEFAULT NULL COMMENT '学生id',
  `is_success` tinyint(1) NULL DEFAULT 0 COMMENT '是否转课成功',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 222 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '转课记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_t_class
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_t_class`;
CREATE TABLE `ods_wenti_t_class`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id(训练基地id)',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班级名称',
  `course_id` int(11) NULL DEFAULT NULL COMMENT '课程id',
  `class_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班级类型',
  `class_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班级编号',
  `sport_id` int(11) NULL DEFAULT NULL COMMENT '运用类型id',
  `class_hour` decimal(11, 2) NULL DEFAULT NULL COMMENT '课时',
  `present` tinyint(1) NULL DEFAULT NULL COMMENT '缺课是否扣除课时',
  `reserve_enable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否启用预约限制人数',
  `reserve_hour` int(11) NULL DEFAULT NULL COMMENT '开课前x小时',
  `reserve_people` int(11) NULL DEFAULT NULL COMMENT '预约限制人数',
  `reserve_cancel_hour` int(11) NULL DEFAULT NULL COMMENT '开课前x小时不能取消约课',
  `remind_enable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否启用上课提醒',
  `remind_hour` int(11) NULL DEFAULT NULL COMMENT '开课前x小时提醒',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `delete_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `delete_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '删除人',
  `top` tinyint(1) NULL DEFAULT 0 COMMENT '是否置顶 0-否 1-是',
  `top_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '置顶时间',
  `sale_status` int(11) NOT NULL DEFAULT 0 COMMENT '上/下架状态 0-下架 1-上架',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 341 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '班级表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_t_class_teacher
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_t_class_teacher`;
CREATE TABLE `ods_wenti_t_class_teacher`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `class_id` int(11) NOT NULL COMMENT '班级id',
  `teacher_id` int(11) NOT NULL COMMENT '教师id',
  `taught_class_hour` int(11) NULL DEFAULT NULL COMMENT '已售课时',
  `commission_type` int(11) NULL DEFAULT NULL COMMENT '提成类型 1:百分比 2：固定',
  `commission_amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '提成金额（百分比）',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `group_commission_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '团体课提成金额',
  `group_commission_type` int(11) NULL DEFAULT NULL COMMENT '团体课提成类型 1:百分比 2：固定',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 424 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教师-班级关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_t_student
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_t_student`;
CREATE TABLE `ods_wenti_t_student`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id(训练基地id)',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学员名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机',
  `id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证',
  `student_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学员编号',
  `card_id` int(11) NULL DEFAULT NULL COMMENT '实体卡id',
  `sex` int(11) NULL DEFAULT NULL COMMENT '1男2女',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '来源',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `contact1` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人1',
  `contact1_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人1电话',
  `contact2` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人2',
  `contact2_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人2电话',
  `class_hour` int(11) NULL DEFAULT NULL COMMENT '课时',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `delete_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `delete_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '删除人',
  `sickness` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否有疾病',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name_phone`(`venue_id`, `phone`, `name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32686 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_t_student_check
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_t_student_check`;
CREATE TABLE `ods_wenti_t_student_check`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `card_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '卡号',
  `student_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生姓名',
  `course_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '课程名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班级名',
  `end_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '有效期至',
  `total_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总课时',
  `deduct_amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '抵扣金额',
  `syllabus_student_id` int(11) NULL DEFAULT NULL COMMENT '上课记录id',
  `prev_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '当前课时',
  `deduct_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '抵扣课时',
  `remain_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '剩余课时',
  `check_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '签到时间',
  `venue_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '训练基地名',
  `opt_user` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 544 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生消课记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_t_student_course
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_t_student_course`;
CREATE TABLE `ods_wenti_t_student_course`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `student_id` int(11) NOT NULL COMMENT '学生id',
  `course_id` int(11) NOT NULL COMMENT '课程id',
  `order_course_id` int(11) NULL DEFAULT NULL COMMENT '订单明细id,m_trade_order_course',
  `class_id` int(11) NULL DEFAULT NULL COMMENT '班级id',
  `ori_order_course_id` int(11) NULL DEFAULT NULL COMMENT '原始订单明细id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生参加课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_t_student_jnl
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_t_student_jnl`;
CREATE TABLE `ods_wenti_t_student_jnl`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `jnl_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '加能量(一起吗)手机号',
  `student_id` int(11) NOT NULL COMMENT '学生id',
  `is_default` int(2) NOT NULL COMMENT '是否默认(1-默认,2-不默认)(一起吗默认显示学生信息)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生-一起吗(加能量)账号关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_t_student_transfer
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_t_student_transfer`;
CREATE TABLE `ods_wenti_t_student_transfer`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `student_id` int(11) NULL DEFAULT NULL COMMENT '学生id',
  `ori_course_id` int(11) NULL DEFAULT NULL COMMENT '原课程id',
  `ori_course_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原课程名',
  `new_course_id` int(11) NULL DEFAULT NULL COMMENT '新课程id',
  `new_course_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新课程名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生转课记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ods_wenti_t_syllabus_student
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_t_syllabus_student`;
CREATE TABLE `ods_wenti_t_syllabus_student`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id(训练基地id)',
  `syllabus_id` int(11) NOT NULL COMMENT '课程安排id',
  `student_id` int(11) NOT NULL COMMENT '学生id',
  `order_course_id` int(11) NOT NULL COMMENT '订单明细id,m_trade_order_course',
  `deduct_amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '课消金额',
  `status` int(11) NULL DEFAULT NULL COMMENT '考勤状态 0：待上课  1：已签到 2：已点名 3：请假 4：缺课',
  `class_hour` decimal(11, 2) NULL DEFAULT NULL COMMENT '消耗课时',
  `is_reserve` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否预约',
  `is_insert` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否插课',
  `is_deduct` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否抵扣课时',
  `is_check` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否签到',
  `check_type` tinyint(4) NULL DEFAULT 0 COMMENT '签到类型：0前台，1闸机',
  `check_count` int(11) NULL DEFAULT 0 COMMENT '闸机签到时，统计次数',
  `is_call` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已点名',
  `is_leave` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已请假',
  `is_this` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否本班学员',
  `is_temp` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否临时添加',
  `check_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '签到时间',
  `reserve_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预约时间',
  `call_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '点名时间',
  `leave_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请假时间',
  `leave_type` int(11) NULL DEFAULT NULL COMMENT '请假方式 0：线下 1：线上',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `student_id`(`student_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 937 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生上课记录表\r\n  `status` int(11) DEFAULT NULL COMMENT \'考勤状态 0：待上课  1：已签到 2：已点名 3：请假 4：缺课\',' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
