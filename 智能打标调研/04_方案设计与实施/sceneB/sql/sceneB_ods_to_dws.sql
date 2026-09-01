-- ============================================================================
-- 场景B · 从 ODS 层改造数据：特征宽表 + 自造标签表（增量）
-- ============================================================================
-- 目标：churn 流失预测 的原料。把 ODS 层原始行为事件，加工成：
--   表1 dws_user_churn_feature   —— 用户×观察窗特征宽表（供 XGBoost 训练/推理）
--   表2 dws_user_churn_label     —— 用户×标签窗 自造标签 y（流失=1）
--   表3 dws_user_churn_label_result —— 模型打标结果表（供 CDP 圈选，与打标 CSV 同 schema）
-- 数据源：ods_wenti_jianengliang_*（C 端：会员/订单/游泳票/活动/积分/次卡）
--
-- 时间窗定义（按 as_of_date 基准日滚动，防泄漏关键）：
--   观察窗 = [as_of_date - 180, as_of_date - 1]   → 只算特征
--   标签窗 = [as_of_date,        as_of_date + 30]  → 只算 y
-- 增量：每日调度触发，按 as_of_date 增量写入；标签需等 30 天成熟才可算。
-- 说明：此为工程化 DDL+DML 骨架，字段/表名对应项目 schema 与注释；
--       生产替换占位注释中的示例查询即可。StarRocks 语法。
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1) 用户维度（脱敏：不含手机号/身份证/姓名）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS dws_user_churn_user (
    user_id         BIGINT      COMMENT '内部用户id（j_member.id）',
    age             INT         COMMENT '年龄',
    sex             INT         COMMENT '性别 0不明 1男 2女',
    login_num       INT         COMMENT '登录次数',
    as_of_date      DATE        COMMENT '基准日'
) ENGINE=OLAP DUPLICATE KEY(user_id, as_of_date)
DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES("replication_num"="1");

-- 2) 特征宽表
CREATE TABLE IF NOT EXISTS dws_user_churn_feature (
    user_id          BIGINT  COMMENT '内部用户id',
    as_of_date       DATE    COMMENT '基准日(观察窗结束)',
    age              INT     COMMENT '年龄',
    sex              INT     COMMENT '性别',
    login_num        INT     COMMENT '登录次数(累计)',
    -- 观察窗行为聚合（[as_of-180, as_of-1]）
    n_events         INT     COMMENT '观察窗事件总数',
    n_events_30d     INT     COMMENT '观察窗最近30天事件数(流失强信号)',
    n_order          INT     COMMENT '订单数',
    n_swim           INT     COMMENT '游泳票票据数',
    n_activity       INT     COMMENT '活动参与数',
    n_points         INT     COMMENT '积分变动次数',
    n_timecard       INT     COMMENT '次卡使用次数',
    spend_total      DOUBLE  COMMENT '消费总额(log1p)',
    spend_mean       DOUBLE  COMMENT '平均客单(log1p)',
    spend_max        DOUBLE  COMMENT '单笔最大(log1p)',
    recency_days     INT     COMMENT '最近一次行为距基准日天数(越大越久未动)',
    behavior_diversity DOUBLE COMMENT '涉及行为类型数/5'
) ENGINE=OLAP DUPLICATE KEY(user_id, as_of_date)
DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES("replication_num"="1");

-- 3) 自造标签表
CREATE TABLE IF NOT EXISTS dws_user_churn_label (
    user_id     BIGINT  COMMENT '内部用户id',
    as_of_date  DATE    COMMENT '基准日(标签窗起点)',
    label_date  DATE    COMMENT '标签窗终点(as_of+30)',
    label_window_start DATE COMMENT '观察窗起点(用于血缘)',
    label_window_end   DATE COMMENT '观察窗终点',
    is_churn    TINYINT COMMENT '标签窗内是否无任何行为(1流失/0未流失)'
) ENGINE=OLAP DUPLICATE KEY(user_id, as_of_date)
DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES("replication_num"="1");

-- ---------------------------------------------------------------------------
-- 3) 标签结果表（训练脚本批量打标的落库目标；CDP 从此表位图圈选高危流失人群）
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS dws_user_churn_label_result (
    user_id       BIGINT       COMMENT '内部用户id',
    as_of_date    DATE         COMMENT '打标基准日',
    churn_prob    DOUBLE       COMMENT '流失概率(0~1)',
    churn_label   VARCHAR(16)  COMMENT '分档：高危流失/中危流失/低危-稳定',
    model_version VARCHAR(32)  COMMENT '打标所用模型版本',
    update_time   DATETIME     COMMENT '写入时间'
) ENGINE=OLAP DUPLICATE KEY(user_id, as_of_date)
DISTRIBUTED BY HASH(user_id) BUCKETS 10
PROPERTIES("replication_num"="1");
-- 写入方式：训练脚本产出 sceneB_churn_labels.csv 后 Stream Load / 或 Python 直连 INSERT；
-- 回滚 = 按 model_version 过滤（下线新版本批次、查询指定旧版本即可）。

