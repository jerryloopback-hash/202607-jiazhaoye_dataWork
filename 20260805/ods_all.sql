/* 文体 ODS 建表脚本（SR 格式） */
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 来源数据库：jianengliang
-- ============================================================

-- ----------------------------
-- ods_wenti_jianengliang_buy_ticket_people   购票人
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_buy_ticket_people`;
CREATE TABLE `ods_wenti_jianengliang_buy_ticket_people`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `num` varchar(64) NOT NULL COMMENT '证件号码',
  `type` int(11) NOT NULL COMMENT '证件类型 1：身份证，2：驾驶证',
  `name` varchar(120) NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(12) NULL DEFAULT NULL COMMENT '手机号',
  `sex` varchar(4) NULL DEFAULT NULL COMMENT '性别',
  `id_card_status` int(11) NULL DEFAULT 0 COMMENT '身份证验证状态 0-未验证 1-验证成功 2-姓名不匹配 3-失败',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '购票人'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_coupon_combination   优惠券组合表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_coupon_combination`;
CREATE TABLE `ods_wenti_jianengliang_coupon_combination`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `status` int(2) NOT NULL COMMENT '状态',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_user` varchar(255) NULL DEFAULT NULL COMMENT '更新用户',
  `reType` int(2) NULL DEFAULT NULL COMMENT '',
  `reSource` int(2) NULL DEFAULT NULL COMMENT '',
  `res_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `re_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `path` varchar(255) NULL DEFAULT NULL COMMENT '路径',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `bgName` varchar(255) NULL DEFAULT NULL COMMENT '',
  `scenetype` int(2) NULL DEFAULT NULL COMMENT '',
  `merchant_id` int(11) NULL DEFAULT 1 COMMENT '商户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券组合表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_coupon_combination_ref   优惠券组合关联表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_coupon_combination_ref`;
CREATE TABLE `ods_wenti_jianengliang_coupon_combination_ref`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `typeDes` varchar(255) NULL DEFAULT NULL COMMENT '',
  `rangeDes` varchar(255) NULL DEFAULT NULL COMMENT '',
  `type` int(2) NULL DEFAULT NULL COMMENT '',
  `name` varchar(255) NULL DEFAULT NULL COMMENT '',
  `codeId` int(10) NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券组合关联表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_coupon_grant   优惠券发放表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_coupon_grant`;
CREATE TABLE `ods_wenti_jianengliang_coupon_grant`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '大麦PROJECTID',
  `couponId` int(10) NOT NULL COMMENT '优惠券id',
  `sceneType` int(1) NOT NULL COMMENT '发放场景',
  `status` int(1) NOT NULL COMMENT '0_禁用，1_启用',
  `createTime` datetime NOT NULL COMMENT '创建时间',
  `createUser` varchar(255) NULL DEFAULT NULL COMMENT '创建人',
  `updateUser` varchar(255) NULL DEFAULT NULL COMMENT '更新人',
  `updateTime` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `coupon_startTime` datetime NULL DEFAULT NULL COMMENT '优惠券有效开始时间',
  `coupon_endTime` datetime NULL DEFAULT NULL COMMENT '优惠券有效结束时间',
  `transaction_type` int(10) NULL DEFAULT NULL COMMENT '交易类型,1_全部交易，2_场馆交易,3_商城交易，4_票务交易，5_活动交易,6_培训交易',
  `share_num` int(10) NULL DEFAULT NULL COMMENT '每次交易分享个数',
  `user_startTime` datetime NULL DEFAULT NULL COMMENT '用户注册开始时间',
  `user_endTime` datetime NULL DEFAULT NULL COMMENT '用户注册结束时间',
  `user_range` int(10) NULL DEFAULT NULL COMMENT '用户注册渠道1_全部，2_小程序，3_IOS,4_Android,5_其它',
  `remarks` varchar(255) NULL DEFAULT '' COMMENT '备注',
  `user_type` int(10) NULL DEFAULT 3 COMMENT '用户范围 1.全部 2.按注册时间和注册渠道 3.按导入名单',
  `bgId` int(11) NULL DEFAULT NULL COMMENT '礼包id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券发放表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_coupon_grant_ref   优惠券发放关联表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_coupon_grant_ref`;
CREATE TABLE `ods_wenti_jianengliang_coupon_grant_ref`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '创建人姓名',
  `grantId` varchar(255) NOT NULL COMMENT '优惠券发放id',
  `userid` int(11) NOT NULL COMMENT '用户id',
  `shareNum` int(11) NOT NULL COMMENT '已分享数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券发放关联表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_coupon_range   优惠券适用范围表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_coupon_range`;
