# 数据模拟实施分阶段计划

> 版本：v1.3 | 日期：2026-08-12 | 上次更新：新增 P2-0 行为表映射规划，P2 尚未执行
> 项目规范：[数据模拟实施Hub.md](数据模拟实施Hub.md) v1.7

---

## 阶段总览

| 阶段 | 名称 | 目标 | 状态 | 产出物 |
|------|------|------|------|-------|
| **P0** | 环境与数据准备 | PersonaHub 下载 + 改造 + 4800条 Persona + 4800条实例 | ✅ **完成** | `wenti_personas.jsonl`（4800条）+ `wenti_persona_instances.jsonl`（4800条） |
| **P1** | 冒烟测试 | 单条实例 → 完整链路 → 3张CSV | ✅ **完成** | `mini_example_output/` 三张CSV，验证全通过 |
| **P2** | jianengliang 核心链路 | P2-0 事件库建模 → P2-1 字典 → P2-2 用户 → P2-3 营销 → P2-4 订单事件（全联动） → P2-5 后置事件 → P2-6 校验 | 🟨 **P2-0规划中** | `wenti_jianengliang_event` 映射规范 + 约16张表 CSV |
| **P3** | training + vmdb | 批次7-11（约14张表） | ⬜ 待开始 | `t_student` / `m_trade_order` / vmdb 三表 CSV |
| **P4** | 质量验收 + 脏数据 | 统计验证 + 脏数据注入 + 可选 StarRocks 推送 | ⬜ 待开始 | `quality_report.json` |

---

## P0：环境与数据准备 ✅

### P0-1 Python 环境搭建 ✅

- [x] Python 3.14.3（`D:\devWorkshopForCC\.venv`）
- [x] 依赖安装：`datasets 5.0.1 / huggingface_hub 1.27.0 / faker 40.36.0 / python-dotenv 1.2.2`
- [x] LLM Provider：远端 vllm `http://10.20.77.89:8000/v1`，模型 `Qwen3.6-35B-A3B`（非本地 Ollama）
- [ ] 创建 `.env` 文件（P1 前需配置，参考 Hub.md §7.4）

> **实际与计划的差异**：PLAN v1.0 推荐本地 Ollama `qwen2.5:7b`，实际使用远端 OpenAI-compatible API（vllm）。
> `hub_adapter.py` 已更新为 `call_llm()` 函数，使用 `chat_template_kwargs: {enable_thinking: False}` 禁用 Qwen3 thinking 模式。

### P0-2 PersonaHub 下载 ✅

- [x] `python scripts/download_persona_hub.py`
- [x] 产出：`wenti_data_simulator/data/personas/persona_hub_raw.jsonl`（200,000 条，21MB）
- [x] 字段名为 `persona`（非 `input_persona`），hub_adapter.py 已兼容处理

### P0-3 关键词筛选候选 Persona ✅

- [x] `python scripts/filter_personas.py`
- [x] 产出：`persona_hub_candidates.jsonl`（**63,493 条**，31.7% 命中率）
- [x] 实际候选量远超原预期 500-2000 条，采用分层采样控制数量

> **实际与计划的差异**：原计划筛选 800-1500 条，实际 63K 条。根本原因是关键词覆盖面宽泛。
> 解决方案：不缩减关键词，改为在 P0-4 通过分层采样精确控制 system 分布。

### P0-4 LLM 批量改造 ✅

**实际执行路径（与 v1.0 计划有重大差异）**：

原计划：关键词推断 system → 顺序取前 N 条 → Ollama 改造  
实际方案：**分层采样预分桶 → 附加 `_preset_system` 字段 → 远端 API 改造**

#### 分层采样方案（核心决策）

问题根因：PersonaHub 候选库天然词频分布 j:t:v ≈ 0.74:0.14:0.12，关键词分类无法突破此上限。  
解决方案：预先对 63K 候选按 `_infer_target_system()` 分桶，再按目标比例分层抽样。

- [x] 测试批次（200条）：`scripts/stratified_sample.py` → `persona_hub_stratified_200.jsonl`（j120:t40:v40）
- [x] 正式批次（4800条）：`scripts/stratified_sample_4800.py` → `persona_hub_stratified_4800.jsonl`（j2880:t960:v960）
- [x] `hub_adapter.py` 读取 `_preset_system` 字段直接指定 system，绕过运行时推断

#### 改造执行

- [x] dry-run 验证（2条）：JSON Schema 通过率 100%，链路通
- [x] 测试批次 200条：成功 200/200，JSON 100%，j:t:v=0.59:0.21:0.20 ✓
- [x] 正式批次 4800条：运行命令 `run_batch.bat`（用户本地执行）

#### 最终结果