-- ---------------------------------------------------------------------------
-- 2) 增量写入示例（每日调度；as_of_date 取前一天，因要确保观察窗数据已落）
-- ---------------------------------------------------------------------------
-- 用户维度（增量：只处理新增/变更 user）
INSERT INTO dws_user_churn_user (user_id, age, sex, login_num, as_of_date)
SELECT id, age, sex, login_num, '${AS_OF_DATE}'
FROM ods_wenti_jianengliang_j_member
WHERE extract_time <= '${AS_OF_DATE} 23:59:59'
  AND (id, '${AS_OF_DATE}') NOT IN (SELECT user_id, as_of_date FROM dws_user_churn_user);

-- 特征宽表（观察窗 = [as_of-180, as_of-1]）
INSERT INTO dws_user_churn_feature
SELECT
    u.id                                   AS user_id,
    '${AS_OF_DATE}'                        AS as_of_date,
    u.age, u.sex, u.login_num,
    COUNT(e.uid)                          AS n_events,
    SUM(e.event_date >= DATE_SUB('${AS_OF_DATE}', INTERVAL 30 DAY)) AS n_events_30d,
    SUM(e.et = 'order')                   AS n_order,
    SUM(e.et = 'swim_ticket')             AS n_swim,
    SUM(e.et = 'activity')                AS n_activity,
    SUM(e.et = 'points')                  AS n_points,
    SUM(e.et = 'time_card')               AS n_timecard,
    LOG1P(COALESCE(SUM(IF(e.et IN('order','swim_ticket'), e.amount, 0)),0)) AS spend_total,
    LOG1P(COALESCE(AVG(IF(e.et IN('order','swim_ticket'), e.amount, NULL)),0)) AS spend_mean,
    LOG1P(COALESCE(MAX(IF(e.et IN('order','swim_ticket'), e.amount, 0)),0))    AS spend_max,
    MIN(DATEDIFF('${AS_OF_DATE}', e.event_date))                             AS recency_days,
    (COUNT(DISTINCT e.et) / 5.0)                                             AS behavior_diversity
FROM ods_wenti_jianengliang_j_member u
LEFT JOIN (
    -- 合并各行为源为统一事件视图（此处为占位：由 订单/游泳票/活动/积分/次卡 各表 UNION 而来）
    -- 生产替代示例：
    --   SELECT user_id AS uid, 'order' AS et, pay_time AS event_date, pay_amount AS amount FROM j_member_order WHERE is_pay=1
    --   UNION ALL SELECT user_id,'swim_ticket',valid_time, 0 FROM j_order_ticket_valid WHERE is_valid=1
    --   UNION ALL SELECT user_id,'activity',sign_time,0 FROM j_platform_activity_person
    --   UNION ALL SELECT member_id,'points',record_time,0 FROM j_points_records
    --   UNION ALL SELECT user_id,'time_card',order_time,0 FROM j_time_card_use WHERE status=1
    ${EVENT_VIEW}  e
) e ON e.uid = u.id
  AND e.event_date >= DATE_SUB('${AS_OF_DATE}', INTERVAL 180 DAY)
  AND e.event_date <  '${AS_OF_DATE}'
WHERE u.extract_time <= '${AS_OF_DATE} 23:59:59'
GROUP BY u.id, u.age, u.sex, u.login_num;

-- 自造标签表（标签窗 = [as_of, as_of+30]）——只对已成熟的 as_of 计算
INSERT INTO dws_user_churn_label
SELECT
    u.id                                   AS user_id,
    '${AS_OF_DATE}'                        AS as_of_date,
    DATE_ADD('${AS_OF_DATE}', INTERVAL 30 DAY) AS label_date,
    DATE_SUB('${AS_OF_DATE}', INTERVAL 180 DAY) AS label_window_start,
    '${AS_OF_DATE}'                        AS label_window_end,
    IF(COUNT(e.uid)=0, 1, 0)               AS is_churn
FROM ods_wenti_jianengliang_j_member u
LEFT JOIN ( ${EVENT_VIEW}  e ) e ON e.uid = u.id
  AND e.event_date >= '${AS_OF_DATE}'
  AND e.event_date <  DATE_ADD('${AS_OF_DATE}', INTERVAL 30 DAY)
WHERE u.extract_time <= '${AS_OF_DATE} 23:59:59'
GROUP BY u.id;

-- ---------------------------------------------------------------------------
-- 3) 增量与调度说明
-- ---------------------------------------------------------------------------
-- · 每日 06:00 调度：as_of_date = 昨天；更新用户维、写入当天特征、写入"已成熟"标签(as_of 距今>=30天)。
-- · 标签成熟性：某 as_of 的标签要等 as_of+30 天数据齐全后才能算；用调度记录表跳过未成熟 as_of。
-- · model_version：训练/打标时把 as_of_date 与 model_version 一并写入标签结果表，保证可回溯回滚。
-- · 防泄漏：训练特征永远取观察窗、标签永远取标签窗，二者时间不相交，杜绝时间穿越。
-- ============================================================================