CREATE TABLE `ods_wenti_jianengliang_coupon_range`  (
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
  `sportId` varchar(255) NULL DEFAULT NULL COMMENT '运动类型id',
  `ticketId` int(10) NULL DEFAULT NULL COMMENT '票id',
  `venueGranularity` int(1) NULL DEFAULT NULL COMMENT '场馆颗粒度,1_所有场馆，2_运动类型，2_单张票',
  `activityTypeId` int(10) NULL DEFAULT NULL COMMENT '活动类型id',
  `activityId` int(10) NULL DEFAULT NULL COMMENT '活动id',
  `activityGranularity` int(1) NULL DEFAULT NULL COMMENT '活动颗粒度1_所有活动，2_活动类型，3_单个活动',
  `couponId` int(10) NOT NULL COMMENT '优惠券码id',
  `mallTickettype` int(10) NULL DEFAULT NULL COMMENT '',
  `mallTicket` int(10) NULL DEFAULT NULL COMMENT '',
  `mallTicketgranularity` int(10) NULL DEFAULT NULL COMMENT '',
  `card_id` int(10) NULL DEFAULT NULL COMMENT '线上办卡id',
  `damai_granularity` int(10) NULL DEFAULT NULL COMMENT '',
  `damai_type` varchar(255) NULL DEFAULT NULL COMMENT '',
  `damai_project_id` varchar(255) NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券适用范围表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_coupon_receive   优惠券领取表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_coupon_receive`;
CREATE TABLE `ods_wenti_jianengliang_coupon_receive`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `ref_id` int(10) NOT NULL COMMENT '优惠券id',
  `userid` int(10) NOT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 11
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券领取表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_activity_statistics   活动统计表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_activity_statistics`;
CREATE TABLE `ods_wenti_jianengliang_j_activity_statistics`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `activity_id` int(11) NOT NULL COMMENT '活动id',
  `activity_name` varchar(255) NOT NULL DEFAULT '' COMMENT '活动名称',
  `type_name` varchar(255) NOT NULL DEFAULT '' COMMENT '类型名称',
  `type_id` int(11) NOT NULL COMMENT '类型id',
  `traffic_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '访问量',
  `share_num` bigint(20) NOT NULL DEFAULT 0 COMMENT '分享量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `tag1` varchar(255) NULL DEFAULT NULL COMMENT '',
  `tag2` varchar(255) NULL DEFAULT NULL COMMENT '',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '活动统计表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_address   收货地址
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_address`;
CREATE TABLE `ods_wenti_jianengliang_j_address`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sex` varchar(6) NULL DEFAULT NULL COMMENT '性别',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `name` varchar(256) NULL DEFAULT NULL COMMENT '收货人姓名',
  `phone` varchar(16) NULL DEFAULT NULL COMMENT '收货人电话',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `area_id` int(11) NULL DEFAULT NULL COMMENT '地区',
  `street_id` int(11) NULL DEFAULT NULL COMMENT '街道',
  `pca_name` varchar(300) NULL DEFAULT NULL COMMENT '商户ID',
  `detailed_address` varchar(500) NULL DEFAULT NULL COMMENT '详细地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_default` int(11) NULL DEFAULT 0 COMMENT '是否为默认地址（0：不是，1：是）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '收货地址'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_coupon   优惠券
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_coupon`;
CREATE TABLE `ods_wenti_jianengliang_j_coupon`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '',
  `name` varchar(128) NOT NULL COMMENT '优惠券名称',
  `code_id` int(11) NOT NULL COMMENT '优惠码id',
  `rec_type` tinyint(4) NULL DEFAULT 0 COMMENT '领取方式1.注册 2.积分兑换 3.发老用户 4.金服注册赠送 5.自定义发放',
  `scene_type` tinyint(4) NULL DEFAULT NULL COMMENT '适用范围 0.全场通用 1.订场售票',
  `use_type` tinyint(4) NULL DEFAULT 0 COMMENT '使用场景 未使用_0,订场_2,游泳票_3,渠道商品订单_4,演艺票订单_5,赛事票订单_6',
  `full_cut_price` decimal(7, 2) NULL DEFAULT NULL COMMENT '满减',
  `price` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '金额',
  `start_time` datetime NULL DEFAULT NULL COMMENT '优惠券有效开始时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '优惠券的有效结束时间',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态 1：未使用 2：已使用',
  `user_id` int(11) NOT NULL COMMENT '会员id',
  `is_pop` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否需要弹窗提示 1:需要',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `description` varchar(512) NULL DEFAULT NULL COMMENT '描述',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'ID',
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '已读状态1为已读',
  `prize_record_id` int(11) NULL DEFAULT NULL COMMENT '奖品发放记录id',
  `discount` decimal(7, 2) NULL DEFAULT NULL COMMENT '折扣',
  `couponCodeType` int(10) NULL DEFAULT 1 COMMENT '优惠券类型',
  `userange` int(10) NULL DEFAULT 0 COMMENT '使用范围',
  `grantId` int(10) NOT NULL DEFAULT 1 COMMENT '优惠券发放id',
  `combinationId` int(10) NULL DEFAULT NULL COMMENT '',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商家ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_coupon_code   优惠码
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_coupon_code`;
CREATE TABLE `ods_wenti_jianengliang_j_coupon_code`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(128) NOT NULL COMMENT '优惠券名称',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '优惠券金额',
  `full_cut_price` decimal(7, 2) NULL DEFAULT NULL COMMENT '满减金额',
  `req_points` int(11) NULL DEFAULT NULL COMMENT '所需积分',
  `rec_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '领取方式 1.注册 2.积分兑换 3.发老用户 4.自定义发放',
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
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态 0.禁用 1.启用 2.假删除',
  `update_user` varchar(32) NULL DEFAULT NULL COMMENT '最后更新用户',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `description` varchar(512) NULL DEFAULT NULL COMMENT '描述',
  `discount` decimal(7, 2) NULL DEFAULT NULL COMMENT '折扣',
  `couponCodeType` int(10) NULL DEFAULT 1 COMMENT '',
  `userange` int(2) NULL DEFAULT 0 COMMENT '',
  `userangeDesc` varchar(255) NULL DEFAULT '' COMMENT '使用范围描述',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠码'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_coupon_recive   优惠券领取表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_coupon_recive`;
CREATE TABLE `ods_wenti_jianengliang_j_coupon_recive`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `coupon_name` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `coupon_type` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠方式',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '状态0.上架 1.下架',
  `coupon_range` int(1) NOT NULL DEFAULT 0 COMMENT '优惠券使用范围',
  `coupon_start_time` datetime NULL DEFAULT NULL COMMENT '优惠券有效开始时间',
  `coupon_end_time` datetime NOT NULL COMMENT '优惠券有效结束时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(255) NOT NULL COMMENT '编辑人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `coupon_id` int(11) NOT NULL COMMENT '优惠券id',
  `coupon_num` int(11) NOT NULL COMMENT '优惠券发放数量',
  `recive_num` int(11) NOT NULL DEFAULT 0 COMMENT '领取数量',
  `grant_id` int(11) NOT NULL COMMENT '',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商家ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券领取表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_coupon_recive_city_ref   优惠券领取城市关联表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_coupon_recive_city_ref`;
CREATE TABLE `ods_wenti_jianengliang_j_coupon_recive_city_ref`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `recive_id` int(11) NOT NULL COMMENT '领券中心id',
  `merchant_id` int(11) NOT NULL COMMENT '商家id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券领取城市关联表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_coupon_recive_ref   优惠券领取关联表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_coupon_recive_ref`;
CREATE TABLE `ods_wenti_jianengliang_j_coupon_recive_ref`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `recive_id` int(11) NOT NULL COMMENT '领券id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '优惠券领取关联表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_id_card_check_record   身份证件记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_id_card_check_record`;
CREATE TABLE `ods_wenti_jianengliang_j_id_card_check_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `id_card` varchar(255) NULL DEFAULT NULL COMMENT 'id_card',
  `member_id` int(11) NOT NULL DEFAULT 0 COMMENT 'member_id',
  `phone` varchar(255) NULL DEFAULT NULL COMMENT 'phone',
  `type` int(11) NULL DEFAULT 1 COMMENT '1 老人2少年',
  `user_name` varchar(255) NULL DEFAULT NULL COMMENT '姓名',
  `code` varchar(11) NULL DEFAULT NULL COMMENT '成功为200（10000），其它为失败状态码',
  `company_type` int(11) NULL DEFAULT 1 COMMENT 'compay_type 1 天眼 2网易 3数据宝',
  `msg` varchar(255) NULL DEFAULT NULL COMMENT 'code对应的说明描述',
  `result` int(1) NULL DEFAULT 1 COMMENT '0 一致（收费），1 不一致（收费），2 无记录（收费）',
  `order_no` varchar(255) NULL DEFAULT NULL COMMENT '订单号',
  `sex` varchar(255) NULL DEFAULT NULL COMMENT '性别',
  `check_desc` varchar(255) NULL DEFAULT NULL COMMENT '验证结果描述信息',
  `birthday` varchar(255) NULL DEFAULT NULL COMMENT '生日',
  `address` varchar(255) NULL DEFAULT NULL COMMENT '籍贯',
  `task_id` varchar(255) NULL DEFAULT NULL COMMENT '本次请求数据标识，可以根据该标识在控制台进行数据查询',
  `reason_type` int(1) NULL DEFAULT 1 COMMENT '	原因详情，1：认证通过 2：输入姓名和身份证号不一致 3：查无此身份证 7：结果获取失败，请重试',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '	认证结果，1：认证通过，2：认证不通过， 0：待定(原因参考下方reasonType字段)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '身份证件记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_intelligent_info   智慧场馆收集数据
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_intelligent_info`;
CREATE TABLE `ods_wenti_jianengliang_j_intelligent_info`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `business_type` int(11) NULL DEFAULT 1 COMMENT '1 :个人中心身份认证页面, 2:游泳馆购票页面, 3:游泳馆办卡页面, 4:免费票领取页, 5:体检报告上传页，6：个人中心身份认证页面',
  `detail_type` int(11) NULL DEFAULT 1 COMMENT '1.储值卡 2.次卡 3.时段卡, 4:散票，5：团体票，6：免费票，7：',
  `member_id` int(11) NOT NULL COMMENT 'h_member id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '智慧场馆收集数据'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_member   用户
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_member`;
CREATE TABLE `ods_wenti_jianengliang_j_member` (
  `extract_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` INT NOT NULL COMMENT 'id',
  `phone` VARCHAR(36) NULL COMMENT '注册手机',
  `password` VARCHAR(64) NULL COMMENT '密码',
  `nick_name` VARCHAR(64) NULL COMMENT '昵称',
  `birthday` VARCHAR(20) NULL COMMENT '生日',
  `age` INT NULL COMMENT '年龄',
  `province` VARCHAR(16) NULL COMMENT '省',
  `city` VARCHAR(16) NULL COMMENT '市',
  `area` VARCHAR(16) NULL COMMENT '区',
  `sex` INT NULL COMMENT '性别 0不明 1男 2女',
  `avatar` VARCHAR(512) NULL COMMENT '用户头像',
  `rank` INT NULL COMMENT '用户等级ID(0.普通会员，1场馆管理员，2培训机构管理员，3商户管理员，4系统平台管理员)枚举体现',
  `is_audit` INT NULL COMMENT '是否审核(0否，1是)',
  `login_num` INT NULL COMMENT '登录次数',
  `last_login_time` DATETIME NULL COMMENT '上次登录时间',
  `this_login_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP COMMENT '本次登录时间',
  `energy_volume_num` INT NULL COMMENT '能量卷数量',
  `depart_discount_num` INT NULL COMMENT '场地抵扣券数量',
  `is_blacklist` TINYINT NULL COMMENT '是否黑名单 0不是 1是',
  `remark` VARCHAR(256) NULL COMMENT '备注',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `guess_status` INT NULL COMMENT '竞猜开关 0 关 1 开',
  `default_image_index` INT NULL COMMENT '默认头像索引',
  `source` INT NOT NULL COMMENT '用户来源 1 android 2 ios 3 小程序 4后台录入',
  `register_source` VARCHAR(50) NULL COMMENT '注册来源(子场馆id)',
  `signature` VARCHAR(100) NULL COMMENT '个性签名',
  `is_vip` INT NOT NULL COMMENT '是否是加V用户(0-不是,1-子场馆关联用户,2-个人加V用户)',
  `jwh_vip` INT NOT NULL COMMENT '佳文荟会员 0-否 1-是 2-已过期',
  `venue_id` VARCHAR(50) NULL COMMENT '场馆id',
  `member_rate` DECIMAL(5,1) NOT NULL COMMENT '用户权重',
  `content_rate` DECIMAL(5,1) NOT NULL COMMENT '内容权重',
  `member_status` INT NOT NULL COMMENT '会员状态(1-正常,2-封禁)',
  `mini_qrcode` VARCHAR(255) NULL COMMENT '小程序分享二维码',
  `id_card_create_time` DATETIME NULL COMMENT 'id_card上传时间',
  `report_create_time` DATETIME NULL COMMENT '体检上传时间',
  `id_card_check` INT NULL COMMENT ' id_card校验 1：未校验，2：已校验，3：过期，4：禁用',
  `id_card_expire_date` DATETIME NULL COMMENT 'id_card有效期',
  `report_expire_date` DATETIME NULL COMMENT '体检有效期',
  `id_card` VARCHAR(255) NOT NULL COMMENT 'id_card',
  `user_name` VARCHAR(255) NULL COMMENT '姓名',
  `report_check` INT NULL COMMENT ' 体检校验 1：未上传， 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用',
  `child_check` INT NULL COMMENT ' 儿童校验 1：未校验，2：已校验，3：过期，4：禁用',
  `child_check_expire_date` DATETIME NULL COMMENT '儿童id_card有效期',
  `child_id_card` VARCHAR(255) NULL COMMENT '儿童id_card',
  `child_birthday` VARCHAR(20) NULL COMMENT '儿童生日',
  INDEX `ik_venue_id` (`venue_id`) USING BITMAP,
  INDEX `phone` (`phone`) USING BITMAP
) ENGINE = OLAP
DUPLICATE KEY (`id`)
COMMENT '文体-jianengliang-用户表'
DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
  "replication_num" = "1"
);

-- ----------------------------
-- ods_wenti_jianengliang_j_member_free_ticket   用户免费票记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_member_free_ticket`;
CREATE TABLE `ods_wenti_jianengliang_j_member_free_ticket`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '会员id',
  `name` varchar(20) NULL DEFAULT NULL COMMENT '报名人名字',
  `venue_activity_goods_id` int(11) NULL DEFAULT NULL COMMENT '场馆活动商品id',
  `id_card` varchar(20) NULL DEFAULT NULL COMMENT '身份证号',
  `id_type` int(11) NULL DEFAULT 1 COMMENT '1.中国居民身份证 2.港澳居民身份证 3.台湾居民身份证',
  `phone` varchar(20) NULL DEFAULT NULL COMMENT '手机号',
  `code` varchar(20) NULL DEFAULT NULL COMMENT '领取码',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '领取时间',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 1：待使用，2：已使用，3：用户取消 4:过期',
  `status_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '状态时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '到期时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `operator_id` varchar(50) NULL DEFAULT NULL COMMENT '核销人id',
  `use_begin_time` datetime NULL DEFAULT NULL COMMENT '使用开始时间',
  `use_end_time` datetime NULL DEFAULT NULL COMMENT '使用结束时间',
  `use_cond` int(20) NULL DEFAULT NULL COMMENT '卡限制类型,与B端UseCond保持一致',
  `ticket_type` varchar(50) NULL DEFAULT NULL COMMENT '免费票类型',
  `batch_code` varchar(255) NULL DEFAULT NULL COMMENT '套票批次码，用于标识套票',
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '已读状态1为已读',
  `update_user` varchar(255) NULL DEFAULT '' COMMENT '核销人',
  `admin_check` int(11) NULL DEFAULT NULL COMMENT '后台核销',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_code`(`code`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '用户免费票记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_member_order   我的套餐
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_member_order`;
CREATE TABLE `ods_wenti_jianengliang_j_member_order`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NULL DEFAULT NULL,
  `venue_id` int(64) NULL DEFAULT NULL COMMENT '场馆id',
  `sport_id` varchar(255) NULL DEFAULT NULL COMMENT '运动项目id',
  `cost` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '应付费用,包括调价和服务费',
  `discount_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠费用',
  `deducted_card_type` varchar(100) NULL DEFAULT NULL COMMENT '专项卡抵扣类型(2011储值卡,2012储值专项,202次卡)',
  `deducted_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '专项卡已抵扣金额',
  `share_deducted_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '分摊剩余抵扣金额',
  `pay_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '实付费用=应付费用-优惠',
  `service_charge` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `order_num` varchar(64) NOT NULL COMMENT '订单号',
  `trade_no` varchar(64) NULL DEFAULT NULL COMMENT '第三方支付订单号',
  `phone` varchar(11) NULL DEFAULT NULL COMMENT '手机号',
  `status` varchar(50) NOT NULL COMMENT '状态 ：\r\n（订场/游泳票）订单状态取值:0:待支付 2:已支付,待使用 3:未支付,支付超时 4:已支付已使用待评价 5.已支付未使用已过期 6:已退款 7:已评价 8:用户取消订单\r\n\r\n（商品/演艺票/赛事票）订单状态取值: 30：已下单待支付，31：已取消，32：支付超时，33：已支付待发货，34：已支付待自取，35：已发货待收货，36：已收货待评价，37：已取票待评价，38：退款中，39：退款成功，40：退款失败，41：已完成，42：关闭订单',
  `type` varchar(50) NOT NULL COMMENT '类型 1_套餐2_订场 3 游泳票 4商品 5演艺 6赛事 7（自营）演艺周边 8（自营）赛事周边 9（自营）其他商品 10找课程',
  `pay_way` varchar(12) NULL DEFAULT NULL COMMENT '支付方式 1、支付宝 2、微信 3、小程序',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `order_time` timestamp NULL DEFAULT NULL COMMENT '订场时间, 向后台发起请求并且订场成功',
  `pay_param` varchar(4000) NULL DEFAULT NULL COMMENT '阿里支付参数',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `used_points` int(11) NULL DEFAULT NULL COMMENT '使用积分',
  `consignee` varchar(64) NULL DEFAULT NULL COMMENT '收货人',
  `consignee_phone` varchar(20) NULL DEFAULT NULL COMMENT '收货人电话',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省id',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市id',
  `area_id` int(11) NULL DEFAULT NULL COMMENT '区id',
  `pca_name` varchar(300) NULL DEFAULT NULL COMMENT '省市区名称',
  `address` varchar(500) NULL DEFAULT NULL COMMENT '收货人地址',
  `id_card` varchar(30) NULL DEFAULT NULL COMMENT '身份證',
  `is_pay` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已支付',
  `is_refund` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已退款',
  `is_send` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已发货',
  `take_way` int(11) NULL DEFAULT 0 COMMENT '获取方式（0：快递，1：自取，2：电子票）',
  `take_address` varchar(255) NULL DEFAULT NULL COMMENT '自取地址',
  `status_time` timestamp NULL DEFAULT NULL COMMENT '状态时间',
  `sys_remark` varchar(3000) NULL DEFAULT NULL COMMENT '（后台）订单备注',
  `handle` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已经统计过报表',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '站点id(当为全国时为0)',
  `commission` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '手续费',
  `channel_discount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '渠道优惠',
  `j_merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `j_merchant_no` varchar(255) NULL DEFAULT '' COMMENT '商户号',
  `asyn_division_flag` tinyint(1) NULL DEFAULT 0 COMMENT '0.无需异步分账 1.需要异步分账',
  `asyn_sure` tinyint(1) NULL DEFAULT NULL COMMENT '0.未确认异步分账 1.已确认异步分账',
  `is_new` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0.旧订单 1.新订单',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '我的套餐'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_member_order_detail   会员订单明细表 （只有游泳票！）看数据判断
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_member_order_detail`;
CREATE TABLE `ods_wenti_jianengliang_j_member_order_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(255) NULL DEFAULT NULL,
  `swim_ticket_desc` varchar(255) NULL DEFAULT NULL COMMENT '游泳票描述',
  `swim_ticket_expire_date` varchar(50) NULL DEFAULT NULL COMMENT '游泳票有效期',
  `field_time_desc` varchar(255) NULL DEFAULT NULL COMMENT '订场时间描述',
  `field_num_desc` varchar(255) NULL DEFAULT NULL COMMENT '订场数量描述',
  `packages_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '套餐价格',
  `field_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '场地价格',
  `swim_ticket_amount` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '游泳票价格',
  `user_remark` varchar(255) NULL DEFAULT NULL COMMENT '用户购买备注',
  `take_remark` varchar(255) NULL DEFAULT NULL COMMENT '用户取票备注',
  `close_remark` varchar(255) NULL DEFAULT NULL COMMENT '订单关闭备注',
  `goods_take_code` varchar(20) NULL DEFAULT NULL COMMENT '搭配商品领取码',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员订单明细表 （只有游泳票！）看数据判断'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_member_order_refund   会员订单退款表（是否是多个平台的退款）
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_member_order_refund`;
CREATE TABLE `ods_wenti_jianengliang_j_member_order_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) NULL DEFAULT NULL COMMENT '订单号',
  `pay_way` varchar(20) NULL DEFAULT NULL COMMENT '支付方式',
  `refund_order_num` varchar(255) NULL DEFAULT NULL COMMENT '退款单号',
  `refund_user` varchar(64) NULL DEFAULT NULL COMMENT '退款人',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_trade_no` varchar(255) NULL DEFAULT NULL COMMENT '第三方退款流水号',
  `refund_amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `refund_type` int(11) NULL DEFAULT NULL COMMENT '退款方式 1原渠道退回',
  `refund_response` varchar(4000) NULL DEFAULT NULL COMMENT '第三方返回响应',
  `refund_param` varchar(4000) NULL DEFAULT NULL COMMENT '退款参数',
  `is_success` tinyint(1) NULL DEFAULT NULL COMMENT '是否成功',
  `fail_reason` varchar(4000) NULL DEFAULT NULL COMMENT '失败原因',
  `refund_remark` varchar(255) NULL DEFAULT NULL COMMENT '退款备注',
  `status` int(11) NULL DEFAULT 0 COMMENT '0：待审核，1：同意，2，拒绝',
  `check_user` varchar(64) NULL DEFAULT NULL COMMENT '审核人员',
  `check_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `refuse_reason` varchar(255) NULL DEFAULT NULL COMMENT '拒绝原因',
  `sup_is_refund` int(11) NULL DEFAULT NULL COMMENT '是否收到商户退款 0：否，1：是',
  `sup_refund_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '商户退款金额',
  `is_only_goods` tinyint(1) NULL DEFAULT 0 COMMENT '是否只退搭配',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `key.order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员订单退款表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_member_third   会员第三方登录绑定表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_member_third`;
CREATE TABLE `ods_wenti_jianengliang_j_member_third`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `third_type` int(2) NOT NULL COMMENT '第三方类型(1-微信,2-支付宝)',
  `third_source` int(2) NOT NULL COMMENT '第三方注册来源(1-小程序,2-微信公众号)',
  `third_id` varchar(64) NOT NULL COMMENT '第三方id(微信为openid)',
  `union_id` varchar(64) NULL DEFAULT NULL COMMENT '第三方唯一id(微信为unionid)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员第三方登录绑定表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_member_time_card   会员次卡表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_member_time_card`;
CREATE TABLE `ods_wenti_jianengliang_j_member_time_card`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `card_id` int(11) NOT NULL COMMENT '闲时卡售卖id',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '卡状态 0_待激活 1_已激活 2_已过期',
  `expire_time` datetime NOT NULL COMMENT '卡过期时间',
  `stime` varchar(255) NOT NULL DEFAULT '' COMMENT '可用时段开始时间',
  `etime` varchar(255) NOT NULL DEFAULT '' COMMENT '可用时段结束时间',
  `type` int(11) NOT NULL COMMENT '卡类型',
  `limit_num` int(11) NOT NULL COMMENT '单日使用限制次数',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `discount_time` decimal(10, 2) NOT NULL COMMENT '单次使用可抵扣最大时长',
  `card_name` varchar(255) NOT NULL DEFAULT '' COMMENT '卡名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员次卡表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_order_btp   订单购票人关系表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_order_btp`;
CREATE TABLE `ods_wenti_jianengliang_j_order_btp`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(64) NULL DEFAULT NULL COMMENT '订单号',
  `btp_id` int(11) NULL DEFAULT NULL COMMENT '购票人id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '订单购票人关系表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_order_card_expense   卡消费表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_order_card_expense`;
CREATE TABLE `ods_wenti_jianengliang_j_order_card_expense`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(255) NULL DEFAULT '' COMMENT '订单号',
  `vip_card_id` varchar(255) NOT NULL DEFAULT '' COMMENT '专项卡id(与B端一致)',
  `vip_card_no` varchar(255) NULL DEFAULT '' COMMENT '专项卡号(与B端一致)',
  `card_no` varchar(255) NULL DEFAULT '' COMMENT '虚拟卡号(与B端一致)',
  `vip_card_type` varchar(255) NOT NULL DEFAULT '' COMMENT '专项卡类型(201-储值卡,202-次卡)',
  `deducted_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '已抵扣金额',
  `spend_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '卡已使用额度',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_cancel` varchar(1) NOT NULL DEFAULT '0' COMMENT '是否取消(0-正常,1-已取消)',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '取消时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ORDER_NUM_INDEX`(`order_num`, `is_cancel`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '卡消费表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_order_coupon   订单优惠券表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_order_coupon`;
CREATE TABLE `ods_wenti_jianengliang_j_order_coupon`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(64) NOT NULL COMMENT '订单',
  `coupon_id` bigint(20) NOT NULL COMMENT '优惠券id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '订单优惠券表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_order_field   已订场地
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_order_field`;
CREATE TABLE `ods_wenti_jianengliang_j_order_field`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(255) NULL DEFAULT NULL COMMENT '订单号',
  `buss_date` varchar(255) NULL DEFAULT NULL COMMENT '开场日期',
  `start_time` varchar(255) NULL DEFAULT NULL COMMENT '开场时间',
  `end_time` varchar(255) NULL DEFAULT NULL COMMENT '结束时间',
  `item_name` varchar(255) NULL DEFAULT NULL COMMENT '场地名称',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售单价(不包含服务费)',
  `ori_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原单价(不包含服务费)',
  `service_charge` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '服务费',
  `cut_ratio` decimal(10, 2) NULL DEFAULT NULL COMMENT '平台抽成比例',
  `field_id` varchar(255) NULL DEFAULT NULL COMMENT '场地id',
  `price_id` varchar(255) NULL DEFAULT NULL COMMENT '价格id',
  `push` int(3) NULL DEFAULT NULL COMMENT '是否已推送提示开场',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '已订场地'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_order_guanjia   馆佳的订单记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_order_guanjia`;
CREATE TABLE `ods_wenti_jianengliang_j_order_guanjia`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `type` varchar(20) NULL DEFAULT NULL COMMENT '订单类型',
  `status` int(11) NULL DEFAULT NULL COMMENT '订单状态',
  `order_num` varchar(50) NOT NULL COMMENT '馆佳订单号',
  `is_give_points` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已送过积分',
  `user_id` int(11) NOT NULL COMMENT '下单用户id',
  `coupon_id` bigint(11) NULL DEFAULT NULL COMMENT '优惠券id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '馆佳的订单记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_order_ticket   游泳票生成表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_order_ticket`;
CREATE TABLE `ods_wenti_jianengliang_j_order_ticket`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `card_id` varchar(255) NULL DEFAULT NULL COMMENT 'B端卡ID',
  `order_num` varchar(255) NULL DEFAULT NULL COMMENT '订单号',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `ticket_num` varchar(255) NULL DEFAULT NULL COMMENT '票号',
  `ticket_name` varchar(255) NULL DEFAULT NULL COMMENT '票名',
  `type` int(11) NULL DEFAULT NULL COMMENT '票类型,与B端use_condition保持一致',
  `ticket_type` int(11) NULL DEFAULT NULL COMMENT '1：成人单次 2:一大一小 3:两大一小',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `status` int(11) NULL DEFAULT NULL COMMENT '使用状态 0 未使用 1已使用 2已过期',
  `description` varchar(255) NULL DEFAULT NULL COMMENT '使用说明',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '游泳票生成表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_order_ticket_valid   散票核销记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_order_ticket_valid`;
CREATE TABLE `ods_wenti_jianengliang_j_order_ticket_valid`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) NOT NULL COMMENT '订单号',
  `ticket_num` varchar(255) NOT NULL COMMENT '票号',
  `operator_id` varchar(255) NULL DEFAULT NULL COMMENT '核销人员id',
  `operator_name` varchar(255) NULL DEFAULT NULL COMMENT '核销人员名称',
  `type` int(11) NULL DEFAULT NULL COMMENT '票类型,与B端use_condition保持一致',
  `ticket_type` int(11) NULL DEFAULT NULL COMMENT '1：成人单次 2:一大一小 3:两大一小',
  `is_valid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已核销',
  `valid_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_num`(`ticket_num`) USING BTREE,
  INDEX `ik_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '散票核销记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_platform_activity   活动报名
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_platform_activity`;
CREATE TABLE `ods_wenti_jianengliang_j_platform_activity`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `activity_name` varchar(150) NULL DEFAULT '' COMMENT '活动名称',
  `category_id` int(11) NULL DEFAULT 0 COMMENT '活动分类id',
  `category_name` varchar(50) NULL DEFAULT '' COMMENT '活动分类名称',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(200) NULL DEFAULT NULL COMMENT '场馆名称',
  `introduction` text NULL COMMENT '介绍',
  `pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '需支付金额',
  `free_sign` tinyint(1) NULL DEFAULT 0 COMMENT '是否免费',
  `least_nums` int(10) NULL DEFAULT 0 COMMENT '至少报名人数',
  `sign_up_nums` int(10) NULL DEFAULT 0 COMMENT '报名人数',
  `sign_up_attrs` varchar(255) NULL DEFAULT '' COMMENT '报名填报信息',
  `thumb_img` varchar(255) NULL DEFAULT NULL COMMENT '缩略图',
  `boostrap_img` varchar(255) NULL DEFAULT NULL COMMENT '首页图片',
  `list_img` varchar(255) NULL DEFAULT NULL COMMENT '列表图片',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `sign_up_start_time` datetime NULL DEFAULT NULL COMMENT '报名开始时间',
  `sign_up_end_time` datetime NULL DEFAULT NULL COMMENT '报名结束时间',
  `release_start_time` datetime NULL DEFAULT NULL COMMENT '自行发布时间',
  `release_end_time` datetime NULL DEFAULT NULL COMMENT '自行下线时间',
  `activity_status` varchar(20) NULL DEFAULT '' COMMENT '活动状态',
  `province_id` int(11) NULL DEFAULT NULL COMMENT '省',
  `city_id` int(11) NULL DEFAULT NULL COMMENT '市',
  `district_id` int(11) NULL DEFAULT NULL COMMENT '区',
  `address` varchar(255) NULL DEFAULT NULL COMMENT '场馆地址',
  `longitude` varchar(255) NULL DEFAULT NULL COMMENT '场馆经度',
  `latitude` varchar(255) NULL DEFAULT NULL COMMENT '场馆纬度',
  `create_name` varchar(200) NULL DEFAULT NULL COMMENT '',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_name` varchar(200) NULL DEFAULT NULL COMMENT '',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `percentage` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '抽成比例',
  `j_merchant_id` int(11) NULL DEFAULT NULL COMMENT '银联商户id',
  `show_list` int(11) NULL DEFAULT 1 COMMENT '是否小程序列表展示 1-是 2-否',
  `sign_up_num_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否展示报名人数 1-是 0-否',
  `label` varchar(500) NULL DEFAULT NULL COMMENT '标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '活动报名'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_platform_activity_bonus   活动报名关联奖品
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_platform_activity_bonus`;
CREATE TABLE `ods_wenti_jianengliang_j_platform_activity_bonus`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `bonus_type` varchar(20) NULL DEFAULT '' COMMENT '奖品类型',
  `bonus_name` varchar(255) NULL DEFAULT '' COMMENT '奖品名称',
  `bonus_id` int(10) NULL DEFAULT 0 COMMENT '奖品id',
  `bonus_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '奖品价值',
  `bonus_count` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '奖品数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '活动报名关联奖品'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_platform_activity_category   活动报名分类
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_platform_activity_category`;
CREATE TABLE `ods_wenti_jianengliang_j_platform_activity_category`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `category_name` varchar(50) NOT NULL DEFAULT '' COMMENT '活动分类名称',
  `sorted_num` int(11) NOT NULL DEFAULT 0 COMMENT '排序值',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '活动报名分类'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_platform_activity_extra_attr   活动报名信息项
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_platform_activity_extra_attr`;
CREATE TABLE `ods_wenti_jianengliang_j_platform_activity_extra_attr`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `attr_name` varchar(255) NULL DEFAULT '' COMMENT '名称',
  `attr_enums` varchar(255) NULL DEFAULT '' COMMENT '信息序列',
  `sorted_num` int(11) NULL DEFAULT 0 COMMENT '排序值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '活动报名信息项'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_platform_activity_gift_bag   活动报名关联礼包
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_platform_activity_gift_bag`;
CREATE TABLE `ods_wenti_jianengliang_j_platform_activity_gift_bag`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `gift_name` varchar(255) NULL DEFAULT '' COMMENT '礼包名称',
  `gift_price` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '礼包单价',
  `gift_pic_url` varchar(255) NULL DEFAULT '' COMMENT '图片地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '活动报名关联礼包'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_platform_activity_goods   活动报名关联商品
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_platform_activity_goods`;
CREATE TABLE `ods_wenti_jianengliang_j_platform_activity_goods`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '活动id',
  `mall_goods_id` int(11) NULL DEFAULT 0 COMMENT '商超商品id',
  `mall_goods_name` varchar(255) NULL DEFAULT '' COMMENT '商品名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '活动报名关联商品'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_platform_activity_person   活动报名-报名者
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_platform_activity_person`;
CREATE TABLE `ods_wenti_jianengliang_j_platform_activity_person`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `activity_id` int(10) NULL DEFAULT 0 COMMENT '活动id',
  `user_id` int(10) NULL DEFAULT 0 COMMENT '用户id',
  `account` varchar(50) NULL DEFAULT '' COMMENT '用户账号',
  `nickname` varchar(100) NULL DEFAULT '' COMMENT '昵称',
  `sign_name` varchar(100) NULL DEFAULT '' COMMENT '登记名称',
  `sign_phone` varchar(100) NULL DEFAULT '' COMMENT '登记手机号',
  `sign_card_type` varchar(100) NULL DEFAULT '' COMMENT '登记证件类型',
  `sign_card_no` varchar(100) NULL DEFAULT '' COMMENT '登记证件号',
  `sign_equip_size` varchar(100) NULL DEFAULT '' COMMENT '登记装备尺寸',
  `sign_remark` varchar(255) NULL DEFAULT NULL COMMENT '登记备注',
  `sign_status` varchar(20) NULL DEFAULT '' COMMENT '报名状态',
  `sign_item_status` varchar(20) NULL DEFAULT '' COMMENT '报名项目状态',
  `sign_gift_bag_id` int(10) NULL DEFAULT 0 COMMENT '礼包id',
  `due_pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '应支付金额',
  `pay_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '实际支付金额',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `pay_status` varchar(20) NULL DEFAULT '' COMMENT '支付状态 0-未支付 1-已支付 2-已退款 3-退款审核中',
  `sign_time` datetime NULL DEFAULT NULL COMMENT '报名时间',
  `free_sign` tinyint(1) NULL DEFAULT 0 COMMENT '是否免费',
  `order_num` varchar(100) NULL DEFAULT '' COMMENT '订单号',
  `mid` int(10) NULL DEFAULT NULL COMMENT '',
  `emergency_contact` varchar(255) NULL DEFAULT NULL COMMENT '紧急联系人',
  `label` varchar(255) NULL DEFAULT NULL COMMENT '标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '活动报名-报名者'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_points_records   会员积分（获取和消费）记录
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_points_records`;
CREATE TABLE `ods_wenti_jianengliang_j_points_records`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `phone` varchar(20) NOT NULL COMMENT '手机号',
  `points` bigint(11) NULL DEFAULT NULL COMMENT '积分值',
  `record_time` datetime NULL DEFAULT NULL COMMENT '记录时间',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `platform` int(11) NULL DEFAULT NULL COMMENT '0-一起吗 1-馆佳 2-乐火',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `merchant_name` varchar(20) NULL DEFAULT NULL COMMENT '商户名称',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(50) NULL DEFAULT NULL COMMENT '场馆名称',
  `order_num` varchar(50) NULL DEFAULT NULL COMMENT '订单号',
  `unique_id` varchar(50) NULL DEFAULT NULL COMMENT '唯一识别id（如订单id，与此确保不会重复增加积分）',
  `goods_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '商品数量',
  `goods_title` varchar(50) NULL DEFAULT NULL COMMENT '商品标题',
  `goods_description` varchar(255) NULL DEFAULT NULL COMMENT '商品描述',
  `send_success` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否推送成功',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `send_message` varchar(255) NULL DEFAULT NULL COMMENT '推送结果',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员积分（获取和消费）记录'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_prize_detail   奖品明细表（不对，给场馆寄票/优惠券？）
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_prize_detail`;
CREATE TABLE `ods_wenti_jianengliang_j_prize_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `send_prize_id` int(11) NULL DEFAULT NULL COMMENT 'j_send_prize id',
  `prize_name` varchar(100) NULL DEFAULT NULL COMMENT '奖品名称',
  `start_date` varchar(50) NULL DEFAULT NULL COMMENT '有效期开始',
  `end_date` varchar(50) NULL DEFAULT NULL COMMENT '有效期结束',
  `use_address` varchar(100) NULL DEFAULT NULL COMMENT '使用地点',
  `use_venue` varchar(200) NULL DEFAULT NULL COMMENT '适用场馆',
  `express_company` varchar(50) NULL DEFAULT NULL COMMENT '快递公司',
  `express_no` varchar(100) NULL DEFAULT NULL COMMENT '快递单号',
  `description` varchar(200) NULL DEFAULT NULL COMMENT '说明',
  `worth` varchar(100) NULL DEFAULT NULL COMMENT '价值',
  `coupon_id` int(11) NULL DEFAULT NULL COMMENT '优惠券id',
  `coupon_num` int(11) NULL DEFAULT NULL COMMENT '优惠券数量',
  `points` int(11) NULL DEFAULT NULL COMMENT '积分',
  `reg_start_time` varchar(50) NULL DEFAULT NULL COMMENT '发送时间开始',
  `reg_end_time` varchar(50) NULL DEFAULT NULL COMMENT '发送时间结束',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_prize_id`(`send_prize_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '奖品明细表（不对，给场馆寄票/优惠券？）'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_report_check_record   体检报告表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_report_check_record`;
CREATE TABLE `ods_wenti_jianengliang_j_report_check_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_id` int(11) NOT NULL COMMENT 'h_member 用户id（可能是馆佳）',
  `venue_id` int(11) NOT NULL COMMENT 'venue_id 场馆id',
  `imgs` varchar(1000) NULL DEFAULT NULL COMMENT '图片(多个用,隔开)',
  `uuid` varchar(200) NULL DEFAULT NULL COMMENT 'uuid',
  `id_card` varchar(200) NULL DEFAULT NULL COMMENT 'id_card',
  `phone` varchar(255) NULL DEFAULT NULL COMMENT 'phone',
  `user_name` varchar(255) NULL DEFAULT NULL COMMENT '姓名',
  `status` int(11) NULL DEFAULT 2 COMMENT ' 体检校验 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用',
  `urgent_name` varchar(255) NULL DEFAULT '' COMMENT '紧急联系人',
  `urgent_phone` varchar(255) NULL DEFAULT '' COMMENT '紧急联系人电话',
  `face_images` varchar(255) NULL DEFAULT NULL COMMENT '人脸照片',
  `reason` varchar(500) NULL DEFAULT NULL COMMENT '拒绝原因',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `report_expire_date` datetime NULL DEFAULT NULL COMMENT '体检有效期',
  `source` int(11) NOT NULL DEFAULT 0 COMMENT '用户来源 1app2后台录入',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '体检报告表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_send_prize   发放奖品记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_send_prize`;
CREATE TABLE `ods_wenti_jianengliang_j_send_prize`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `activity_name` varchar(100) NULL DEFAULT NULL COMMENT '活动名称',
  `should_num` int(11) NULL DEFAULT NULL COMMENT '应发数量',
  `real_num` int(11) NULL DEFAULT NULL COMMENT '实发数量',
  `prize_type` int(11) NULL DEFAULT NULL COMMENT '奖品类型 1：线下礼品 2：邮寄礼品 3：线下优惠券 4：线上优惠券 5：积分',
  `send_status` int(11) NULL DEFAULT NULL COMMENT '发送状态 0：发送中 1：已发送',
  `failure_num` int(11) NULL DEFAULT NULL COMMENT '失败数量',
  `opt_user` varchar(20) NULL DEFAULT NULL COMMENT '操作人',
  `use_num` int(11) NULL DEFAULT NULL COMMENT '使用数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '',
  `target_user` int(11) NULL DEFAULT NULL COMMENT '目标用户 1.excel 2.手动输入 3。新注册用户',
  `enable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '启用，禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '发放奖品记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_send_prize_record   奖品发放记录表（发送目标用户，是否核销、已读等）
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_send_prize_record`;
CREATE TABLE `ods_wenti_jianengliang_j_send_prize_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `send_prize_id` int(11) NULL DEFAULT NULL COMMENT 'j_send_prize id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '目标用户',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发放时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `use_name` varchar(50) NULL DEFAULT NULL COMMENT '核销方',
  `is_use` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否核销',
  `is_pop` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否弹窗',
  `is_view` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '奖品发放记录表（发送目标用户，是否核销、已读等）'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_time_card_use   次卡使用表（绑定卡id，不直接绑定用户）
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_time_card_use`;
CREATE TABLE `ods_wenti_jianengliang_j_time_card_use`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `card_id` int(11) NOT NULL COMMENT '用户卡id',
  `discount` decimal(10, 2) NOT NULL COMMENT '抵扣时长',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `venue_name` varchar(255) NOT NULL DEFAULT '' COMMENT '场馆名称',
  `open_time` datetime NOT NULL COMMENT '开场时间',
  `order_num` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `order_time` datetime NOT NULL COMMENT '消费时间',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `status` int(11) NOT NULL COMMENT '0.未抵扣 1.已抵扣',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '次卡使用表（绑定卡id，不直接绑定用户）'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_j_venue_reserve   用户电话预定场馆表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_j_venue_reserve`;
CREATE TABLE `ods_wenti_jianengliang_j_venue_reserve`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `name` varchar(255) NULL DEFAULT NULL COMMENT '姓名',
  `time` varchar(255) NULL DEFAULT NULL COMMENT '预定时间',
  `phone` varchar(255) NULL DEFAULT NULL COMMENT '用户电话',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '预定备注',
  `sex` int(11) NULL DEFAULT NULL COMMENT '1 男 2女',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `handle_user` varchar(255) NULL DEFAULT NULL COMMENT '处理人',
  `handle_remark` varchar(255) NULL DEFAULT NULL COMMENT '处理备注',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '0 待处理 1已处理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '用户电话预定场馆表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_jianengliang_p_park_customer   停车场客户表（只有一个场馆接入）
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_jianengliang_p_park_customer`;
CREATE TABLE `ods_wenti_jianengliang_p_park_customer`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_name` varchar(255) NULL DEFAULT NULL COMMENT '用户名称',
  `user_phone` varchar(20) NULL DEFAULT NULL COMMENT '用户手机号',
  `car_no` varchar(50) NULL DEFAULT NULL COMMENT '车牌号',
  `is_yellow_car` tinyint(1) NULL DEFAULT NULL COMMENT '是否黄牌车',
  `is_new_enegry` tinyint(1) NULL DEFAULT NULL COMMENT '是否新能源车',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_virtual` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否无牌车生成的虚拟车牌',
  `certificate_no` varchar(255) NULL DEFAULT NULL COMMENT '无牌车生成的凭证号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_phone`(`user_phone`) USING BTREE COMMENT '用户手机号'
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '停车场客户表（只有一个场馆接入）'
  ROW_FORMAT = DYNAMIC;

-- ============================================================
-- 来源数据库：training
-- ============================================================

-- ----------------------------
-- ods_wenti_training_h_card   实体卡表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_h_card`;
CREATE TABLE `ods_wenti_training_h_card`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `card_code` varchar(30) NOT NULL COMMENT '卡号',
  `card_track` varchar(30) NOT NULL COMMENT '卡磁道',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '实体卡表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_h_member_course_refund   会员课程退款申请表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_h_member_course_refund`;
CREATE TABLE `ods_wenti_training_h_member_course_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 0-审核中 1-审核通过 2-审核拒绝 3-已退款 4-已同意',
  `name` varchar(255) NULL DEFAULT NULL COMMENT '名称',
  `phone` varchar(255) NULL DEFAULT NULL COMMENT '申请人手机号',
  `apply_phone` varchar(255) NULL DEFAULT NULL COMMENT '报名人手机号，以逗号相隔',
  `refund_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `actual_refund_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '实际退款金额',
  `bank_name` varchar(255) NULL DEFAULT NULL COMMENT '银行名称',
  `bank_account` varchar(255) NULL DEFAULT NULL COMMENT '银行卡号',
  `bank_card_image` varchar(255) NULL DEFAULT NULL COMMENT '银行卡照片',
  `account_name` varchar(255) NULL DEFAULT NULL COMMENT '开户名',
  `id_card` varchar(255) NULL DEFAULT NULL COMMENT '身份证号',
  `id_card_image` varchar(255) NULL DEFAULT NULL COMMENT '身份证照片',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_user_id` int(11) NULL DEFAULT NULL COMMENT '更新人',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `item_id` varchar(500) NULL DEFAULT NULL COMMENT '项目',
  `item_name` varchar(500) NULL DEFAULT NULL COMMENT '项目名，以逗号相隔',
  `update_material` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否更新材料',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员课程退款申请表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_m_trade_order   order_status:              PAYING(\"100\", \"未付款\"),  PAID_FIELD(\"101\", \"已付款\"), PAY_CLOSE(\"102\",\"支付超时\"), CANCEL(\"103\",\"取消订单\"), FINISHED(\"200\", \"已完成\"), REFUNDED(\"300\", \"退款完成\"), REFUNDING(\"301\",\"退款中\") COMMENT = 
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_m_trade_order`;
CREATE TABLE `ods_wenti_training_m_trade_order`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) NOT NULL COMMENT '订单号',
  `order_type` varchar(20) NULL DEFAULT '' COMMENT '订单类型',
  `order_type_name` varchar(120) NULL DEFAULT '' COMMENT '订单类型名称',
  `order_item_type` varchar(20) NULL DEFAULT '' COMMENT '订单项目类型',
  `is_account_business` tinyint(1) NULL DEFAULT 0 COMMENT '是否记账订单',
  `customer_phone` varchar(50) NULL DEFAULT '' COMMENT '客户手机号',
  `customer_name` varchar(200) NULL DEFAULT '' COMMENT '客户名称',
  `student_id` int(11) NULL DEFAULT NULL COMMENT '学生id',
  `order_time` datetime NULL DEFAULT NULL COMMENT '下单时间',
  `order_remark` varchar(300) NULL DEFAULT '' COMMENT '下单备注',
  `order_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '订单金额',
  `merchant_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '商家优惠金额',
  `landlord_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '租主优惠金额',
  `list_desc` varchar(500) NULL DEFAULT NULL COMMENT '用于C端列表展示的一些数据',
  `pay_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `order_status` varchar(20) NULL DEFAULT '' COMMENT '订单状态',
  `status_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '状态时间',
  `consume_time` datetime NULL DEFAULT NULL COMMENT '消费时间',
  `pay_way` varchar(20) NULL DEFAULT '' COMMENT '支付方式',
  `is_mini_app_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否为小程序支付(兼容微信)',
  `pay_remark` varchar(300) NULL DEFAULT '' COMMENT '付款备注',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '付款时间',
  `pay_no` varchar(100) NULL DEFAULT '' COMMENT '支付流水号',
  `pay_params` text NULL COMMENT '第三方支付参数',
  `create_order_param` text NULL COMMENT '下单参数',
  `origin_type` tinyint(1) NULL DEFAULT 0 COMMENT '来源类型(是否C端订单)',
  `fail_pay_remark` varchar(300) NULL DEFAULT '' COMMENT '付款失败备注',
  `cancel_remark` varchar(300) NULL DEFAULT '' COMMENT '取消备注',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '基地id',
  `venue_name` varchar(300) NULL DEFAULT '' COMMENT '基地名称',
  `mechant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `mechant_name` varchar(300) NULL DEFAULT '' COMMENT '商户名称',
  `operator_id` int(11) NULL DEFAULT NULL COMMENT '操作id',
  `operator_name` varchar(120) NULL DEFAULT '' COMMENT '操作人名称',
  `is_hidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否查询隐藏',
  `evaluated` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已评价',
  `active_status` int(1) NULL DEFAULT NULL COMMENT '是否已激活',
  `active_time` datetime NULL DEFAULT NULL COMMENT '激活时间',
  `sex` int(11) NULL DEFAULT NULL COMMENT '1男2女',
  `sickness` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否有疾病',
  `id_card` varchar(300) NULL DEFAULT '' COMMENT '下单身份证号',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = 'order_status:              PAYING(\\"100\\", \\"未付款\\"),  PAID_FIELD(\\"101\\", \\"已付款\\"), PAY_CLOSE(\\"102\\",\\"支付超时\\"), CANCEL(\\"103\\",\\"取消订单\\"), FINISHED(\\"200\\", \\"已完成\\"), REFUNDED(\\"300\\", \\"退款完成\\"), REFUNDING(\\"301\\",\\"退款中\\") COMMENT = ';

-- ----------------------------
-- ods_wenti_training_m_trade_order_course   订单课程信息表\r\nstatus:                   NOT_ACTIVE(0, \"待激活\"), ACTIVE(1, \"已激活\"), CANCEL(2,\"已取消\"), REFUND(3,\"已退款\"),TRANSFER(4,\"已转课\") COMMENT = 
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_m_trade_order_course`;
CREATE TABLE `ods_wenti_training_m_trade_order_course`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(50) NOT NULL COMMENT '订单号',
  `student_id` int(11) NULL DEFAULT NULL COMMENT '学员id',
  `course_id` int(11) NOT NULL COMMENT '课程id',
  `spec_id` int(11) NOT NULL COMMENT '规格id',
  `course_name` varchar(255) NOT NULL COMMENT '课程名',
  `spec_name` varchar(255) NOT NULL COMMENT '规格名',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '订单课程信息表';

-- ----------------------------
-- ods_wenti_training_m_trade_order_detail   交易订单-项目明细表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_m_trade_order_detail`;
CREATE TABLE `ods_wenti_training_m_trade_order_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) NOT NULL DEFAULT '' COMMENT '订单号',
  `item_id` int(10) NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(300) NULL DEFAULT '' COMMENT '项目名称',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单-项目明细表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_m_trade_order_refund   交易订单退款表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_m_trade_order_refund`;
CREATE TABLE `ods_wenti_training_m_trade_order_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `refund_num` varchar(50) NOT NULL COMMENT '退款单号',
  `order_num` varchar(50) NOT NULL COMMENT '订单号',
  `is_mini_app_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否为小程序支付(兼容微信)',
  `pay_way` varchar(20) NULL DEFAULT '' COMMENT '支付方式',
  `refund_user_name` varchar(120) NULL DEFAULT '' COMMENT '退款人',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_trade_no` varchar(300) NULL DEFAULT '' COMMENT '第三方退款流水号',
  `refund_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `deducted_card_type` varchar(200) NULL DEFAULT '' COMMENT '抵扣卡类型',
  `deducted_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣金额',
  `deducted_quato` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣额度',
  `refund_remark` varchar(300) NULL DEFAULT '' COMMENT '退款备注',
  `refund_type` varchar(20) NULL DEFAULT '' COMMENT '退款方式',
  `refund_param` text NULL COMMENT '退款参数',
  `refund_response` text NULL COMMENT '第三方返回响应',
  `fail_reason` varchar(300) NULL DEFAULT '' COMMENT '第三方退款失败原因',
  `refund_status` varchar(20) NULL DEFAULT '' COMMENT '退款状态',
  `is_success` tinyint(1) NULL DEFAULT 0 COMMENT '退款是否成功',
  `audit_advise` varchar(500) NULL DEFAULT '' COMMENT '审核意见',
  `audit_operator` varchar(120) NULL DEFAULT '' COMMENT '审核人',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `operation_type` int(2) NULL DEFAULT 1 COMMENT '1:退钱，2：不退钱',
  `status` int(11) NULL DEFAULT 1 COMMENT '1:正常，2：删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单退款表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_m_transfer_course_record   转课记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_m_transfer_course_record`;
CREATE TABLE `ods_wenti_training_m_transfer_course_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `course_id` int(11) NULL DEFAULT NULL COMMENT '转课后的新课程的课程id，t_course',
  `order_num` varchar(255) NULL DEFAULT NULL COMMENT '转课生成的订单号',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '转课记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_t_class   班级表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_t_class`;
CREATE TABLE `ods_wenti_training_t_class`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id(训练基地id)',
  `name` varchar(50) NULL DEFAULT NULL COMMENT '班级名称',
  `course_id` int(11) NULL DEFAULT NULL COMMENT '课程id',
  `class_type` varchar(50) NULL DEFAULT NULL COMMENT '班级类型',
  `class_code` varchar(50) NULL DEFAULT NULL COMMENT '班级编号',
  `sport_id` int(11) NULL DEFAULT NULL COMMENT '运用类型id',
  `class_hour` decimal(11, 2) NULL DEFAULT NULL COMMENT '课时',
  `present` tinyint(1) NULL DEFAULT NULL COMMENT '缺课是否扣除课时',
  `reserve_enable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否启用预约限制人数',
  `reserve_hour` int(11) NULL DEFAULT NULL COMMENT '开课前x小时',
  `reserve_people` int(11) NULL DEFAULT NULL COMMENT '预约限制人数',
  `reserve_cancel_hour` int(11) NULL DEFAULT NULL COMMENT '开课前x小时不能取消约课',
  `remind_enable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否启用上课提醒',
  `remind_hour` int(11) NULL DEFAULT NULL COMMENT '开课前x小时提醒',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `delete_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `delete_by` varchar(50) NULL DEFAULT NULL COMMENT '删除人',
  `top` tinyint(1) NULL DEFAULT 0 COMMENT '是否置顶 0-否 1-是',
  `top_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '置顶时间',
  `sale_status` int(11) NOT NULL DEFAULT 0 COMMENT '上/下架状态 0-下架 1-上架',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '班级表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_t_class_teacher   教师-班级关联表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_t_class_teacher`;
CREATE TABLE `ods_wenti_training_t_class_teacher`  (
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '教师-班级关联表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_t_student   学生表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_t_student`;
CREATE TABLE `ods_wenti_training_t_student`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id(训练基地id)',
  `name` varchar(100) NULL DEFAULT NULL COMMENT '学员名',
  `phone` varchar(20) NULL DEFAULT NULL COMMENT '手机',
  `id_card` varchar(50) NULL DEFAULT NULL COMMENT '身份证',
  `student_code` varchar(50) NULL DEFAULT NULL COMMENT '学员编号',
  `card_id` int(11) NULL DEFAULT NULL COMMENT '实体卡id',
  `sex` int(11) NULL DEFAULT NULL COMMENT '1男2女',
  `source` varchar(20) NULL DEFAULT NULL COMMENT '来源',
  `address` varchar(255) NULL DEFAULT NULL COMMENT '地址',
  `contact1` varchar(20) NULL DEFAULT NULL COMMENT '联系人1',
  `contact1_phone` varchar(20) NULL DEFAULT NULL COMMENT '联系人1电话',
  `contact2` varchar(20) NULL DEFAULT NULL COMMENT '联系人2',
  `contact2_phone` varchar(20) NULL DEFAULT NULL COMMENT '联系人2电话',
  `class_hour` int(11) NULL DEFAULT NULL COMMENT '课时',
  `image` varchar(255) NULL DEFAULT NULL COMMENT '头像',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '状态',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `delete_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
  `delete_by` varchar(20) NULL DEFAULT NULL COMMENT '删除人',
  `sickness` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否有疾病',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name_phone`(`venue_id`, `phone`, `name`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '学生表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_t_student_check   学生消课记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_t_student_check`;
CREATE TABLE `ods_wenti_training_t_student_check`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `card_no` varchar(20) NULL DEFAULT NULL COMMENT '卡号',
  `student_name` varchar(20) NULL DEFAULT NULL COMMENT '学生姓名',
  `course_name` varchar(100) NULL DEFAULT NULL COMMENT '课程名',
  `class_name` varchar(100) NULL DEFAULT NULL COMMENT '班级名',
  `end_date` varchar(20) NULL DEFAULT NULL COMMENT '有效期至',
  `total_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总课时',
  `deduct_amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '抵扣金额',
  `syllabus_student_id` int(11) NULL DEFAULT NULL COMMENT '上课记录id',
  `prev_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '当前课时',
  `deduct_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '抵扣课时',
  `remain_class_hour` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '剩余课时',
  `check_time` varchar(20) NULL DEFAULT NULL COMMENT '签到时间',
  `venue_name` varchar(50) NULL DEFAULT NULL COMMENT '训练基地名',
  `opt_user` varchar(20) NULL DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '学生消课记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_t_student_course   学生参加课程表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_t_student_course`;
CREATE TABLE `ods_wenti_training_t_student_course`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `student_id` int(11) NOT NULL COMMENT '学生id',
  `course_id` int(11) NOT NULL COMMENT '课程id',
  `order_course_id` int(11) NULL DEFAULT NULL COMMENT '订单明细id,m_trade_order_course',
  `class_id` int(11) NULL DEFAULT NULL COMMENT '班级id',
  `ori_order_course_id` int(11) NULL DEFAULT NULL COMMENT '原始订单明细id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '学生参加课程表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_t_student_jnl   学生-一起吗(加能量)账号关联表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_t_student_jnl`;
CREATE TABLE `ods_wenti_training_t_student_jnl`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `jnl_phone` varchar(20) NOT NULL COMMENT '加能量(一起吗)手机号',
  `student_id` int(11) NOT NULL COMMENT '学生id',
  `is_default` int(2) NOT NULL COMMENT '是否默认(1-默认,2-不默认)(一起吗默认显示学生信息)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '学生-一起吗(加能量)账号关联表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_t_student_transfer   学生转课记录
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_t_student_transfer`;
CREATE TABLE `ods_wenti_training_t_student_transfer`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `student_id` int(11) NULL DEFAULT NULL COMMENT '学生id',
  `ori_course_id` int(11) NULL DEFAULT NULL COMMENT '原课程id',
  `ori_course_name` varchar(50) NULL DEFAULT NULL COMMENT '原课程名',
  `new_course_id` int(11) NULL DEFAULT NULL COMMENT '新课程id',
  `new_course_name` varchar(50) NULL DEFAULT NULL COMMENT '新课程名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '学生转课记录'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_training_t_syllabus_student   学生上课记录表\r\n  `status` int(11) DEFAULT NULL COMMENT '考勤状态 0：待上课  1：已签到 2：已点名 3：请假 4：缺课',
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_training_t_syllabus_student`;
CREATE TABLE `ods_wenti_training_t_syllabus_student`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id(训练基地id)',
  `syllabus_id` int(11) NOT NULL COMMENT '课程安排id',
  `student_id` int(11) NOT NULL COMMENT '学生id',
  `order_course_id` int(11) NOT NULL COMMENT '订单明细id,m_trade_order_course',
  `deduct_amount` decimal(20, 2) NULL DEFAULT NULL COMMENT '课消金额',
  `status` int(11) NULL DEFAULT NULL COMMENT '考勤状态 0：待上课 1：已签到 2：已点名 3：请假 4：缺课',
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
  `check_time` varchar(20) NULL DEFAULT NULL COMMENT '签到时间',
  `reserve_time` varchar(20) NULL DEFAULT NULL COMMENT '预约时间',
  `call_time` varchar(20) NULL DEFAULT NULL COMMENT '点名时间',
  `leave_time` varchar(20) NULL DEFAULT NULL COMMENT '请假时间',
  `leave_type` int(11) NULL DEFAULT NULL COMMENT '请假方式 0：线下 1：线上',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `student_id`(`student_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '学生上课记录表\\r\\n  `status` int(11) DEFAULT NULL COMMENT \'考勤状态 0：待上课  1：已签到 2：已点名 3：请假 4：缺课\','
  ROW_FORMAT = DYNAMIC;
  

-- ============================================================
-- 来源数据库：vmdb
-- ============================================================

-- ----------------------------
-- ods_wenti_vmdb_gate_link_lock   闸机租柜联动记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_gate_link_lock`;
CREATE TABLE `ods_wenti_vmdb_gate_link_lock`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `phone` varchar(20) NULL DEFAULT NULL COMMENT '手机号',
  `status` int(11) NULL DEFAULT NULL COMMENT '1-开闸 2-租柜 3-还柜 4-出闸',
  `gate_open_time` datetime NULL DEFAULT NULL COMMENT '开闸时间',
  `gate_close_time` datetime NULL DEFAULT NULL COMMENT '出闸时间',
  `lock_open_time` datetime NULL DEFAULT NULL COMMENT '开柜时间',
  `lock_close_time` datetime NULL DEFAULT NULL COMMENT '还柜时间',
  `gate_open_from` char(1) NULL DEFAULT NULL COMMENT '入闸方式 1-吞卡 2-刷卡 3-二维码 4-人脸',
  `track_info` varchar(50) NULL DEFAULT NULL COMMENT '二维码字符串',
  `out_track_info` varchar(50) NULL DEFAULT NULL COMMENT '出闸二维码',
  `registed_palm` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否注册了掌纹',
  `gate_close_from` char(1) NULL DEFAULT NULL COMMENT '出闸方式',
  `registed_sn` varchar(50) NULL DEFAULT NULL COMMENT '注册掌纹设备',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_phone`(`phone`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '闸机租柜联动记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_card   实体卡表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_card`;
CREATE TABLE `ods_wenti_vmdb_h_card`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `card_code` varchar(30) NOT NULL COMMENT '卡号',
  `card_track` varchar(30) NOT NULL COMMENT '卡磁道',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '实体卡表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_card_vip   会员卡(实体卡绑定)表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_card_vip`;
CREATE TABLE `ods_wenti_vmdb_h_card_vip`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `card_id` int(11) NOT NULL COMMENT '关联实体卡id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `is_valid` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否消费验证',
  `is_work_cost` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否收取工本费',
  `order_num` varchar(30) NULL DEFAULT '' COMMENT '订单号',
  `model_type` int(2) NULL DEFAULT NULL COMMENT '收费类型（1.办卡工本费 2.补卡工本费）',
  `is_main` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为主卡',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否可用（0停用 1可用）',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `last_enter_gate_date` datetime NULL DEFAULT '1999-12-01 00:00:00' COMMENT '最后一次入闸时间',
  `gmt_create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_create_user` varchar(200) NULL DEFAULT '' COMMENT '创建人',
  `gmt_update_user` varchar(200) NULL DEFAULT '' COMMENT '操作人',
  `gmt_update_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `MEMBER_ID`(`member_id`) USING BTREE,
  INDEX `CARD_ID`(`card_id`) USING BTREE,
  INDEX `MERCHANT_ID`(`merchant_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员卡(实体卡绑定)表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_id_card_check_record   id_card校验表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_id_card_check_record`;
CREATE TABLE `ods_wenti_vmdb_h_id_card_check_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `id_card` varchar(255) NULL DEFAULT NULL COMMENT '会员卡号',
  `phone` varchar(255) NOT NULL DEFAULT '' COMMENT '手机号码',
  `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `type` int(11) NULL DEFAULT 1 COMMENT '1 老人2少年',
  `code` varchar(11) NULL DEFAULT NULL COMMENT '成功为200（10000），其它为失败状态码',
  `company_type` int(11) NULL DEFAULT 1 COMMENT 'company_type 1 天眼 2网易 3数据宝',
  `msg` varchar(255) NOT NULL DEFAULT '' COMMENT 'code对应的说明描述',
  `result` int(1) NOT NULL DEFAULT 1 COMMENT '1-一致，2-不一致，3：异常情况',
  `order_no` varchar(255) NULL DEFAULT NULL COMMENT '	订单号',
  `sex` varchar(255) NULL DEFAULT NULL COMMENT '性别',
  `check_desc` varchar(255) NULL DEFAULT NULL COMMENT '验证结果描述信息',
  `birthday` varchar(255) NULL DEFAULT NULL COMMENT '	生日',
  `address` varchar(255) NULL DEFAULT NULL COMMENT '	籍贯',
  `task_id` varchar(255) NULL DEFAULT NULL COMMENT '本次请求数据标识，可以根据该标识在控制台进行数据查询',
  `reason_type` int(1) NULL DEFAULT 1 COMMENT '	原因详情，1：认证通过 2：输入姓名和身份证号不一致 3：查无此身份证 7：结果获取失败，请重试',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '	认证结果，1：认证通过，2：认证不通过',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `source` int(11) NULL DEFAULT 1 COMMENT '来源 1:馆佳pc 2:一起吗',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = 'id_card校验表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_member   会员信息表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_member`;
CREATE TABLE `ods_wenti_vmdb_h_member`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(30) NOT NULL COMMENT '姓名',
  `sex` int(11) NULL DEFAULT NULL COMMENT '性别（0女 1男）',
  `phone` varchar(20) NOT NULL COMMENT '手机号',
  `discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '会员折扣',
  `card_id` int(11) NULL DEFAULT NULL COMMENT '关联实体卡id',
  `id_card` varchar(100) NULL DEFAULT NULL COMMENT '身份证号码',
  `birthday` datetime NULL DEFAULT NULL COMMENT '出生日期',
  `remarks` varchar(100) NULL DEFAULT NULL COMMENT '备注',
  `photo` varchar(255) NULL DEFAULT NULL COMMENT '照片',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user_id` int(11) NOT NULL COMMENT '创建人员id',
  `up_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `up_user_id` int(11) NOT NULL COMMENT '修改人员id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  `is_valid` tinyint(1) NULL DEFAULT 0 COMMENT '是否消费验证',
  `is_work_cost` tinyint(1) NULL DEFAULT 0 COMMENT '是否收取工本费',
  `order_num` varchar(30) NULL DEFAULT NULL COMMENT '订单号',
  `model_type` int(2) NULL DEFAULT NULL COMMENT '收费类型（1.办卡工本费 2.补卡工本费）',
  `channel` int(10) NULL DEFAULT 1 COMMENT '数据来源渠道，1：pc，2：app',
  `is_success` tinyint(1) NULL DEFAULT 0 COMMENT '线上开卡是否注册成功（只对线上开卡有用）',
  `urgent_name` varchar(255) NULL DEFAULT '' COMMENT '紧急联系人',
  `urgent_phone` varchar(255) NULL DEFAULT '' COMMENT '紧急联系人电话',
  `is_face_enable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '人脸是否可用 0-不可用 1-可用',
  `id_card_create_time` datetime NULL DEFAULT NULL COMMENT 'id_card上传时间',
  `report_create_time` datetime NULL DEFAULT NULL COMMENT '体检上传时间',
  `id_card_check` int(11) NULL DEFAULT 1 COMMENT ' id_card校验 1：未校验，2：已校验，3：过期，4：禁用',
  `id_card_expire_date` datetime NULL DEFAULT NULL COMMENT 'id_card有效期',
  `report_expire_date` datetime NULL DEFAULT NULL COMMENT '体检有效期',
  `report_check` int(11) NULL DEFAULT 1 COMMENT ' 体检校验 1：未上传， 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用',
  `signature` varchar(255) NULL DEFAULT NULL COMMENT '签名',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `merchant_phone_unique`(`merchant_id`, `phone`) USING BTREE,
  INDEX `card_id`(`card_id`) USING BTREE,
  INDEX `venue_id`(`venue_id`) USING BTREE,
  INDEX `create_user_id`(`create_user_id`) USING BTREE,
  INDEX `up_user_id`(`up_user_id`) USING BTREE,
  INDEX `phone`(`phone`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员信息表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_member_card   会员专项卡表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_member_card`;
CREATE TABLE `ods_wenti_vmdb_h_member_card`  (
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员专项卡表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_member_card_refund   会员卡退款申请表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_member_card_refund`;
CREATE TABLE `ods_wenti_vmdb_h_member_card_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '会员id',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 0-审核中 1-审核通过 2-审核拒绝 3-已退款 4-已同意',
  `name` varchar(255) NULL DEFAULT NULL COMMENT '名称',
  `phone` varchar(255) NULL DEFAULT NULL COMMENT '手机号',
  `apply_phone` varchar(255) NULL DEFAULT NULL COMMENT '申请手机号',
  `item_id` varchar(500) NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(500) NULL DEFAULT NULL COMMENT '项目名称',
  `refund_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `actual_refund_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '实际退款金额',
  `bank_name` varchar(255) NULL DEFAULT NULL COMMENT '银行名称',
  `bank_account` varchar(255) NULL DEFAULT NULL COMMENT '银行卡号',
  `bank_card_image` varchar(255) NULL DEFAULT NULL COMMENT '银行卡照片',
  `account_name` varchar(255) NULL DEFAULT NULL COMMENT '开户名',
  `id_card` varchar(255) NULL DEFAULT NULL COMMENT '身份证号',
  `id_card_image` varchar(255) NULL DEFAULT NULL COMMENT '身份证照片',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_user_id` int(11) NULL DEFAULT NULL COMMENT '更新人',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `update_material` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否更新材料',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员卡退款申请表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_member_charge   会员充值记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_member_charge`;
CREATE TABLE `ods_wenti_vmdb_h_member_charge`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '会员id',
  `card_vip_id` int(11) NULL DEFAULT NULL COMMENT '会员实体卡id',
  `card_sales_id` int(11) NOT NULL COMMENT '售卡id',
  `enable_date` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '启用日期',
  `recharge_numoramount` decimal(10, 2) NULL DEFAULT NULL COMMENT '充值金额/次',
  `present_numoramount` decimal(10, 2) NULL DEFAULT NULL COMMENT '赠送金额/次',
  `sell_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '售价',
  `order_num` varchar(30) NOT NULL COMMENT '订单号',
  `is_used` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已使用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员充值记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_member_deducted   会员卡抵扣记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_member_deducted`;
CREATE TABLE `ods_wenti_vmdb_h_member_deducted`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `is_cancel` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否取消',
  `member_card_id` int(11) NOT NULL COMMENT '专项卡id',
  `deductedQuato` decimal(10, 2) NOT NULL COMMENT '抵扣额度',
  `order_num` varchar(30) NOT NULL COMMENT '订单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员卡抵扣记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_member_record   会员卡消费/充值流水表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_member_record`;
CREATE TABLE `ods_wenti_vmdb_h_member_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_card_id` int(11) NOT NULL COMMENT '专项卡记录id',
  `type` int(11) NOT NULL COMMENT '类型（0.记账,1.退款 2.消费 3.充值）',
  `order_num` varchar(30) NULL DEFAULT NULL COMMENT '订单号',
  `discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '使用折扣',
  `amount_or_num` decimal(10, 2) NULL DEFAULT NULL COMMENT '金额/次',
  `present` decimal(10, 2) NULL DEFAULT NULL COMMENT '赠送',
  `present_consume` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '赠送消费',
  `balance` decimal(10, 2) NULL DEFAULT NULL COMMENT '余额/次',
  `present_balance` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '赠送余额',
  `channel` int(11) NULL DEFAULT NULL COMMENT '渠道（1.网络 2.线下），注意：该字段与其他表取值不一致',
  `remarks` varchar(255) NULL DEFAULT NULL COMMENT '备注',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '会员卡消费/充值流水表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_h_member_report_approval   用户体检报告审核
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_h_member_report_approval`;
CREATE TABLE `ods_wenti_vmdb_h_member_report_approval`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '会员id',
  `name` varchar(50) NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(50) NULL DEFAULT NULL COMMENT '手机号',
  `id_card` varchar(50) NULL DEFAULT NULL COMMENT '证件号码',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '状态 1：未上传， 2：审核中、3：审核通过、4：审核未通过、5：已过期、6：已禁用 ',
  `valid_date` datetime NULL DEFAULT NULL COMMENT '有效期',
  `approval_user_id` int(11) NULL DEFAULT NULL COMMENT '审核人id',
  `approval_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `attachment` varchar(1000) NULL DEFAULT NULL COMMENT '附件',
  `reason` varchar(500) NULL DEFAULT NULL COMMENT '拒绝原因',
  `remark` varchar(500) NULL DEFAULT NULL COMMENT '备注',
  `uuid` varchar(200) NULL DEFAULT NULL COMMENT 'uuid',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user_id` int(11) NULL DEFAULT NULL COMMENT '创建人员id',
  `create_name` varchar(20) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `update_user_id` int(11) NULL DEFAULT NULL COMMENT '修改人员id',
  `update_name` varchar(20) NULL DEFAULT NULL COMMENT '修改人',
  `source` int(11) NULL DEFAULT 1 COMMENT '来源 1:馆佳pc 2:一起吗',
  `is_deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  `urgent_name` varchar(255) NULL DEFAULT NULL COMMENT '紧急联系人',
  `urgent_phone` varchar(255) NULL DEFAULT NULL COMMENT '紧急联系人电话',
  `face_images` varchar(255) NULL DEFAULT NULL COMMENT '人脸照片',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `member_report_approval_query`(`merchant_id`, `venue_id`, `member_id`) USING BTREE,
  INDEX `member_report_approval_phone`(`phone`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '用户体检报告审核'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_enter_gate   入闸记录
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_enter_gate`;
CREATE TABLE `ods_wenti_vmdb_m_enter_gate`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `type` int(11) NOT NULL COMMENT '1.单次卡 2.次卡 3.场次卡 4.二维码 5.时段卡 6.管理卡',
  `qr_code_type` int(11) NULL DEFAULT NULL COMMENT '二维码类型 1.散票 2.团体票 3.通票',
  `card_name` varchar(50) NULL DEFAULT NULL COMMENT '卡名',
  `item_id` int(11) NULL DEFAULT NULL COMMENT '不同类型对应不同id',
  `card_no` varchar(50) NULL DEFAULT NULL COMMENT '卡号/二维码',
  `order_num` varchar(50) NULL DEFAULT NULL COMMENT '订单号',
  `gate_name` varchar(50) NULL DEFAULT NULL COMMENT '闸机名',
  `remark` varchar(50) NULL DEFAULT NULL COMMENT '备注',
  `status` int(11) NOT NULL COMMENT '状态 1.正常 2.已撤回',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '入闸记录'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_group_ticket_no   团体票号表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_group_ticket_no`;
CREATE TABLE `ods_wenti_vmdb_m_group_ticket_no`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `sale_id` int(11) NULL DEFAULT NULL COMMENT '销售记录id',
  `pregeneration_id` int(11) NULL DEFAULT NULL COMMENT '预生成记录id',
  `ticket_no` varchar(50) NOT NULL COMMENT '票号',
  `random_code` varchar(10) NULL DEFAULT NULL COMMENT '随机码',
  `remain_num` int(11) NOT NULL COMMENT '剩余核销次数',
  `verify_num` int(11) NOT NULL DEFAULT 0 COMMENT '前台核销次数',
  `bingding_status` int(1) NOT NULL DEFAULT 0 COMMENT 'C端绑定状态 1：已绑定',
  `bingding_mobile` varchar(20) NULL DEFAULT NULL COMMENT 'C端绑定绑定手机号',
  `enter_gate_num` int(11) NOT NULL DEFAULT 0 COMMENT '入闸核销次数',
  `status` int(11) NOT NULL COMMENT '状态 0：未激活 1：已激活 2：已使用 3：部分使用 4.已过期',
  `verify_time` datetime NULL DEFAULT NULL COMMENT '首次核销时间',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `viewd` tinyint(1) NULL DEFAULT 0 COMMENT '是否已读',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_no`(`ticket_no`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '团体票号表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_group_ticket_sale   团体票销售记录
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_group_ticket_sale`;
CREATE TABLE `ods_wenti_vmdb_m_group_ticket_sale`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `order_num` varchar(255) NOT NULL COMMENT '订单号',
  `ticket_id` int(11) NOT NULL COMMENT '团体票id',
  `ticket_name` varchar(50) NULL DEFAULT NULL COMMENT '团体票名',
  `ticket_type` int(11) NULL DEFAULT NULL COMMENT '1:单次票',
  `sport_id` varchar(255) NULL DEFAULT NULL COMMENT '运动类型',
  `total` int(11) NOT NULL COMMENT '销售数量',
  `used` int(11) NULL DEFAULT 0 COMMENT '已使用数量',
  `status` int(11) NULL DEFAULT NULL COMMENT '票号状态 1：生成中 2：已生成',
  `price` decimal(20, 2) NULL DEFAULT NULL COMMENT '单价（折前）',
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否显示',
  `expire_date` date NULL DEFAULT NULL COMMENT '过期日期',
  `sale_way` int(11) NULL DEFAULT NULL COMMENT '销售方式 1：电子 2：纸质',
  `start_ticket_no` varchar(50) NULL DEFAULT NULL COMMENT '开始票号',
  `end_ticket_no` varchar(50) NULL DEFAULT NULL COMMENT '结束票号',
  `sale_employee_id` int(11) NULL DEFAULT NULL COMMENT '销售人id',
  `sale_employee` varchar(50) NULL DEFAULT NULL COMMENT '销售人名',
  `download_employee` varchar(50) NULL DEFAULT NULL COMMENT '最近下载人',
  `download_time` datetime NULL DEFAULT NULL COMMENT '最近下载时间',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `give_total` int(11) NOT NULL DEFAULT 0 COMMENT '赠送数量',
  `start_date` date NULL DEFAULT NULL COMMENT '开始日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '团体票销售记录'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_group_ticket_verify   团体票号核销记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_group_ticket_verify`;
CREATE TABLE `ods_wenti_vmdb_m_group_ticket_verify`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `ticket_no_id` int(11) NOT NULL COMMENT '团体票票号id',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_no`(`ticket_no_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '团体票号核销记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order   交易订单主表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) NOT NULL COMMENT '订单号',
  `order_type` varchar(20) NULL DEFAULT '' COMMENT '订单类型',
  `order_type_name` varchar(120) NULL DEFAULT '' COMMENT '订单类型名称',
  `order_item_type` varchar(20) NULL DEFAULT '' COMMENT '订单项目类型',
  `is_account_business` tinyint(1) NULL DEFAULT 0 COMMENT '是否记账订单',
  `is_new_card` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为新卡(仅充值有效)',
  `order_ticket_type` int(11) NULL DEFAULT NULL COMMENT '售票订单票务类型 1：散票 2：团体票',
  `member_id` int(11) NULL DEFAULT NULL COMMENT '会员id',
  `card_vip_id` int(11) NULL DEFAULT NULL COMMENT '会员vipId',
  `customer_phone` varchar(50) NULL DEFAULT '' COMMENT '客户手机号',
  `customer_name` varchar(200) NULL DEFAULT '' COMMENT '客户名称',
  `sport_id` varchar(50) NULL DEFAULT '' COMMENT '运动id',
  `sport_name` varchar(150) NULL DEFAULT '' COMMENT '运动名称',
  `preorder_time` date NULL DEFAULT NULL COMMENT '预定日期',
  `order_time` datetime NULL DEFAULT NULL COMMENT '下单时间',
  `order_remark` varchar(300) NULL DEFAULT '' COMMENT '下单备注',
  `order_quantity` int(11) NULL DEFAULT NULL COMMENT '订单数量',
  `order_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '订单金额',
  `merchant_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '商家优惠金额',
  `landlord_discount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '租主优惠金额',
  `deducted_card_type` varchar(200) NULL DEFAULT '' COMMENT '抵扣卡类型',
  `deducted_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣金额',
  `deducted_prepaid_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣预收入金额(属于抵扣金额一部分)',
  `deducted_quato` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣额度',
  `list_desc` varchar(500) NULL DEFAULT NULL COMMENT '用于C端列表展示的一些数据',
  `pay_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `order_status` varchar(20) NULL DEFAULT '' COMMENT '订单状态',
  `status_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '状态时间',
  `consume_time` datetime NULL DEFAULT NULL COMMENT '消费时间',
  `pay_way` varchar(20) NULL DEFAULT '' COMMENT '支付方式',
  `is_mini_app_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否为小程序支付(兼容微信)',
  `pay_remark` varchar(300) NULL DEFAULT '' COMMENT '付款备注',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '付款时间',
  `pay_no` varchar(100) NULL DEFAULT '' COMMENT '支付流水号',
  `origin_type` tinyint(1) NULL DEFAULT 0 COMMENT '来源类型(是否C端订单)',
  `fail_pay_remark` varchar(300) NULL DEFAULT '' COMMENT '付款失败备注',
  `cancel_remark` varchar(300) NULL DEFAULT '' COMMENT '取消备注',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(300) NULL DEFAULT '' COMMENT '场馆名称',
  `mechant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `mechant_name` varchar(300) NULL DEFAULT '' COMMENT '商户名称',
  `operator_id` int(11) NULL DEFAULT NULL COMMENT '操作id',
  `operator_name` varchar(120) NULL DEFAULT '' COMMENT '操作人名称',
  `is_hidden` tinyint(1) NULL DEFAULT 0 COMMENT '是否查询隐藏',
  `is_discount` tinyint(1) NULL DEFAULT 0 COMMENT '是否需要输入折扣',
  `evaluated` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已评价',
  `is_switch` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已换场',
  `is_book_field` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是场地预定订单',
  `is_invoice` tinyint(1) NULL DEFAULT 0 COMMENT '是否已开发票',
  `link_order_num` varchar(50) NULL DEFAULT '' COMMENT '关联订单号',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单主表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_coupon   交易订单-优惠券使用表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_coupon`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_coupon`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(50) NULL DEFAULT '' COMMENT '订单号',
  `customer_phone` varchar(50) NULL DEFAULT '' COMMENT '用户手机号',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `coupon_id` int(11) NOT NULL COMMENT '商户优惠券id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `coupon_id`(`coupon_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单-优惠券使用表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_detail   交易订单明细表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_detail`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) NOT NULL DEFAULT '' COMMENT '订单号',
  `fee_item_type` varchar(20) NULL DEFAULT '' COMMENT '消费项目类型(与订单类型一致,已废)',
  `item_id` int(10) NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(300) NULL DEFAULT '' COMMENT '项目名称',
  `start_time` varchar(40) NULL DEFAULT '' COMMENT '开始时间',
  `end_time` varchar(40) NULL DEFAULT '' COMMENT '结束时间',
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
  `goods_receiver_code` varchar(255) NULL DEFAULT NULL COMMENT '批次号',
  `goods_sale_tax` decimal(12, 2) NULL DEFAULT NULL COMMENT '税率',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单明细表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_field   交易订单-场地预定表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_field`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_field`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_num` varchar(50) NULL DEFAULT NULL COMMENT '订单号',
  `order_detail_id` int(11) NULL DEFAULT 0 COMMENT '订单详情id',
  `field_detail_id` int(11) NOT NULL COMMENT '场地详情id',
  `field_id` int(11) NOT NULL COMMENT '场地id',
  `field_date` date NOT NULL COMMENT '预定日期',
  `field_status` varchar(20) NULL DEFAULT NULL COMMENT '订单场地状态',
  `customer_phone` varchar(50) NULL DEFAULT '' COMMENT '客户手机号',
  `customer_name` varchar(200) NULL DEFAULT '' COMMENT '客户名称',
  `customer_remark` varchar(300) NULL DEFAULT '' COMMENT '客户预定备注',
  `locked_item` varchar(300) NULL DEFAULT '' COMMENT '锁场项目',
  `locked_remark` varchar(300) NULL DEFAULT '' COMMENT '锁场备注',
  `origin_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '来源类型(是否C端订单)',
  `start_time` varchar(6) NOT NULL COMMENT '开始时间',
  `end_time` varchar(6) NOT NULL COMMENT '结束时间',
  `fixed_id` int(11) NULL DEFAULT NULL COMMENT '固定场记录id',
  `lock_status` tinyint(1) NULL DEFAULT 0 COMMENT '锁场是否已收款',
  `type` int(2) NOT NULL DEFAULT 1 COMMENT '预定类型（0.会员预定 1.散客 2.票券）',
  `card_vip_id` int(11) NULL DEFAULT NULL COMMENT '会员卡id',
  `card_code` varchar(200) NULL DEFAULT '' COMMENT '会员卡号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `detail_id_date_unique`(`field_detail_id`, `field_date`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单-场地预定表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_field_gate   交易订单-场地入闸核销表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_field_gate`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_field_gate`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `order_num` varchar(50) NOT NULL COMMENT '订单号',
  `remain_num` int(11) NULL DEFAULT NULL COMMENT '剩余核销次数',
  `verify_num` int(11) NOT NULL DEFAULT 0 COMMENT '前台核销次数',
  `enter_gate_num` int(11) NOT NULL DEFAULT 0 COMMENT '入闸核销次数',
  `first_verify_time` datetime NULL DEFAULT NULL COMMENT '首次核销时间',
  `status` int(11) NULL DEFAULT NULL COMMENT '0:未使用 1:已使用 2:已过期 3:已退款',
  `field_id` int(11) NULL DEFAULT NULL COMMENT '场地id',
  `end_time` datetime NULL DEFAULT NULL COMMENT '有效使用过期结束时间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '有效使用过期开始时间',
  `door_enter_device` varchar(500) NULL DEFAULT NULL COMMENT '门禁可用设备',
  `door_remain_num` int(11) NULL DEFAULT NULL COMMENT '门禁可用次数',
  `door_enter_num` int(11) NULL DEFAULT NULL COMMENT '门禁进入次数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单-场地入闸核销表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_pay   交易订单支付表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_pay`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_pay`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(50) NULL DEFAULT '' COMMENT '订单号',
  `pay_catetory` varchar(1) NULL DEFAULT '' COMMENT '支付类别(1:CASH,2:卡,3:票)',
  `pay_type` varchar(20) NULL DEFAULT '' COMMENT '支付类型',
  `pay_entity_id` int(11) NULL DEFAULT 0 COMMENT '支付实体id',
  `pay_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '支付金额',
  `pay_quota` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '支付额度',
  `pay_third_no` varchar(100) NULL DEFAULT '' COMMENT '第三方支付流水号',
  `valid_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '卡对应价值',
  `refund_num` varchar(50) NULL DEFAULT '' COMMENT '退款单号',
  `is_main_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否为主要支付',
  `is_refund` tinyint(1) NULL DEFAULT 0 COMMENT '是否退款',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ORDER_NUM`(`order_num`) USING BTREE,
  INDEX `REFUND_NUM`(`refund_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单支付表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_refund   交易订单退款表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_refund`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_refund`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `refund_num` varchar(50) NOT NULL COMMENT '退款单号',
  `order_num` varchar(50) NOT NULL COMMENT '订单号',
  `is_mini_app_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否为小程序支付(兼容微信)',
  `pay_way` varchar(20) NULL DEFAULT '' COMMENT '支付方式',
  `refund_user_name` varchar(120) NULL DEFAULT '' COMMENT '退款人',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_trade_no` varchar(300) NULL DEFAULT '' COMMENT '第三方退款流水号',
  `refund_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `deducted_card_type` varchar(200) NULL DEFAULT '' COMMENT '抵扣卡类型',
  `deducted_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣金额',
  `deducted_quato` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '抵扣额度',
  `refund_remark` varchar(300) NULL DEFAULT '' COMMENT '退款备注',
  `refund_type` varchar(20) NULL DEFAULT '' COMMENT '退款方式',
  `refund_param` text NULL COMMENT '退款参数',
  `refund_response` text NULL COMMENT '第三方返回响应',
  `fail_reason` varchar(300) NULL DEFAULT '' COMMENT '第三方退款失败原因',
  `refund_status` varchar(20) NULL DEFAULT '' COMMENT '退款状态',
  `is_success` tinyint(1) NULL DEFAULT 0 COMMENT '退款是否成功',
  `audit_advise` varchar(500) NULL DEFAULT '' COMMENT '审核意见',
  `audit_operator` varchar(120) NULL DEFAULT '' COMMENT '审核人',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单退款表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_refund_offline   交易订单线下退款表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_refund_offline`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_refund_offline`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `refund_num` varchar(50) NOT NULL COMMENT '退款单号',
  `order_num` varchar(50) NOT NULL COMMENT '订单号',
  `pay_way` varchar(20) NULL DEFAULT '' COMMENT '支付方式',
  `pay_amount` decimal(13, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_amount` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '退款金额',
  `refund_remark` varchar(300) NULL DEFAULT '' COMMENT '退款备注',
  `refund_type` varchar(20) NULL DEFAULT '' COMMENT '退款方式',
  `order_type` varchar(20) NULL DEFAULT '' COMMENT '订单类型',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `venue_name` varchar(300) NULL DEFAULT '' COMMENT '场馆名称',
  `refund_status` int(11) NULL DEFAULT 1 COMMENT '退款状态(1:成功，2：删除)',
  `audit_advise` varchar(500) NULL DEFAULT '' COMMENT '审核意见',
  `audit_operator` varchar(120) NULL DEFAULT '' COMMENT '审核人',
  `audit_id` int(11) NULL DEFAULT NULL COMMENT '审核人',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `SINGLE_NUM_INDEX`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '交易订单线下退款表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_ticket   散票订单详情
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_ticket`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_ticket`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `order_num` varchar(50) NOT NULL COMMENT '订单号',
  `ticket_id` int(11) NOT NULL COMMENT '散票id',
  `ticket_name` varchar(50) NOT NULL COMMENT '散票名',
  `ticket_attr` int(11) NULL DEFAULT NULL COMMENT '属性，1：成人 2：儿童 3：学生 4：老人 5：套票',
  `sport_id` varchar(50) NULL DEFAULT NULL COMMENT '运动类型id',
  `num` int(11) NOT NULL COMMENT '数量',
  `price` decimal(20, 2) NULL DEFAULT NULL COMMENT '单价（折前）',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '散票订单详情'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_ticket_no   散票票号表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_ticket_no`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_ticket_no`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `order_ticket_id` int(11) NULL DEFAULT NULL COMMENT '订单售票id',
  `ticket_no` varchar(50) NULL DEFAULT NULL COMMENT '票号',
  `remain_num` int(11) NULL DEFAULT NULL COMMENT '剩余核销次数',
  `verify_num` int(11) NOT NULL DEFAULT 0 COMMENT '前台核销次数',
  `enter_gate_num` int(11) NOT NULL DEFAULT 0 COMMENT '入闸核销次数',
  `first_verify_time` datetime NULL DEFAULT NULL COMMENT '首次核销时间',
  `status` int(11) NULL DEFAULT NULL COMMENT '0:未使用 1:已使用 2:已过期 3:已退款',
  `expire_date` date NULL DEFAULT NULL COMMENT '有效使用过期结束时间',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读',
  `expire_start_date` date NULL DEFAULT NULL COMMENT '有效使用过期开始时间',
  `customer_phone` varchar(50) NULL DEFAULT '' COMMENT '客户手机号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_no`(`ticket_no`) USING BTREE,
  INDEX `ik_order_ticket_id`(`order_ticket_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '散票票号表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_trade_order_ticket_verify   散票核销表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_trade_order_ticket_verify`;
CREATE TABLE `ods_wenti_vmdb_m_trade_order_ticket_verify`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_ticket_no_id` int(11) NOT NULL COMMENT '散票票号id',
  `ticket_attr` int(11) NULL DEFAULT NULL COMMENT '属性，1：成人 2：儿童 3：学生 4：老人',
  `verify_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `is_verify` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已核销',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ik_ticket_no`(`order_ticket_no_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '散票核销表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_m_venue_customer   场馆顾客表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_m_venue_customer`;
CREATE TABLE `ods_wenti_vmdb_m_venue_customer`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `phone` varchar(30) NOT NULL COMMENT '手机号',
  `type` int(11) NOT NULL COMMENT '用户类型 1.非会员 2。场馆会员',
  `consume_num` int(11) NOT NULL DEFAULT 0 COMMENT '消费次数',
  `channel` int(11) NOT NULL COMMENT '渠道 1.B端 2.C端',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `last_consume_time` datetime NOT NULL COMMENT '最后消费时间',
  `register_time` datetime NULL DEFAULT NULL COMMENT '注册时间',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_phone`(`phone`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '场馆顾客表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_p_park_record   停车记录表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_p_park_record`;
CREATE TABLE `ods_wenti_vmdb_p_park_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `park_order_num` varchar(255) NULL DEFAULT NULL COMMENT '第三方停车订单号',
  `order_num` varchar(255) NULL DEFAULT NULL COMMENT '订单号',
  `merchant_id` int(11) NULL DEFAULT NULL COMMENT '商户id',
  `merchant_name` varchar(255) NULL DEFAULT NULL COMMENT '商户名称',
  `is_member` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否是会员',
  `user_name` varchar(255) NULL DEFAULT NULL COMMENT '用户名称',
  `user_phone` varchar(20) NULL DEFAULT NULL COMMENT '用户手机号',
  `car_no` varchar(50) NULL DEFAULT NULL COMMENT '车牌号',
  `creat_time` datetime NULL DEFAULT NULL COMMENT '计费时间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '入场时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '离场时间',
  `park_time` int(11) NULL DEFAULT NULL COMMENT '停车时长',
  `park_time_format` varchar(50) NULL DEFAULT NULL COMMENT '停车时长',
  `pay_way` varchar(20) NULL DEFAULT NULL COMMENT '支付方式',
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
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '停车记录表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_p_park_ticket   停车券表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_p_park_ticket`;
CREATE TABLE `ods_wenti_vmdb_p_park_ticket`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(255) NOT NULL COMMENT '临取券时生成的券码',
  `config_id` int(11) NOT NULL COMMENT '发券配置id',
  `name` varchar(255) NOT NULL COMMENT '停车券名',
  `merchant_id` int(11) NOT NULL COMMENT '商户id',
  `merchant_name` varchar(255) NOT NULL COMMENT '商户名称',
  `channel` tinyint(1) NOT NULL DEFAULT 0 COMMENT '渠道 0：线下，1：线上',
  `scene` tinyint(1) NOT NULL DEFAULT 0 COMMENT '发放场景，0：线下， 1：订场，2：售票，3：刷卡',
  `deducted_hour` decimal(10, 1) NOT NULL DEFAULT 0.0 COMMENT '抵扣时长',
  `is_member` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否会员， 0：否， 1：是',
  `user_phone` varchar(255) NOT NULL COMMENT '手机号',
  `car_no` varchar(255) NULL DEFAULT NULL COMMENT '车牌号',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态 0：未使用 1：已使用 2：已过期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `service_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `soure_order_num` varchar(255) NULL DEFAULT NULL COMMENT '停车券来源订单号',
  `soure_ticket_no` varchar(255) NULL DEFAULT NULL COMMENT '停车券来源票号',
  `soure_member_card_id` int(11) NULL DEFAULT NULL COMMENT '停车券来源卡号',
  `source_give_detail_id` int(11) NULL DEFAULT NULL COMMENT '赠送详情id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除 0：未删除 1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '停车券表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_p_park_ticket_give_record   停车券赠送记录
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_p_park_ticket_give_record`;
CREATE TABLE `ods_wenti_vmdb_p_park_ticket_give_record`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `code` varchar(255) NOT NULL COMMENT '停车券码',
  `config_id` int(11) NOT NULL COMMENT '停车券配置id',
  `old_ticket_id` int(11) NULL DEFAULT NULL COMMENT '旧停车券id',
  `new_ticket_id` int(11) NULL DEFAULT NULL COMMENT '新停车券id',
  `create_phone` varchar(255) NOT NULL DEFAULT '' COMMENT '赠送人手机号',
  `receive_phone` varchar(255) NULL DEFAULT NULL COMMENT '接收人手机号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '停车券赠送记录'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_sale_channel   剧场票务-分销
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_sale_channel`;
CREATE TABLE `ods_wenti_vmdb_theatre_sale_channel`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '分享者id',
  `phone` varchar(30) NULL DEFAULT NULL COMMENT '分享者手机号',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `item_id` int(11) NOT NULL COMMENT '项目id',
  `item_name` varchar(255) NULL DEFAULT NULL COMMENT '项目名',
  `com_id` int(11) NULL DEFAULT NULL COMMENT '机构id',
  `com_code` varchar(50) NULL DEFAULT NULL COMMENT '机构编码',
  `wxacode` varchar(255) NULL DEFAULT NULL COMMENT '小程序码',
  `source` int(11) NULL DEFAULT NULL COMMENT '来源，1-一起吗 2-剧院小程序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-分销'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_sale_channel_detail   剧场票务-场次表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_sale_channel_detail`;
CREATE TABLE `ods_wenti_vmdb_theatre_sale_channel_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `channel_id` int(11) NOT NULL COMMENT '分销渠道id',
  `channel_user_phone` varchar(30) NULL DEFAULT NULL COMMENT '分享者手机号',
  `channel_source` int(11) NULL DEFAULT NULL COMMENT '渠道来源',
  `channel_com_name` varchar(255) NULL DEFAULT NULL COMMENT '渠道公司名称',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `item_id` int(11) NULL DEFAULT NULL COMMENT '项目id',
  `item_name` varchar(255) NULL DEFAULT NULL COMMENT '项目名称',
  `sell_id` int(11) NULL DEFAULT NULL COMMENT '场次id',
  `sell_start_time` datetime NULL DEFAULT NULL COMMENT '场次开始时间',
  `sell_end_time` datetime NULL DEFAULT NULL COMMENT '场次结束时间',
  `order_user_phone` varchar(30) NULL DEFAULT NULL COMMENT '下单用户手机号',
  `order_num` varchar(255) NULL DEFAULT NULL COMMENT '订单号',
  `status` int(11) NULL DEFAULT NULL COMMENT '订单状态',
  `order_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '订单金额',
  `pay_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '支付金额',
  `commission_ratio` int(11) NULL DEFAULT NULL COMMENT '佣金比例',
  `commission_amount` decimal(11, 2) NULL DEFAULT NULL COMMENT '佣金金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-场次表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_ticket_discount   剧场票务-座位区折扣表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_ticket_discount`;
CREATE TABLE `ods_wenti_vmdb_theatre_ticket_discount`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `area_code` varchar(255) NULL DEFAULT NULL COMMENT '座位区域',
  `min_number` int(11) NULL DEFAULT NULL COMMENT '最少张数',
  `discount` decimal(2, 1) NULL DEFAULT NULL COMMENT '折扣',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-座位区折扣表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_ticket_item   剧场票务-演出项目表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_ticket_item`;
CREATE TABLE `ods_wenti_vmdb_theatre_ticket_item`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆',
  `venue_name` varchar(255) NULL DEFAULT NULL COMMENT '场馆名',
  `name` varchar(255) NOT NULL COMMENT '项目名',
  `longitude` varchar(255) NULL DEFAULT NULL COMMENT '经度',
  `latitude` varchar(255) NULL DEFAULT NULL COMMENT '维度',
  `thumbnail` varchar(255) NULL DEFAULT NULL COMMENT '缩略图',
  `info` longtext NULL COMMENT '详情',
  `remind` varchar(5000) NULL DEFAULT NULL COMMENT '须知',
  `is_deleted` tinyint(1) NULL DEFAULT NULL COMMENT '是否删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `third_project_id` varchar(255) NULL DEFAULT NULL COMMENT '第三方项目id',
  `third_project_type` varchar(20) NULL DEFAULT NULL COMMENT '第三方项目类型',
  `choose_seat_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否选座',
  `type` int(11) NOT NULL DEFAULT 1 COMMENT '项目类型 1-演艺 2-赛事',
  `banner_image` varchar(255) NULL DEFAULT NULL COMMENT 'banner图片',
  `recommended_image` varchar(255) NULL DEFAULT NULL COMMENT '推荐图',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-演出项目表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_ticket_lock_log   剧场票务-场次表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_ticket_lock_log`;
CREATE TABLE `ods_wenti_vmdb_theatre_ticket_lock_log`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `sell_detail_ids` varchar(255) NULL DEFAULT NULL COMMENT '售票明细id列表',
  `ticket_num` int(1) NULL DEFAULT NULL COMMENT '票数',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型 0-解锁 -1-锁定',
  `seat_info` varchar(1000) NULL DEFAULT NULL COMMENT '座位信息',
  `sell_info` varchar(1000) NULL DEFAULT NULL COMMENT '场次信息',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `operator` varchar(255) NULL DEFAULT NULL COMMENT '操作人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sell_id`(`sell_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-场次表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_ticket_price   剧场票务-座位区票价表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_ticket_price`;
CREATE TABLE `ods_wenti_vmdb_theatre_ticket_price`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `area_code` varchar(255) NULL DEFAULT NULL COMMENT '座位区域',
  `colour` varchar(255) NULL DEFAULT NULL COMMENT '颜色',
  `name` varchar(255) NULL DEFAULT NULL COMMENT '名称',
  `plan_id` int(11) NULL DEFAULT NULL COMMENT '方案id',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `stock` int(10) NULL DEFAULT NULL COMMENT '无座时表示数量',
  `remaining_stock` int(10) NULL DEFAULT NULL COMMENT '剩余数量',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-座位区票价表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_ticket_seat   剧场票务-座位图
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_ticket_seat`;
CREATE TABLE `ods_wenti_vmdb_theatre_ticket_seat`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NOT NULL COMMENT '场馆id',
  `seat_id` int(11) NULL DEFAULT NULL COMMENT '座位id',
  `num_x` int(11) NULL DEFAULT NULL COMMENT 'Y轴',
  `col_no` int(11) NULL DEFAULT NULL COMMENT '列号',
  `num_y` int(11) NULL DEFAULT NULL COMMENT 'X轴',
  `row_no` int(11) NULL DEFAULT NULL COMMENT '行号',
  `name` varchar(255) NULL DEFAULT NULL COMMENT '座位名',
  `area_code` varchar(255) NULL DEFAULT NULL COMMENT '价格分区',
  `is_side` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否间隔',
  `plan_id` int(11) NULL DEFAULT NULL COMMENT '区域方案',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-座位图'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_ticket_sell   剧场票务-场次详情表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_ticket_sell`;
CREATE TABLE `ods_wenti_vmdb_theatre_ticket_sell`  (
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
  `third_project_id` varchar(255) NULL DEFAULT NULL COMMENT '第三方项目id',
  `third_project_type` varchar(20) NULL DEFAULT NULL COMMENT '第三方项目类型',
  `rule_type` int(11) NULL DEFAULT 0 COMMENT '实名规则 0非实名 1一票一证',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-场次详情表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_ticket_sell_detail   剧场票务-场次表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_ticket_sell_detail`;
CREATE TABLE `ods_wenti_vmdb_theatre_ticket_sell_detail`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `venue_id` int(11) NULL DEFAULT NULL COMMENT '场馆id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `seat_id` int(11) NULL DEFAULT NULL COMMENT '座位id',
  `seat_name` varchar(255) NULL DEFAULT NULL COMMENT '座位号',
  `seat_num_x` int(11) NULL DEFAULT NULL COMMENT '座位坐标X',
  `seat_num_y` int(11) NULL DEFAULT NULL COMMENT '座位坐标Y',
  `seat_row_no` int(11) NULL DEFAULT NULL COMMENT '座位排号',
  `seat_col_no` int(11) NULL DEFAULT NULL COMMENT '座位列号',
  `is_side` tinyint(1) NULL DEFAULT NULL COMMENT '是否边座',
  `area_name` varchar(255) NULL DEFAULT NULL COMMENT '座位区域',
  `area_code` varchar(255) NULL DEFAULT NULL COMMENT '座位区域',
  `status` int(11) NULL DEFAULT NULL COMMENT '状态 -1-锁定 0-正常 1-待付款 2-已付款 3-已核销 4-已过期',
  `order_num` varchar(255) NULL DEFAULT NULL COMMENT '订单号',
  `customer_phone` varchar(255) NULL DEFAULT NULL COMMENT '客户手机号',
  `customer_name` varchar(255) NULL DEFAULT NULL COMMENT '客户姓名',
  `cert_type` int(11) NULL DEFAULT NULL COMMENT '客户证件类型 1-身份证',
  `cert_no` varchar(255) NULL DEFAULT NULL COMMENT '客户证件号',
  `verify_code` varchar(255) NULL DEFAULT NULL COMMENT '票码',
  `verify_worker` varchar(255) NULL DEFAULT NULL COMMENT '核销工作人员',
  `verify_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `price_id` int(11) NULL DEFAULT NULL COMMENT '票价id',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `pay_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '实付金额',
  `discount` decimal(2, 1) NULL DEFAULT NULL COMMENT '折扣大小',
  `discount_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '折扣金额',
  `third_type` int(11) NULL DEFAULT NULL COMMENT '第三方类型 1-大麦 2-猫眼',
  `third_order_num` varchar(255) NULL DEFAULT NULL COMMENT '第三方订单号',
  `third_user_id` varchar(255) NULL DEFAULT NULL COMMENT '第三方用户信息',
  `channel_user_phone` varchar(20) NULL DEFAULT NULL COMMENT '分销手机号',
  `channel_com_name` varchar(255) NULL DEFAULT NULL COMMENT '渠道公司名称',
  `choose_seat_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否选座',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sell_id`(`sell_id`) USING BTREE,
  INDEX `idx_order`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-场次表'
  ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- ods_wenti_vmdb_theatre_ticket_third_order   剧场票务-第三方订单表
-- ----------------------------
DROP TABLE IF EXISTS `ods_wenti_vmdb_theatre_ticket_third_order`;
CREATE TABLE `ods_wenti_vmdb_theatre_ticket_third_order`  (
  `extract_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据采集时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sell_id` int(11) NOT NULL COMMENT '场次id',
  `order_num` varchar(255) NULL DEFAULT NULL COMMENT '订单号',
  `third_order_num` varchar(255) NULL DEFAULT NULL COMMENT '第三方订单号',
  `third_type` int(1) NULL DEFAULT NULL COMMENT '第三方类型',
  `order_time` datetime NULL DEFAULT NULL COMMENT '下单时间',
  `is_pay` tinyint(1) NULL DEFAULT 0 COMMENT '是否支付',
  `is_cancel` tinyint(1) NULL DEFAULT NULL COMMENT '是否退票',
  `total_amount` bigint(20) NULL DEFAULT NULL COMMENT '订单总金额',
  `real_amount` bigint(20) NULL DEFAULT NULL COMMENT '实付金额',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 0
  DEFAULT CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '剧场票务-第三方订单表'
  ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