| 维度 | 数量 | 占比 | 目标 | 状态 |
|------|------|------|------|------|
| jianengliang | 2883 | 60.1% | 45-65% | ✓ |
| training | 952 | 19.8% | 12-28% | ✓ |
| vmdb | 965 | 20.1% | 8-22% | ✓ |
| cross_system | 0 | 0% | 4-14% | — 未配额，后续扩量补充 |
| dirty>=0.10（后处理注入） | 261 | 5.4% | 5-12% | ✓ |

产出：`wenti_data_simulator/data/personas/wenti_personas.jsonl`（**4800 条**）

#### P0 工具脚本清单

| 脚本 | 用途 | 状态 |
|------|------|------|
| `scripts/download_persona_hub.py` | HuggingFace 流式下载 200K 条 | ✅ 已使用 |
| `scripts/filter_personas.py` | 关键词筛选，产出 63K 候选 | ✅ 已使用 |
| `scripts/stratified_sample.py` | 分层采样 200 条（测试） | ✅ 已使用 |
| `scripts/stratified_sample_4800.py` | 分层采样 4800 条（正式） | ✅ 已使用 |
| `wenti_data_simulator/persona/hub_adapter.py` | 改造核心：分层输入→远端 LLM→WentiPersona JSON | ✅ 已使用 |
| `prompts/persona_adapt.txt` | Prompt B（含 vmdb/training 业务含义说明） | ✅ 已使用 |
| `run_batch.bat` | 本地一键运行入口（ASCII 编码） | ✅ 已使用 |
| `check_progress.bat` | 查看当前 wenti_personas.jsonl 行数 | ✅ 已使用 |

---

### P0-5：Persona 实例化 ✅

| 子项 | 内容 | 脚本 | 产出 |
|------|------|------|------|
| P0-5-1 | 编写实例化脚本 | `wenti_data_simulator/persona/instantiate_personas.py` | 脚本就绪 ✅ |
| P0-5-2 | 编写运行入口 | `run_instantiate.bat`（ASCII编码） | bat 就绪 ✅ |
| P0-5-3 | 执行4800条实例化 | 用户本地运行 `run_instantiate.bat` | `wenti_persona_instances.jsonl` ✅ |

**目标**：为每条 `wenti_personas.jsonl` 记录生成具体实例人（姓名/省市/性别/年龄/家庭/房车/年薪/健康），行为概率在原值基础上随机变异（85%小波动±0.08，15%大波动±0.20），全部中国化（海外场景改写）。

**产出物**：`wenti_data_simulator/data/personas/wenti_persona_instances.jsonl`（4800条）

**后续使用**：P2 行为决策层起，所有模拟调用实例库而非 Persona 库。

---

## P1：冒烟测试 ✅

**目标**：验证"一条实例 → 两次 LLM → 三张 CSV"完整链路

**前置条件**：
- [x] `wenti_personas.jsonl` 存在（4800 条，P0-4 完成）
- [x] `wenti_persona_instances.jsonl` 已完成（P0-5，4800条，j=2883/t=952/v=965）
- [x] `wenti_data_simulator/mini_example.py` 已编写（仅读实例库，无 Persona fallback）
- [x] LLM：直接硬编码远端 API `http://10.20.77.89:8000/v1`，无需 `.env`

**执行结果（2026-08-11）**：
- [x] 运行 `python wenti_data_simulator/mini_example.py`，一次通过，总耗时 11.2s
- [x] `mini_example_output/` 下出现 `j_member.csv`、`j_member_order.csv`、`j_bill.csv`
- [x] 验证模块全部通过（时序 / 金额 / 枚举）
- [x] 三表外键对齐（user_id/order_num/phone 一致）

**已知 P2 优化项**：
- Prompt D 需加"phone 必须随机生成，不得使用 138xxxxxxx 连续占位号"

---

## P2：jianengliang 核心链路

> **整体逻辑**：P2-0 产出事件库（业务契约） → P2-1 生成字典数据（外键基础） → P2-2 生成用户数据 → P2-3 生成营销数据 → P2-4 逐事件生成订单全链路（每次 LLM 调用同时输出该事件所有联动表记录） → P2-5 生成订单后置事件（核销/积分） → P2-6 事件级联动校验。P2-0 通过评审后才执行 P2-1 及以后的步骤。

> **数据源**：P2 起所有行为模拟均从 `wenti_persona_instances.jsonl`（4800 条实例库）读取，不再使用 `wenti_personas.jsonl`。cross_system 当前为 0 条，P2 生成 training 学员时，从 jianengliang 用户中按比例随机选取并赋予跨系统标记，而非依赖 cross_system 字段筛选。

### P2-0 行为表映射与事件库规划

**目标**：建立 `wenti_jianengliang_event` 事件库，将“用户行为事件”明确映射为一组必须联动生成的数据库记录，作为 P2 后续行为决策层与字段翻译层之间的业务契约。

