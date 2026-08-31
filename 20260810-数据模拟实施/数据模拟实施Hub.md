# 佳兆业文体业务数据模拟实施 Hub

> 版本：v1.8 | 日期：2026-08-12 | 状态：**P0 + P1 完成** ✅，P2-0 规划中，P2-1 起待开始

本文档涵盖架构设计、Persona 库、Prompt 模板、字段映射规则、Python 骨架和执行检查清单。后续所有实施均以本文档为准。

---

**v1.8 调整摘要（2026-08-12）**

- **§2.2 重写为六层架构**：在原五层（知识注入/字典/Persona/行为决策/字段翻译/后处理）之间新增第 3.5 层「事件编排层」（`event_orchestrator.py`，纯代码，无 LLM）。事件编排层负责：以 `event_type` 查事件库 → 评估附加行为条件 → 确定 `target_tables` 和行数规则 → 组装 `user_context` 共享键 → 输出 `EventCallPlan`。Prompt D 的职责收窄为”在已确定表集合内填充字段”，不再自行决定表集合、不再自行生成 venue_id 等全局 ID。
- **§2.3 事件库设计保留**：§2.3 为 P2-0 规划内容，含事件库 schema、首轮事件覆盖清单、DAG 与事件库职责边界、P2-0 完成标准，不变。
- **§2.4 DAG 重写**：批次描述由”逐表列举”改为”逐事件列举”，明确批次5（订单事件）的联动机制；`t_class` 移至 P3 批次7；training+vmdb 批次编号调整为批次7-10；新增 P2 批次6（订单后置：核销/次卡使用）；DEC-P2-05 待决策项已标注。旧批次6（training订单主表）改为批次9，旧批次7（jianengliang订单明细）已并入批次5，旧批次9-10（核销/积分）已并入批次5和批次6。
- **§2.4 关联键章节重编号为 §2.5**（内容不变）。

**v1.5 调整摘要（2026-08-11）**

- **P1 完成（2026-08-11）**：`mini_example.py` 实际运行通过，实例 INST_0763，总耗时 11.2s，验证全部通过（时序/金额/枚举），三张 CSV 写出。数据源改为**仅读取实例库**，不再有 Persona 库或内嵌 fallback——未实例化的 Persona 缺少具体个人信息，无法进行角色扮演，fallback 无意义。
- **mini_example.py 数据源**：仅 `wenti_persona_instances.jsonl`，文件不存在则报错退出，不降级。
- **P2 优化项已记录**：Prompt D 需加"phone 必须随机生成，不得使用 138xxxxxxx 连续占位号"。

**v1.4 调整摘要（2026-08-11）**

- **P0-5 新增：Persona 实例化**：新增 `wenti_data_simulator/persona/instantiate_personas.py`，对4800条 `wenti_personas.jsonl` 逐条 LLM 实例化，产出包含姓名/省市/性别/年龄/家庭/房车/年薪/健康状况的 `wenti_persona_instances.jsonl`（4800条）。
- **实例化合理化规则**：全部设定中国境内（海外场景改写），基本信息不得与原 Persona 描述冲突，行为概率在原值基础上变异（85%小波动±0.08，15%大波动±0.20）。
- **后续模拟调用变更**：P1起，行为决策层和数据翻译层输入从 `wenti_personas.jsonl` 改为 `wenti_persona_instances.jsonl`，直接读取实例字段填充数据库表。
- **DEC-007 新增**：决策表增加实例库决策条目。详见 §1.2 和 §3.5。

**v1.3 调整摘要（2026-08-11）**

- **LLM Provider 变更**：改造 Persona 所用 LLM 由本地 Ollama 改为远端 OpenAI-compatible API（vllm 部署 `Qwen3.6-35B-A3B`），调用参数新增 `chat_template_kwargs: {enable_thinking: False}` 以禁用 Qwen3 thinking 模式。详见 §4.3。
- **Persona 库规模变更**：目标条数由"500-2000 条"扩大为 **4800 条**（已产出），分层采样 j:t:v=2880:960:960（60%:20%:20%）。
- **分层采样架构**：候选库关键词分类上限为 j:t:v≈0.74:0.14:0.12，无法单靠词典调整达到目标分布。实际方案：`scripts/stratified_sample_4800.py` 预分桶后附加 `_preset_system` 字段，`hub_adapter.py` 读取该字段直接指定 system，绕过运行时词典推断。
- **dirty_data 注入方式**：LLM 改造时普遍填写保守值，`dirty_data_probability≥0.10` 实际为 0。改为后处理脚本强制将随机选取的约 5.4%（261条）条目改写为 0.12。
- **已产出数据**：`wenti_personas.jsonl` 共 **4800 条**，j=2883/t=952/v=965，dirty=261（5.4%）。

**v1.2 调整摘要（2026-08-10）**

- **Persona 层架构变更**：删除全部手工固定 Persona（原 §3.3 P001-P020，共20条），改为从 Tencent PersonaHub 批量筛选改造，由远端 LLM API 逐条生产，目标 4800 条，存储于 `data/personas/wenti_personas.jsonl`。
- **PersonaHub 调研已内嵌**：数据集地址、格式、许可证、下载方式已更新至 §3.2；CC BY-NC-SA 4.0，仅研究用途。
- **§3.4 行为概率矩阵**：不再以静态表格维护，改为内嵌于每条 Persona 的 `behavior_probabilities` 字段，按 `system` 分层抽样。
- **§5 字段映射**：所有原来引用 P0xx 编号的字段说明，改为基于维度属性（`user_type`、`dirty_data_probability` 阈值等）的描述，与 PersonaHub 改造结果解耦。
- **config.yaml**：`persona.weights`（固定20条权重字典）改为 `persona.system_weights`（按系统分层权重）。
- **v1.1 变更**（2026-08-10 同日早先）：修正 vmdb 表名（对照 DDL）、修正 order_status 枚举、补充 j_member_order NOT NULL 字段（is_send/handle/is_new）、修正 rank 为角色类型 0-4。



