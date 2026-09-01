# 场景B · 方案设计与打标模拟（C 端会员流失预测 · XGBoost）

> 汇报 + 落地用。**场景 B 已从「图嵌入(原规划)」调整为「XGBoost 预测模型训练 + 工程实现」。**
> 对应匹配表里的 **场景 2 流失/复购预测**：用历史行为(观察窗→特征)预测未来是否流失(标签窗→y)。
> 类型标注：[A] DWS 直算，**无需 ER 层** —— 因此场景 B 不再依赖 ER 同事产出，可独立落地。
>
> **本 demo 定位**：跑通「ODS 改造数据 → 特征工程 → 自造标签 → XGBoost 训练 → 评估 → 批量打标 → 增量重训」完整生产型链路。

---

## 0. 方向调整记录

| 项 | 原规划 | 现方案 |
|---|---|---|
| 场景B方法 | 图嵌入 node2vec（ER 关系 → 相似人群/兴趣类群） | **XGBoost(或其轻量变体) 流失预测** |
| 场景B标签 | 关系/相似类 | **概率型流失标签**（未来30天流失/未流失） |
| 依赖层 | 依赖 ER 层「学员×课程」关系表 | **[A] DWS 直算，不依赖 ER** |
| 与场景A关系 | A=直算聚类, B=ER关系图嵌入，互补 | **A=聚类，B=预测，均 DWS 直算**，补足了"有监督"这条主线 |

**调整理由**：ER 层由另一同事负责、到位时间不可控；而流失预测（自造标签 y）不依赖 ER、
可独立跑通，且补上场景 A 缺失的"监督/预测"方法线，两大主线（无监督聚类 + 有监督预测）就此齐备。

---

## 1. 业务目标与标签需求

- **业务场景**：识别未来 30 天内可能流失（无任何消费/入场/活动/积分/次卡行为）的 C 端会员，用于召回营销。
- **标签**：`churn_prob`（流失概率，连续 0~1）+ `churn_label`（分档：高危流失 / 中危流失 / 低危-稳定）。
- **标签类型**：[A] DWS 直算（自造监督信号，无需人工标注）。
- **方法**：XGBoost（梯度提升树；轻量变体可用 LightGBM/CatBoost，脚本骨架通用）。

---

## 2. 数据寻找（基于真实 schema/注释 第一依据）

**真实 ODS 表可用字段**（C 端 `jianengliang`，源自 `ods_wenti_starrocks.sql`）：

| 数据 | 真实表 | 可用字段(观察窗特征/标签窗) |
|---|---|---|
| 用户主体 | `ods_wenti_jianengliang_j_member` | id(打标主体), age, sex, login_num, last_login_time |
| 消费订单 | `ods_wenti_jianengliang_j_member_order` | user_id, type, pay_amount, pay_time, status, is_pay |
| 游泳票核销 | `ods_wenti_jianengliang_j_order_ticket_valid` | order_num, user_id, is_valid, valid_time |
| 活动互动 | `ods_wenti_jianengliang_j_platform_activity_person` | user_id, sign_time, pay_status |
| 积分变动 | `ods_wenti_jianengliang_j_points_records` | member_id, points, record_time |
| 次卡使用 | `ods_wenti_jianengliang_j_time_card_use` | user_id, status, order_time |

**数据质量现实（重要约束）**：
- 测试库质量极差（与场景 A 相同问题：性别/年龄大量不明、订单关联断裂），**不直接基于它训练真实模型**。
- 因此**本 demo 用合成数据(脚本) + LLM 增强**模拟"生产质量合格的 ODS 行为流"，跑通全链路；
  生产化时把数据源替换为生产 DWS 宽表/ODS（SQL 见 `sql/sceneB_ods_to_dws.sql`）。

---

## 3. 完整流程设计（从 ODS 改造 → 训练 → 工程使用 → 增量 → 输出）

### 3.1 从 ODS 层先改造数据（特征宽表 + 自造标签）
- **观察窗** `[as_of-180, as_of-1]` → 特征；**标签窗** `[as_of, as_of+30]` → y（流失=1）。
- 两窗时间不相交 → 从根源防数据泄漏。
- 产出两张 DWS 表：`dws_user_churn_feature`(用户×特征宽表) + `dws_user_churn_label`(自造 y)。
- ODS 各行为源 UNION 成统一"事件视图"(uid, et事件类型, event_date, amount)，再做窗口聚合。
- 详细 DDL/DML 与增量见：`sql/sceneB_ods_to_dws.sql`。

### 3.2 特征工程（一人一行宽表）
15 维特征，与 DWS 特征宽表口径一一对应：
`age, sex, login_num, n_events, n_events_30d, n_order, n_swim, n_activity, n_points, n_timecard,
 spend_total, spend_mean, spend_max, recency_days, behavior_diversity`
（`n_events_30d`=观察窗最近 30 天事件数，流失最强信号；金额用 `log1p` 压缩长尾，与场景 A 一致；
`recency_days`=最近一次行为距基准日天数，无行为置 999。）
实现：`scripts/sceneB_featurize.py`

### 3.3 训练 + 评估
- 算法：`XGBClassifier`，early-stopping on validation，`scale_pos_weight` 处理不平衡。
- 切分：随机分层（同期 cohort 无跨用户时序依赖；防泄漏已在窗口构造阶段完成）。
- 指标：AUC / PR-AUC / 混淆矩阵 / 特征重要性（可解释性）。
实现：`scripts/sceneB_train_xgboost.py`