**方案判断**：可行，但事件库不能只有“行为名 + 表名 + 行数”。每个事件还必须定义：

- 事件触发条件：Persona 行为概率、order_type、支付/退款/核销状态等
- 事件主键与共享关联键：`member_id`、`phone`、`order_num`、`ticket_num`、`card_id`、`coupon_id`
- 每张涉及表的行数规则：固定 1 行、按购买数量、按票务人数量、按订单明细数量，或条件为 0
- 表动作：`insert`、`update`、`insert_or_update`，因为优惠券状态、次卡剩余次数、票状态等不是单纯新增记录
- 前置事件与后置事件：例如“购票”先于“票务核销”，“开次卡”先于“次卡使用”
- 跨表不变量：金额、状态、时间顺序、外键存在性和同一业务键复用规则
- 纳入范围：Phase 1 生成、字典/基础数据、暂缓或明确排除

**建议的事件库最小记录结构**（规划阶段先确定 schema，后续再落地 JSONL/JSON）：

```json
{
  "event_id": "JN_EVT_001",
  "event_name": "purchase_swimming_ticket",
  "event_description": "会员购买游泳票并完成支付",
  "system": "jianengliang",
  "trigger": {
    "order_type": ["3"],
    "conditions": ["purchase_intent=true", "complete_payment=true"]
  },
  "table_actions": [
    {"table": "j_member_order", "action": "insert", "rows": 1, "row_rule": "one_per_event"},
    {"table": "j_member_order_detail", "action": "insert", "rows": 1, "row_rule": "one_per_order"},
    {"table": "j_order_ticket", "action": "insert", "rows": "quantity", "row_rule": "one_per_ticket"},
    {"table": "j_bill", "action": "insert", "rows": 1, "row_rule": "one_per_paid_order"}
  ],
  "shared_keys": ["member_id", "phone", "order_num", "venue_id", "ticket_num"],
  "preconditions": ["member_exists", "venue_exists", "sport_exists"],
  "postconditions": ["paid_amount_equals_cost_minus_discounts", "ticket_order_num_exists"],
  "follow_up_events": ["redeem_ticket", "accumulate_points"],
  "phase1_scope": "in_scope",
  "notes": "j_bill 需先与真实 DDL/目标表范围核实后才能纳入正式事件"
}
```

**事件库与生成架构的职责边界**：

- `wenti_jianengliang_event` 决定一次行为事件需要产生哪些表记录、每张表几行，以及哪些表需要更新。
- Prompt C 负责选择/补全行为语义，不直接决定任意表集合。
- 事件编排器根据事件库和行为决策解析出 `target_tables`、行数规则、共享键和上下文更新。
- Prompt D 负责在已确定的表集合和 schema 内生成一组联动记录；不得自行增删目标表。
- DAG 负责批次间依赖顺序；同一事件内部的表联动由事件库约束。
- 代码校验器负责硬约束；LLM 语义审查只做辅助，不能替代外键和金额/状态校验。

**首轮必须梳理的 jianengliang 行为事件**：

| 类别 | 事件 | 主要涉及表 | 规划重点 |
|------|------|------------|----------|
| 用户 | 注册会员 | `j_member` | 基础身份、来源、证件状态、唯一 phone |
| 用户 | 绑定第三方账号 | `j_member_third` | `member_id`，绑定类型与 Persona 概率 |
| 用户 | 添加购票人 | `buy_ticket_people` | 购票人数量、证件/性别字段；与订单事件分开建模 |
| 用户 | 开通次卡 | `j_member_time_card` | 卡状态、有效期、用户关联 |
| 营销 | 领取优惠券 | `j_coupon` | `j_coupon_code` 前置、用户关联、有效期 |
| 订单 | 订场并支付 | `j_member_order` + `j_member_order_detail` + `j_order_field` + 可选 `j_order_coupon`/`j_order_card_expense`/`j_points_records` | 一订单一 order_num，多场地明细可能多行 |
| 订单 | 购买游泳票并支付 | `j_member_order` + `j_member_order_detail` + `j_order_ticket` + 可选 `j_order_coupon`/`j_order_card_expense`/`j_points_records` | ticket 数量、ticket_num、核销后置事件 |
| 订单 | 购买演艺/赛事票 | `j_member_order` + `j_member_order_detail` + `j_order_ticket` + 可选优惠/积分表 | 票类型和身份校验规则需与真实业务确认 |
| 订单 | 未支付/取消/超时 | `j_member_order` + 可能的明细表 | `status`、`is_pay`、支付时间和明细是否保留 |
| 订单 | 申请退款并完成退款 | `j_member_order` + `j_member_order_refund` | 订单状态、退款金额、退款时间联动 |
| 票务 | 核销散票 | `j_order_ticket` 更新 + `j_order_ticket_valid` | `ticket_num` 一致，核销时间晚于订单时间，票状态同步 |
| 次卡 | 次卡抵扣消费 | `j_member_order` + `j_order_card_expense` + `j_time_card_use` + `j_member_time_card` 状态联动 | `card_id`、`order_num`、抵扣金额；剩余次数承载字段待 DDL 核实 |
| 订单后置 | 订单完成后累计积分 | `j_points_records` | 仅完成/支付订单触发，`member_id`、`phone`、`order_num`一致 |
| 订单后置 | 馆佳订单同步 | `j_order_guanjia` | 是否纳入 Phase 1 需按数据目标确认，不能默认遗漏 |