1. [项目概览与决策记录](#1-项目概览与决策记录)
2. [数据架构设计](#2-数据架构设计)
3. [Persona 库设计](#3-persona-库设计)
4. [Prompt 模板库](#4-prompt-模板库)
5. [字段映射规则](#5-字段映射规则)
6. [脏数据注入规则](#6-脏数据注入规则)
7. [Python 项目骨架](#7-python-项目骨架)
8. [生成目标与执行检查清单](#8-生成目标与执行检查清单)

---

## 1. 项目概览与决策记录

### 1.1 项目目标

为佳兆业文体业务三个子系统（jianengliang C端、training 培训B端、vmdb 场馆管理B端）的 StarRocks ODS 层冷启动模拟数据，目标用于：
- 标签体系研发阶段的功能验证
- 数据质量基准测试
- 推荐/运营算法的离线实验

**核心约束：效率优先，质量次之（生产数据本身质量也不高）。**

### 1.2 已锁定决策速览

| 决策编号 | 决策点 | 结论 | 影响范围 |
|---------|--------|------|---------|
| DEC-001 | LLM API 选型 | 可配置 Provider 层，不锁定具体 API，支持 pluggable client | 全局架构，llm/ 模块设计 |
| DEC-002 | Persona 来源 | 全量从 Tencent PersonaHub 筛选改造（**实际产出 4800 条**），不手工设计固定 Persona；改造结果通过**远端 OpenAI-compatible API**（`http://10.20.77.89:8000/v1`，`Qwen3.6-35B-A3B`）逐条生产 | persona/ 模块，Prompt B 设计，hub_adapter.py，stratified_sample_4800.py |
| DEC-003 | Phase 1 覆盖范围 | 三系统各选核心链路：jianengliang ~15表 + training ~6表 + vmdb ~8表 | 字段映射规则、生成目标行数 |
| DEC-004 | Hub 产出形式 | 规格说明文档（本文档）+ Python 项目骨架代码 | 交付物类型 |
| DEC-005 | 脏数据策略 | Python 规则注入为主，约5%，行为性脏数据归入特殊类型 Persona（高脏数据概率条目从 PersonaHub 改造时注入） | dirty_injector.py，dirty_data_probability 字段 |
| DEC-006 | 数据写入方式 | 先输出 CSV/JSON 中间文件，写入层可插拔（file \| stream_load） | output/ 模块设计，config.yaml |
| DEC-007 | Persona 实例化 | 在文体化 Persona 基础上，增加 P0-5 实例化步骤，产出含具体个人信息的实例库 `wenti_persona_instances.jsonl`；P1起所有模拟调用实例库而非原始 Persona 库 | instantiate_personas.py，§3.5，第3/4层输入变更 |

### 1.3 非目标（明确排除项）

本次数据模拟**明确不做**以下内容：

1. **不模拟支付网关真实流转**：不调用第三方支付API，pay_time、trade_no 等字段均为模拟生成，不保证与支付宝/微信真实规范一致。
2. **不生成二进制 blob 数据**：不生成图片、视频、PDF等大型二进制文件（如会员照片、场馆宣传图），相关字段置 NULL 或留空。
3. **不覆盖所有90张表**：Phase 1 仅覆盖29张核心表，其余表（如系统日志表、临时中间表、已废弃表）暂不生成。
4. **不模拟实时消息队列**：不模拟 Kafka/RocketMQ 等消息队列的实时数据流，仅生成静态批量数据。
5. **不实现完整的 Agent 框架**：不引入 LangChain/AutoGPT 等 Agent 框架，保持 Python 脚本编排的轻量级架构。
6. **不进行生产环境部署**：模拟数据仅用于开发/测试环境，不直接写入生产 StarRocks 集群。
7. **不保证跨系统数据的完美闭环**：三系统间的关联（venue_id/phone/member_id）在语义层保持一致，但不保证每条 jianengliang 订单都能在 vmdb 找到对应的入闸记录（允许部分数据孤岛）。
8. **不模拟外部系统集成**：不模拟与CRM、ERP、微信公众号等外部系统的数据交互。
9. **不覆盖 vmdb 剧场票务系统**：vmdb 中 `theatre_ticket_*`（选座、分销、票房分成等约10张表）业务逻辑复杂，Phase 1 不覆盖，后续 Phase 2/3 视需求决定是否纳入。
10. **不覆盖 vmdb 停车场系统**：vmdb 中 `p_park_record`、`p_park_ticket` 等停车相关表 Phase 1 不覆盖。

---

## 2. 数据架构设计

### 2.1 三系统关系概览

```
┌─────────────────────────────────────────────────────────────────────┐
│                        佳兆业文体业务三系统                           │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────────────┐         ┌──────────────────────┐         ┌──────────────────────┐
│  jianengliang (C端)  │         │   training (培训B端)  │         │   vmdb (场馆管理B端)  │
│                      │         │                      │         │                      │
│  - 会员注册          │         │  - 学员管理          │         │  - 场馆配置          │
│  - 订场/游泳票       │         │  - 课程购买          │         │  - 会员卡管理        │
│  - 优惠券/积分       │         │  - 排课上课          │         │  - 入闸核销          │
│  - 演艺/赛事票       │         │  - 教练分佣          │         │  - 票务核销          │
└──────────────────────┘         └──────────────────────┘         └──────────────────────┘
         │                                 │                                 │
         │                                 │                                 │
         └─────────────────────────────────┴─────────────────────────────────┘
                                           │
                               ┌───────────┴───────────┐
                               │   跨系统关联键         │
                               │                       │
                               │  • venue_id (场馆ID)  │
                               │  • phone (手机号)     │
                               │  • member_id (会员ID) │
                               └───────────────────────┘

关联说明：
1. venue_id：三系统共享的场馆维度，所有订单/学员/入闸记录都关联到具体场馆
2. phone：跨系统用户识别的主键，jianengliang.j_member.phone = training.t_student.phone
3. member_id：jianengliang 内部会员ID，可通过 phone 映射到 training.t_student.id
4. 弱关联：training 和 vmdb 不直接关联，需通过 venue_id + phone 间接关联
```

### 2.2 六层生成架构（v1.8 更新）

> v1.8 在原五层之上新增第 3.5 层「事件编排层」，解决"一个行为需要生成哪些联动表记录"的问题。原第4层 Prompt D 的职责收窄为"只填充已确定表集合的字段"，不再自行决定表集合。

数据生成流程采用**六层架构**：

```
第0层  知识注入       ODS DDL + 枚举字典 + 业务规则 → data/dict/
第1层  字典数据       Prompt A → venues / sports / merchants / j_coupon_code
第2层  Persona 库    PersonaHub 筛选改造 → wenti_personas.jsonl（4800条）
第2.5层 Persona 实例化  LLM 逐条实例化 → wenti_persona_instances.jsonl（4800条）
第3层  行为决策       Prompt C → 行为决策 JSON（事件类型 + 附加行为标志）
第3.5层 事件编排      事件库查表 → target_tables + 行数规则 + user_context
第4层  字段翻译       Prompt D → 多张联动表字段值（同一事件内不跨批次）
第5层  后处理         脏数据注入 + 质量校验 + CSV 写出
```

#### 第0层：知识注入层

**目的**：为 LLM 提供领域知识上下文。

**输入**：
- ODS 表结构 SQL（CREATE TABLE 语句）
- 业务规则文档（优惠券满减规则、积分计算公式、退款流程等）
- 枚举字典（性别、支付方式、订单状态等）

**输出**：
- 结构化的领域知识 JSON（供 Prompt 引用）
- 枚举值映射表（供后续生成时查表）

**实现方式**：
- 手工编写或从 SQL DDL 自动提取
- 存储在 `data/dict/business_rules.json` 和 `data/dict/enum_mapping.json`

#### 第1层：字典数据层

**目的**：生成全局共享的参照数据（维度表）。P2 专用，training 字典在 P3 生成。

**输入**：
- 第0层的领域知识
- Prompt A（字典数据生成模板）

**输出**：
- `data/dict/venues.json`（场馆，venue_id V001-V010）
- `data/dict/sports.json`（运动类型，sport_id S001-S020）
- `data/dict/merchants.json`（商户，merchant_id M001-M005）
- `j_coupon_code`（优惠券模板，20条）

**实现方式**：
- 调用 LLM（Prompt A）生成合理的字典数据
- 存储在 `data/dict/*.json`，后续所有 FK 仅从此处取值，不允许 LLM 自行生成 venue_id 等全局 ID

#### 第2层：Persona 层

**目的**：建立虚拟用户的行为画像库（改造层，输出行为偏好 JSON）。已完成（P0-4）。

**输出**（已产出）：
- `data/personas/wenti_personas.jsonl`（4800条，j=60.1%/t=19.8%/v=20.1%，dirty=5.4%）

#### 第2.5层：Persona 实例化层

**目的**：为每条行为 Persona 生成具体实例人，补齐数据库表所需的个人基本信息字段。已完成（P0-5）。

**输出**（已产出）：
- `data/personas/wenti_persona_instances.jsonl`（4800条，含姓名/省市/年龄/家庭/收入/行为概率变异）

**后续使用规则**：
- P2 起所有行为模拟均从实例库读取，不再使用 Persona 库
- ⚠️ **`system` 字段已于 2026-08-12 从实例库全量移除**，不再存在于 `wenti_persona_instances.jsonl`。任何按 `system` 字段过滤的旧代码均应删除。
- P2-2 起直接从全库 4800 条中随机抽样（按需抽 800 条），不按 system 分层。training 学员仍从已生成的 jianengliang 用户中按比例选取并赋予跨系统标记（DEC-P2-01 近似方案，不变）。

#### 第3层：行为决策层（Prompt C）

**目的**：从实例的视角生成行为决策，输出**事件类型**和所有附加行为标志，不涉及具体字段。

**输入**：
- 选定的实例 JSON（`wenti_persona_instances.jsonl` 中一条）
- 场景描述（如"工作日晚上购买游泳票"）
- 字典数据摘要（可选场馆、可用优惠券 ID 等）
- Prompt C

**输出**：
```json
{
  "instance_id": "INST_0763",
  "event_type": "EVT_buy_swim_ticket",
  "order_type": "3",
  "complete_payment": true,
  "use_coupon": true,
  "coupon_id": 30001,
  "use_time_card": false,
  "add_ticket_people": false,
  "ticket_people_count": 0,
  "accumulate_points": true,
  "quantity": 1,
  "venue_id": "V003",
  "sport_id": "S002",
  "order_time": "2026-08-12 19:30:00",
  "pay_time_offset_minutes": 5
}
```

**实现方式**：
- `generators/behavior_generator.py` 调用 LLM（Prompt C），temperature=0.7
- 输出只包含行为语义和标志，**不包含任何 DB 字段值**
- 使用 Chain-of-Thought 要求 LLM 先推理再输出

#### 第3.5层：事件编排层（新增）

**目的**：将 Prompt C 的行为决策翻译为"本次 Prompt D 调用需要生成哪些表、每张表几行、使用哪些共享键"，作为第4层的调度指令。这是 LLM 和 DB 之间的确定性桥梁，**不使用 LLM，纯代码逻辑**。

**输入**：
- 第3层的行为决策 JSON（含 event_type + 附加标志）
- `data/events/wenti_jianengliang_event.json`（事件库）
- 当前 user_context（member_id、phone、已生成的 coupon_id / card_id / ticket_people_ids 等）

**处理逻辑**：
1. 以 `event_type` 查事件库，取出该事件的 `table_actions`
2. 对每条 `table_action`，评估 `condition`（如 `use_coupon=true`）是否满足，不满足则 rows=0，从 target_tables 中剔除
3. 计算 rows 规则表达式（如 `quantity`、`ticket_people_count`）
4. 组装 `user_context`，填入 `member_id`、`phone`、`order_num`（新生成）、`ticket_num`（预生成序列）等共享键
5. 输出 `EventCallPlan`（告诉 Prompt D 要生成什么）

**输出**：
```json
{
  "event_id": "JN_EVT_002",
  "target_tables": [
    {"table": "j_member_order", "rows": 1, "action": "insert"},
    {"table": "j_member_order_detail", "rows": 1, "action": "insert"},
    {"table": "j_order_ticket", "rows": 1, "action": "insert"},
    {"table": "j_order_coupon", "rows": 1, "action": "insert"},
    {"table": "j_points_records", "rows": 1, "action": "insert"}
  ],
  "state_updates": [
    {"table": "j_coupon", "key": "id=30001", "fields": {"status": 2, "use_time": "..."}}
  ],
  "user_context": {
    "member_id": 10042,
    "phone": "13812345678",
    "venue_id": "V003",
    "order_num": "JN20260812193001001",
    "coupon_id": 30001,
    "ticket_num_list": ["TK202608121930001"]
  },
  "schema_snapshot": {
    "j_member_order": "<该表的字段 schema>",
    "j_order_ticket": "<该表的字段 schema>"
  }
}
```

**实现方式**：
- `generators/event_orchestrator.py`，纯代码，无 LLM 调用
- 事件库从 `data/events/wenti_jianengliang_event.json` 加载，P2-0 完成后产出

#### 第4层：字段翻译层（Prompt D）

**目的**：在已确定的表集合和 schema 内，一次性填充同一事件所有联动表的字段值。**职责收窄：不决定目标表集合，只填字段。**

**输入**：
- 第3.5层输出的 `EventCallPlan`（含 target_tables、行数、user_context、schema_snapshot）
- 第3层的行为决策 JSON（提供语义上下文）
- Prompt D

**输出**：
- 同一事件所有 insert 表的字段记录（嵌套 JSON，key 为表名）

**关键约束**：
- `target_tables` 由第3.5层传入，Prompt D **不得自行增删表**
- `order_num`、`ticket_num`、`member_id`、`phone` 等共享键全部由 user_context 注入，Prompt D **不得自行生成主键类 ID**
- 所有 `state_updates`（如 `j_coupon.status=2`）由代码执行，不经过 Prompt D
- 温度 temperature=0.3，减少幻觉

**实现方式**：
- `generators/field_translator.py` 调用 LLM（Prompt D）
- 校验后置：字段翻译完成后由 `validation/event_validator.py` 做事件级校验（外键、金额、状态不变量）

#### 第5层：后处理层

**目的**：注入脏数据、验证质量、输出最终文件。

**输入**：
- 第4层生成的干净记录 JSON（已通过事件级校验）

**输出**：
- CSV/JSON 文件（按表分文件，存储在 `data/output/`）
- 质量报告 JSON（统计分布、异常检测结果）

**实现方式**：
- `generators/dirty_injector.py`：按约 5% 比例随机注入脏数据规则（见第6章）
- `validation/quality_checker.py`：统计分布验证（枚举值分布、金额范围、时序一致性）
- `output/file_writer.py`：输出 CSV/JSON
- `output/stream_loader.py`：可选的 StarRocks Stream Load 写入

### 2.3 P2-0：jianengliang 行为事件到表映射（规划门槛）

> 本节定义 P2 实施前必须完成的业务建模工作。当前只建立规范和事件库 schema，不执行字典生成、LLM 调用或业务数据生成。

#### 2.3.1 为什么需要事件库

原有 DAG 解决的是“表之间按什么顺序生成”，但没有解决“某个用户行为需要生成哪些表记录”。例如一次使用优惠券的游泳票订单，至少需要共享 `order_num` 的订单主表、订单明细、票记录、订单优惠券关联，并同步优惠券使用状态；一次次卡抵扣还需要卡消费和次卡使用记录。只按批次逐表生成，容易出现表数量齐全但业务事件断裂、孤儿外键或状态不一致。

P2-0 新增 `wenti_jianengliang_event` 事件库，事件是**可执行的业务事务模板**，不是表名标签。一个事件至少描述：

1. 行为名称和业务语义；
2. 触发条件与互斥条件；
3. 涉及表及每表的 `insert/update/insert_or_update` 动作；
4. 每张表的行数规则（每事件、每订单、每票、每购票人或条件触发）；
5. 共享键及键的生成/继承关系；
6. 前置事件、后置事件和状态更新；
7. 金额、时间、状态、外键等跨表不变量；
8. Phase 1 是否纳入，以及未纳入表的理由。

#### 2.3.2 事件库建议 schema

建议文件：`wenti_data_simulator/data/events/wenti_jianengliang_event.json`（正式实现时可改为 JSONL，但记录结构保持一致）。

```json
{
  "event_id": "JN_EVT_001",
  "event_name": "purchase_swimming_ticket",
  "event_description": "会员购买游泳票并完成支付",
  "system": "jianengliang",
  "trigger": {
    "order_type": ["3"],
    "conditions": ["purchase_intent=true", "complete_payment=true"],
    "probability_keys": ["accumulate_points", "use_coupon", "use_time_card"]
  },
  "table_actions": [
    {"table": "j_member_order", "action": "insert", "rows": 1, "row_rule": "one_per_event"},
    {"table": "j_member_order_detail", "action": "insert", "rows": 1, "row_rule": "one_per_order"},
    {"table": "j_order_ticket", "action": "insert", "rows": "quantity", "row_rule": "one_per_ticket"},
    {"table": "j_order_coupon", "action": "insert", "rows": 1, "condition": "use_coupon=true"},
    {"table": "j_order_card_expense", "action": "insert", "rows": 1, "condition": "use_time_card=true"},
    {"table": "j_points_records", "action": "insert", "rows": 1, "condition": "accumulate_points=true && paid=true"}
  ],
  "state_updates": [
    {"table": "j_coupon", "condition": "use_coupon=true", "fields": ["status", "use_time"]},
    {"table": "j_member_time_card", "condition": "use_time_card=true", "fields": ["pending_confirmation"], "notes": "当前DDL无remain_num，需先确认剩余次数的真实承载字段或表"}
  ],
  "shared_keys": ["member_id", "phone", "venue_id", "order_num", "ticket_num", "coupon_id", "card_id"],
  "preconditions": ["member_exists", "venue_exists", "sport_exists"],
  "postconditions": ["all_order_rows_share_order_num", "pay_amount_is_reconciled", "ticket_rows_reference_order"],
  "follow_up_events": ["redeem_ticket", "accumulate_points"],
  "phase1_scope": "in_scope",
  "notes": "示例记录，仅用于定义结构，不代表已执行生成"
}
```

其中 `rows` 必须支持整数和规则表达式；规则表达式只能引用已确认的行为上下文，不得由 LLM 自由解释。例如 `quantity`、`ticket_people_count`、`max(1, selected_items)`。每个 `state_updates` 必须明确更新前后状态和幂等键，防止重复执行事件造成重复扣减。

#### 2.3.3 首轮事件覆盖清单

| 事件类别 | 建议事件 | 核心表 | 关键联动 |
|---------|---------|--------|---------|
| 用户生命周期 | 注册会员 | `j_member` | phone 唯一、证件状态 |
| 用户关系 | 绑定第三方账号 | `j_member_third` | `member_id` |
| 购票人 | 新增购票人 | `buy_ticket_people` | `member_id`、随后由 `j_order_btp` 关联 |
| 用户权益 | 开通次卡 | `j_member_time_card` | `card_id`、有效期、user_id |
| 营销 | 领取优惠券 | `j_coupon` | `j_coupon_code.id`、user_id、有效期 |
| 订单 | 订场并支付 | `j_member_order`、`j_member_order_detail`、`j_order_field` | 一个 order_num，多场地明细可多行 |
| 订单 | 购买游泳票并支付 | `j_member_order`、`j_member_order_detail`、`j_order_ticket` | quantity、ticket_num |
| 订单 | 购买演艺/赛事票 | `j_member_order`、`j_member_order_detail`、`j_order_ticket` | ticket_type、身份校验 |
| 订单附加行为 | 使用优惠券 | `j_order_coupon` + 更新 `j_coupon` | coupon_id、折扣金额、使用时间 |
| 订单附加行为 | 次卡抵扣 | `j_order_card_expense`、`j_time_card_use` + `j_member_time_card` 状态联动 | card_id、order_num、抵扣金额；剩余次数承载字段待 DDL 核实 |
| 订单附加行为 | 添加购票人 | `j_order_btp` | order_num、btp_id、购票人数 |
| 订单后置 | 票务核销 | 更新 `j_order_ticket` + `j_order_ticket_valid` | ticket_num、核销时间、票状态 |
| 订单后置 | 累计积分 | `j_points_records` | member_id、phone、order_num |
| 异常流程 | 未支付/取消/超时 | `j_member_order` | status、is_pay、pay_time、明细保留策略 |
| 异常流程 | 退款 | `j_member_order` + `j_member_order_refund` | status、is_refund、refund_amount |
| 同步流程 | 馆佳订单同步 | `j_order_guanjia` | order_num、user_id、coupon_id |

#### 2.3.4 事件库与 DAG 的关系

- 事件库回答“一个行为产生什么”；DAG 回答“这些记录何时可写入”。
- 事件内部必须先得到父记录和共享键，再生成子记录；跨事件状态更新必须由事件编排器串行提交。
- Prompt C 只能输出事件类型、行为参数和状态意图；事件编排器根据事件库解析 `target_tables`，不能把完整表列表交给 LLM 自由决定。
- Prompt D 一次调用可以生成同一事件的多张 `insert` 表记录，但必须接收动态裁剪后的 schema、事件记录计划和 `user_context`；对 `update` 只能输出更新意图，实际更新由代码执行。
- 事件执行完成后必须进行事件级校验：所有声明的必需表均有规定行数、所有共享键一致、所有 FK 可解析、所有状态更新与主事件一致。

#### 2.3.5 P2-0 完成标准

- [ ] 对真实 jianengliang DDL 逐表标记：事件角色、主键、关联键、Phase 1 纳入/暂缓/排除
- [ ] 完成首轮行为事件清单，并为每个事件填写表动作和行数规则
- [ ] 明确 `insert` 与 `update` 的边界、幂等键和状态更新规则
- [ ] 完成事件到表映射矩阵及事件间前后置依赖
- [ ] 明确 `j_bill` 的真实归属；在确认前不纳入正式 P2 事件
- [ ] 核实 `j_member_time_card` 剩余次数的真实承载字段/表；当前 DDL 不存在 `remain_num`，不得按旧字段实现
- [ ] 设计事件级校验规则和事件执行记录格式
- [ ] 评审通过后，才进入原 P2-1 字典数据生成

### 2.4 跨表生成依赖顺序（DAG）

> v1.8 重写：DAG 描述的是**批次间的外键依赖顺序**，不描述单次 LLM 调用的表集合（那是事件库的职责）。同一批次内，一次 LLM 调用通过事件编排层同时输出该事件所有联动表记录；批次间仍串行，保证 FK 可解析。

#### P2 jianengliang 批次

##### 批次1：字典数据（无依赖，P2-1）

1. `dict_venues`（场馆字典，持久化 JSON，所有 venue_id FK 来源）
2. `dict_sports`（运动类型字典）
3. `dict_merchants`（商户字典）
4. `j_coupon_code`（优惠券模板，供批次4的 j_coupon 引用）

##### 批次2：用户注册事件（依赖批次1 venue_id，P2-2-A）

5. `j_member`（C端会员，每事件一次 Prompt C + 事件编排 + Prompt D）

##### 批次3：用户关系事件（依赖批次2 member_id，P2-2-B/C/D）

6. `j_member_third`（第三方绑定，触发条件：`bind_wechat 概率`）
7. `buy_ticket_people`（购票人，触发条件：`add_ticket_person 概率`，多条/人）
8. `j_member_time_card`（次卡，触发条件：`use_time_card && consumption_frequency=high`）

> 批次3内部无依赖，可并行。

##### 批次4：营销事件（依赖批次1 j_coupon_code.id + 批次2 member_id，P2-3）

9. `j_coupon`（用户优惠券，status=1 未使用）

##### 批次5：订单事件（依赖批次1-4，P2-4）

> 批次5是核心批次。**每次事件调用同时输出该事件的全部联动表记录**，由事件编排层根据事件库确定 target_tables。

10-A `EVT_book_field`（订场）→ `j_member_order` + `j_member_order_detail` + `j_order_field` + 条件附加表
10-B `EVT_buy_swim_ticket`（游泳票）→ `j_member_order` + `j_member_order_detail` + `j_order_ticket` + 条件附加表
10-C `EVT_buy_event_ticket`（演艺/赛事）→ `j_member_order` + `j_member_order_detail` + `j_order_ticket` + 条件附加表
10-D `EVT_abandoned_order`（未支付/取消）→ `j_member_order` + 对应明细表（status 未支付）
10-E `EVT_refund_order`（退款）→ 更新 `j_member_order.status` + `j_member_order_refund`（代码执行 update）

附加表（条件触发，与主事件同批次）：
- `j_order_coupon`（`use_coupon=true` → 同时代码更新 `j_coupon.status=2`）
- `j_order_card_expense`（`use_time_card=true`）
- `j_order_btp`（`add_ticket_people=true`）
- `j_points_records`（`accumulate_points=true && complete_payment=true`）

> 待 DEC-P2-05 决策后确认：`j_time_card_use` 在批次5与 `j_order_card_expense` 同步生成，还是推迟到批次6。

##### 批次6：订单后置事件（依赖批次5 ticket_num / card_id，P2-5）

11. `j_order_ticket_valid`（散票核销，依赖 `j_order_ticket.ticket_num`，约 60% 的票生成核销记录）
12. `j_time_card_use`（次卡使用，依赖 `j_member_time_card.id + j_member_order.order_num`；若 DEC-P2-05 决策移至批次5，此处删除）

##### P2 执行策略

- 批次1-4 串行，每批完成后写出 CSV/JSON 并入 user_context 池
- 批次5 每次事件调用通过事件编排层确定 target_tables，Prompt D 一次性输出该事件所有联动表记录，事件完成后立即写出并追加更新 user_context
- 批次5 内不同事件间可并行（线程安全地共享 order_seq 计数器）；同一事件内严格串行
- 批次6 在批次5全部写出后执行；核销/次卡使用均在内存中读取批次5产物
- state_updates（优惠券状态、票状态等）全部由代码执行，不经过 LLM

#### P3 training + vmdb 批次

##### 批次7：training 字典（无依赖，P3-1 前置）

13. `t_class`（培训课程模板，P3 专用字典）

##### 批次8：training 学员（依赖批次1 venue_id，P3-1）

14. `t_student`（培训学员；从 jianengliang 用户中按比例选取跨系统标记，见 DEC-P2-01）

##### 批次9：training 订单事件（依赖批次7-8，P3-1）

15. `m_trade_order` + `m_trade_order_course` + `m_trade_order_detail`（每事件联动生成）
16. `t_class_teacher`（课程教练，依赖 t_class.id）

##### 批次10：vmdb 核心表（依赖批次1 venue_id，P3-2，可与批次7-9并行）

> ✅ 表名已核实（2026-08-10，对照 `ods_wenti_starrocks.sql`）

17. `ods_wenti_vmdb_h_member`（vmdb会员信息表）
18. `ods_wenti_vmdb_h_member_card`（会员专项卡）
19. `ods_wenti_vmdb_m_enter_gate`（入闸记录）
20. `ods_wenti_vmdb_m_trade_order`（vmdb交易订单）
21. `ods_wenti_vmdb_m_trade_order_ticket_verify`（散票核销，依赖 m_trade_order_ticket_no）
22. `ods_wenti_vmdb_m_venue_customer`（场馆顾客）

**执行策略**：
- P2 批次1-6 与 P3 批次7-10 串行（P3 依赖 P2 的 j_member 产出）
- P3 内部：批次10（vmdb）可与批次7-9（training）并行（弱依赖）
- 批次间严格串行，确保外键参照完整性

### 2.5 三系统跨表关联键

#### 关联键定义

| 关联键 | 数据类型 | 作用域 | 说明 |
|--------|---------|--------|------|
| `venue_id` | VARCHAR(50) | 全局 | 场馆唯一标识，三系统共享，关联到字典表 dict_venues |
| `phone` | VARCHAR(20) | jianengliang ↔ training | 手机号，跨系统用户识别主键，j_member.phone = t_student.phone |
| `member_id` | BIGINT | jianengliang 内部 | C端会员ID（j_member.id），可通过 phone 映射到 training.t_student.id |
| `student_id` | BIGINT | training 内部 | 培训学员ID（t_student.id），可通过 phone 映射到 jianengliang.j_member.id |
| `order_num` | VARCHAR(50) | 系统内部 | 订单号，各系统独立编码规则，不跨系统关联 |
| `ticket_num` | VARCHAR(50) | jianengliang ↔ vmdb | 票号，jianengliang 生成，vmdb 核销时引用 |

#### 跨系统映射策略

##### 策略1：C端用户 ↔ 培训学员

**场景**：一个用户既在C端购买游泳票，又报名培训课程。

**映射方式**：
```python
# 通过 phone 关联
j_member.phone = t_student.phone

# 生成时确保一致性
persona_phone = "13800138001"
j_member_record = {"id": 10001, "phone": persona_phone, ...}
t_student_record = {"id": 20001, "phone": persona_phone, ...}
```

**数据生成规则**：
- Persona 生成时决定是否跨系统（字段 `cross_system_user: bool`）
- 跨系统用户：同一 phone 在 j_member 和 t_student 都有记录
- 单系统用户：phone 仅在一个系统出现

##### 策略2：订单 ↔ 场馆

**场景**：所有订单都关联到具体场馆。

**映射方式**：
```python
# 通过 venue_id 关联
j_member_order.venue_id = dict_venues.venue_id
m_trade_order.venue_id = dict_venues.venue_id
vmdb_entry_record.venue_id = dict_venues.venue_id
```

**数据生成规则**：
- 批次1生成 dict_venues（如：V001-V010，共10个场馆）
- 后续所有表的 venue_id 从 dict_venues 中随机选择（可根据 Persona 的地域偏好调整分布）

##### 策略3：票务 ↔ 核销

**场景**：C端购买游泳票后，在 vmdb 系统核销入场。

**映射方式**：
```python
# 通过 ticket_num 关联
j_order_ticket.ticket_num = vmdb_ticket_verification.ticket_num

# 核销时间必须晚于购买时间
j_order_ticket.create_time < vmdb_ticket_verification.verification_time
j_order_ticket.status = 1  # 已使用
```

**数据生成规则**：
- 批次7生成 j_order_ticket，生成 ticket_num
- 批次11生成 vmdb_ticket_verification，随机选择部分 ticket_num 进行核销（核销率约60%）
- 未核销的票：status=0（未使用）或 status=2（已过期）

##### 策略4：时间卡 ↔ 使用记录

**场景**：用户购买时间卡后，在订场时抵扣。

**映射方式**：
```python
# 通过 card_id 关联
j_member_time_card.card_id = j_time_card_use.card_id

# 次卡使用后的剩余次数/额度处理
# 当前 DDL 未提供 remain_num 字段，具体更新字段或派生计算方式须在 P2-0 核实后确定
remaining_state = derive_or_update_after_card_use(card_id, order_num)
```

**数据生成规则**：
- 批次3生成 j_member_time_card（部分 Persona 拥有时间卡）
- 批次9生成 j_time_card_use（随机选择时间卡用户的订单，标记为时间卡抵扣）
- 抵扣后根据 P2-0 核实的真实字段/派生规则处理次卡剩余状态

#### 关联一致性校验

在 `validation/quality_checker.py` 中实现以下校验：

1. **phone 跨系统一致性**：
   - 检查 j_member.phone 与 t_student.phone 的交集（跨系统用户比例应为 20-30%）
   
2. **venue_id 完整性**：
   - 所有订单表的 venue_id 必须存在于 dict_venues
   
3. **ticket_num 引用完整性**：
   - vmdb_ticket_verification.ticket_num 必须存在于 j_order_ticket.ticket_num
   
4. **order_num 唯一性**：
   - j_member_order.order_num 在全表唯一
   - m_trade_order.order_num 在全表唯一（不同系统可重复，如 JN202608... 和 TR202608...）

---

## 3. Persona 库设计

### 3.1 Persona 8维度定义

在原7维度基础上加入"身体/证件状态"维度，共8个维度：

| 维度编号 | 维度名称 | 字段 key | 取值范围 |
|---------|---------|---------|---------|
| D1 | 用户类型 | user_type | 大学生、上班族、家庭主妇、退休老人、青少年、企业客户、偶发型游客 |
| D2 | 价格敏感度 | price_sensitivity | high（高敏感/羊毛党）、medium（中性）、low（低敏感/消费力强） |
| D3 | 偏好场景 | preferred_scenes | 游泳、订场（羽毛球/篮球/网球）、培训课程、演艺活动、赛事参与、健身房 |
| D4 | 活跃时段 | active_hours | morning（6-9点）、noon（11-14点）、evening（18-22点）、weekend_full_day、irregular |
| D5 | 消费频次 | consumption_frequency | high（≥8次/月）、medium（3-7次/月）、low（1-2次/月）、dormant（0次/月） |
| D6 | 注册渠道 | registration_channel | android（1）、ios（2）、miniprogram（3）、backend_entry（4） |
| D7 | 生命周期 | lifecycle_stage | new_user（注册<30天）、growing（30-180天）、mature（180天+）、at_risk（90天未消费）、churned（180天未消费） |
| D8 | 身份/证件状态 | id_verification_status | unverified（id_card_check=1）、verified（id_card_check=2）、expired（id_card_check=3）、disabled（id_card_check=4） |

**说明：**
- D8维度直接映射到 j_member.id_card_check 和 j_member.report_check
- D8影响的业务规则：赛事参与、特殊票类需要 id_card_check=2（已校验）
- id_card_check 与 report_check 可以组合，如：已验证身份但未上传健康报告（id_card_check=2, report_check=1）

### 3.2 Tencent Persona Hub 接入策略

#### 1. 数据集地址与下载命令

```bash
# HuggingFace 数据集地址
# https://huggingface.co/datasets/proj-persona/PersonaHub

# 使用 datasets 库下载（推荐，可流式下载避免OOM）
pip install datasets

python3 -c "
from datasets import load_dataset
# 流式加载，避免一次性下载全部
ds = load_dataset('proj-persona/PersonaHub', split='train', streaming=True)
# 取前5000条
records = []
for i, row in enumerate(ds):
    if i >= 5000:
        break
    records.append(row)
import json
with open('data/personas/persona_hub_raw.jsonl', 'w', encoding='utf-8') as f:
    for r in records:
        f.write(json.dumps(r, ensure_ascii=False) + '
')
print(f'Downloaded {len(records)} records')
"
```

#### 2. 筛选策略

PersonaHub 原始记录格式为英文 persona 描述，需筛选出具有消费相关描述的子集：

```python
# 关键词过滤（英文关键词，对应文体消费场景）
RELEVANT_KEYWORDS = [
    # 运动/健身相关
    "fitness", "gym", "swimming", "sports", "exercise", "workout",
    "badminton", "basketball", "tennis", "yoga", "martial arts",
    # 消费行为相关
    "shopping", "consumer", "purchase", "budget", "price", "discount",
    "membership", "subscription", "online shopping",
    # 人群类型相关
    "student", "office worker", "parent", "retiree", "young professional",
    "family", "athlete", "beginner",
    # 文体娱乐相关
    "entertainment", "concert", "event", "ticketing", "leisure",
    "recreation", "community center", "sports facility"
]

def is_relevant(persona_text: str) -> bool:
    text_lower = persona_text.lower()
    return any(kw in text_lower for kw in RELEVANT_KEYWORDS)

# 类别过滤（PersonaHub 部分版本有 input_persona 字段）
RELEVANT_CATEGORIES = [
    "sports", "health", "lifestyle", "consumer", "entertainment",
    "education", "community"
]
```

**预期筛选结果**：200K 原始数据中实际筛选出 **63,493 条**（31.7%），再分层采样产出 4800 条改造输入。

#### 3. LLM改造 Prompt 模板（Prompt B 完整版）

见 4.3 节。

#### 4. 改造后的输出 JSON Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "WentiPersona",
  "type": "object",
  "required": ["persona_id", "name", "system", "dimensions", "behavior_probabilities",
               "typical_order_types", "avg_monthly_orders", "avg_order_amount_range", "dirty_data_probability"],
  "properties": {
    "persona_id":   {"type": "string", "pattern": "^P[0-9]{3}$"},
    "name":         {"type": "string", "description": "Persona 中文名称"},
    "source":       {"type": "string", "enum": ["manual", "persona_hub_adapted"], "description": "来源"},
    "system":       {"type": "string", "enum": ["jianengliang", "training", "vmdb", "cross_system"]},
    "dimensions": {
      "type": "object",
      "required": ["user_type","price_sensitivity","preferred_scenes","active_hours",
                   "consumption_frequency","registration_channel","lifecycle_stage","id_verification_status"],
      "properties": {
        "user_type":              {"type": "string"},
        "price_sensitivity":      {"type": "string", "enum": ["high","medium","low"]},
        "preferred_scenes":       {"type": "array", "items": {"type": "string"}, "minItems": 1},
        "active_hours":           {"type": "string"},
        "consumption_frequency":  {"type": "string", "enum": ["high","medium","low","dormant"]},
        "registration_channel":   {"type": "string", "enum": ["android","ios","miniprogram","backend_entry"]},
        "lifecycle_stage":        {"type": "string", "enum": ["new_user","growing","mature","at_risk","churned"]},
        "id_verification_status": {"type": "string", "enum": ["unverified","verified","expired","disabled"]}
      }
    },
    "behavior_probabilities": {
      "type": "object",
      "required": ["use_coupon","bind_wechat","add_ticket_person","accumulate_points",
                   "use_time_card","complete_id_check","complete_health_check"],
      "properties": {
        "use_coupon":             {"type": "number", "minimum": 0, "maximum": 1},
        "bind_wechat":            {"type": "number", "minimum": 0, "maximum": 1},
        "add_ticket_person":      {"type": "number", "minimum": 0, "maximum": 1},
        "accumulate_points":      {"type": "number", "minimum": 0, "maximum": 1},
        "use_time_card":          {"type": "number", "minimum": 0, "maximum": 1},
        "complete_id_check":      {"type": "number", "minimum": 0, "maximum": 1},
        "complete_health_check":  {"type": "number", "minimum": 0, "maximum": 1}
      }
    },
    "typical_order_types":       {"type": "array", "items": {"type": "string"}},
    "avg_monthly_orders":        {"type": "integer", "minimum": 0},
    "avg_order_amount_range":    {"type": "array", "items": {"type": "number"}, "minItems": 2, "maxItems": 2},
    "dirty_data_probability":    {"type": "number", "minimum": 0, "maximum": 0.3},
    "notes":                     {"type": "string", "description": "特殊说明（可选）"}
  }
}
```

### 3.3 PersonaHub 改造后 Persona 样例

> ⚠️ **架构变更说明（v1.2）**：本节已由"20个手工固定 Persona"调整为"PersonaHub 批量改造"方案。
> 不再维护任何手工编写的固定 Persona；所有 Persona 由 `hub_adapter.py` 通过**远端 LLM API**（`Qwen3.6-35B-A3B`）逐条生产，存储于 `data/personas/wenti_personas.jsonl`。
> 下方仅保留 **3条典型改造样例** 供格式参考，不代表实际运行时的完整 Persona 库。

#### 改造样例一：运动健康类（来自 PersonaHub）

```json
{
  "persona_id": "P_HUB_0042",
  "name": "注重健康的年轻白领",
  "source": "persona_hub_adapted",
  "original_persona": "A 28-year-old office worker who values fitness and health, enjoys swimming after work, budget-conscious but willing to invest in wellbeing.",
  "system": "jianengliang",
  "dimensions": {
    "user_type": "上班族",
    "price_sensitivity": "medium",
    "preferred_scenes": ["游泳", "健身房"],
    "active_hours": "evening",
    "consumption_frequency": "medium",
    "registration_channel": "miniprogram",
    "lifecycle_stage": "mature",
    "id_verification_status": "verified"
  },
  "behavior_probabilities": {
    "use_coupon": 0.55,
    "bind_wechat": 0.72,
    "add_ticket_person": 0.18,
    "accumulate_points": 0.80,
    "use_time_card": 0.42,
    "complete_id_check": 0.75,
    "complete_health_check": 0.40
  },
  "typical_order_types": ["游泳票", "订场"],
  "avg_monthly_orders": 5,
  "avg_order_amount_range": [50, 120],
  "dirty_data_probability": 0.02,
  "notes": "从原 Persona 的'enjoys swimming'和'budget-conscious'推导；晚间消费高峰"
}
```

#### 改造样例二：家庭亲子类（来自 PersonaHub）

```json
{
  "persona_id": "P_HUB_0217",
  "name": "带孩子的全职妈妈",
  "source": "persona_hub_adapted",
  "original_persona": "A stay-at-home mother of two young children, actively seeks enrichment activities for kids, price-aware but prioritizes quality for children's education.",
  "system": "training",
  "dimensions": {
    "user_type": "家庭主妇",
    "price_sensitivity": "medium",
    "preferred_scenes": ["培训课程"],
    "active_hours": "weekend_full_day",
    "consumption_frequency": "high",
    "registration_channel": "miniprogram",
    "lifecycle_stage": "growing",
    "id_verification_status": "verified"
  },
  "behavior_probabilities": {
    "use_coupon": 0.60,
    "bind_wechat": 0.78,
    "add_ticket_person": 0.00,
    "accumulate_points": 0.65,
    "use_time_card": 0.00,
    "complete_id_check": 0.90,
    "complete_health_check": 0.85
  },
  "typical_order_types": ["课程购买"],
  "avg_monthly_orders": 1,
  "avg_order_amount_range": [800, 3500],
  "dirty_data_probability": 0.01,
  "notes": "青少年学员（子女）；健康证明要求严格；周末报名高峰"
}
```

#### 改造样例三：高脏数据概率类（来自 PersonaHub）

```json
{
  "persona_id": "P_HUB_0891",
  "name": "冲动下单但不付款的用户",
  "source": "persona_hub_adapted",
  "original_persona": "An impulsive buyer who often adds items to cart but abandons checkout, very price-sensitive, waits for heavy discounts before committing.",
  "system": "jianengliang",
  "dimensions": {
    "user_type": "普通用户",
    "price_sensitivity": "high",
    "preferred_scenes": ["游泳", "订场"],
    "active_hours": "irregular",
    "consumption_frequency": "low",
    "registration_channel": "miniprogram",
    "lifecycle_stage": "at_risk",
    "id_verification_status": "unverified"
  },
  "behavior_probabilities": {
    "use_coupon": 0.32,
    "bind_wechat": 0.48,
    "add_ticket_person": 0.08,
    "accumulate_points": 0.22,
    "use_time_card": 0.00,
    "complete_id_check": 0.18,
    "complete_health_check": 0.04
  },
  "typical_order_types": ["游泳票", "订场"],
  "avg_monthly_orders": 2,
  "avg_order_amount_range": [0, 60],
  "dirty_data_probability": 0.18,
  "notes": "行为性脏数据源：约70%订单不完成支付，status=0/pay_time=NULL/is_pay=0"
}
```

#### 改造后 Persona 库的分布目标

运行 `hub_adapter.py` 完成批量改造后，`wenti_personas.jsonl` 中条目应满足以下分布约束。**实际采用分层采样方案（`stratified_sample_4800.py`）精确控制，不依赖后处理自动纠正**：

| 维度 | 目标分布 | 实际结果（4800条） |
|------|---------|---------|
| system | jianengliang ≥50%，training 15-25%，vmdb 10-20%，cross_system 5-10% | j=60.1%, t=19.8%, v=20.1%, cs=0% |
| dirty_data_probability | ≥0.10 的"高脏数据"条目占比约 5-10% | 5.4%（261条，后处理注入） |
| price_sensitivity | high 25-35%，medium 40-50%，low 15-25% | — |
| lifecycle_stage | new_user ≤15%，growing 20-35%，mature 35-50%，at_risk 10-20%，churned 5-10% | — |
| consumption_frequency | dormant ≤15%，high 20-35%，medium 35-45%，low 15-25% | — |

> **分层采样核心逻辑**：PersonaHub 候选库天然词频结构导致词典分类上限 j:t:v≈0.74:0.14:0.12，无法单靠关键词调整达到目标。实际方案：`scripts/stratified_sample_4800.py` 按词典预分桶后附加 `_preset_system` 字段，`hub_adapter.py` 读取该字段直接指定 system。`cross_system=0` 是当前分层样本未配额所致，后续扩量时在 TARGETS 中补充。


### 3.4 行为概率矩阵（内嵌于每条 Persona）

> **架构变更说明（v1.2）**：行为概率矩阵不再以静态表格维护，而是作为每条 PersonaHub 改造 Persona 的 `behavior_probabilities` 字段内嵌存储（见 3.2 节 JSON Schema 和 3.3 节样例）。

**7个行为维度定义：**

| 行为键 | 含义 | 典型高概率场景 |
|--------|------|--------------|
| `use_coupon` | 生成订单时使用优惠券的概率（触发后从 j_coupon 中选可用券） | 价格敏感型、冲动型 |
| `bind_wechat` | j_member_third 表中有微信绑定记录的概率（third_type=2） | 年轻用户、互联网原生 |
| `add_ticket_person` | 订单关联 buy_ticket_people 的概率（亲子/演艺场景高） | 家庭型、演艺观众 |
| `accumulate_points` | 订单完成后生成 j_points_records 的概率 | 成熟用户、高频用户 |
| `use_time_card` | 订单使用时间卡抵扣的概率（需先生成 j_member_time_card） | 高频用户、包月会员 |
| `complete_id_check` | j_member.id_card_check=2（已校验）的概率 | 赛事参与、正式会员 |
| `complete_health_check` | j_member.report_check=3（已通过）的概率 | 青少年学员（家长代报）、正式会员 |

**运行时使用方式：**

```python
import random

# persona 是从 wenti_personas.jsonl 中随机抽取的一条改造 Persona
persona = random.choice(all_personas)

if random.random() < persona["behavior_probabilities"]["use_coupon"]:
    # 从用户的可用优惠券中选择一张
    coupon_id = select_available_coupon(user_id)
    order["coupon_id"] = coupon_id

# 脏数据触发
if random.random() < persona["dirty_data_probability"]:
    dirty_injector.inject(order, persona)
```

**Persona 抽样策略：**

由于 PersonaHub 改造后条目数量大（**实际 4800 条**），不再使用固定权重字典，改为按 `system` 字段分层抽样：
- 生成 jianengliang 记录时，从 `system="jianengliang"` 或 `system="cross_system"` 的 Persona 池中随机抽取
- 生成 training 记录时，从 `system="training"` 或 `system="cross_system"` 的 Persona 池中抽取
- 生成 vmdb 记录时，从 `system="vmdb"` 的 Persona 池中抽取
- `cross_system` Persona 同时参与 jianengliang 和 training 两个池，确保跨系统用户比例（目标 20-30%）

> **v1.4 说明**：抽样单位已由 Persona（`wenti_personas.jsonl`）改为实例（`wenti_persona_instances.jsonl`）。实例字段与 Persona 字段一一对应，`system` 分层逻辑不变，但每个被抽中的实例带有具体个人信息（姓名/省市/年龄等），可直接填入数据库记录。

---

### 3.5 实例库字段规范（v1.4 新增）

每条 `wenti_persona_instances.jsonl` 记录在原 Persona 字段基础上新增以下个人信息字段：

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| `instance_id` | string | `INST_XXXX`，全局唯一 | 4位零填充 |
| `persona_id` | string | 关联的 `P_HUB_XXXX` | 与 wenti_personas.jsonl 一一对应 |
| `name` | string | 中文姓名（2-3字） | 与 user_type 性别一致 |
| `gender` | string | `male` / `female` | — |
| `age` | int | 整数，与 user_type 一致 | 大学生18-24，退休老人55+等 |
| `province` | string | XX省/直辖市 | 全部中国境内 |
| `city` | string | XX市 | 与 province 匹配 |
| `district` | string | XX区（可选，可空） | — |
| `family_status.married` | bool | 是否已婚 | — |
| `family_status.has_children` | bool | 是否有孩子 | — |
| `family_status.children_count` | int | 孩子数量（0-N） | — |
| `has_house` | bool | 是否有房 | — |
| `has_car` | bool | 是否有车 | — |
| `annual_income` | int | 年薪（元，整数） | 与 user_type/消费能力一致 |
| `health_status` | string | `good` / `fair` / `poor` | — |
| `behavior_probabilities` | object | 7个行为概率（变异后） | 原值 ±0.08/±0.20，范围 [0,1] |
| `avg_monthly_orders` | int | 月均消费次数（变异后） | ±20% 以内 |
| `avg_order_amount_range` | [int,int] | 订单金额区间（变异后） | ±20% 以内 |
| `dirty_data_probability` | float | 脏数据触发概率 | **保持原值不变** |
| `system` | string | jianengliang/training/vmdb | 继承自 Persona |
| `dimensions` | object | 8维度（继承，不变） | — |
| `original_persona` | string | 原始英文 Persona 描述 | 继承，用于溯源 |

**中国化规则**：
- 海外地名/场景改写为中国等价（硅谷→深圳南山，Broadway→上海戏剧院）
- 省市覆盖一线/二线城市为主（广东/上海/北京/浙江/四川优先），与文体消费场景匹配
- 年龄+家庭+收入三者内部一致性由 LLM 自行保证（prompt 中有明确说明）

---

## 4. Prompt 模板库

### 4.1 LLM Provider 接口规范

```python
from abc import ABC, abstractmethod
from typing import Dict, Any, Optional

class LLMProvider(ABC):
    """
    LLM Provider 抽象接口，所有具体实现必须继承此类。

    设计原则：
    - 调用方只需关心 complete() 接口，不关心底层实现
    - 支持 JSON 输出格式（response_format="json"）
    - 统一的错误处理和重试机制
    - 配置通过 config.yaml 注入，不硬编码
    """

    @abstractmethod
    def complete(
        self,
        system: str,
        user: str,
        response_format: str = "text",
        temperature: float = 0.7,
        max_tokens: int = 4096
    ) -> Dict[str, Any]:
        """
        调用 LLM 生成响应。

        Args:
            system: 系统提示词（角色定义、任务描述）
            user: 用户提示词（具体输入数据）
            response_format: 响应格式，"text" | "json"
            temperature: 温度参数，0.0-2.0
            max_tokens: 最大输出 token 数

        Returns:
            {
                "content": str,           # 生成的文本内容
                "parsed_json": dict,      # 如果 response_format="json"，解析后的 JSON 对象
                "usage": {
                    "prompt_tokens": int,
                    "completion_tokens": int,
                    "total_tokens": int
                },
                "model": str,             # 实际使用的模型
                "latency_ms": float       # 请求耗时（毫秒）
            }

        Raises:
            LLMError: LLM 调用失败（网络错误、API 错误、超时等）
        """
        pass

    @abstractmethod
    def get_provider_name(self) -> str:
        """返回 Provider 名称，如 'deepseek', 'claude', 'openai'"""
        pass


class LLMProviderFactory:
    """
    Provider 工厂类，根据配置动态加载实现。

    使用方式：
    >>> config = load_config("config.yaml")
    >>> factory = LLMProviderFactory(config)
    >>> provider = factory.create_provider()
    >>> response = provider.complete(system="...", user="...")
    """

    _registry: Dict[str, type] = {}

    @classmethod
    def register(cls, provider_name: str, provider_class: type):
        """注册一个 Provider 实现"""
        cls._registry[provider_name] = provider_class

    def __init__(self, config: Dict[str, Any]):
        self.config = config

    def create_provider(self) -> LLMProvider:
        """根据配置创建 Provider 实例"""
        provider_name = self.config["llm"]["provider"]
        if provider_name not in self._registry:
            raise ValueError(f"Unknown provider: {provider_name}")

        provider_class = self._registry[provider_name]
        provider_config = self.config["llm"].get(provider_name, {})
        return provider_class(provider_config)


# 使用示例：具体实现在各 provider 文件中自动注册
# from llm.deepseek_provider import DeepSeekProvider
# LLMProviderFactory.register("deepseek", DeepSeekProvider)
```

### 4.2 Prompt A：字典数据生成

```python
# prompts/dict_gen.txt

SYSTEM_PROMPT = """
你是一个专业的数据工程师，负责为文体业务系统生成合理的字典数据（维度表）。

要求：
1. 数据必须符合中国文体行业的真实情况（场馆名称、运动类型、地理位置等）
2. 生成的数据要有足够的多样性，避免过于模式化
3. 数值范围要合理（如优惠券金额、课程价格等）
4. 严格按照 JSON Schema 输出，确保字段名和类型正确
5. 如果不确定某个字段的合理取值，优先参考常见的行业规范

你的输出将直接用于后续的数据生成流程，不要包含任何解释性文字。
"""

USER_PROMPT_TEMPLATE = """
请生成以下字典数据：

【数据类型】：<<DATA_TYPE>>

【数量要求】：<<QUANTITY>>

【字段 Schema】：
<<FIELD_SCHEMA>>

【业务规则】：
<<BUSINESS_RULES>>

【输出格式】：
严格按照以下 JSON Schema 输出，不要添加任何其他内容：

<<OUTPUT_SCHEMA>>

【参考示例】（仅供理解，不要完全照抄）：
<<EXAMPLES>>
"""

# 场馆字典生成示例
VENUE_EXAMPLE = {
    "data_type": "venues",
    "quantity": 10,
    "field_schema": {
        "venue_id": "VARCHAR(50), 主键，格式 V001-V999",
        "venue_name": "VARCHAR(100), 场馆名称，需符合中国文体中心命名习惯",
        "province": "VARCHAR(50), 省份",
        "city": "VARCHAR(50), 城市",
        "area": "VARCHAR(50), 区县",
        "capacity": "INT, 场馆容量（人）",
        "open_time": "TIME, 营业开始时间",
        "close_time": "TIME, 营业结束时间"
    },
    "business_rules": [
        "场馆名称多为：XX体育中心、XX游泳馆、XX羽毛球馆、XX文体活动中心",
        "地理位置集中在广东省深圳市（南山区、福田区、宝安区等）",
        "容量范围：500-5000人",
        "营业时间一般为：06:00-22:00"
    ],
    "output_schema": {
        "type": "array",
        "items": {
            "type": "object",
            "properties": {
                "venue_id": {"type": "string"},
                "venue_name": {"type": "string"},
                "province": {"type": "string"},
                "city": {"type": "string"},
                "area": {"type": "string"},
                "capacity": {"type": "integer"},
                "open_time": {"type": "string", "format": "time"},
                "close_time": {"type": "string", "format": "time"}
            }
        }
    },
    "examples": [
        {
            "venue_id": "V001",
            "venue_name": "深圳湾体育中心",
            "province": "广东省",
            "city": "深圳市",
            "area": "南山区",
            "capacity": 3000,
            "open_time": "06:00:00",
            "close_time": "22:00:00"
        }
    ]
}

# 优惠券模板生成示例
COUPON_CODE_EXAMPLE = {
    "data_type": "coupon_codes",
    "quantity": 20,
    "field_schema": {
        "id": "BIGINT, 主键，自增",
        "name": "VARCHAR(100), 优惠券名称",
        "price": "DECIMAL(10,2), 面额（元）",
        "full_cut_price": "DECIMAL(10,2), 满减门槛（元），0表示无门槛",
        "req_points": "INT, 兑换所需积分，0表示直接发放",
        "rec_type": "INT, 推荐类型（1首页/2分类/3详情）",
        "scene_type": "INT, 使用场景（2订场/3游泳票/5演艺/6赛事）",
        "days": "INT, 有效天数",
        "amount": "INT, 发行总量",
        "ex_amount": "INT, 已兑换数量（初始为0）",
        "use_amount": "INT, 已使用数量（初始为0）",
        "expire_amount": "INT, 已过期数量（初始为0）",
        "send_start_time": "DATETIME, 发放开始时间",
        "send_end_time": "DATETIME, 发放结束时间",
        "merchant_id": "VARCHAR(50), 商户ID"
    },
    "business_rules": [
        "优惠券类型：满减券（price>0, full_cut_price>price）、折扣券、无门槛券（full_cut_price=0）",
        "面额范围：5元-200元",
        "满减门槛一般为面额的2-5倍",
        "有效期一般为7天、15天、30天",
        "发行总量：1000-50000张",
        "初始状态：ex_amount=0, use_amount=0, expire_amount=0",
        "send_start_time 从2026年1月1日起，send_end_time 在 start_time 基础上+30到90天"
    ],
    "output_schema": {
        "type": "array",
        "items": {
            "type": "object",
            "properties": {
                "id": {"type": "integer"},
                "name": {"type": "string"},
                "price": {"type": "number"},
                "full_cut_price": {"type": "number"},
                "req_points": {"type": "integer"},
                "rec_type": {"type": "integer"},
                "scene_type": {"type": "integer"},
                "days": {"type": "integer"},
                "amount": {"type": "integer"},
                "ex_amount": {"type": "integer"},
                "use_amount": {"type": "integer"},
                "expire_amount": {"type": "integer"},
                "send_start_time": {"type": "string", "format": "date-time"},
                "send_end_time": {"type": "string", "format": "date-time"},
                "merchant_id": {"type": "string"}
            }
        }
    }
}
```

### 4.3 Prompt B：Persona改造（Persona Hub → 文体Persona）

```python
# prompts/persona_adapt.txt

SYSTEM_PROMPT = """
你是一个专业的 Persona 设计师，负责将通用的用户画像改造为文体消费场景下的具体 Persona。

你的任务：
1. 阅读输入的 Persona Hub 原始记录（英文描述）
2. 提取其中与消费行为、生活方式、人群特征相关的信息
3. 将其映射到文体消费场景（游泳、订场、培训、演艺等）
4. 补充8个维度的具体取值
5. 估算行为概率矩阵（基于常识推理）

要求：
- 保持原 Persona 的核心特征（年龄段、消费能力、生活方式等）
- 映射要合理：如"健身爱好者"→高频游泳/订场，"家长"→培训课程
- 行为概率要符合直觉：价格敏感的人use_coupon概率高，VIP用户complete_id_check概率高
- 如果原 Persona 与文体消费关联度低，可以适当创造性扩展，但不能偏离原人设

输出严格遵循 JSON Schema，不要包含任何解释性文字。
"""

USER_PROMPT_TEMPLATE = """
请将以下 Persona Hub 原始记录改造为文体消费场景 Persona：

【原始 Persona】：
<<ORIGINAL_PERSONA>>

【改造目标系统】：<<TARGET_SYSTEM>>
（可选值：jianengliang | training | vmdb | cross_system）

【8维度定义】：
1. user_type: 用户类型（大学生、上班族、家庭主妇、退休老人、青少年、企业客户、偶发型游客）
2. price_sensitivity: 价格敏感度（high | medium | low）
3. preferred_scenes: 偏好场景（游泳、订场、培训课程、演艺活动、赛事参与、健身房）
4. active_hours: 活跃时段（morning | noon | evening | weekend_full_day | irregular）
5. consumption_frequency: 消费频次（high≥8次/月 | medium 3-7次/月 | low 1-2次/月 | dormant 0次/月）
6. registration_channel: 注册渠道（android | ios | miniprogram | backend_entry）
7. lifecycle_stage: 生命周期（new_user<30天 | growing 30-180天 | mature 180天+ | at_risk 90天未消费 | churned 180天未消费）
8. id_verification_status: 身份验证状态（unverified | verified | expired | disabled）

【行为概率维度】：
- use_coupon: 使用优惠券概率
- bind_wechat: 绑定微信概率
- add_ticket_person: 添加票务人概率
- accumulate_points: 积分累积概率
- use_time_card: 使用时间卡概率
- complete_id_check: 完成身份验证概率
- complete_health_check: 完成健康报告概率

【输出格式】：
严格按照以下 JSON Schema 输出：

{
  "persona_id": "P_HUB_<<INDEX>>",
  "name": "中文名称（简短描述）",
  "source": "persona_hub_adapted",
  "system": "<<TARGET_SYSTEM>>",
  "dimensions": {
    "user_type": "...",
    "price_sensitivity": "high|medium|low",
    "preferred_scenes": ["...", "..."],
    "active_hours": "...",
    "consumption_frequency": "...",
    "registration_channel": "...",
    "lifecycle_stage": "...",
    "id_verification_status": "..."
  },
  "behavior_probabilities": {
    "use_coupon": 0.0-1.0,
    "bind_wechat": 0.0-1.0,
    "add_ticket_person": 0.0-1.0,
    "accumulate_points": 0.0-1.0,
    "use_time_card": 0.0-1.0,
    "complete_id_check": 0.0-1.0,
    "complete_health_check": 0.0-1.0
  },
  "typical_order_types": ["...", "..."],
  "avg_monthly_orders": <integer>,
  "avg_order_amount_range": [min, max],
  "dirty_data_probability": 0.0-0.05,
  "notes": "改造说明（可选）"
}

【示例】：
原始 Persona: "A 35-year-old software engineer who enjoys swimming and values work-life balance. Budget-conscious but willing to invest in health."
改造后:
{
  "persona_id": "P_HUB_001",
  "name": "注重健康的程序员",
  "source": "persona_hub_adapted",
  "system": "jianengliang",
  "dimensions": {
    "user_type": "上班族",
    "price_sensitivity": "medium",
    "preferred_scenes": ["游泳"],
    "active_hours": "evening",
    "consumption_frequency": "medium",
    "registration_channel": "android",
    "lifecycle_stage": "mature",
    "id_verification_status": "verified"
  },
  "behavior_probabilities": {
    "use_coupon": 0.55,
    "bind_wechat": 0.70,
    "add_ticket_person": 0.20,
    "accumulate_points": 0.75,
    "use_time_card": 0.40,
    "complete_id_check": 0.70,
    "complete_health_check": 0.45
  },
  "typical_order_types": ["游泳票"],
  "avg_monthly_orders": 5,
  "avg_order_amount_range": [50, 120],
  "dirty_data_probability": 0.02,
  "notes": "从原 Persona 的'enjoys swimming'和'budget-conscious'推导"
}
"""
```


### 4.4 Prompt C：层一行为决策

```
# prompts/behavior_decision.txt

[SYSTEM]
你是一个文体消费行为模拟专家。你的任务是代入给定的用户Persona角色，
在指定场景下做出真实合理的消费行为决策。

要求：
1. 在输出JSON的 "reasoning" 字段中写出你的思维链推理过程
2. 推理过程中要考虑：Persona的价格敏感度、偏好、活跃时段、生命周期
3. 决策必须与Persona的行为概率矩阵一致（高概率行为更易发生）
4. 输出JSON中的枚举值必须使用数字编码（如sex=1，而非"男"）
5. 时间字段格式：YYYY-MM-DD HH:MM:SS，时间要符合Persona的活跃时段
6. 只输出一个完整的JSON对象，不要包含任何JSON以外的文字

[USER]
请基于以下信息生成一条行为决策：

【Persona信息】：
<<PERSONA_JSON>>

【场景描述】：<<SCENARIO_DESCRIPTION>>
（如：周末下午购买游泳票、工作日晚上订羽毛球场、节假日参加赛事等）

【可用字典数据摘要】：
场馆列表：<<AVAILABLE_VENUES>>
可用优惠券：<<AVAILABLE_COUPONS>>
可用时间卡：<<AVAILABLE_TIME_CARDS>>
运动类型：<<AVAILABLE_SPORTS>>

【模拟日期范围】：<<DATE_RANGE>>
（如：2026-01-01 至 2026-06-30，在此范围内选择合理的下单时间）

{
  "reasoning": "1.Persona分析：该用户是[用户类型]，价格敏感度[高/中/低]，通常在[时段]活跃... 2.场景匹配：[场景]符合偏好[是/否]... 3.行为决策：use_coupon概率<<USE_COUPON_PROB>>，[会/不会]使用优惠券...",
  "decision_id": "D<<TIMESTAMP>>_<<PERSONA_ID>>",
  "persona_id": "<<PERSONA_ID>>",
  "scenario": "<<SCENARIO_KEY>>",
  "simulation_date": "<<SELECTED_DATE>>",
  "actions": {
    "select_venue": {
      "venue_id": "<<VENUE_ID>>",
      "venue_name": "<<VENUE_NAME>>"
    },
    "order_type": <1套餐|2订场|3游泳票|4商品|5演艺|6赛事>,
    "ticket_type": <1成人|2一大一小|3两大一小|null>,
    "quantity": <购买数量>,
    "select_sport": {
      "sport_id": "<<SPORT_ID>>",
      "sport_name": "<<SPORT_NAME>>"
    },
    "use_coupon": <true|false>,
    "coupon_code_id": <优惠券模板ID|null>,
    "payment_method": <1支付宝|2微信|3小程序>,
    "order_time": "<<YYYY-MM-DD HH:MM:SS>>",
    "complete_payment": <true|false>,
    "pay_time_offset_minutes": <0-30，完成支付距下单的分钟数，未支付则null>,
    "add_ticket_people": <true|false>,
    "ticket_people_count": <0-4>,
    "use_time_card": <true|false>,
    "time_card_id": <时间卡ID|null>,
    "special_behavior": <null|"abandon_payment"|"refund_request"|"expired_coupon">
  },
  "estimated_cost": <订单原价，小数点2位>,
  "estimated_discount": <优惠金额，无优惠则0>,
  "estimated_pay_amount": <实际支付金额>
}
```

### 4.5 Prompt D：层二字段翻译

```
# prompts/field_translate.txt

[SYSTEM]
你是一个数据库记录生成专家。你的任务是将行为决策JSON转换为
具体的数据库表字段值，可以直接用于INSERT语句。

核心要求：
1. 所有枚举字段必须使用数字编码，不能使用中文或英文字符串
   - sex: 0不明/1男/2女
   - pay_way（VARCHAR）: "1"支付宝/"2"微信/"3"小程序
   - order.type: 1套餐/2订场/3游泳票/4商品/5演艺/6赛事
   - order.status（VARCHAR，订场/游泳票）: "0"待支付/"2"已支付待使用/"3"未支付超时/"4"已支付已使用/"5"已支付过期/"6"已退款/"7"已评价/"8"用户取消；商品/演艺/赛事订单用"30"-"42"（见§5.1）
   - ticket.status: 0未用/1已用/2已过期
   - ticket_type: 1成人/2一大一小/3两大一小
   - member.source: 1安卓/2iOS/3小程序/4后台
   - id_card_check: 1未校验/2已校验/3过期/4禁用
   - report_check: 1未上传/2审核中/3已通过/4已拒绝/5已过期/6已禁用
   - coupon.status: 1未使用/2已使用
2. 手机号格式：11位数字，以1开头，真实的手机号段（130-139,150-159,180-189等）
3. 身份证号格式：18位，前6位为真实地区码（广东省：440xxx），后12位合理
4. 订单号格式：JN+14位时间戳+3位序号（如JN20260802143001001）
5. 票号格式：TK+14位时间戳+4位序号
6. trade_no（第三方支付流水号）：支付宝16位数字，微信32位字符串
7. 时间字段：pay_time必须晚于create_time，use_time必须晚于order_time
8. 金额计算：pay_amount = cost - discount_amount，service_charge通常为0

[USER]
请将以下行为决策转换为数据库记录：

【行为决策】：
<<BEHAVIOR_DECISION_JSON>>

【目标表Schema】：
<<TARGET_TABLE_SCHEMAS>>

【用户上下文】（已存在的用户数据，用于保持外键一致性）：
<<USER_CONTEXT>>
（包含：member_id, phone, venue_id, existing_card_ids等）

【全局序号计数器】：
- 当前最大 member_id: <<MAX_MEMBER_ID>>
- 当前最大 order id: <<MAX_ORDER_ID>>
- 当前 order_num 序号: <<ORDER_SEQ>>

【业务规则补充】：
<<EXTRA_BUSINESS_RULES>>

请输出以下目标表的记录JSON（只输出需要生成的表，不需要生成的表不要包含）：

{
  "j_member": {
    "id": <BIGINT>,
    "phone": "<11位手机号>",
    "nick_name": "<昵称，2-8个中文字符>",
    "birthday": "<YYYY-MM-DD，符合age字段>",
    "age": <整数，由birthday计算>,
    "province": "<省份>",
    "city": "<城市>",
    "area": "<区县>",
    "sex": <0|1|2>,
    "rank": <0-4，角色类型：0普通会员/1场馆管理员/2培训机构管理员/3商户管理员/4系统平台管理员，C端模拟数据绝大多数应为0>,
    "is_blacklist": <0|1>,
    "source": <1|2|3|4>,
    "is_vip": <0|1>,
    "venue_id": "<venue_id>",
    "member_rate": <0.0-5.0>,
    "content_rate": <0.0-5.0>,
    "member_status": <1|2>,
    "id_card": "<18位身份证号>",
    "user_name": "<真实姓名，2-4个汉字>",
    "id_card_check": <1|2|3|4>,
    "report_check": <1|2|3|4|5|6>
  },
  "j_member_order": {
    "id": <BIGINT>,
    "user_id": <j_member.id>,
    "phone": "<同j_member.phone>",
    "venue_id": "<venue_id>",
    "sport_id": "<sport_id>",
    "order_num": "<JN+14位时间戳+3位序号>",
    "trade_no": "<第三方支付流水号|null>",
    "type": <VARCHAR，订单类型："1"套餐/"2"订场/"3"游泳票/"4"商品/"5"演艺/"6"赛事/"7"-"10"自营/找课程>,
    "cost": <原价，精确到分>,
    "discount_amount": <优惠金额>,
    "pay_amount": <实付金额>,
    "service_charge": <服务费，通常0>,
    "status": <VARCHAR，订场/游泳票用"0"/"2"/"3"/"4"/"5"/"6"/"7"/"8"，商品/演艺/赛事用"30"-"42">,
    "pay_way": <VARCHAR，"1"支付宝/"2"微信/"3"小程序，未支付时null>,
    "pay_time": "<YYYY-MM-DD HH:MM:SS|null>",
    "create_time": "<YYYY-MM-DD HH:MM:SS>",
    "order_time": "<同create_time>",
    "is_pay": <0|1>,
    "is_refund": <0|1>,
    "merchant_id": "<merchant_id>"
  },
  "j_order_ticket": {
    "id": <BIGINT>,
    "order_num": "<同j_member_order.order_num>",
    "ticket_num": "<TK+14位时间戳+4位序号>",
    "user_id": <j_member.id>,
    "card_id": <时间卡ID|null>,
    "ticket_name": "<票名称>",
    "type": <订单类型>,
    "ticket_type": <1|2|3>,
    "venue_id": "<venue_id>",
    "status": <0|1|2>,
    "expire_time": "<YYYY-MM-DD HH:MM:SS，通常create_time+7天>",
    "remain_num": <剩余次数，初始等于quantity>,
    "price": <票价>,
    "service_charge": <0.0>,
    "deducted_amount": <时间卡抵扣金额|0>
  }
}
```

### 4.6 Prompt E：质量语义审查

```
# prompts/quality_check.txt

[SYSTEM]
你是一个数据质量审查专家（LLM-as-judge）。你的任务是检查一批模拟生成的
数据库记录，找出语义上不合理的问题。

你不需要检查格式问题（由代码校验），重点关注：
1. 时序逻辑：时间字段的先后顺序是否合理
2. 金额逻辑：优惠后的价格是否低于原价；pay_amount是否正确计算
3. 状态一致性：is_pay与status是否一致；is_refund与status是否一致
4. 业务逻辑：票务人数量与ticket_type是否匹配；
   is_blacklist=1的用户是否还有未取消的订单等
5. 枚举值合理性：sex分布是否偏态（如全为1）；
   source分布是否符合业务特征
6. 跨表一致性：order_num在关联表中是否存在；
   ticket_num在核销记录中引用是否存在于j_order_ticket

[USER]
请审查以下批次的模拟数据记录，找出语义不合理的问题：

【批次ID】：<<BATCH_ID>>

【待审查记录】：
<<RECORDS_JSON>>
（格式：{ "table_name": [record1, record2, ...], ... }）

【业务规则摘要】：
<<BUSINESS_RULES_SUMMARY>>

请输出以下格式的审查报告（JSON）：

{
  "batch_id": "<<BATCH_ID>>",
  "total_records": <总记录数>,
  "issues_found": <发现的问题数>,
  "pass_rate": <0.0-1.0>,
  "issues": [
    {
      "issue_id": "Q001",
      "severity": "critical|warning|info",
      "table": "<表名>",
      "record_index": <记录在批次中的索引>,
      "field": "<问题字段名>",
      "actual_value": "<实际值>",
      "expected_or_reason": "<期望值或问题说明>",
      "suggestion": "<修复建议>"
    }
  ],
  "statistics": {
    "sex_distribution": {"0": 0, "1": 0, "2": 0},
    "source_distribution": {"1": 0, "2": 0, "3": 0, "4": 0},
    "order_status_distribution": {"0": 0, "1": 0, "2": 0, "3": 0, "4": 0},
    "avg_pay_amount": 0.0,
    "payment_method_distribution": {"1": 0, "2": 0, "3": 0}
  },
  "summary": "<整体质量说明>"
}

**关注重点（必查）**：
- pay_time < create_time（时间倒序，critical）
- status=2但is_pay=0（状态矛盾，critical）
- pay_amount > cost（付款超过原价，critical）
- discount_amount + pay_amount != cost（金额不平衡，warning）
- expire_time < create_time（票已过期但刚生成，warning）
- ticket_type=2但buy_ticket_people只有1条记录（数量不符，warning）
```

---

## 5. 字段映射规则

### 5.1 全局枚举字典

| 枚举分组 | 字段 | 值 | 含义 |
|---------|------|-----|------|
| sex | j_member.sex, t_student.sex | 0 | 性别不明 |
| sex | j_member.sex, t_student.sex | 1 | 男 |
| sex | j_member.sex, t_student.sex | 2 | 女 |
| pay_way | j_member_order.pay_way（VARCHAR(12)） | 1 | 支付宝 |
| pay_way | 同上 | 2 | 微信 |
| pay_way | 同上 | 3 | 小程序 |
| source | j_member.source, t_student.source | 1 | 安卓/后台录入 |
| source | 同上 | 2 | iOS |
| source | 同上 | 3 | 小程序 |
| source | 同上 | 4 | 后台人工录入 |
| member_status | j_member.member_status | 1 | 正常 |
| member_status | 同上 | 2 | 封禁 |
| id_card_check | j_member.id_card_check | 1 | 未校验 |
| id_card_check | 同上 | 2 | 已校验 |
| id_card_check | 同上 | 3 | 过期 |
| id_card_check | 同上 | 4 | 禁用 |
| report_check | j_member.report_check | 1 | 未上传 |
| report_check | 同上 | 2 | 审核中 |
| report_check | 同上 | 3 | 已通过 |
| report_check | 同上 | 4 | 已拒绝 |
| report_check | 同上 | 5 | 已过期 |
| report_check | 同上 | 6 | 已禁用 |
| order_status | j_member_order.status（VARCHAR(50)，订场/游泳票） | 0 | 待支付 |
| order_status | 同上 | 2 | 已支付，待使用 |
| order_status | 同上 | 3 | 未支付，支付超时 |
| order_status | 同上 | 4 | 已支付已使用，待评价 |
| order_status | 同上 | 5 | 已支付未使用，已过期 |
| order_status | 同上 | 6 | 已退款 |
| order_status | 同上 | 7 | 已评价 |
| order_status | 同上 | 8 | 用户取消订单 |
| order_status | j_member_order.status（VARCHAR(50)，商品/演艺票/赛事票） | 30 | 已下单待支付 |
| order_status | 同上 | 31 | 已取消 |
| order_status | 同上 | 32 | 支付超时 |
| order_status | 同上 | 33 | 已支付待发货 |
| order_status | 同上 | 34 | 已支付待自取 |
| order_status | 同上 | 35 | 已发货待收货 |
| order_status | 同上 | 36 | 已收货待评价 |
| order_status | 同上 | 37 | 已取票待评价 |
| order_status | 同上 | 38 | 退款中 |
| order_status | 同上 | 39 | 退款成功 |
| order_status | 同上 | 40 | 退款失败 |
| order_status | 同上 | 41 | 已完成 |
| order_status | 同上 | 42 | 关闭订单 |
| order_type | j_member_order.type（VARCHAR(50)） | 1 | 套餐 |
| order_type | 同上 | 2 | 订场 |
| order_type | 同上 | 3 | 游泳票 |
| order_type | 同上 | 4 | 商品 |
| order_type | 同上 | 5 | 演艺 |
| order_type | 同上 | 6 | 赛事 |
| order_type | 同上 | 7 | 自营演艺周边 |
| order_type | 同上 | 8 | 自营赛事周边 |
| order_type | 同上 | 9 | 自营其他商品 |
| order_type | 同上 | 10 | 找课程 |
| ticket_type | j_order_ticket.ticket_type | 1 | 成人票 |
| ticket_type | 同上 | 2 | 一大一小 |
| ticket_type | 同上 | 3 | 两大一小 |
| ticket_status | j_order_ticket.status | 0 | 未使用 |
| ticket_status | 同上 | 1 | 已使用 |
| ticket_status | 同上 | 2 | 已过期 |
| coupon_status | j_coupon.status | 1 | 未使用 |
| coupon_status | 同上 | 2 | 已使用 |
| coupon_use_type | j_coupon.use_type | 0 | 未使用 |
| coupon_use_type | 同上 | 2 | 订场 |
| coupon_use_type | 同上 | 3 | 游泳票 |
| coupon_use_type | 同上 | 4 | 渠道 |
| coupon_use_type | 同上 | 5 | 演艺 |
| coupon_use_type | 同上 | 6 | 赛事 |
| time_card_status | j_member_time_card.status | 0 | 待激活 |
| time_card_status | 同上 | 1 | 已激活 |
| time_card_status | 同上 | 2 | 已过期 |
| time_card_use_status | j_time_card_use.status | 0 | 未抵扣 |
| time_card_use_status | 同上 | 1 | 已抵扣 |
| m_order_status | m_trade_order.order_status | PAYING | 支付中 |
| m_order_status | 同上 | PAID_FIELD | 已支付场地 |
| m_order_status | 同上 | PAY_CLOSE | 支付关闭 |
| m_order_status | 同上 | CANCEL | 已取消 |
| m_order_status | 同上 | FINISHED | 已完成 |
| m_order_status | 同上 | REFUNDED | 已退款 |
| m_order_status | 同上 | REFUNDING | 退款中 |
| course_status | m_trade_order_course.course_status | 0 | 已完成 |
| course_status | 同上 | 1 | 进行中 |
| student_status | t_student.status | 1 | 正常 |
| student_status | 同上 | 2 | 禁用 |
| class_sale_status | t_class.sale_status | 0 | 下架 |
| class_sale_status | 同上 | 1 | 上架 |
| order_course_status | m_trade_order_course.status | 0 | 待开始 |
| order_course_status | 同上 | 1 | 进行中 |
| order_course_status | 同上 | 2 | 已完成 |

> ⚠️ **字符串枚举例外**：`buy_ticket_people.sex` 字段在真实 DDL 中为 `VARCHAR(4)`，生成时使用字符串值 `"男"/"女"/"未知"`，而非整数编码。Prompt D 在翻译 `buy_ticket_people` 记录时需单独处理此字段，不得套用上表整数枚举。

> ⚠️ **m_trade_order.pay_way 字符串枚举**：`m_trade_order.pay_way` 为 `VARCHAR(20)` 类型，枚举值为字符串 `ALIPAY/WECHAT/MINIPROGRAM`，与 `j_member_order.pay_way` 的整数枚举（1/2/3）完全不同。Prompt D 翻译 training 系统订单时须使用字符串值，不得使用整数编码。


### 5.2 业务编号生成规则

#### order_num（订单号）

**格式**：`{系统前缀}{14位时间戳}{3位序号}`

- jianengliang：`JN20260802143001001`
- training：`TR20260802143001001`

```python
import datetime
from threading import Lock

class OrderNumGenerator:
    """线程安全的订单号生成器"""
    _lock = Lock()
    _seq = {}

    @classmethod
    def generate(cls, prefix: str = "JN") -> str:
        with cls._lock:
            ts = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
            key = f"{prefix}_{ts}"
            if key not in cls._seq:
                cls._seq[key] = 1
            else:
                cls._seq[key] += 1
            seq = cls._seq[key]
            return f"{prefix}{ts}{seq:03d}"
```

#### ticket_num（票号）

**格式**：`TK{yyyyMMddHHmmss}{4位序号}`

```python
def generate_ticket_num(create_time, seq: int) -> str:
    ts = create_time.strftime("%Y%m%d%H%M%S")
    return f"TK{ts}{seq:04d}"
```

#### student_code（学员编号）

**格式**：`STU{venue_short}{yyyyMM}{4位序号}`

```python
def generate_student_code(venue_id: str, register_date, seq: int) -> str:
    venue_short = venue_id.replace("V", "").zfill(3)
    ym = register_date.strftime("%Y%m")
    return f"STU{venue_short}{ym}{seq:04d}"
```

#### id（自增主键起始值建议）

| 表名 | 建议起始值 |
|------|-----------|
| j_member.id | 10001 |
| j_member_order.id | 50001 |
| j_order_ticket.id | 80001 |
| j_coupon.id | 30001 |
| t_student.id | 10001 |
| m_trade_order.id | 50001 |

### 5.3 jianengliang 核心链路字段映射

#### j_member（会员表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增，起始10001 | 主键 |
| phone | VARCHAR(20) | Faker生成11位手机号（1[3-9]xxxxxxxxx） | 非空，唯一 |
| nick_name | VARCHAR(100) | LLM生成中文昵称或Faker | 可为NULL |
| birthday | DATE | 根据user_type：学生(2000-2006)、上班族(1985-1998)、老人(1950-1968) | 可为NULL |
| age | INT | 由birthday计算 | 可为NULL |
| province | VARCHAR(50) | 广东省(80%)、其他(20%) | 可为NULL |
| city | VARCHAR(50) | 深圳市(60%)、广州市(20%)、其他(20%) | 可为NULL |
| area | VARCHAR(50) | 深圳：南山/福田/宝安/龙华/龙岗/罗湖 | 可为NULL |
| sex | TINYINT | 1男(55%)、2女(40%)、0不明(5%) | 可为NULL |
| rank | INT | 角色类型：0普通会员，1场馆管理员，2培训机构管理员，3商户管理员，4系统平台管理员（⚠️非VIP等级，VIP由is_vip/jwh_vip控制） | 默认0 |
| is_blacklist | TINYINT | 正常=0，特殊Persona小概率=1 | 默认0 |
| source | TINYINT | 依Persona.registration_channel | 非空 |
| is_vip | TINYINT | Persona `price_sensitivity=low` 且 `lifecycle_stage=mature` 的高净值条目=1，其余=0 | 默认0 |
| venue_id | VARCHAR(50) | 从dict_venues随机选择 | 非空 |
| member_rate | DECIMAL(3,1) | 随机0.0-5.0 | 默认0 |
| content_rate | DECIMAL(3,1) | 随机0.0-5.0 | 默认0 |
| member_status | TINYINT | 正常=1，封禁=2 | 默认1 |
| id_card | VARCHAR(20) | 规则生成18位身份证号 | 可为NULL |
| user_name | VARCHAR(50) | Faker中文姓名（2-4字） | 可为NULL |
| id_card_check | TINYINT | 依Persona.id_verification_status | 默认1 |
| report_check | TINYINT | 依Persona.complete_health_check概率 | 默认1 |
| extract_time | DATETIME | 固定为数据生成时的当前时间 | 非空 |
| password | VARCHAR | 固定NULL（不模拟真实密码，见1.3节非目标） | 可为NULL |
| avatar | VARCHAR | 固定NULL（不生成二进制资源） | 可为NULL |
| is_audit | INT | 0未审核；id_card_check=2时=1 | 可为NULL |
| login_num | INT | mature用户50-200，growing用户5-50，new_user用户1-5 | 可为NULL |
| last_login_time | DATETIME | 最后一笔订单时间 ± 随机0-7天内 | 可为NULL |
| energy_volume_num | INT | 随机0-10 | 可为NULL |
| depart_discount_num | INT | 随机0-5 | 可为NULL |
| guess_status | INT | 固定0 | 可为NULL |
| default_image_index | INT | 随机0-9 | 可为NULL |
| register_source | VARCHAR | 与venue_id相同（注册时所在子场馆） | 可为NULL |
| signature | VARCHAR | 固定NULL | 可为NULL |
| jwh_vip | INT | VIP/企业类 Persona（`user_type` 含"高净值"或"企业"）=1，expired用户=2，其余=0（与is_vip含义不同：0否/1是/2已过期） | 非空 |
| mini_qrcode | VARCHAR | 固定NULL | 可为NULL |
| id_card_create_time | DATETIME | id_card_check≥2时有值，= create_time + 随机1-30天 | 可为NULL |
| report_create_time | DATETIME | report_check≥2时有值，= create_time + 随机1-60天 | 可为NULL |
| id_card_expire_date | DATETIME | id_card_check=2时 = create_time + 3年；check=3时为过去时间 | 可为NULL |
| report_expire_date | DATETIME | report_check=3时 = report_create_time + 1年 | 可为NULL |
| child_check | INT | 亲子类 Persona（`add_ticket_person>=0.90`）：1-4枚举（同id_card_check）；其余NULL | 可为NULL |
| child_check_expire_date | DATETIME | 亲子类 Persona 有值；其余NULL | 可为NULL |
| child_id_card | VARCHAR | 亲子类 Persona：儿童身份证号；其余NULL | 可为NULL |
| child_birthday | VARCHAR | 亲子类 Persona：儿童生日（YYYY-MM-DD）；其余NULL | 可为NULL |

> ⚠️ `is_vip` 与 `jwh_vip` 含义不同：`is_vip`（0不是/1子场馆关联/2个人加V），`jwh_vip`（0否/1是/2已过期），生成时需分别处理，不可混用。

#### j_member_order（订单表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增，起始50001 | 主键 |
| user_id | BIGINT | 关联j_member.id | 外键 |
| phone | VARCHAR(20) | 同j_member.phone | 非空 |
| venue_id | VARCHAR(50) | 从dict_venues选择 | 非空 |
| sport_id | VARCHAR(50) | 根据order.type选择对应运动类型 | 可为NULL |
| order_num | VARCHAR(50) | 格式：JN+14位时间戳+3位序号 | 唯一 |
| trade_no | VARCHAR(50) | 支付宝16位/微信32位，未支付=NULL | 可为NULL |
| type | VARCHAR(50) | 依Persona.typical_order_types，见§5.1 order_type 枚举（1-10） | 非空 |
| cost | DECIMAL(20,2) | LLM生成或公式计算 | 非空 |
| discount_amount | DECIMAL(20,2) | 使用优惠券时>0，否则=0 | 默认0 |
| deducted_card_type | VARCHAR(100) | 使用专项卡时填写（2011储值卡/2012储值专项/202次卡），否则NULL | 可为NULL |
| deducted_amount | DECIMAL(20,2) | 专项卡已抵扣金额，默认0 | 非空，默认0 |
| share_deducted_amount | DECIMAL(20,2) | 分摊剩余抵扣金额，默认0 | 非空，默认0 |
| pay_amount | DECIMAL(20,2) | cost - discount_amount - deducted_amount | 非空 |
| service_charge | DECIMAL(10,2) | 通常=0 | 非空，默认0 |
| status | VARCHAR(50) | 订场/游泳票：0/2/3/4/5/6/7/8；商品/演艺/赛事：30-42（高脏数据类 Persona `dirty_data_probability>=0.10`=0，正常完成=2或4） | 非空 |
| pay_way | VARCHAR(12) | "1"支付宝/"2"微信/"3"小程序，未支付=NULL | 可为NULL |
| pay_time | DATETIME | status为2/4/5/6/7/33-41时=create_time+随机3-30分钟 | 可为NULL |
| create_time | DATETIME | LLM生成的order_time | 非空 |
| order_time | DATETIME | 订场成功时间，通常同create_time | 可为NULL |
| is_pay | TINYINT | status为已支付类时=1，否则=0 | 非空，默认0 |
| is_refund | TINYINT | 退款型脏数据 Persona 或 status=6/39时=1 | 非空，默认0 |
| is_send | TINYINT | type=4商品订单已发货时=1，否则=0 | 非空，默认0 |
| handle | TINYINT | 是否已统计报表，默认0（生成时固定填0） | 非空，默认0 |
| is_new | TINYINT | 1新订单/0旧订单，模拟数据统一填1 | 非空，默认1 |
| merchant_id | INT | 从dict_merchants选择 | 可为NULL |
| used_points | INT | 使用积分数量，不使用积分时=NULL | 可为NULL |
| consignee | VARCHAR(64) | type=4商品订单收货人，其余NULL | 可为NULL |
| consignee_phone | VARCHAR(20) | type=4商品订单收货人电话，其余NULL | 可为NULL |
| address | VARCHAR(500) | type=4商品订单收货地址，其余NULL | 可为NULL |
| take_way | INT | type=4时：0快递/1自取/2电子票，其余NULL | 可为NULL |
| sys_remark | VARCHAR(3000) | 后台备注，默认NULL | 可为NULL |
| channel_discount | DECIMAL(10,2) | 渠道优惠，默认NULL | 可为NULL |
| commission | DECIMAL(10,2) | 手续费，默认NULL | 可为NULL |

#### j_order_ticket（游泳票明细表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增，起始80001 | 主键 |
| order_num | VARCHAR(50) | 关联j_member_order.order_num | 外键 |
| ticket_num | VARCHAR(50) | TK+14位时间戳+4位序号 | 唯一 |
| user_id | BIGINT | 同j_member_order.user_id | 非空 |
| card_id | BIGINT | 使用时间卡时=j_member_time_card.id | 可为NULL |
| ticket_name | VARCHAR(100) | 如"成人游泳票"、"亲子票" | 非空 |
| type | TINYINT | 同j_member_order.type | 非空 |
| ticket_type | TINYINT | 1成人/2一大一小/3两大一小 | 非空 |
| venue_id | VARCHAR(50) | 同j_member_order.venue_id | 非空 |
| status | TINYINT | 0未用/1已用/2已过期 | 默认0 |
| expire_time | DATETIME | create_time + 7天 | 非空 |
| remain_num | — | 当前 jianengliang DDL 未定义该字段 | 不得按旧规划直接生成；P2-0 核实剩余次数/额度的真实承载方式 |
| price | DECIMAL(10,2) | 同j_member_order.pay_amount | 非空 |
| service_charge | DECIMAL(10,2) | 通常=0 | 默认0 |
| deducted_amount | DECIMAL(10,2) | 时间卡抵扣金额 | 默认0 |

### 5.4 training 核心链路字段映射

#### t_student（培训学员表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增，起始10001 | 主键 |
| merchant_id | VARCHAR(50) | 从dict_merchants选择 | 非空 |
| venue_id | VARCHAR(50) | 从dict_venues选择 | 非空 |
| name | VARCHAR(50) | Faker中文姓名 | 非空 |
| phone | VARCHAR(20) | Faker手机号；`system="cross_system"` Persona 与 j_member.phone 保持一致 | 非空 |
| id_card | VARCHAR(20) | 18位身份证号；未成年人需合理的出生年份 | 可为NULL |
| student_code | VARCHAR(50) | STU+venue_short+yyyyMM+4位序号 | 唯一 |
| card_id | BIGINT | 可选：关联会员卡 | 可为NULL |
| sex | TINYINT | 枚举随机1/2/0 | 可为NULL |
| birthday | DATE | 青少年类 Persona（`user_type=青少年/儿童`）<2010年；成人类 Persona 1980-2005年 | 可为NULL |
| age | INT | 由birthday计算 | 可为NULL |
| address | VARCHAR(200) | 详细地址（省市区+街道） | 可为NULL |
| province_id | INT | 广东省=44 | 可为NULL |
| city_id | INT | 深圳市=4403 | 可为NULL |
| area_id | INT | 南山区=440305等 | 可为NULL |
| source | TINYINT | 1后台/2C端，依Persona.registration_channel | 非空 |
| status | TINYINT | 正常=1，禁用=2 | 默认1 |
| first_come | DATE | 注册日期（历史日期） | 可为NULL |
| is_deleted | TINYINT | 0未删除/1已删除，默认=0 | 默认0 |

#### t_class（培训课程表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增，起始1001 | 主键 |
| merchant_id | VARCHAR(50) | 从dict_merchants选择 | 非空 |
| venue_id | VARCHAR(50) | 从dict_venues选择 | 非空 |
| name | VARCHAR(100) | LLM生成课程名称（如"少儿游泳A班"、"成人羽毛球提高班"） | 非空 |
| course_id | BIGINT | 关联课程模板（字典表） | 非空 |
| class_type | INT | 1个人课/2团体课/3精英班 | 非空 |
| class_code | VARCHAR(50) | 班级编号，CLASS+4位序号 | 唯一 |
| sport_id | VARCHAR(50) | 从dict_sports选择 | 非空 |
| class_hour | INT | 课时数：10/20/30/40/60课时 | 非空 |
| reserve_enable | TINYINT | 是否可预约：0/1 | 默认1 |
| reserve_people | INT | 最大预约人数：1-30 | 可为NULL |
| status | TINYINT | 状态：0下架/1上架 | 默认1 |
| sale_status | TINYINT | 销售状态：0下架/1上架 | 默认1 |

#### t_class_teacher（课程教练表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增，起始2001 | 主键 |
| class_id | BIGINT | 关联t_class.id | 外键 |
| teacher_id | BIGINT | 教练ID（字典数据，t_teacher表） | 外键 |
| taught_class_hour | INT | 已教课时，初始=0 | 默认0 |
| commission_type | INT | 提成类型：1固定/2比例 | 非空 |
| commission_amount | DECIMAL(10,2) | 每课时固定提成（commission_type=1时有值） | 可为NULL |
| group_commission_amount | DECIMAL(10,2) | 团体课提成金额 | 可为NULL |
| group_commission_type | INT | 团体课提成类型：1固定/2比例 | 可为NULL |

#### m_trade_order（培训订单主表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增，起始50001 | 主键 |
| order_num | VARCHAR(50) | TR+14位时间戳+3位序号 | 唯一 |
| order_type | VARCHAR(50) | COURSE/SINGLE_COURSE | 非空 |
| customer_phone | VARCHAR(20) | 同t_student.phone | 非空 |
| customer_name | VARCHAR(50) | 同t_student.name | 非空 |
| student_id | BIGINT | 关联t_student.id | 外键 |
| order_time | DATETIME | 历史日期，依Persona活跃时段 | 非空 |
| order_amount | DECIMAL(10,2) | 课程原价 | 非空 |
| merchant_discount | DECIMAL(10,2) | 商户优惠金额，企业客户类 Persona（`user_type=企业客户`）较高 | 默认0 |
| landlord_discount | DECIMAL(10,2) | 场地优惠金额 | 默认0 |
| pay_amount | DECIMAL(10,2) | order_amount - merchant_discount - landlord_discount | 非空 |
| order_status | VARCHAR(20) | 依Persona：正常=FINISHED；退课频繁类 Persona（`dirty_data_probability>=0.15`）=REFUNDED/REFUNDING | 非空 |
| pay_way | VARCHAR(20) | ALIPAY/WECHAT/MINIPROGRAM | 可为NULL |
| pay_time | DATETIME | FINISHED时=order_time+随机3-20分钟 | 可为NULL |
| venue_id | VARCHAR(50) | 同t_student.venue_id | 非空 |
| venue_name | VARCHAR(100) | 对应venue_id的名称 | 可为NULL |
| mechant_id | VARCHAR(50) | 从dict_merchants选择（注意原字段名拼写） | 非空 |
| sex | TINYINT | 同t_student.sex | 可为NULL |
| sickness | VARCHAR(200) | 青少年类 Persona：可能有健康信息备注 | 可为NULL |
| id_card | VARCHAR(20) | 同t_student.id_card | 可为NULL |
| commission_amount | DECIMAL(10,2) | 教练提成金额 | 可为NULL |
| commission_percent | DECIMAL(5,2) | 教练提成比例（0-100） | 可为NULL |
| is_jwh_vip | TINYINT | 企业客户类 Persona（`user_type=企业客户`）=1，其余=0 | 默认0 |

#### m_trade_order_course（培训课程明细表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增，起始70001 | 主键 |
| order_num | VARCHAR(50) | 关联m_trade_order.order_num | 外键 |
| student_id | BIGINT | 关联t_student.id | 外键 |
| course_id | BIGINT | 关联课程字典 | 外键 |
| spec_id | BIGINT | 课程规格ID | 外键 |
| course_name | VARCHAR(100) | 课程名称（同t_class.name） | 非空 |
| spec_name | VARCHAR(100) | 规格名（如"30课时包"） | 非空 |
| num | INT | 购买数量，通常=1 | 默认1 |
| status | INT | 0待开始/1进行中/2已完成 | 非空 |
| ori_amount | DECIMAL(10,2) | 原价 | 非空 |
| discount | DECIMAL(10,2) | 优惠金额 | 默认0 |
| amount | DECIMAL(10,2) | 实付金额 | 非空 |
| total_class_hour | INT | 总课时 | 非空 |
| remain_class_hour | INT | 剩余课时（初始=total_class_hour，每次上课-1） | 非空 |
| remain_amount | DECIMAL(10,2) | 剩余金额 | 可为NULL |
| valid_days | INT | 课程有效天数（如360天） | 可为NULL |
| start_date | DATE | 开课日期 | 可为NULL |
| end_date | DATE | 结课日期（start_date + valid_days） | 可为NULL |
| course_status | TINYINT | 1进行中/0已完成；退课脏数据类 Persona 反常情况：0但remain_class_hour>0 | 非空 |

#### m_trade_order_detail（培训订单详情表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | BIGINT | 自增 | 主键 |
| order_num | VARCHAR(50) | 关联m_trade_order.order_num | 外键 |
| item_id | BIGINT | 商品/课程ID | 非空 |
| item_name | VARCHAR(100) | 同course_name | 非空 |
| quantity | INT | 数量，通常=1 | 默认1 |
| price | DECIMAL(10,2) | 单价 | 非空 |
| merchant_discount | DECIMAL(10,2) | 商户折扣 | 默认0 |
| landlord_discount | DECIMAL(10,2) | 场地折扣 | 默认0 |
| due_amount | DECIMAL(10,2) | 应付金额（含折扣） | 非空 |
| amount | DECIMAL(10,2) | 实付金额 | 非空 |

### 5.5 vmdb 核心链路字段映射

> ✅ **表名已核实**（2026-08-10）：本节所有表名均已对照 `ods_wenti_starrocks.sql` 确认，使用真实 DDL 表名。vmdb 场馆配置不是独立表，场馆维度直接复用 `dict_venues` 字典数据。

#### ods_wenti_vmdb_h_member（vmdb会员信息表）

> vmdb 有独立的会员体系，与 jianengliang.j_member 通过 phone 关联，但字段结构不同，需单独生成。

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | INT | 自增，起始20001 | 主键 |
| name | VARCHAR(30) | Faker中文姓名 | 非空 |
| sex | INT | 0女/1男（注意：vmdb性别编码与jianengliang相反，DDL注释"0女1男"） | 可为NULL |
| phone | VARCHAR(20) | 复用 j_member.phone（vmdb 类 Persona `system="vmdb"` 对应用户） | 非空 |
| id_card | VARCHAR(100) | 18位身份证号 | 可为NULL |
| birthday | DATETIME | 根据Persona用户类型推算 | 可为NULL |
| venue_id | INT | 从dict_venues选择（注意此表venue_id为INT类型） | 非空 |
| merchant_id | INT | 从dict_merchants选择 | 非空 |
| create_user_id | INT | 固定填写操作员ID（字典数据，默认1） | 非空 |
| up_user_id | INT | 同create_user_id | 非空 |
| up_time | DATETIME | 同create_time | 非空 |
| create_time | DATETIME | 历史注册时间 | 非空 |
| is_deleted | TINYINT | 默认0（未删除） | 非空，默认0 |
| channel | INT | 1 pc / 2 app，依Persona.registration_channel | 默认1 |
| is_face_enable | TINYINT | 默认1（人脸可用） | 非空，默认1 |
| id_card_check | INT | 依Persona.id_verification_status | 默认1 |
| report_check | INT | 依Persona.complete_health_check概率 | 默认1 |
| urgent_name | VARCHAR(255) | 紧急联系人，默认空字符串 | 可为NULL |
| urgent_phone | VARCHAR(255) | 紧急联系人电话，默认空字符串 | 可为NULL |

#### ods_wenti_vmdb_h_member_card（会员专项卡表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | INT | 自增，起始30001 | 主键 |
| member_id | INT | 关联ods_wenti_vmdb_h_member.id | 非空 |
| balance | DECIMAL(10,2) | 余额/剩余次数（高频包月类 Persona `consumption_frequency=high` 月卡=NULL，其余依卡类型） | 可为NULL |
| present_balance | DECIMAL(10,2) | 赠送余额，默认0 | 默认0 |
| start_effect_date | DATETIME | 激活日期 | 非空 |
| end_effect_date | DATETIME | 过期日期（月卡=start+30天，季卡=start+90天） | 非空 |
| status | INT | 1正常/2停用/3过期 | 非空 |
| card_sales_id | INT | 售卡记录ID（字典数据，默认1） | 非空 |
| update_date | DATETIME | 同create_date | 非空 |
| create_date | DATETIME | 开卡时间 | 非空 |
| update_user_id | INT | 默认1 | 非空 |
| create_user_id | INT | 默认1 | 非空 |
| venue_id | INT | 从dict_venues选择 | 非空 |
| merchant_id | INT | 从dict_merchants选择 | 非空 |
| is_active | INT | 0未激活/1已激活，已生效卡=1 | 非空，默认0 |
| channel | INT | 1 pc / 2 app | 默认1 |
| owe_flag | TINYINT | 是否欠费，默认0 | 非空，默认0 |
| sluice_priority | TINYINT | 入闸优先级，默认0 | 非空，默认0 |

#### ods_wenti_vmdb_m_enter_gate（入闸记录）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | INT | 自增，起始40001 | 主键 |
| merchant_id | INT | 从dict_merchants选择 | 非空 |
| venue_id | INT | 从dict_venues选择 | 非空 |
| type | INT | 入闸卡类型：1单次卡/2次卡/3场次卡/4二维码/5时段卡/6管理卡 | 非空 |
| qr_code_type | INT | type=4时：1散票/2团体票/3通票；否则NULL | 可为NULL |
| card_name | VARCHAR(50) | 对应卡名称 | 可为NULL |
| item_id | INT | 关联对应卡/票的ID（如h_member_card.id） | 可为NULL |
| card_no | VARCHAR(50) | 卡号或二维码字符串 | 可为NULL |
| order_num | VARCHAR(50) | 关联订单号（二维码入闸时有值） | 可为NULL |
| gate_name | VARCHAR(50) | 闸机名称（如"1号闸"），字典数据 | 可为NULL |
| status | INT | 1正常/2已撤回，默认1 | 非空 |
| gmt_create | DATETIME | 入闸时间（依Persona活跃时段） | 非空 |
| gmt_updated | DATETIME | 同gmt_create | 非空 |

#### ods_wenti_vmdb_m_trade_order_ticket_verify（散票核销表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | INT | 自增 | 主键（依DDL待确认具体字段，执行前对照DDL补全） |

> ⚠️ `ods_wenti_vmdb_m_trade_order_ticket_verify` 的完整字段映射待补全，执行批次11前须对照DDL确认字段结构。

#### ods_wenti_vmdb_m_venue_customer（场馆顾客表）

| 字段名 | 数据类型 | 生成策略 | 约束说明 |
|--------|---------|---------|---------|
| id | INT | 自增 | 主键（依DDL待确认具体字段，执行前对照DDL补全） |

> ⚠️ `ods_wenti_vmdb_m_venue_customer` 的完整字段映射待补全，执行批次11前须对照DDL确认字段结构。

---

## 6. 脏数据注入规则

### 6.1 规则分类清单

总脏数据比例约5%，各规则独立触发（不叠加到同一行）。

| 规则ID | 类型 | 目标表 | 目标字段 | 触发比例 | 注入逻辑 | Python实现思路 |
|--------|------|--------|----------|----------|----------|----------------|
| D001 | 格式错误 | j_member | phone | 0.3% | 生成不合法手机号（如12开头/10位/含字母） | `random.choice(["1234567890", "abc1380013", "138001380"])` |
| D002 | 格式错误 | j_member | id_card | 0.2% | 生成错误身份证（位数不足/非数字结尾X以外字符） | `id_card[:-1] + "A"` 或截断为17位 |
| D003 | 格式错误 | t_student | phone | 0.3% | 同D001，针对培训学员 | 同D001 |
| D004 | 状态矛盾 | j_member_order | status+is_pay | 0.4% | status=2(已支付)但is_pay=0 | `record["status"]=2; record["is_pay"]=0` |
| D005 | 状态矛盾 | j_coupon | use_time+status | 0.3% | status=1(未使用)但use_time有值 | `record["status"]=1; record["use_time"]="2026-03-01 10:00:00"` |
| D006 | 状态矛盾 | j_order_ticket | status+expire_time | 0.3% | status=0(未用)但expire_time在create_time前 | `record["expire_time"] = record["create_time"] - timedelta(days=3)` |
| D007 | 时序异常 | j_member_order | pay_time+create_time | 0.5% | pay_time早于create_time（如提前3-30分钟） | `record["pay_time"] = record["create_time"] - timedelta(minutes=random.randint(3,30))` |
| D008 | 时序异常 | j_order_ticket_valid | valid_time+order_time | 0.3% | valid_time（核销时间）早于order_time（下单时间） | `record["valid_time"] = order_time - timedelta(hours=random.randint(1,24))` |
| D009 | 时序异常 | j_coupon | use_time+start_time | 0.2% | use_time早于start_time（在优惠券生效前使用） | `record["use_time"] = record["start_time"] - timedelta(days=1)` |
| D010 | 空值注入 | j_member | birthday+age | 0.5% | birthday有值但age=NULL，或birthday=NULL但age有值 | `record["age"] = None` |
| D011 | 空值注入 | j_member_order | pay_way | 0.4% | status=2(已支付)但pay_way=NULL | `record["pay_way"] = None` |
| D012 | 空值注入 | m_trade_order | pay_time | 0.3% | order_status=FINISHED但pay_time=NULL | `record["pay_time"] = None` |
| D013 | 金额异常 | j_member_order | discount_amount | 0.4% | discount_amount > cost（优惠超过原价） | `record["discount_amount"] = record["cost"] * random.uniform(1.1, 2.0)` |
| D014 | 金额异常 | j_member_order | pay_amount | 0.3% | pay_amount = 0但status=2(已支付) | `record["pay_amount"] = 0; record["status"] = 2` |
| D015 | 金额异常 | m_trade_order | pay_amount | 0.2% | pay_amount > order_amount（实付超过原价） | `record["pay_amount"] = record["order_amount"] * 1.1` |
| D016 | 重复数据 | j_member_order | order_num | 0.2% | 将某条记录的order_num与另一条重复 | 从已生成记录中选取一个order_num赋值给新记录 |
| D017 | 重复数据 | j_member | phone | 0.1% | 两条j_member记录有相同phone | 重复使用某个已生成的phone |
| D018 | 枚举越界 | j_member_order | type | 0.2% | type=99（无效枚举值） | `record["type"] = 99` |
| D019 | 安全测试 | 所有表 | remark/desc | 0%（默认禁用） | remark 注入 SQL 片段，仅在 `enable_injection_test: true` 时触发 | 需手动开启，防止污染正式输出文件 |

**实现框架**：

```python
# generators/dirty_injector.py 核心逻辑

import random
from typing import List, Dict, Any
from datetime import timedelta

class DirtyInjector:
    """
    脏数据注入器：对已生成的干净记录按规则随机注入脏数据。

    设计原则：
    - 每条规则独立触发，不叠加到同一行（同一记录只注入一条脏数据）
    - 总脏数据比例不超过5%
    - 注入后记录被标记 _is_dirty=True，方便后续统计
    """

    RULES = [
        {"id": "D001", "table": "j_member", "field": "phone", "rate": 0.003},
        {"id": "D002", "table": "j_member", "field": "id_card", "rate": 0.002},
        {"id": "D004", "table": "j_member_order", "field": "status+is_pay", "rate": 0.004},
        {"id": "D007", "table": "j_member_order", "field": "pay_time", "rate": 0.005},
        {"id": "D010", "table": "j_member", "field": "birthday+age", "rate": 0.005},
        {"id": "D013", "table": "j_member_order", "field": "discount_amount", "rate": 0.004},
        {"id": "D016", "table": "j_member_order", "field": "order_num", "rate": 0.002},
        # ... 其他规则
    ]

    def inject(self, records: Dict[str, List[Dict[str, Any]]]) -> Dict[str, List[Dict[str, Any]]]:
        """
        对批次记录注入脏数据。

        Args:
            records: {table_name: [record_dict, ...]}

        Returns:
            注入脏数据后的records，每条脏数据记录含 _is_dirty=True, _dirty_rule=rule_id
        """
        for table_name, table_records in records.items():
            dirty_injected = set()  # 记录已注入脏数据的记录索引

            for rule in self.RULES:
                if rule["table"] != table_name:
                    continue

                for i, record in enumerate(table_records):
                    if i in dirty_injected:
                        continue  # 每条记录只注入一次
                    if random.random() < rule["rate"]:
                        self._apply_rule(record, rule["id"])
                        record["_is_dirty"] = True
                        record["_dirty_rule"] = rule["id"]
                        dirty_injected.add(i)

        return records

    def _apply_rule(self, record: Dict, rule_id: str):
        """应用具体规则到记录"""
        if rule_id == "D001":
            bad_phones = ["1234567890", "13800138A", "1380013800100"]
            record["phone"] = random.choice(bad_phones)

        elif rule_id == "D004":
            record["status"] = 2
            record["is_pay"] = 0

        elif rule_id == "D007":
            from datetime import datetime, timedelta
            if "pay_time" in record and record["pay_time"] and "create_time" in record:
                ct = datetime.strptime(record["create_time"], "%Y-%m-%d %H:%M:%S")
                record["pay_time"] = (ct - timedelta(minutes=random.randint(3, 30))).strftime("%Y-%m-%d %H:%M:%S")

        elif rule_id == "D013":
            if "cost" in record:
                record["discount_amount"] = round(record["cost"] * random.uniform(1.1, 2.0), 2)

        # TODO: 补充其他规则的实现
```

### 6.2 特殊Persona行为性脏数据

这类脏数据不需要规则注入，而是在 Persona 的行为决策流程中自然产生：

#### 未支付型脏数据 Persona（`dirty_data_probability >= 0.12`，行为特征：`complete_payment=False`）

PersonaHub 改造时，原始描述含"impulsive buyer"、"cart abandonment"、"waits for discount"等关键词的 Persona 会被赋予较高的 `dirty_data_probability`（0.12-0.20），在生成时触发以下机制：

**生成机制**：
- 层一行为决策时：`complete_payment = False`（约70%概率）
- 层二字段翻译时：`status=0, pay_time=NULL, is_pay=0, trade_no=NULL`

**数据特征**：
```json
{
  "j_member_order": {
    "status": 0,
    "pay_time": null,
    "is_pay": 0,
    "trade_no": null,
    "pay_way": null
  }
}
```

**业务含义**：用于测试订单超时取消逻辑、未支付订单统计、转化率分析。

#### 退款型脏数据 Persona（`dirty_data_probability >= 0.15`，行为特征：高退款率）

PersonaHub 改造时，原始描述含"frequently returns"、"refund-prone"、"changes mind often"等的 Persona：

**生成机制**：
- 正常生成一条 status=2（已支付）的订单
- 以60%概率生成一条 status=5（退款中）的状态变更记录
- 以80%概率最终变为 status=6（已退款），is_refund=1

**数据特征**：
```json
{
  "j_member_order": {
    "status": 6,
    "is_refund": 1,
    "pay_time": "2026-03-01 14:30:00"
  },
  "j_member_order_refund": [
    {"order_num": "JN...", "refund_amount": 40.0, "refund_time": "2026-03-02 10:00:00", "status": 1},
    {"order_num": "JN...", "refund_amount": 40.0, "refund_time": "2026-03-03 15:00:00", "status": 2}
  ]
}
```

**注意**：j_member_order_refund 表不在 Phase 1 核心表范围内，退款记录可以只在 j_member_order.is_refund=1+status=6 中体现，不单独生成退款明细表。

#### 转课退课型脏数据 Persona（training 系统，`dirty_data_probability >= 0.15`）

PersonaHub 改造时，原始描述含"indecisive"、"frequently switches courses"等的 training 类 Persona：

**生成机制**：
- 正常生成 m_trade_order（order_status=FINISHED）
- 生成 m_trade_order_course 时：course_status=0（已完成），但 remain_class_hour 设为一个>0的值（如total_class_hour的30-60%）
- m_trade_order 的 order_status 随机设为 REFUNDING 或 REFUNDED

**数据特征**：
```json
{
  "m_trade_order": {
    "order_status": "REFUNDED",
    "pay_amount": 2000.0
  },
  "m_trade_order_course": {
    "course_status": 0,
    "total_class_hour": 30,
    "remain_class_hour": 18,
    "course_status_note": "[脏数据] 已完成但余课未上"
  }
}
```

---

## 7. Python 项目骨架

### 7.1 目录结构

```
wenti_data_simulator/
├── config.yaml                    # 全局配置（LLM provider、路径、行数、随机种子等）
├── main.py                        # 入口：解析参数，按批次调用各生成器
├── mini_example.py                # 端到端最小可运行示例（见7.4节）
├── llm/
│   ├── __init__.py
│   ├── provider.py                # 抽象接口 + 工厂 + 注册机制
│   ├── deepseek_provider.py       # DeepSeek API 实现
│   ├── claude_provider.py         # Claude API 实现
│   └── openai_provider.py         # OpenAI 兼容接口实现（可接 Ollama）
├── persona/
│   ├── __init__.py
│   ├── hub_adapter.py             # Persona Hub 下载、过滤、LLM改造
│   └── persona_library.py         # Persona 加载、采样、权重管理
├── generators/
│   ├── __init__.py
│   ├── dict_generator.py          # 批次1：字典数据生成（场馆/运动/优惠券等）
│   ├── behavior_generator.py      # 层一：Persona代入生成行为决策JSON
│   ├── field_translator.py        # 层二：行为决策翻译为数据库字段值
│   └── dirty_injector.py          # 后处理：脏数据规则注入
├── output/
│   ├── __init__.py
│   ├── file_writer.py             # 输出 CSV/JSON 到本地文件
│   └── stream_loader.py           # 可选：StarRocks Stream Load 写入
├── validation/
│   ├── __init__.py
│   └── quality_checker.py         # 统计分布验证 + LLM语义审查
├── data/
│   ├── personas/                  # PersonaHub 改造后的 Persona（wenti_personas.jsonl）
│   ├── dict/                      # 字典数据（venues.json, sports.json等）
│   └── output/                    # 生成的 CSV/JSON 文件（按表名分文件）
│       ├── j_member.csv
│       ├── j_member_order.csv
│       └── ...
└── prompts/
    ├── dict_gen.txt               # Prompt A 模板
    ├── persona_adapt.txt          # Prompt B 模板
    ├── behavior_decision.txt      # Prompt C 模板
    ├── field_translate.txt        # Prompt D 模板
    └── quality_check.txt          # Prompt E 模板
```

### 7.2 config.yaml 示例

```yaml
# wenti_data_simulator/config.yaml
# 佳兆业文体数据模拟器配置文件

# =================== LLM Provider 配置 ===================
llm:
  provider: deepseek          # 切换：deepseek | claude | openai | ollama
  temperature: 0.7
  max_tokens: 4096

  deepseek:
    api_key: "sk-xxxxxxxxxxxxxxxxxxxx"   # 替换为真实 API Key
    base_url: "https://api.deepseek.com/v1"
    model: "deepseek-chat"
    timeout: 60                 # 请求超时（秒）
    max_retries: 3

  claude:
    api_key: "sk-ant-xxxxxxxxxxxx"
    base_url: "https://api.anthropic.com"
    model: "claude-opus-4-5"
    timeout: 90
    max_retries: 3

  openai:
    api_key: "sk-xxxxxxxxxxxxxxxxxxxx"
    base_url: "https://api.openai.com/v1"   # 可换为 Ollama: http://localhost:11434/v1
    model: "gpt-4o-mini"
    timeout: 60
    max_retries: 3

  # ── 实际使用的 Provider（P0 阶段已验证）──
  vllm_local:
    api_key: "shuangan645310"
    base_url: "http://10.20.77.89:8000/v1"
    model: "Qwen3.6-35B-A3B"
    timeout: 120
    max_retries: 3
    # 重要：Qwen3 默认开启 thinking 模式，需通过 chat_template_kwargs 关闭
    extra_body:
      chat_template_kwargs:
        enable_thinking: false

# =================== 输出路径配置 ===================
output:
  base_dir: "data/output"
  format: csv                 # csv | json
  csv_encoding: utf-8-sig     # Windows Excel 兼容
  json_indent: 2

# =================== 随机种子（确保可复现） ===================
seed: 42

# =================== 脏数据配置 ===================
dirty_data:
  enabled: true
  total_rate: 0.05            # 总脏数据比例上限
  rules:
    D001: 0.003
    D002: 0.002
    D004: 0.004
    D007: 0.005
    D010: 0.005
    D013: 0.004
    D016: 0.002
    D019: 0.000   # 默认禁用（SQL注入片段，需 enable_injection_test: true 时手动开启）
  enable_injection_test: false   # M014: D019 安全开关，false=禁用注入类脏数据

# =================== Phase 1 各表目标行数 ===================
phase: 1

table_targets:
  # jianengliang C端
  j_member: 200
  j_member_third: 150           # 约75%的会员绑定微信
  buy_ticket_people: 80          # 约40%的订单有附加购票人
  j_coupon_code: 20              # 字典表，固定数量
  j_coupon: 300                  # 每会员平均1.5张
  j_member_order: 500            # 每会员平均2.5次订单
  j_order_field: 150             # 约30%订单为订场
  j_order_ticket: 280            # 约56%订单为票务
  j_order_btp: 60                # 有购票人的订单数
  j_order_coupon: 200            # 有优惠券的订单数
  j_order_ticket_valid: 200      # 约70%的票已核销
  j_points_records: 400          # 约80%的完成订单有积分
  j_member_time_card: 60         # 约30%的高频用户有时间卡
  j_time_card_use: 100           # 时间卡使用记录

  # training 培训B端
  t_student: 80
  t_class: 30                    # 字典表
  t_class_teacher: 30            # 与t_class对应
  m_trade_order: 120
  m_trade_order_course: 120
  m_trade_order_detail: 120

  # vmdb 场馆管理B端
  vmdb_venue_config: 10          # 字典表（场馆数）
  vmdb_member_card: 150
  vmdb_entry_record: 600         # 约3-5次/会员
  vmdb_ticket_verification: 200

# =================== Persona 采样配置 ===================
persona:
  library_path: "data/personas"
  library_file: "wenti_personas.jsonl"   # hub_adapter.py 生成的改造结果
  # 不再使用固定权重字典；改为按 system 字段分层随机抽样（见 §3.4）
  # 如需调整各系统比例，修改以下 system_weights
  system_weights:
    jianengliang: 0.55    # C端会员生成比例
    training: 0.20        # 培训B端学员比例
    vmdb: 0.15            # 场馆B端会员比例
    cross_system: 0.10    # 跨系统用户比例（同时参与 jianengliang + training）
    # weights 合计 = 1.00

# =================== StarRocks 连接配置（可选，写入时启用） ===================
starrocks:
  enabled: false               # true 时启用 Stream Load
  host: "192.168.1.100"
  http_port: 8030
  jdbc_port: 9030
  database: "wenti_ods"
  username: "root"
  password: "xxxxxx"           # 替换为真实密码
  timeout: 300

# =================== 日志配置 ===================
logging:
  level: INFO
  file: "logs/simulator.log"
  max_bytes: 10485760           # 10MB
  backup_count: 3
```

### 7.3 各模块 Python stub

以下给出各模块核心 stub，包含 import、类/函数签名、docstring、关键 TODO 注释。

#### llm/provider.py




### 7.3 各模块 Python stub

以下给出各模块核心 stub（函数签名 + 注释 + TODO，可直接作为开发起点）。

#### llm/deepseek_provider.py

```python
# llm/deepseek_provider.py
import json, time, requests
from typing import Dict, Any
from .provider import LLMProvider, LLMProviderFactory, LLMError

class DeepSeekProvider(LLMProvider):
    # DeepSeek API 实现，完整支持 JSON 输出格式
    def __init__(self, config: Dict[str, Any]):
        self.api_key  = config["api_key"]
        self.base_url = config.get("base_url", "https://api.deepseek.com/v1")
        self.model    = config.get("model", "deepseek-chat")
        self.timeout  = config.get("timeout", 60)
        self.retries  = config.get("max_retries", 3)

    def complete(self, system, user, response_format="text",
                 temperature=0.7, max_tokens=4096) -> Dict[str, Any]:
        # 构建请求 payload
        headers = {"Authorization": f"Bearer {self.api_key}",
                   "Content-Type": "application/json"}
        payload = {"model": self.model,
                   "messages": [{"role": "system", "content": system},
                                 {"role": "user",   "content": user}],
                   "temperature": temperature,
                   "max_tokens":   max_tokens}
        if response_format == "json":
            payload["response_format"] = {"type": "json_object"}
        for attempt in range(self.retries):
            try:
                t0 = time.time()
                resp = requests.post(f"{self.base_url}/chat/completions",
                                     headers=headers, json=payload, timeout=self.timeout)
                resp.raise_for_status()
                data    = resp.json()
                content = data["choices"][0]["message"]["content"]
                result  = {"content": content,
                           "usage":   data.get("usage", {}),
                           "model":   data.get("model", self.model),
                           "latency_ms": (time.time() - t0) * 1000}
                if response_format == "json":
                    result["parsed_json"] = json.loads(content)
                return result
            except Exception as e:
                if attempt == self.retries - 1:
                    raise LLMError(f"DeepSeek failed: {e}")
                time.sleep(2 ** attempt)

    def get_provider_name(self) -> str:
        return "deepseek"

# 自动注册
LLMProviderFactory.register("deepseek", DeepSeekProvider)
```

#### persona/hub_adapter.py

```python
# persona/hub_adapter.py
import json, logging
from pathlib import Path
from typing import List, Dict, Any

logger = logging.getLogger(__name__)
RELEVANT_KEYWORDS = ["fitness","gym","swimming","sports","consumer","student","parent","athlete"]

class PersonaHubAdapter:
    # 下载->过滤->LLM改造 完整适配器
    def __init__(self, llm_provider, config: Dict[str, Any]):
        self.llm = llm_provider
        self.raw_file    = Path("data/personas/persona_hub_raw.jsonl")
        self.adapted_dir = Path("data/personas")
        self.adapted_dir.mkdir(parents=True, exist_ok=True)

    def download_and_filter(self, max_records: int = 5000) -> int:
        # TODO: from datasets import load_dataset
        # ds = load_dataset("proj-persona/PersonaHub", split="train", streaming=True)
        # 流式读取，按 RELEVANT_KEYWORDS 过滤，保存为 JSONL
        raise NotImplementedError

    def adapt_batch(self, raw_records: List[Dict], target_system: str = "jianengliang") -> List[Dict]:
        # 调用 LLM（Prompt B），验证 JSON Schema，保存 P_HUB_XXX.json
        tpl = Path("prompts/persona_adapt.txt").read_text(encoding="utf-8")
        results = []
        for i, raw in enumerate(raw_records):
            user_p = (tpl
                .replace("<<ORIGINAL_PERSONA>>", str(raw))
                .replace("<<TARGET_SYSTEM>>", target_system)
                .replace("<<INDEX>>", f"{i+1:03d}"))
            try:
                resp    = self.llm.complete(system="你是专业的Persona设计师。",
                                            user=user_p, response_format="json")
                adapted = resp["parsed_json"]
                results.append(adapted)
                out = self.adapted_dir / f"P_HUB_{i+1:03d}.json"
                out.write_text(json.dumps(adapted, ensure_ascii=False, indent=2))
            except Exception as e:
                logger.warning(f"adapt persona {i} failed: {e}")
        return results
```

#### persona/persona_library.py

```python
# persona/persona_library.py
import json, random
from pathlib import Path
from copy import deepcopy
from typing import Dict, List, Any

class PersonaLibrary:
    # Persona 库加载与加权采样
    def __init__(self, library_path: str, weights: Dict[str, float]):
        self.library_path = Path(library_path)
        self.weights  = weights
        self.personas: Dict[str, Dict] = {}

    def load_all(self):
        for fp in self.library_path.glob("P*.json"):
            p = json.loads(fp.read_text(encoding="utf-8"))
            self.personas[p["persona_id"]] = p

    def sample(self, count: int = 1) -> List[Dict]:
        ids  = list(self.weights.keys())
        wts  = [self.weights[i] for i in ids]
        picked = random.choices(ids, weights=wts, k=count)
        return [deepcopy(self.personas[pid]) for pid in picked if pid in self.personas]

    def get_by_id(self, persona_id: str) -> Dict:
        return self.personas.get(persona_id, {})
```

#### generators/ (behavior + field + dirty)

```python
# generators/behavior_generator.py  —— 层一行为决策生成器（Prompt C）
# 职责：接收 Persona JSON + 场景描述，调用 LLM 输出行为决策（消费意向、支付方式等）
import json
import logging
from typing import Dict, Any
from pathlib import Path

logger = logging.getLogger(__name__)

class BehaviorGenerator:
    """
    层一生成器：调用 Prompt C 生成用户在指定场景的行为决策。
    temperature=0.7，鼓励多样性；返回已解析的 dict，不做字段翻译。
    """

    def __init__(self, llm_provider, config: Dict[str, Any]):
        self.llm   = llm_provider
        self.cfg   = config
        prompt_path = Path(config.get("prompt_dir", "prompts")) / "behavior_decision.txt"
        self.template = prompt_path.read_text(encoding="utf-8")

    def generate_decision(
        self,
        persona:   Dict[str, Any],
        scenario:  str,
        context:   Dict[str, Any],
    ) -> Dict[str, Any]:
        """
        Parameters
        ----------
        persona  : PersonaLibrary.get_by_id() 返回的完整 Persona JSON
        scenario : 场景描述字符串，如"购买月卡""报名拳击课""场地预订"
        context  : 运行时上下文，keys: venues, coupons, date_range, max_member_id

        Returns
        -------
        行为决策字典，示例 keys:
            purchase_intent, payment_method, use_coupon,
            coupon_id, preferred_venue_id, session_time, remarks
        """
        behavior_probs = persona.get("behavior_probabilities", {})
        prompt = (
            self.template
            .replace("<<PERSONA_JSON>>",
                     json.dumps(persona, ensure_ascii=False, indent=2))
            .replace("<<SCENARIO_DESCRIPTION>>", scenario)
            .replace("<<AVAILABLE_VENUES>>",
                     json.dumps(context.get("venues", []), ensure_ascii=False))
            .replace("<<AVAILABLE_COUPONS>>",
                     json.dumps(context.get("coupons", []), ensure_ascii=False))
            .replace("<<DATE_RANGE>>",
                     context.get("date_range", "2026-01-01 至 2026-06-30"))
            .replace("<<USE_COUPON_PROB>>",
                     str(behavior_probs.get("use_coupon", 0.5)))
        )
        result = self.llm.complete(
            system="你是文体消费行为模拟专家。请用纯 JSON 输出行为决策，不加 markdown 代码块。",
            user=prompt,
            response_format="text",   # M011-A: text 模式，避免与 reasoning 字段冲突
            temperature=0.7,
        )
        # M011-A: 从 text 响应中提取 JSON（兼容 LLM 偶尔附带前后说明文字的情况）
        raw_text = result.get("content", "")
        import re as _re
        m = _re.search(r'\{.*\}', raw_text, _re.DOTALL)
        if m:
            try:
                decision = json.loads(m.group())
            except json.JSONDecodeError:
                logger.warning("Behavior decision JSON parse failed for persona %s, raw: %s",
                               persona.get("persona_id"), raw_text[:200])
                decision = {}
        else:
            decision = result.get("parsed_json", {})
        logger.debug("Behavior decision for persona %s: %s",
                     persona.get("persona_id"), json.dumps(decision, ensure_ascii=False))
        return decision
```

```python
# generators/field_translator.py  —— 层二字段翻译器（Prompt D, temperature=0.3）
# 职责：将层一行为决策翻译为一到多张目标表的 DB 字段记录
import json
import logging
from typing import Dict, List, Any
from pathlib import Path

logger = logging.getLogger(__name__)

class FieldTranslator:
    """
    层二翻译器：调用 Prompt D 将行为决策翻译为目标表字段。
    temperature=0.3，减少幻觉，确保枚举值合规。
    """

    def __init__(self, llm_provider, config: Dict[str, Any]):
        self.llm  = llm_provider
        self.cfg  = config
        prompt_path = Path(config.get("prompt_dir", "prompts")) / "field_translate.txt"
        self.template = prompt_path.read_text(encoding="utf-8")

    def translate_to_records(
        self,
        decision:      Dict[str, Any],
        target_tables: List[str],
        user_context:  Dict[str, Any],
    ) -> Dict[str, Dict[str, Any]]:
        """
        Parameters
        ----------
        decision      : BehaviorGenerator.generate_decision() 的输出
        target_tables : 此次需要填写字段的表名列表，如 ["j_member_order","j_bill"]
        user_context  : 已生成的 FK 信息，keys: member_id, venue_id, order_seq, ...

        Returns
        -------
        {table_name: {field_name: value, ...}, ...}
        后置验证（TODO）：
          - pay_time >= create_time（dirty injector 可反向破坏）
          - pay_amount == cost - discount_amount（允许少量误差）
          - status/is_pay 一致性
          - 枚举值白名单校验（见第5章枚举字典）
        """
        prompt = (
            self.template
            .replace("<<BEHAVIOR_DECISION_JSON>>",
                     json.dumps(decision, ensure_ascii=False, indent=2))
            .replace("<<USER_CONTEXT>>",
                     json.dumps(user_context, ensure_ascii=False, indent=2))
            .replace("<<MAX_MEMBER_ID>>",
                     str(user_context.get("max_member_id", 10000)))
            .replace("<<ORDER_SEQ>>",
                     str(user_context.get("order_seq", 1)))
            .replace("<<TARGET_TABLE_SCHEMAS>>",
                     json.dumps(target_tables, ensure_ascii=False))
        )
        result = self.llm.complete(
            system="你是数据库记录生成专家。严格遵守枚举规范，输出纯 JSON，不加说明文字。",
            user=prompt,
            response_format="json",
            temperature=0.3,
        )
        records = result.get("parsed_json", {})
        logger.debug("Field translation for tables %s done.", target_tables)
        return records
```

```python
# generators/dirty_injector.py  —— 脏数据注入器（第6章规则清单 D001-D019）
# 职责：按概率随机破坏合法记录，模拟真实系统的数据质量问题
import random
import logging
from datetime import datetime, timedelta
from typing import Dict, List, Any

logger = logging.getLogger(__name__)

DIRTY_RULE_REGISTRY = {
    # rule_id : (table_filter_or_None, description)
    "D001": ("j_member",          "手机号格式错误"),
    "D002": ("j_member",          "身份证号格式错误"),
    "D003": ("j_member",          "birthday 超出合理范围（<1900 或 >2015）"),
    "D004": ("j_member_order",    "status=2(已支付) 但 is_pay=0（状态矛盾）"),
    "D005": ("j_member_order",    "pay_amount=0 但 status=已支付"),
    "D006": ("j_member_order",    "coupon_id 无对应优惠券记录（孤儿 FK）"),
    "D007": ("j_member_order",    "pay_time < create_time（时序倒置）"),
    "D008": ("j_bill",            "bill_type 枚举值非法"),
    "D009": ("j_bill",            "amount 为负数"),
    "D010": ("j_member",          "age 为 NULL（本应必填）"),
    "D011": (None,                "created_time 为 NULL"),
    "D012": ("t_student",         "student_code 格式错误（非 STU 开头）"),
    "D013": ("j_member_order",    "discount_amount > cost（折扣超出原价）"),
    "D014": ("j_member_order",    "重复 order_num（同用户两条相同订单号）"),
    "D015": ("t_student",         "course_id 无对应课程（孤儿 FK）"),
    "D016": ("j_member",          "同 phone + id_card 对应不同 member_id（重复注册）"),
    "D017": ("v_booking",         "start_time 与 end_time 相同"),
    "D018": ("j_member_order",    "pay_way 枚举值非法"),
    "D019": (None,                "remark 字段包含 SQL 注入片段"),
}

class DirtyInjector:
    """
    按 config.dirty_data.rules 字典的概率为每条记录随机打标并破坏字段。
    已破坏的记录追加 _is_dirty=True、_dirty_rule=rule_id 两个内部字段，
    FileWriter 输出时会自动剥除以 _ 开头的内部字段。
    """

    def __init__(self, config: Dict[str, Any]):
        dd = config.get("dirty_data", {})
        self.enabled = dd.get("enabled", True)
        self.rules   = dd.get("rules", {})
        self._dirty_pool: dict = {}   # 跨记录脏数据值池（D014/D016用）

    def inject(self, records: Dict[str, List[Dict]]) -> Dict[str, List[Dict]]:
        if not self.enabled:
            return records
        total_dirty = 0
        for table, rows in records.items():
            dirty_set: set = set()
            # 为跨记录规则预收集值池
            self._dirty_pool["order_nums"] = [r["order_num"] for r in rows if r.get("order_num")]
            self._dirty_pool["phones"]     = [r["phone"]     for r in rows if r.get("phone")]
            for rule_id, rate in self.rules.items():
                if rule_id not in DIRTY_RULE_REGISTRY:
                    continue
                table_filter = DIRTY_RULE_REGISTRY[rule_id][0]
                if table_filter and table_filter != table:
                    continue
                for idx, row in enumerate(rows):
                    if idx in dirty_set:
                        continue
                    if random.random() < rate:
                        if self._apply(row, rule_id, table):
                            row["_is_dirty"]    = True
                            row["_dirty_rule"]  = rule_id
                            dirty_set.add(idx)
                            total_dirty += 1
        logger.info("DirtyInjector: %d records dirtied across tables %s",
                    total_dirty, list(records.keys()))
        return records

    # ------------------------------------------------------------------
    # 规则实现
    # ------------------------------------------------------------------

    def _apply(self, row: Dict, rule_id: str, table: str) -> bool:
        try:
            if rule_id == "D001":
                row["phone"] = random.choice(["1234567890", "138001380A",
                                               "186-1234-5678", ""])
                return True
            if rule_id == "D002":
                row["id_card"] = "123456789012345X0"  # 18位但最后两位多了一位
                return True
            if rule_id == "D003":
                row["birthday"] = random.choice(["1850-01-01", "2020-12-31", "0000-00-00"])
                return True
            if rule_id == "D004":
                row["status"] = 2; row["is_pay"] = 0
                return True
            if rule_id == "D005":
                row["pay_amount"] = 0; row["status"] = 2; row["is_pay"] = 1
                return True
            if rule_id == "D007" and row.get("pay_time") and row.get("create_time"):
                ct  = datetime.strptime(str(row["create_time"]), "%Y-%m-%d %H:%M:%S")
                row["pay_time"] = (ct - timedelta(minutes=random.randint(3, 60))).strftime(
                    "%Y-%m-%d %H:%M:%S"
                )
                return True
            if rule_id == "D009":
                row["amount"] = round(-abs(float(row.get("amount", 10))), 2)
                return True
            if rule_id == "D010":
                row["age"] = None
                return True
            if rule_id == "D011":
                row["created_time"] = None
                return True
            if rule_id == "D013" and "cost" in row:
                row["discount_amount"] = round(float(row["cost"]) * random.uniform(1.1, 2.0), 2)
                return True
            if rule_id == "D017" and "start_time" in row:
                row["end_time"] = row["start_time"]
                return True
            if rule_id == "D018":
                row["pay_way"] = random.choice([99, -1, "unknown"])
                return True
            if rule_id == "D019":
                # M014: D019 默认禁用，须在 config.dirty_data.enable_injection_test=true 时才触发
                if not self.config.get("dirty_data", {}).get("enable_injection_test", False):
                    return False
                field = "remark" if "remark" in row else next(
                    (k for k in row if "desc" in k.lower()), None)
                if field:
                    row[field] = "'; DROP TABLE j_member; --"
                    return True
            # ---- 以下为 M003-B 补全的6条规则 ----
            if rule_id == "D006":
                # coupon_id 设为不存在的孤儿值（9999999）
                if "coupon_id" in row or "coupon_code_id" in row:
                    key = "coupon_id" if "coupon_id" in row else "coupon_code_id"
                    row[key] = 9999999
                    return True
            if rule_id == "D008":
                # bill_type 枚举值非法
                if "bill_type" in row:
                    row["bill_type"] = random.choice([0, 99, -1])
                    return True
            if rule_id == "D012":
                # student_code 格式错误：去掉 STU 前缀或截断
                if "student_code" in row:
                    row["student_code"] = random.choice([
                        "XS" + str(random.randint(10000000, 99999999)),  # 旧错误前缀
                        str(random.randint(100000, 999999)),              # 纯数字（缺前缀）
                        "",                                               # 空字符串
                    ])
                    return True
            if rule_id == "D014":
                # 重复 order_num：从同批次已有 order_num 池中随机挑一个
                pool = self._dirty_pool.get("order_nums", [])
                if pool and "order_num" in row:
                    row["order_num"] = random.choice(pool)
                    return True
            if rule_id == "D015":
                # course_id 设为不存在的孤儿值
                if "course_id" in row:
                    row["course_id"] = 9999999
                    return True
            if rule_id == "D016":
                # 重复 phone：从同批次已有 phone 池中随机挑一个
                pool = self._dirty_pool.get("phones", [])
                if pool and "phone" in row:
                    row["phone"] = random.choice(pool)
                    return True
        except Exception as exc:
            logger.debug("DirtyInjector rule %s on table %s failed: %s", rule_id, table, exc)
        return False
```


#### output/  (file\_writer + stream\_loader)

```python
# output/file_writer.py  —— CSV / JSONL 本地输出
import csv
import json
import logging
from pathlib import Path
from typing import Dict, List

logger = logging.getLogger(__name__)

class FileWriter:
    """
    将内存中的表记录写到本地磁盘。
    支持 format=csv（默认，BOM UTF-8，兼容 Excel）或 format=jsonl。
    内部调试字段（以 _ 开头）在输出时自动剥除。
    """

    def __init__(self, config: dict):
        out_cfg        = config.get("output", {})
        self.base_dir  = Path(out_cfg.get("base_dir", "data/output"))
        self.fmt       = out_cfg.get("format", "csv")
        self.encoding  = out_cfg.get("csv_encoding", "utf-8-sig")
        self.base_dir.mkdir(parents=True, exist_ok=True)

    def write_table(self, table_name: str, records: List[Dict]):
        """写出单张表，records 含脏数据标记字段均可（自动剥除）。"""
        clean = [{k: v for k, v in row.items() if not k.startswith("_")}
                 for row in records]
        if not clean:
            logger.warning("write_table: %s has 0 records, skipped.", table_name)
            return
        if self.fmt == "csv":
            fpath = self.base_dir / f"{table_name}.csv"
            with open(fpath, "w", newline="", encoding=self.encoding) as fh:
                writer = csv.DictWriter(fh, fieldnames=list(clean[0].keys()))
                writer.writeheader()
                writer.writerows(clean)
        else:
            fpath = self.base_dir / f"{table_name}.jsonl"
            with open(fpath, "w", encoding="utf-8") as fh:
                for row in clean:
                    fh.write(json.dumps(row, ensure_ascii=False) + "\n")
        logger.info("FileWriter: %d rows -> %s", len(clean), fpath)

    def write_all(self, all_records: Dict[str, List[Dict]]):
        """批量写出，all_records = {table_name: [row_dict, ...]}。"""
        for table, rows in all_records.items():
            self.write_table(table, rows)
```

```python
# output/stream_loader.py  —— StarRocks Stream Load 推送（可选）
# 若 config.starrocks.enabled=false，此模块在 main.py 中不被调用
import json
import logging
import requests
from pathlib import Path
from typing import Dict, List

logger = logging.getLogger(__name__)

class StreamLoader:
    """
    将记录通过 StarRocks HTTP Stream Load 接口推送到目标表。
    依赖：config.starrocks.{host, http_port, user, password, database}
    调用前须保证 StarRocks 已创建对应表结构。
    """

    def __init__(self, config: dict):
        sr = config.get("starrocks", {})
        self.host      = sr.get("host", "localhost")
        self.port      = sr.get("http_port", 8030)
        self.user      = sr.get("user", "root")
        self.password  = sr.get("password", "")
        self.database  = sr.get("database", "ods_wenti")
        self.enabled   = sr.get("enabled", False)

    def load_table(self, table_name: str, records: List[Dict]) -> bool:
        """
        推送单张表。失败时记录错误日志并返回 False，不抛异常（保证主流程不中断）。
        Stream Load 要求 Content-Type: application/json，body 为 JSON Array。
        """
        if not self.enabled:
            logger.debug("StreamLoader disabled, skip %s.", table_name)
            return True
        clean = [{k: v for k, v in row.items() if not k.startswith("_")}
                 for row in records]
        url = (f"http://{self.host}:{self.port}"
               f"/api/{self.database}/{table_name}/_stream_load")
        headers = {
            "Content-Type": "application/json",
            "Expect": "100-continue",
            "format": "json",
            "strip_outer_array": "true",
        }
        try:
            resp = requests.put(
                url, data=json.dumps(clean, ensure_ascii=False).encode("utf-8"),
                headers=headers,
                auth=(self.user, self.password),
                timeout=60,
            )
            body = resp.json()
            if body.get("Status") in ("Success", "Publish Timeout"):
                logger.info("StreamLoader: %s -> %d rows loaded (TxnId=%s)",
                            table_name, len(clean), body.get("TxnId"))
                return True
            logger.error("StreamLoader: %s failed: %s", table_name, body)
            return False
        except Exception as exc:
            logger.error("StreamLoader: %s exception: %s", table_name, exc)
            return False
```

#### validation/ (quality\_checker)

```python
# validation/quality_checker.py  —— 双轨质量验证：统计规则 + LLM 语义审查
import json
import logging
from collections import Counter
from pathlib import Path
from typing import Dict, List, Any

logger = logging.getLogger(__name__)

class QualityChecker:
    """
    双轨校验：
      Track A  统计规则（无 LLM 消耗）：时序一致性、枚举合规、金额逻辑
      Track B  LLM 语义审查（Prompt E）：抽样 + judge 模式，每表最多 10 行
    """

    def __init__(self, llm_provider, config: Dict[str, Any]):
        self.llm    = llm_provider
        self.config = config
        prompt_path = Path(config.get("prompt_dir", "prompts")) / "quality_check.txt"
        self.template = prompt_path.read_text(encoding="utf-8") if prompt_path.exists() else ""

    # ------------------------------------------------------------------
    # Track A：统计校验
    # ------------------------------------------------------------------

    def check_statistics(self, records: Dict[str, List[Dict]]) -> Dict[str, Any]:
        """返回每张表的统计报告 dict，供 main.py 记录日志或写入 QA 文件。"""
        report: Dict[str, Any] = {}

        if "j_member_order" in records:
            orders = records["j_member_order"]
            timing_err = sum(
                1 for o in orders
                if o.get("pay_time") and o.get("create_time")
                and str(o["pay_time"]) < str(o["create_time"])
            )
            amounts = [float(o["pay_amount"]) for o in orders if o.get("pay_amount") is not None]
            report["j_member_order"] = {
                "total":          len(orders),
                "timing_errors":  timing_err,
                "status_dist":    dict(Counter(o.get("status")  for o in orders)),
                "pay_way_dist":   dict(Counter(o.get("pay_way") for o in orders)),
                "avg_pay_amount": round(sum(amounts) / len(amounts), 2) if amounts else 0,
                "dirty_count":    sum(1 for o in orders if o.get("_is_dirty")),
            }

        if "j_member" in records:
            members = records["j_member"]
            report["j_member"] = {
                "total":       len(members),
                "sex_dist":    dict(Counter(m.get("sex")    for m in members)),
                "source_dist": dict(Counter(m.get("source") for m in members)),
                "vip_count":   sum(1 for m in members if m.get("is_vip") == 1),
                "dirty_count": sum(1 for m in members if m.get("_is_dirty")),
            }

        if "t_student" in records:
            students = records["t_student"]
            code_err = sum(
                1 for s in students
                if not str(s.get("student_code", "")).startswith("STU")
            )
            report["t_student"] = {
                "total":           len(students),
                "code_format_err": code_err,
                "dirty_count":     sum(1 for s in students if s.get("_is_dirty")),
            }

        # 汇总跨表脏数据比例
        total_rows = sum(len(v) for v in records.values())
        total_dirty = sum(
            row.get("_is_dirty", 0)
            for rows in records.values() for row in rows
        )
        report["_summary"] = {
            "total_rows":  total_rows,
            "total_dirty": total_dirty,
            "dirty_rate":  round(total_dirty / total_rows, 4) if total_rows else 0,
        }
        return report

    # ------------------------------------------------------------------
    # Track B：LLM 语义审查（Prompt E）
    # ------------------------------------------------------------------

    def semantic_check(
        self, records: Dict[str, List[Dict]], batch_id: str
    ) -> Dict[str, Any]:
        """
        每张表抽样最多 10 条，调用 Prompt E 做 LLM-as-judge 语义审查。
        返回 LLM 输出的审查报告 JSON。
        若 Prompt E 模板不存在，跳过语义检查并返回空字典。
        """
        if not self.template:
            logger.warning("QualityChecker: Prompt E template not found, skip semantic check.")
            return {}

        sampled = {table: rows[:10] for table, rows in records.items()}
        # 清理内部字段后再传给 LLM
        sampled_clean = {
            t: [{k: v for k, v in r.items() if not k.startswith("_")} for r in rows]
            for t, rows in sampled.items()
        }
        prompt = (
            self.template
            .replace("<<BATCH_ID>>", batch_id)
            .replace("<<RECORDS_JSON>>",
                     json.dumps(sampled_clean, ensure_ascii=False, indent=2))
            .replace("<<BUSINESS_RULES_SUMMARY>>",
                     "见第5章字段映射规则和枚举字典（status/pay_way/source/sex 枚举、"
                     "pay_time>=create_time、pay_amount=cost-discount_amount）")
        )
        result = self.llm.complete(
            system="你是数据质量审查专家。用纯 JSON 输出审查报告，格式：{issues:[{table,field,row_index,desc}], pass:bool}",
            user=prompt,
            response_format="json",
            temperature=0.1,
        )
        return result.get("parsed_json", {})
```

#### main.py  —— 入口编排

```python
# main.py  —— 整体生成流程编排入口
# 用法：python main.py --config config.yaml --phase 1
#       --phase 1  验证阶段（50-200 行/表）
#       --phase 2  中量阶段（1000-5000 行/表）
#       --phase 3  大量阶段（10000+ 行/表）
import argparse
import json
import logging
import random
import sys
from pathlib import Path

import yaml

from llm.provider         import LLMProviderFactory
from persona.persona_library import PersonaLibrary
from generators.dict_generator   import DictGenerator
from generators.member_generator import MemberGenerator
from generators.behavior_generator import BehaviorGenerator
from generators.field_translator   import FieldTranslator
from generators.dirty_injector     import DirtyInjector
from output.file_writer    import FileWriter
from output.stream_loader  import StreamLoader
from validation.quality_checker import QualityChecker


def setup_logging(log_dir: str = "logs"):
    Path(log_dir).mkdir(parents=True, exist_ok=True)
    fmt = "%(asctime)s [%(levelname)-8s] %(name)s: %(message)s"
    logging.basicConfig(
        level=logging.INFO,
        format=fmt,
        handlers=[
            logging.FileHandler(f"{log_dir}/simulator.log", encoding="utf-8"),
            logging.StreamHandler(sys.stdout),
        ],
    )


def main():
    parser = argparse.ArgumentParser(description="佳兆业文体数据模拟器")
    parser.add_argument("--config", default="config.yaml",
                        help="配置文件路径（默认 config.yaml）")
    parser.add_argument("--phase",  type=int, default=1,
                        help="生成阶段：1=验证 / 2=中量 / 3=大量")
    parser.add_argument("--dry-run", action="store_true",
                        help="只生成到内存，不写磁盘也不推 StarRocks")
    args = parser.parse_args()

    with open(args.config, encoding="utf-8") as fp:
        config = yaml.safe_load(fp)

    setup_logging(config.get("log_dir", "logs"))
    logger = logging.getLogger("main")
    random.seed(config.get("seed", 42))

    # ── 初始化组件 ──────────────────────────────────────────────────────
    llm = LLMProviderFactory(config).create_provider()
    logger.info("LLM Provider: %s", llm.get_provider_name())

    persona_lib = PersonaLibrary(
        config["persona"]["library_path"],
        config["persona"].get("weights", {}),
    )
    persona_lib.load_all()
    logger.info("Loaded %d personas", len(persona_lib.personas))

    dict_gen   = DictGenerator(llm, config)
    member_gen = MemberGenerator(llm, config)
    beh_gen    = BehaviorGenerator(llm, config)
    field_tr   = FieldTranslator(llm, config)
    dirty_inj  = DirtyInjector(config)
    writer     = FileWriter(config)
    loader     = StreamLoader(config)
    checker    = QualityChecker(llm, config)

    targets = config.get("table_targets", {})

    # ── Batch 1：字典/枚举表（无 FK 依赖，先生成） ─────────────────────
    logger.info("=== Batch 1: 字典数据 ===")
    venues   = dict_gen.generate_venues(targets.get("dict_venues", 10))
    sports   = dict_gen.generate_sports(20)
    coupons  = dict_gen.generate_coupon_codes(targets.get("j_coupon_code", 20))
    classes  = dict_gen.generate_classes(targets.get("t_class", 30))
    courses  = dict_gen.generate_courses(targets.get("t_course", 15))
    if not args.dry_run:
        writer.write_all({
            "dict_venues": venues, "dict_sports": sports,
            "j_coupon_code": coupons, "t_class": classes, "t_course": courses,
        })

    # ── Batch 2：j_member 会员基础表 ────────────────────────────────────
    logger.info("=== Batch 2: j_member (%d rows) ===", targets.get("j_member", 100))
    context = {"venues": venues, "date_range": config.get("date_range",
               "2026-01-01 至 2026-06-30")}
    members = []
    for i in range(targets.get("j_member", 100)):
        persona   = persona_lib.sample(1)[0]
        member_rec = member_gen.generate(persona, context)
        members.append(member_rec)
    members = dirty_inj.inject({"j_member": members})["j_member"]
    if not args.dry_run:
        writer.write_table("j_member", members)
        loader.load_table("j_member", members)

    # ── Batch 3-11：TODO（按 2.4 节 DAG 顺序逐批实现） ──────────────────
    # 每批逻辑：
    #   1. 为每位 member 抽 Persona
    #   2. beh_gen.generate_decision(persona, scenario, context)
    #   3. field_tr.translate_to_records(decision, tables, user_ctx)
    #   4. dirty_inj.inject(batch_records)
    #   5. writer.write_all + loader.load_table（非 dry-run）
    #   6. stat_report = checker.check_statistics(batch_records)
    # TODO: Batch 3  j_member_card / j_member_card_log
    # TODO: Batch 4  j_member_order + j_bill + j_order_coupon
    # TODO: Batch 5  j_ticket + j_ticket_check
    # TODO: Batch 6  j_invoice
    # TODO: Batch 7  t_student + t_student_course
    # TODO: Batch 8  t_class_schedule + t_attendance
    # TODO: Batch 9  v_venue + v_venue_price + v_coach
    # TODO: Batch 10 v_booking + v_booking_order
    # TODO: Batch 11 cross-system 关联校验（member_id/venue_id/phone 对齐）

    # ── 整体质量验证（Phase 1 强制，Phase 2/3 按需） ────────────────────
    if args.phase == 1:
        logger.info("=== Phase 1 Quality Check ===")
        all_records = {"j_member": members}  # TODO: 加入其他已生成表
        stat_report = checker.check_statistics(all_records)
        logger.info("Stat report:
%s",
                    json.dumps(stat_report, ensure_ascii=False, indent=2))
        # 语义审查（消耗 LLM tokens，Phase 1 少量数据时可开启）
        # sem_report = checker.semantic_check(all_records, batch_id="batch_all")

    logger.info("Phase %d generation complete. Output -> %s",
                args.phase, config.get("output", {}).get("base_dir", "data/output"))


if __name__ == "__main__":
    main()
```

---

### 7.4  mini\_example.py — 最小可运行端到端示例

> **目标**：不依赖完整项目结构，仅用 `python-dotenv` + `requests`，演示
> "随机抽取 Persona → 层一行为决策 → 层二字段翻译 → 写出 3 张 CSV"的完整链路，
> 可作冒烟测试和 API 联调工具。

**前置**：在项目根目录创建 `.env` 文件：

```
DEEPSEEK_API_KEY=sk-xxxxxxxxxxxx
# 或者
OPENAI_API_KEY=sk-xxxxxxxxxxxx
LLM_PROVIDER=deepseek   # deepseek | openai
```

```python
#!/usr/bin/env python3
# mini_example.py  —— 端到端冒烟测试（最小依赖：python-dotenv + requests）
# 演示：从 wenti_personas.jsonl 随机抽取一条 Persona -> 行为决策(LLM) -> 字段翻译(LLM) -> 3张CSV
# 不依赖项目其他模块，单文件可独立运行
# 用法：python mini_example.py

import csv
import json
import os
import random
import time
from pathlib import Path
from datetime import datetime, timedelta

import requests
from dotenv import load_dotenv

load_dotenv()

# ── 配置 ────────────────────────────────────────────────────────────────
PROVIDER = os.getenv("LLM_PROVIDER", "deepseek").lower()
DEEPSEEK_KEY = os.getenv("DEEPSEEK_API_KEY", "")
OPENAI_KEY   = os.getenv("OPENAI_API_KEY", "")
OUTPUT_DIR   = Path("mini_example_output")
SEED         = 42
random.seed(SEED)

# ── 加载 Persona：优先从 wenti_personas.jsonl 随机抽取，回退到内嵌 fallback ──
def load_persona(jsonl_path: str = "data/personas/wenti_personas.jsonl") -> dict:
    """从 wenti_personas.jsonl 随机抽取一条 jianengliang 类 Persona；文件不存在时返回内嵌 fallback。"""
    p = Path(jsonl_path)
    if p.exists():
        lines = p.read_text(encoding="utf-8").strip().splitlines()
        candidates = [json.loads(l) for l in lines
                      if '"jianengliang"' in l or '"cross_system"' in l]
        if candidates:
            return random.choice(candidates)
    # fallback：内嵌示例（仅在 wenti_personas.jsonl 未生成时使用）
    return {
        "persona_id": "FALLBACK_001",
        "name": "示例：注重健康的年轻上班族",
        "source": "persona_hub_adapted",
        "system": "jianengliang",
        "dimensions": {
            "user_type": "上班族",
            "price_sensitivity": "medium",
            "preferred_scenes": ["游泳", "订场"],
            "active_hours": "evening",
            "consumption_frequency": "medium",
            "registration_channel": "miniprogram",
            "lifecycle_stage": "growing",
            "id_verification_status": "unverified",
        },
        "behavior_probabilities": {
            "use_coupon": 0.55,
            "bind_wechat": 0.70,
            "add_ticket_person": 0.20,
            "accumulate_points": 0.80,
            "use_time_card": 0.20,
            "complete_id_check": 0.50,
            "complete_health_check": 0.25,
        },
        "typical_order_types": ["游泳票", "订场"],
        "avg_monthly_orders": 4,
        "avg_order_amount_range": [40, 120],
        "dirty_data_probability": 0.02,
        "notes": "内嵌 fallback，请先运行 hub_adapter.py 生成 wenti_personas.jsonl",
    }

PERSONA = load_persona()

# ── LLM 调用封装（仅 DeepSeek / OpenAI）────────────────────────────────

def call_llm(system: str, user: str, temperature: float = 0.7) -> dict:
    """调用 LLM，返回解析后的 JSON dict；失败时抛出 RuntimeError。"""
    if PROVIDER == "deepseek":
        url    = "https://api.deepseek.com/v1/chat/completions"
        model  = "deepseek-chat"
        api_key = DEEPSEEK_KEY
    else:
        url    = "https://api.openai.com/v1/chat/completions"
        model  = "gpt-4o-mini"
        api_key = OPENAI_KEY

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type":  "application/json",
    }
    payload = {
        "model":       model,
        "temperature": temperature,
        "messages": [
            {"role": "system",  "content": system},
            {"role": "user",    "content": user},
        ],
        "response_format": {"type": "json_object"},
    }
    resp = requests.post(url, headers=headers, json=payload, timeout=60)
    resp.raise_for_status()
    raw = resp.json()["choices"][0]["message"]["content"]
    try:
        return json.loads(raw)
    except json.JSONDecodeError as exc:
        raise RuntimeError(f"LLM 返回非 JSON：{raw[:200]}") from exc


# ── 层一：行为决策（Prompt C 简化版）────────────────────────────────────

BEHAVIOR_SYSTEM = "你是文体消费行为模拟专家。用纯 JSON 输出行为决策，不加 markdown 代码块。"

BEHAVIOR_USER_TPL = """# 任务
根据以下 Persona，模拟一次"购买月卡"场景的行为决策。

# Persona
{persona_json}

# 可用场馆（示例）
[{{"venue_id": 1, "name": "深圳湾体育中心游泳馆", "sports": ["游泳"]}}]

# 输出 JSON 格式（严格遵守以下 keys）
{{
  "purchase_intent":   true/false,
  "payment_method":    "微信支付|支付宝|银联|现金|赠送",
  "use_coupon":        true/false,
  "coupon_code":       "XXXX 或 null",
  "preferred_venue_id": 1,
  "preferred_sport":   "游泳",
  "session_time":      "morning|afternoon|evening|night",
  "remarks":           "备注，可为空字符串"
}}
仅输出 JSON，不要其他文字。"""


def step1_behavior_decision(persona: dict) -> dict:
    print("  [层一] 调用 LLM 生成行为决策…")
    user_prompt = BEHAVIOR_USER_TPL.format(
        persona_json=json.dumps(persona, ensure_ascii=False, indent=2)
    )
    return call_llm(BEHAVIOR_SYSTEM, user_prompt, temperature=0.7)


# ── 层二：字段翻译（Prompt D 简化版）────────────────────────────────────

FIELD_SYSTEM = "你是数据库记录生成专家。严格遵守枚举规范，输出纯 JSON，不加说明文字。"

FIELD_USER_TPL = """# 任务
将以下行为决策翻译为 StarRocks ODS 三张表的字段值。

# 行为决策
{decision_json}

# 上下文
- member_id: {member_id}
- order_seq: {order_seq}
- 当前时间: {now}

# 枚举约束（以下均为 VARCHAR 字段存储字符串值）
- j_member_order.status（订场/游泳票）: "0"待支付/"2"已支付待使用/"3"未支付超时/"4"已支付已使用/"5"已支付过期/"6"已退款/"7"已评价/"8"用户取消
- j_member_order.status（商品/演艺/赛事）: "30"-"42"，见§5.1完整枚举
- j_member_order.pay_way（VARCHAR）: "1"支付宝/"2"微信/"3"小程序
- j_member_order.type（VARCHAR）: "1"套餐/"2"订场/"3"游泳票/"4"商品/"5"演艺/"6"赛事/"7"-"10"自营/找课程
- j_bill.bill_type:       1=充值 2=消费 3=退款 4=赠送

# 输出 JSON（严格遵守以下结构，所有字段必须填写）
{{
  "j_member": {{
    "member_id":     {member_id},
    "phone":         "手机号（138开头11位）",
    "sex":           1,
    "age":           30,
    "source":        1,
    "is_vip":        0,
    "created_time":  "{now}"
  }},
  "j_member_order": {{
    "order_id":      1,
    "order_num":     "ORD{order_seq:08d}",
    "member_id":     {member_id},
    "venue_id":      1,
    "sport_id":      1,
    "status":        2,
    "is_pay":        1,
    "pay_way":       1,
    "cost":          298.00,
    "discount_amount": 0.00,
    "pay_amount":    298.00,
    "coupon_id":     null,
    "create_time":   "{now}",
    "pay_time":      "{pay_time}"
  }},
  "j_bill": {{
    "bill_id":       1,
    "member_id":     {member_id},
    "order_id":      1,
    "bill_type":     2,
    "amount":        298.00,
    "balance_after": 0.00,
    "created_time":  "{now}"
  }}
}}
仅输出 JSON，不要其他文字。"""


def step2_field_translation(decision: dict, member_id: int, order_seq: int) -> dict:
    print("  [层二] 调用 LLM 翻译字段值…")
    now      = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    pay_time = (datetime.now() + timedelta(minutes=random.randint(1, 10))).strftime(
        "%Y-%m-%d %H:%M:%S"
    )
    user_prompt = FIELD_USER_TPL.format(
        decision_json=json.dumps(decision, ensure_ascii=False, indent=2),
        member_id=member_id,
        order_seq=order_seq,
        now=now,
        pay_time=pay_time,
    )
    return call_llm(FIELD_SYSTEM, user_prompt, temperature=0.3)


# ── 写 CSV ──────────────────────────────────────────────────────────────

def write_csv(table_name: str, records: list, output_dir: Path):
    if not records:
        return
    fpath = output_dir / f"{table_name}.csv"
    with open(fpath, "w", newline="", encoding="utf-8-sig") as fh:
        writer = csv.DictWriter(fh, fieldnames=list(records[0].keys()))
        writer.writeheader()
        writer.writerows(records)
    print(f"  -> 写出 {len(records)} 行到 {fpath}")


# ── 主流程 ──────────────────────────────────────────────────────────────

def run():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"=== mini_example.py  Provider={PROVIDER} ===")
    print(f"Persona: {PERSONA['persona_id']} {PERSONA.get('name', PERSONA.get('persona_name', ''))}")
    print()

    # 步骤一：行为决策
    t0       = time.time()
    decision = step1_behavior_decision(PERSONA)
    print(f"  决策结果: {json.dumps(decision, ensure_ascii=False)}")
    print(f"  耗时 {time.time()-t0:.1f}s
")

    # 步骤二：字段翻译
    t1 = time.time()
    member_id = random.randint(1000, 9999)
    order_seq = 1
    if not decision.get("purchase_intent", True):
        print("  [跳过] Persona 无购买意向，跳过字段翻译。")
        return
    records = step2_field_translation(decision, member_id, order_seq)
    print(f"  耗时 {time.time()-t1:.1f}s
")

    # 步骤三：写 CSV
    all_records = {
        "j_member":       [records.get("j_member", {})],
        "j_member_order": [records.get("j_member_order", {})],
        "j_bill":         [records.get("j_bill", {})],
    }
    print("写出 CSV 到", OUTPUT_DIR)
    for table, rows in all_records.items():
        write_csv(table, rows, OUTPUT_DIR)

    total = time.time() - t0
    print(f"
完成！总耗时 {total:.1f}s，LLM 调用 2 次。")
    print("输出目录:", OUTPUT_DIR.resolve())


if __name__ == "__main__":
    run()
```

> **说明**
> - 仅需 `pip install python-dotenv requests`，无需安装完整项目依赖。
> - 两次 LLM 调用合计约 1500-2500 tokens（DeepSeek-chat 约 ¥0.003 人民币）。
> - 若要测试 OpenAI，修改 `.env` 中 `LLM_PROVIDER=openai`，确认 `OPENAI_API_KEY` 已填写。
> - `response_format: json_object` 需 DeepSeek V2.5+、GPT-4o/4o-mini 支持。


---

## 第8章  生成目标、执行清单与风险备案

---

### 8.1  三阶段生成目标与规模估算

| 阶段 | 目标行数/表 | 总行数（估算） | LLM 调用次数 | 预估耗时 | 用途 |
|:----:|:-----------:|:--------------:|:------------:|:--------:|:-----|
| **Phase 1**（验证阶段） | 50–200 | ~3 000 | ~400–800 次 | 10–30 分钟 | 冒烟测试、枚举校验、时序/金额逻辑验证、Prompt 调优 |
| **Phase 2**（中量阶段） | 1 000–5 000 | ~50 000 | ~8 000–15 000 次 | 3–8 小时 | 业务覆盖率验证、脏数据比例验证、StarRocks 灌库测试、可视化验证 |
| **Phase 3**（大量阶段） | 10 000+ | 500 000+ | ~100 000+ 次 | 24–72 小时 | 生产级模拟数据、冷启动填充、压测数据 |

**LLM token 估算（以 Phase 1 为例）**

- 每位会员：Prompt A（Persona 筛选）≈ 800 tokens
- 每次消费行为：Prompt C（决策）≈ 1 200 tokens + Prompt D（翻译）≈ 1 500 tokens
- 每 10 行质量检查：Prompt E ≈ 2 000 tokens
- 单会员全生命周期（≈5 次消费）≈ 800 + 5×2700 + 200 ≈ **14 500 tokens**
- 100 会员 Phase 1 合计 ≈ **1 450 000 tokens**（DeepSeek-chat 约 ¥2.9 人民币）

**并发策略**（Phase 2/3）

```
max_workers=8  # 建议 DeepSeek API 并发上限
每批 batch_size=10 人，批间 sleep 0.5s（避免 429 限流）
失败重试：指数退避，最多 3 次（见 LLMProvider.complete()）
```

---

### 8.2  Phase 1 执行清单

#### 环境准备

- [ ] Python 3.10+ 已安装，`pip install -r requirements.txt` 无报错
- [ ] `.env` 文件已配置 `DEEPSEEK_API_KEY`（或 `OPENAI_API_KEY`）
- [ ] `config.yaml` 已复制并按实际需求调整（`phase: 1`，`table_targets` 设置为 Phase 1 规模）
- [ ] `data/personas/wenti_personas.jsonl` 已由 `hub_adapter.py` 生成（条目数 >= 500）
- [ ] `prompts/` 目录下已放置 5 个 Prompt 文本文件（A–E）
- [ ] StarRocks 连接可选：若需测试推送，确认 `config.yaml` 的 `starrocks.enabled: true` 及连接参数
- [ ] **[M010]** 核实 vmdb 六张表的实际表名和关键字段（对照 `ods_wenti_starrocks.sql` 中 vmdb 相关 DDL），更新5.5节映射表，去除 `[待核实]` 标注后再执行批次11
- [ ] `logs/` 目录可写（自动创建）

#### 冒烟测试

- [ ] 运行 `python mini_example.py`，确认两次 LLM 调用均返回合法 JSON
- [ ] 检查 `mini_example_output/` 下出现 `j_member.csv`、`j_member_order.csv`、`j_bill.csv`
- [ ] 打开 CSV，确认字段齐全、`pay_time >= create_time`、`pay_amount == cost - discount_amount`
- [ ] 确认 `j_member_order.status` 值在 {1,2,3,4,5,6} 内，`pay_way` 值在 {1,2,3,4,5} 内

#### Phase 1 正式运行

- [ ] `python main.py --config config.yaml --phase 1`
- [ ] 观察终端日志，确认各 Batch 无报错退出
- [ ] 检查 `data/output/` 目录，确认 29 张表均有对应 CSV 文件
- [ ] 各表行数与 `config.yaml` 中 `table_targets` 一致（允许 ±5% 偏差）

#### 数据质量核查（统计）

- [ ] `j_member`：`sex_dist` 中男/女比例在 40/60–60/40 之间
- [ ] `j_member`：`source_dist` 分布合理，微信小程序占比最高（≥30%）
- [ ] `j_member_order`：`pay_way_dist` 中微信支付/支付宝合计占比 ≥60%
- [ ] `j_member_order`：`timing_errors = 0`（Phase 1 非脏数据记录不得出现时序倒置）
- [ ] `j_member_order`：已支付订单（`is_pay=1`）的 `pay_amount > 0` 率 = 100%
- [ ] `j_bill`：每条 `j_member_order` 对应至少一条 `j_bill`（外键完整性）
- [ ] `t_student`：`student_code` 格式均以 `STU` 开头
- [ ] 整体脏数据比例在 3%–7% 之间（目标 5%）

#### 数据质量核查（语义，可选）

- [ ] 抽取 `j_member_order` 前 10 行，人工核查场景逻辑是否自洽
- [ ] 运行 `QualityChecker.semantic_check()` 对 Phase 1 全量数据做 Prompt E 审查，`pass=true` 率 ≥90%
- [ ] 检查 Prompt E 输出的 `issues` 列表，定位高频问题后回溯 Prompt C/D 调整

#### StarRocks 推送（可选）

- [ ] 确认 StarRocks 中 `ods_wenti` 数据库及全部表结构已创建
- [ ] 开启 `starrocks.enabled: true` 后重新运行 `main.py --phase 1`
- [ ] 通过 StarRocks Web UI 或 `SELECT COUNT(*) FROM ods_wenti.j_member` 验证行数正确
- [ ] 确认 Stream Load 无 `FAILED` 状态（检查 `logs/simulator.log`）

#### 收尾

- [ ] 将 `data/output/` 归档，文件夹重命名为 `phase1_YYYYMMDD_HHMMSS`
- [ ] 将质量报告 JSON（`logs/qa_report_phase1.json`，由 `main.py` 写出）提交给数据负责人审阅
- [ ] 更新 Prompt A/C/D 中不合理的枚举或规则描述（若质量核查发现系统性问题）
- [ ] 记录本次运行的总 token 消耗和费用，更新 8.1 估算表

---

### 8.3  已知风险与缓解措施

**R001  LLM 枚举幻觉**
LLM 有时会输出不在枚举白名单内的字段值（如 `pay_way=6`、`status=0`）。
缓解：FieldTranslator 在调用 LLM 后做枚举白名单校验，非法值替换为最近合法值并记录
`_fix_applied=True`；Prompt D 头部重复强调枚举约束并附完整枚举表。

**R002  时序逻辑颠倒（pay\_time < create\_time）**
LLM 在翻译字段时偶尔生成不合理时间顺序。
缓解：FieldTranslator 后置校验：若 `pay_time < create_time`，自动将 `pay_time` 修正为
`create_time + randint(1,30)分钟`；DirtyInjector 的 D007 规则才是唯一合法的时序破坏入口。

**R003  跨系统主键不对齐**
`venue_id`、`member_id`、`phone` 在三个子系统间应能 JOIN，但若各 Batch 独立生成
可能产生孤儿引用。
缓解：严格按 2.3 节 DAG 批次顺序生成，后续批次从已生成记录中随机抽取 FK，
禁止随机生成未在字典表中登记的 ID；Batch 11 专用跨系统对齐校验步骤。

**R004  API 限流（429 Too Many Requests）**
DeepSeek/OpenAI 有并发和 TPM 上限，Phase 2/3 大量并发时容易触发。
缓解：`max_workers` 默认 8（可通过 `config.yaml` 调整），请求失败后指数退避重试
（1s→2s→4s，最多 3 次）；Phase 3 建议在低峰期（夜间）分批跑；监控 `X-RateLimit-*` 响应头。

**R005  Persona 权重偏差导致数据分布失真**
若 PersonaHub 筛选关键词偏向运动健身类，生成数据中高频运动用户比例可能严重偏高，
不能反映真实冷启动用户分布。
缓解：分层采样脚本（`scripts/stratified_sample_4800.py`）精确控制 j:t:v 比例，已实际产出 4800 条，j=60.1%/t=19.8%/v=20.1%；
若后续扩量仍发现分布偏差，在 `stratified_sample_4800.py` 的 TARGETS 字典中调整各系统配额后重新采样即可，无需重跑改造；
Phase 1 结束后核查 `sex_dist`/`source_dist`/`consumption_frequency` 分布，与业务方历史比例对比，偏差 >20% 时调整 `config.yaml` 的 `persona.system_weights` 后重跑。

**R006  Prompt Token 超限**
Prompt C/D 包含完整 Persona JSON + 枚举字典 + 场景描述，单次可能超过 4096 tokens，
导致截断。
缓解：Persona JSON 精简为只保留 8 个维度字段（去掉 `background` 详细描述）；
枚举字典从 Prompt 内联改为压缩格式（键=值列表）；Prompt D 按目标表拆分，
每次只翻译 2–3 张相关表而非全部 29 张。

**R007  脏数据规则冲突导致 Phase 1 质量误判**
D007（时序倒置）和 D004（状态矛盾）同时触发同一条记录时，quality\_checker 可能将
正常合规性问题（DirtyInjector 刻意制造的）误报为 Prompt 生成错误。
缓解：FileWriter 在输出时保留 `_is_dirty` 和 `_dirty_rule` 到 `dirty_records/` 子目录的
单独文件；`check_statistics()` 在计算错误率时排除已知脏记录（`_is_dirty=True`），
仅对清洁记录（`_is_dirty` 为空或 False）做合规性校验。

---

*文档结束。版本 v1.0，2026-08-07。*
*下一次更新：Phase 1 执行后根据实测结果修正 8.1 token 估算和 8.3 风险措施。*