### 3.4 工程上如何使用标签
- **批次**：把 `churn_label` + `churn_prob` 写回标签表（含 `model_version`、`as_of_date`）。
- **下游**：CDP 位图圈选(高危流失人群) → 召回营销短信/企微/App 推送；效果闭环用"命中率/挽回率"回测。
- **血缘/回滚**：每条标签带模型版本与基准日，可回溯、可回滚到旧模型。

### 3.5 增量优化（离线批量 + 增量重训）
- **批量打标**：每日/每周调度，读 DWS 特征宽表 → 用当前模型全量打标（秒级）。
- **增量重训**：新样本随窗口滚动累积；按固定节奏(如每周)用"历史累积 + 新增"**全量重训并版本化**，
  保留旧模型可回滚；或用已成熟标签做 warm-start 微调（脚本已预留）。
- **数据增量**：DWS 特征/标签表按 `as_of_date` 增量写入；标签等 30 天成熟后回填。

### 3.6 输出形式
| 产物 | 文件/表 | 形式 |
|---|---|---|
| 标签表(线上) | `dws_user_churn_label_result` | user_id + churn_prob + churn_label + model_version + as_of_date |
| 打标 CSV(演示) | `output/sceneB_churn_labels.csv` | 同上，脱敏 |
| 评估报告 | `output/sceneB_eval_report.txt` | AUC/PR-AUC/混淆矩阵/特征重要性 |
| 模型(版本化) | `output/model/model_<ts>.json` + `latest.json` | XGBoost 原生格式 |

---

## 4. 运行（本机已跑通，环境安装见 `sceneB/环境安装指南.md`）

```bash
cd sceneB
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt   # 首次：装环境
.venv/bin/python scripts/sceneB_synth_data.py        # 1) 生成模拟 ODS 数据（纯 stdlib）
.venv/bin/python scripts/sceneB_featurize.py         # 2) 特征工程 + 自造标签
.venv/bin/python scripts/sceneB_llm_augment.py       # 3)（可选）LLM 增强，config 已 enabled
.venv/bin/python scripts/sceneB_train_xgboost.py     # 4) XGBoost 训练 + 评估 + 批量打标
```

产物输出到 `sceneB/output/`。

---

## 5. demo 结果（2026-09-01 本机真实运行）

| 项 | 值 |
|---|---|
| 用户数 / 特征 | 12000 / **15 维** |
| 流失率(y=1) | 47.8%（类平衡良好） |
| 切分 | train 8400 / valid 1800 / test 1800 |
| **AUC / PR-AUC** | **0.7134 / 0.6901**（测试集真实流失率 47.5%） |
| Top 特征 | `n_events_30d`(0.295) > `n_events` > `recency_days` —— 近30天行为是最强流失信号，符合业务直觉 |
| 全量打标分布 | 高危流失 24.0% / 中危流失 37.3% / 低危-稳定 38.7% |
| 模型版本 | `model_20260901_104130.json`（output/model/ 版本化保留） |
| 数据来源 | 合成脚本（latent+趋势衰减驱动）+ LLM 增强（qwen3.8 已接入） |
| 产物 | `sceneB_churn_labels.csv` / `sceneB_eval_report.txt` / `model/` 均已生成 ✅ |

> ⚠️ **定位说明**：以上为**合成数据**上的链路验证结果，证明生产型全链路（ODS 改造→训练→打标→版本化→增量）
> 可运行、方法有效（模型确实学到"近期行为衰减→流失"的信号）；**数值不代表生产效果**。
> 生产训练只需替换数据源（读生产 DWS 宽表，schema 一致则代码零改动）。

---

## 6. 生产化落地点

> 服务器部署、环境依赖、建表回填、调度编排、监控回滚的**完整操作步骤**见 **[生产部署运行手册](sceneB/生产部署运行手册.md)**。

1. 把 `dws_user_churn_feature` 与 `dws_user_churn_label` 建到生产 DWS，按 `as_of_date` 每日增量。
2. 训练脚本读生产宽表替换 `features.csv`；输出写回 `dws_user_churn_label_result`。
3. 对接 CDP：高危流失人群位图圈选 + 召回营销 + 命中率/挽回率回测形成效果闭环。
4. 增量重训：周级全量重训练 + 版本化 + 离线调度(Airflow/DolphinScheduler)。

---

## 7. 决策记录（本场景已确认的取舍）

| 决策点 | 选择 | 说明 |
|---|---|---|
| 预测目标 | 流失预测 | 综合价值/可自造y/特征充分 |
| 数据模拟 | 脚本 + LLM 混合 | 脚本保证可复现，LLM 增强业务真实性；LLM 当前 mock 回退，接本地 LLM 后置 `enabled=true` |
| 算法 | XGBoost | 梯度提升树，CPU 即可；轻量变体(LGBM/CatBoost)骨架通用 |
| 增量/输出 | 离线批量 + 增量重训 | 标签表版本化，可回滚可回溯 |

*文档维护：2026-08-31（2026-09-01 补生产部署运行手册、SQL 补结果表、校正产物状态）。关联：[[智能打标调研/PLAN]]、[[03_场景与标签需求/场景标签与方法匹配]]、[[02_方法调研/方法流程与可行性]]、[[智能打标调研/README]]。*