**真实 DDL 范围核对结论**：

- jianengliang 真实 DDL 至少包含上述核心事件涉及的 `j_member`、`buy_ticket_people`、`j_coupon`、`j_coupon_code`、`j_member_order`、`j_member_order_detail`、`j_member_order_refund`、`j_member_third`、`j_member_time_card`、`j_order_btp`、`j_order_card_expense`、`j_order_coupon`、`j_order_field`、`j_order_guanjia`、`j_order_ticket`、`j_order_ticket_valid`、`j_time_card_use`、`j_points_records` 等表。
- 原 P2 清单只覆盖其中一部分，且把“行为性联动”写成了批次产物，未定义事件级行数和 update 动作；P2-0 必须先补齐。
- `j_bill` 未在当前 `ods_wenti_starrocks.sql` 的 jianengliang DDL 命中，P1 的 `j_bill` 只能作为冒烟测试占位产物；P2-0 完成前不得把它当作正式 jianengliang 事件表。
- `j_member_order_detail` 的 DDL 注释明确其主要为游泳票订单明细，需在事件库中按 order_type 确认适用范围，不能笼统地对所有订单生成。

**P2-0 交付物**：

- [x] `data/events/wenti_jianengliang_event.json` 已创建，12个事件，含 schema 定义
- [x] jianengliang 全量候选行为事件清单及事件到表的映射矩阵（见事件库文件）
- [x] 每个事件的表动作、行数规则、共享键、前置/后置事件和不变量
- [x] Phase 1 纳入表清单，以及暂缓/排除表的理由（见下方 DDL 核实结论）
- [x] 由 DDL 抽取结果和事件库共同形成的事件覆盖检查清单
- [ ] P2-0 评审通过后，才开始 P2-1 字典数据生成

**DDL 核实结论（2026-08-12）**：

| 发现 | 结论 |
|------|------|
| `j_order_ticket.remain_num` | ✅ 存在，含义=剩余核销次数（非次卡次数），初始值=quantity |
| `j_member_time_card.remain_num` | ❌ 不存在。次卡限制通过 `limit_num`（单日上限）+`discount_time`（单次时长）体现 |
| `j_member_order_detail` 适用范围 | 已确认：只有游泳票(type=3)。订场/演艺/赛事不生成此表 |
| `j_member_order.venue_id` | INT 类型（DDL: `int(64)`），非 VARCHAR，生成时注意 |
| `j_member.id` | INT(11)，非 BIGINT |
| `j_order_card_expense.vip_card_id` | VARCHAR，B端卡ID体系，非 `j_member_time_card.id` |
| `j_time_card_use.card_id` | INT，引用 `j_member_time_card.id` |
| `j_bill` | ❌ jianengliang DDL 不存在，P1 仅为 smoke test 占位 |
| `j_order_guanjia` | ✅ 存在，字段完整，纳入 Phase 1（约50%已支付订单同步） |

**P2-0 待决策问题（评审前需逐条确认）**：

> 以下问题影响 P2-1 至 P2-5 的执行细节，评审时必须明确结论后才能进入后续步骤。

- [x] **[DEC-P2-01] cross_system 近似处理**：✅ **已决策（近似方案）**：直接从 jianengliang 用户中随机选取并赋予跨系统标记，实例的 `behavior_probabilities` 和 `preferred_scenes` 保持 jianengliang 语义（语义近似，已在事件库中标注）。

- [x] **[DEC-P2-02] 退款事件 update 执行方式**：✅ **已决策（选项A，全由代码执行）**：事件编排层直接读内存/CSV，用 `order_num` 作幂等键，定向修改 `j_member_order.status="6", is_refund=1`，并按规则 insert `j_member_order_refund` 记录，不经过 LLM。幂等保证：同一 order_num 不重复执行退款。

- [x] **[DEC-P2-03] 积分的条件行数规则**：✅ **已决策（编排器提前判断）**：`j_points_records` 的 rows=0/1 由事件编排器在构建 `EventCallPlan.target_tables` 时判断（依据 `complete_payment=true`），Prompt D 的 target_tables 中不会出现 `j_points_records` 条目（若未支付），LLM 不自行决策。

- [x] **[DEC-P2-04] `j_member_order_detail` 适用范围**：✅ **已决策（选项A，只有游泳票 type=3）**：DDL 表注释明确"只有游泳票！"，确认此表仅在 `order_type=3` 时生成。P2-4-A（订场 type=2）和 P2-4-C（演艺/赛事 type=5/6）不生成此表，从这些事件的 `table_actions` 中移除。

- [x] **[DEC-P2-05] `j_order_card_expense` 与 `j_time_card_use` 的批次归属**：✅ **已决策（选项A，同批次批次5写入）**：两张表在同一订单事件内同步写入，`j_order_card_expense` 记录卡消费/抵扣，`j_time_card_use` 同时记录次卡使用，`order_num` 一致。批次6（P2-5）中 `j_time_card_use` 删除，不再重复生成。

### P2-1 字典数据生成（批次1）

> 前置条件：P2-0 评审通过，Phase 1 纳入表清单已确认。

- [x] 调用 LLM（新模型 qwopus3.6-27b-fusion-bf16，8080端口）生成字典数据：
  - [x] `data/dict/venues.json`（10条，V001-V010，深圳各区真实地名）
  - [x] `data/dict/sports.json`（20条，S001-S020，order_type_compatible 已修正）
  - [x] `data/dict/merchants.json`（5条，M001-M005，佳兆业各区子公司）
- [x] `data/output/j_coupon_code.csv`（20条，id 30001-30020，已验证 merchant_id 格式）
- [x] **不在此步生成** training 相关字典（`t_class` 等），training 归 P3
- [x] 脚本：`wenti_data_simulator/generators/generate_dicts.py`（含 fallback，支持 --dry-run）

**LLM API 变更（2026-08-12）**：旧端点 `10.20.77.89:8000`（Qwen3.6-35B-A3B）已下线；新端点 `10.20.77.89:8080`，模型 `/home/lck/c/Qwopus3.6-27B-Fusion-BF16.gguf`，API key 不变。新模型单次请求需 2-3 分钟，并发=1，需 max_tokens≥2000 让模型完成 thinking 后再输出 content。

### P2-2 用户事件（批次2-3）

> **数据源（已更新 2026-08-12）**：`wenti_persona_instances.jsonl` 全库 4800 条随机抽 **800 人**，不按 system 字段过滤（该字段已从实例库删除）。
>
> **时间分散规则**：注册时间随机分布在 2026-01-01 至 2026-08-12；批次3各事件时间 = 注册时间 + 随机 1-30 天偏移；同一会员的多条记录相邻最少间隔 1 天。

**P2-2-A 注册会员（批次2）**

触发事件：`EVT_register_member`

每个事件一次 LLM 调用，直接输出完整 j_member 字段（注册事件无复杂联动，Prompt C+D 合并）：
- [ ] `j_member` 1条（目标 **800 条**）
  - `phone` 唯一，从实例 phone 字段取值（若无，Faker 生成）
  - `source` 依实例 `registration_channel`；`rank` 默认 0
  - `id_card_check` / `report_check` 依实例 `id_verification_status`
  - `create_time` 随机分布在 2026-01-01 至 2026-08-12

**P2-2-B 绑定第三方账号（批次3，依赖 P2-2-A）**

触发事件：`EVT_bind_third_party`，触发条件：按实例 `bind_wechat` 概率，代码生成无 LLM

每个事件输出：
- [ ] `j_member_third` 1条（预计约 **600 条**，约 75% 会员触发）
  - `member_id` 引用 `j_member.id`；`third_type=1`（微信）；`third_source=1`（小程序）
  - `create_time` = 注册时间 + 随机 1-14 天

**P2-2-C 添加购票人（批次3，依赖 P2-2-A，可与 2-B 同步）**

触发事件：`EVT_add_ticket_person`，触发条件：按实例 `add_ticket_person` 概率，代码生成无 LLM

每个事件输出：
- [ ] `buy_ticket_people` 1-3 条（预计约 **320 条会员触发**）
  - `member_id` 引用 `j_member.id`；`sex` 字段为 VARCHAR（"男"/"女"/"未知"）
  - `create_time` = 注册时间 + 随机 1-30 天

**P2-2-D 开通次卡（批次3，依赖 P2-2-A）**

触发事件：`EVT_open_time_card`，触发条件：按实例 `use_time_card` 概率 且 `consumption_frequency=high`，代码生成无 LLM

每个事件输出：
- [ ] `j_member_time_card` 1条（预计约 **240 条**）
  - `user_id` 引用 `j_member.id`；`status=0`（待激活）
  - `create_time` = 注册时间 + 随机 1-60 天；`expire_time` = create_time + 365 天

### P2-3 营销事件（批次4，依赖批次2）

触发事件：`EVT_receive_coupon`，触发条件：按实例 `use_coupon` 概率，代码生成无 LLM

每个事件输出：
- [ ] `j_coupon` 1-2 条（目标约 **1200 条**）
  - `code_id` 引用 `j_coupon_code.id`（30001-30020 随机）；`user_id` 引用 `j_member.id`
  - `status=1`（未使用）；各张券时间**至少间隔 3 天**，在 `[注册时间, 注册时间+120天]` 内打散

### P2-4 订单事件（批次5，依赖批次2-4）

> **核心架构**：每次 LLM 调用（Prompt C 行为决策 → Prompt D 字段翻译）同时输出一个订单事件的**全部联动表记录**。Prompt C 先确定 `order_type` 和所有附加行为标志，事件编排器据事件库选定 `target_tables`，Prompt D 一次性填充所有联动表字段。主表与明细表**不拆批次**，同一事件内强制联动。

**通用输入上下文（user_context）**：
```
member_id, phone, venue_id（从字典取）, order_seq, 
coupon_id（若触发 use_coupon）, time_card_id（若触发 use_time_card）,
ticket_people_ids（若触发 add_ticket_people）
```

---

**P2-4-A 订场订单**

触发事件：`EVT_book_field`，触发条件：`order_type="2"`

每个事件 Prompt D 输出（1 次 LLM 调用）：
- [ ] `j_member_order` 1条（type="2"，status 依支付状态）
- [ ] `j_member_order_detail` 1条（订场描述、场地价格）
- [ ] `j_order_field` 1-N 条（每个场地时段 1 条，通常 1 条）
- [ ] `j_order_coupon` 1条（条件：`use_coupon=true`）→ 同时更新 `j_coupon.status=2`
- [ ] `j_order_card_expense` 1条（条件：`use_time_card=true`）→ 同时触发次卡状态联动
- [ ] `j_order_btp` N条（条件：`add_ticket_people=true`，N = 购票人数量）
- [ ] `j_points_records` 1条（条件：支付完成 && `accumulate_points=true`）

**目标**：约 150 个订场事件

---

**P2-4-B 购买游泳票订单**

触发事件：`EVT_buy_swim_ticket`，触发条件：`order_type="3"`

每个事件 Prompt D 输出：
- [ ] `j_member_order` 1条（type="3"）
- [ ] `j_member_order_detail` 1条（游泳票描述、有效期）
- [ ] `j_order_ticket` N条（N = 购票数量 quantity，每条含 ticket_num）
- [ ] `j_order_coupon` 1条（条件：`use_coupon=true`）→ 更新 `j_coupon.status=2`
- [ ] `j_order_card_expense` 1条（条件：`use_time_card=true`）
- [ ] `j_order_btp` N条（条件：`add_ticket_people=true`，`ticket_type=2/3`）
- [ ] `j_points_records` 1条（条件：支付完成）

**目标**：约 200 个游泳票事件

---

**P2-4-C 购买演艺/赛事票订单**

触发事件：`EVT_buy_event_ticket`，触发条件：`order_type="5"` 或 `"6"`

每个事件 Prompt D 输出：
- [ ] `j_member_order` 1条（type="5"或"6"，status 使用 30-42 枚举）
- [ ] `j_member_order_detail` 1条
- [ ] `j_order_ticket` N条
- [ ] `j_order_coupon` 1条（条件：`use_coupon=true`）→ 更新 `j_coupon.status=2`
- [ ] `j_order_btp` N条（条件：有同行人）
- [ ] `j_points_records` 1条（条件：支付完成）

**目标**：约 80 个演艺/赛事事件

---

**P2-4-D 未支付 / 取消 / 超时订单（脏数据 Persona 驱动）**

触发事件：`EVT_abandoned_order`，触发条件：`complete_payment=false` 或 `dirty_data_probability >= 0.10`

每个事件 Prompt D 输出：
- [ ] `j_member_order` 1条（status="0"待支付 或 "3"超时 或 "8"用户取消，`is_pay=0`，`pay_time=null`）
- [ ] `j_member_order_detail` 1条（仅在已生成明细信息时保留，否则可省略）
- [ ] 对应明细表（`j_order_field` 或 `j_order_ticket`）1条，`status` 保持待使用或取消

**目标**：约 70 个未支付/取消事件（约占总订单 14%）

---

**P2-4-E 退款订单**

触发事件：`EVT_refund_order`，触发条件：从已完成支付的订单中随机选取，`dirty_data_probability >= 0.15` 的 Persona 驱动

每个事件 Prompt D 输出：
- [ ] 更新 `j_member_order.status="6"`, `is_refund=1`
- [ ] `j_member_order_refund` 1条（refund_amount、退款时间晚于 pay_time）

**目标**：约 30 个退款事件（从 P2-4-A/B/C 已生成的支付订单中按概率选取）

---

**P2-4 订单事件目标汇总**

| 事件 | 目标条数 | 主要产出表 |
|------|---------|-----------|
| P2-4-A 订场 | ~150 | `j_member_order` + `j_order_field` |
| P2-4-B 游泳票 | ~200 | `j_member_order` + `j_order_ticket` |
| P2-4-C 演艺/赛事 | ~80 | `j_member_order` + `j_order_ticket` |
| P2-4-D 未支付/取消 | ~70 | `j_member_order`（无后续核销） |
| P2-4-E 退款 | ~30 | `j_member_order` + `j_member_order_refund` |
| **合计** | **~530** | — |

> `j_order_guanjia` 是否纳入 P2-4：待 P2-0 事件库对其业务来源（馆佳平台订单）完成裁定后决定。

### P2-5 订单后置事件（批次6，依赖批次5）

> 后置事件依赖 P2-4 已生成的 `j_order_ticket.ticket_num` 和 `j_member_time_card.id`，必须在 P2-4 全部写出后执行。

**P2-5-A 散票核销**

触发事件：`EVT_redeem_ticket`，触发条件：从 P2-4-B/C 产出的 `j_order_ticket` 中随机选约 60% 进行核销

每个核销事件输出：
- [ ] `j_order_ticket_valid` 1条（`ticket_num` 引用 `j_order_ticket.ticket_num`，`valid_time` 晚于对应订单 `create_time`）
- [ ] 更新 `j_order_ticket.status=1`（已使用）

**目标**：约 200 条核销记录

**P2-5-B 次卡使用**

触发事件：`EVT_use_time_card`，触发条件：含 `j_order_card_expense` 的订单事件触发次卡使用记录

每个次卡使用事件输出：
- [ ] `j_time_card_use` 1条（`card_id` 引用 `j_member_time_card.id`，`order_num` 一致）
- [ ] ⚠️ `j_member_time_card` 状态更新：具体更新字段待 P2-0 核实 DDL 后确定

**目标**：与 P2-4 中触发 `use_time_card=true` 的订单事件数量一致（约 60-100 条）

**P2-5-C 累计积分**

> `j_points_records` 已在 P2-4 订单事件中随主事件同步生成（`accumulate_points=true` 时内嵌），P2-5-C 不重复生成。若 P2-0 评审后决定积分单独批次，此处执行补充。

- [ ] 核查 `j_points_records` 行数与已支付订单 × 积分概率是否吻合

### P2-6 事件级联动校验

> 不生成数据，只做验证。所有校验失败须回到对应 P2-4/P2-5 步骤修复，修复完成后重新校验通过才视 P2 完成。

**外键完整性**
- [ ] `j_member_order.user_id` → `j_member.id` 全量命中
- [ ] `j_member_order.venue_id` → `data/dict/venues.json` 全量命中
- [ ] `j_order_field.order_num` / `j_order_ticket.order_num` → `j_member_order.order_num` 全量命中
- [ ] `j_order_coupon.coupon_id` → `j_coupon.id` 全量命中
- [ ] `j_order_btp.btp_id` → `buy_ticket_people.id` 全量命中
- [ ] `j_order_ticket_valid.ticket_num` → `j_order_ticket.ticket_num` 全量命中
- [ ] `j_time_card_use.card_id` → `j_member_time_card.id` 全量命中
- [ ] `j_points_records.order_num` → `j_member_order.order_num` 全量命中

**事件内联动一致性**
- [ ] `j_member_order.type` 与明细表匹配：type="2" → 存在 `j_order_field`；type="3/5/6" → 存在 `j_order_ticket`
- [ ] `j_member_order.order_num` 唯一（全表）
- [ ] `j_order_ticket.ticket_num` 唯一（全表）
- [ ] `j_member.phone` 唯一（全表）

**状态与金额不变量**
- [ ] `is_pay=1` 的订单：`pay_time` 非空，`pay_time >= create_time`
- [ ] `is_pay=1` 的订单：`pay_amount > 0`
- [ ] `pay_amount = cost - discount_amount - deducted_amount`（允许 ±0.01 浮点误差）
- [ ] `is_refund=1` 的订单：存在 `j_member_order_refund` 关联记录，且 `refund_time >= pay_time`
- [ ] `j_coupon.status=2` 的优惠券：存在对应 `j_order_coupon` 关联记录
- [ ] `j_order_ticket_valid` 中的 `valid_time >= 对应 j_member_order.create_time`

**分布合规性**
- [ ] `j_member.sex` 分布：男(1) / 女(2) / 不明(0) 比例在 40/55/5 ± 20% 以内
- [ ] `j_member.source` 分布：小程序(3) ≥ 30%
- [ ] 脏数据条目（`dirty_data_probability >= 0.10` 的 Persona）产出的 `status=0/3/8` 订单比例 ≈ Persona 比例（5.4%）
- [ ] 订单类型分布：订场 / 游泳票 / 演艺赛事 / 未支付 / 退款比例与 P2-4 目标 ±10% 吻合

### P2 完成标准

P2-6 所有校验项全部通过，且：
- [ ] 行数目标：各表行数在下表目标 ±10%

| 表 | 行数目标 |
|----|---------|
| `j_member` | **800** |
| `j_member_third` | ~600 |
| `buy_ticket_people` | ~320 |
| `j_member_time_card` | ~240 |
| `j_coupon` | ~1200 |
| `j_member_order` | ~2120 |
| `j_member_order_detail` | ~1200（游泳票订单明细） |
| `j_member_order_refund` | ~120 |
| `j_order_field` | ~600 |
| `j_order_ticket` | ~1680（游泳票+演艺赛事） |
| `j_order_coupon` | ~800 |
| `j_order_card_expense` | ~240-400 |
| `j_order_btp` | ~240 |
| `j_order_ticket_valid` | ~800 |
| `j_time_card_use` | ~240-400 |
| `j_points_records` | ~1520 |

---

## P3：training + vmdb（批次7-11）

### P3-1 training 订单（批次7-8）

- [ ] `m_trade_order`（120条）
  - `order_status` 枚举：PAYING/FINISHED/REFUNDING/REFUNDED/CANCELLED（VARCHAR）
- [ ] `m_trade_order_course`（120条）
- [ ] `m_trade_order_detail`（120条）
- [ ] `t_class_teacher`（30条）

### P3-2 vmdb 核心表（批次10-11）

> ⚠️ 表名已核实（Hub.md §2.4）：使用 `ods_wenti_vmdb_*` 前缀

- [ ] `ods_wenti_vmdb_h_member`（100条）
  - sex 字段：0=女/1=男（与 jianengliang 定义不同）
- [ ] `ods_wenti_vmdb_h_member_card`（150条）
- [ ] `ods_wenti_vmdb_m_enter_gate`（300-600条入闸记录）

### P3-3 training + vmdb 后置校验

- [ ] `t_student.phone` 与 `j_member.phone` 交集比例 ≥ 20%（跨系统用户）
- [ ] `ods_wenti_vmdb_m_enter_gate.venue_id` 全部来自 `dict/venues.json`

---

## P4：质量验收 + 脏数据注入

### P4-1 脏数据注入

- [ ] 运行 `dirty_injector.py`（按 Hub.md §6.1 规则 D001-D019，总比例 ~5%）
- [ ] 验证脏数据比例：3%-7% 之间
- [ ] 高脏数据 Persona 行为性脏数据已在 P2-P3 阶段自然产生，无需重复注入

> **注意**：`wenti_personas.jsonl` 中 261 条 `dirty_data_probability=0.12` 是 Persona 层面的倾向标记，
> 不等于最终数据集脏数据。P4-1 基于 Hub.md §6.x 规则做表级脏数据注入。

### P4-2 统计质量核查

- [ ] `j_member`：sex 分布 40/60-60/40
- [ ] `j_member`：source 分布，小程序 ≥ 30%
- [ ] `j_member_order`：`timing_errors = 0`（非脏数据条目）
- [ ] `j_member_order`：`is_pay=1` 的 `pay_amount > 0` 率 = 100%
- [ ] 整体脏数据 3%-7%
- [ ] 跨系统 phone 关联：jianengliang ↔ training 交集 20-30%

### P4-3 可选：StarRocks 推送

- [ ] 配置 `config.yaml` 的 `starrocks.*`
- [ ] 运行 Stream Load，验证行数
- [ ] 检查无 FAILED 状态

---

## 风险提示（已更新）

| 风险 | 缓解 |
|------|------|
| PersonaHub 关键词筛选后候选过多（63K）导致分布不均 | ✅ 已解决：分层采样脚本精确控制 j:t:v 比例 |
| LLM Provider 为远端 API，依赖网络可达性 | 确保 `10.20.77.89:8000` 在改造期间持续可用；`--resume` 支持断点续传 |
| Qwen3 thinking 模式导致 content=None | ✅ 已解决：`chat_template_kwargs: {enable_thinking: False}` |
| cross_system Persona=0（分层样本未含） | 后续扩量时在 `stratified_sample_4800.py` 的 TARGETS 加入 `cross_system: N` |
| `order_status` 存储值不确定（"100" vs "PAYING"） | 先确认业务方；暂用字符串枚举，后续一键替换 |
| vmdb 两张表字段映射不完整 | Phase 1 可生成空文件占位，Phase 2 补全 |
| LLM 生成速度慢（单条 ~10-20s） | 4 workers 并发；`--resume` 断点续传；可分多天批次运行 |

---

*计划末尾。执行时以本文件 TODO 为追踪依据，完成一项勾选一项。*
