# 文体业务 AI/Agent 驱动数据模拟方案调研报告

**调研时间**：2026年8月5日  
**调研背景**：企业文体业务 ODS 建表完成（3078行SQL，含票务、优惠券、场馆、培训、商城、活动等8大业务域），需在正式接入企业系统前，通过 AI/Agent 方案生成高质量模拟数据，支撑后续数据清洗、填充、打标签等开发工作。  
**调研者**：Solar Pro4（Arena.ai Agent Mode）

---

## 目录

1. [文体业务数据架构简析](#一文体业务数据架构简析)
2. [数据模拟的核心诉求与挑战](#二数据模拟的核心诉求与挑战)
3. [AI/ Agent 数据模拟技术图谱（2025-2026）](#三ai-agent-数据模拟技术图谱2025-2026)
   - 3.1 基于 LLM 的结构化数据生成
   - 3.2 基于 Agent 的多角色behavioural模拟
   - 3.3 多 Agent 协作生成 pipeline
   - 3.4 本地模型驱动的私有化模拟
   - 3.5 传统生成式模型（GAN/VAE/CTGAN）与 AI 的混合
4. [主流工具与平台对比](#四主流工具与平台对比)
5. [面向文体业务的分层模拟架构设计](#五面向文体业务的分层模拟架构设计)
6. [标签设计前置：模拟数据如何赋能标签体系](#六标签设计前置模拟数据如何赋能标签体系)
7. [实施路线建议](#七实施路线建议)
8. [风险与注意事项](#八风险与注意事项)
9. [参考文献与信息源](#九参考文献与信息源)

---

## 一、文体业务数据架构简析

根据你提供的 `文体_ods_建表(1).sql`（来源数据库：jianengliang），文体 ODS 层涵盖以下核心业务域和代表性表结构：

| 业务域 | 代表表 | 关键字段 | 数据特征 |
|--------|--------|----------|----------|
| **票务 - 购票人** | `ods_wenti_jianengliang_buy_ticket_people` | member_id, num(证件号), name, phone, sex, id_card_status | 身份信息，1/2/3级验证状态 |
| **票务 - 剧场场次** | `ods_wenti_vmdb_theatre_ticket_sell_detail` | venue_id, sell_id, seat信息, status(-1锁定~4已过期), order_num, customer_phone/name, price, pay_amount, discount, third_type/order_num | 座位级交易明细，多状态流转，第三方订单关联（大麦/猫眼） |
| **票务 - 第三方订单** | `ods_wenti_vmdb_theatre_ticket_third_order` | sell_id, order_num, third_order_num, third_type, order_time, is_pay, is_cancel, total_amount, real_amount | 第三方支付流水，退票标记 |
| **优惠券 - 发放** | `ods_wenti_jianengliang_coupon_grant` | couponId, sceneType, status, transaction_type(1~6), share_num, user_range, user_type, bgId, merchant_id | 6类交易类型，用户范围/渠道过滤，礼包关联 |
| **优惠券 - 发放关联** | `ods_wenti_jianengliang_coupon_grant_ref` | grantId, userid, shareNum | 用户-优惠券多对多 |
| **优惠券 - 适用范围** | `ods_wenti_jianengliang_coupon_range` | traningVenueId/TypeId/CourseId, goodsTypeId/Id, venueId/Type, sportId, ticketId, activityTypeId/Id, couponId, mallTicket* | **跨域关联核心表**，覆盖培训/商品/场馆/运动/票务/活动6大颗粒度 |
| **优惠券 - 组合** | `ods_wenti_jianengliang_coupon_combination` + `_ref` | merchant_id, bgName, sceneType, codeId, typeDes | 礼包组合与关联 |

**架构特征**：
- **强关联性**：`coupon_range` 表是跨培训、商品、场馆、运动、票务、活动的多粒度适用范围，模拟时必须保证外键语义一致
- **状态流转**：票务状态(-1→4)、优惠券启用/禁用、验证状态(0~3)等枚举值需要符合业务逻辑分布
- **交易类型覆盖广**：1_全部、2_场馆、3_商城、4_票务、5_活动、6_培训，模拟数据需按类型分布生成
- **第三方集成**：大麦、猫眼等第三方订单号、用户信息需要独立生成且与内部订单保持映射关系

---

## 二、数据模拟的核心诉求与挑战

### 2.1 你面临的特殊挑战

| 挑战 | 传统方案的问题 | AI/Agent 方案的潜在优势 |
|------|----------------|--------------------------|
| **非业务专家** | 人工规则需基于对业务深刻理解，否则生成的规则本身就有偏差 | LLM 通过自然语言提示即可产出符合业务语义的多样化数据，无需预先编码规则 |
| **多表强关联** | 手工维护外键关系极易出错，尤其跨6个业务域的 `coupon_range` | Agent 可先生成"主表种子"，再基于外键依赖逐级生成关联数据，逻辑一致性更好 |
| **状态流转的真实性** | 随机枚举无法还原真实的状态分布（如退票率、验证失败率） | LLM 可基于对业务场景的理解生成符合概率分布的数据；也可通过多轮对话模拟用户行为路径 |
| **标签设计的探索性** | 规则固定的数据只能验证已知标签假设 | AI 生成的广度可以暴露意外的特征组合，帮助发现新的标签维度 |
| **冷启动阶段无真实数据** | GAN/CTGAN 等需要真实数据训练 | LLM 基于 Schema + 自然语言描述即可从零生成；也可先生成小规模种子再反馈给生成模型 |

### 2.2 模拟数据的预期用途

1. **数据清洗方案验证**：模拟包含脏数据的场景（如证件号格式错乱、手机号不合法、状态不一致），测试清洗规则
2. **数据填充方案验证**：测试在部分字段缺失、部分表为空的情况下，填充逻辑是否健壮
3. **标签设计探索**：通过观察 AI 生成的用户行为分布，发现潜在的用户分群维度和标签特征
4. **流水线集成测试**：为后续 ETL/ELT pipeline 提供可运行的测试数据集
5. **模型训练准备**：标签体系初步确定后，可继续扩展模拟数据用于初步模型训练

---

## 三、AI / Agent 数据模拟技术图谱（2025-2026）

### 3.1 基于 LLM 的结构化数据生成（Schema-Driven Generation）

这是目前最成熟、最易上手的 AI 数据模拟范式。核心思想：**将数据库 Schema（表名、字段、类型、注释、枚举值、关系）以自然语言 + 结构化提示的形式交给 LLM，要求其生成符合 Schema 的 JSON/CSV/SQL 插入数据**。

#### 典型工作流（参考 Microsoft Azure OpenAI 实践 [1]）

1. **System Message 定义**：你是数据生成引擎，需生成高质量、逼真、符合 Schema 的企业数据
2. **Schema 注入**：逐表提供字段名、类型、约束、枚举含义、注释（即你的 SQL COMMENT）
3. **Few-shot 示例**：提供 1-3 条符合业务逻辑的示例记录
4. **批量生成**：用 prompt 要求生成 N 条记录，格式为 JSON 数组
5. **后处理**：将 JSON 转换为 INSERT SQL 或加载到数据库

#### 优势
- **无需真实数据**：仅凭 Schema + 业务描述即可生成
- **语义理解能力**：LLM 能理解"场馆类型1_全部，2_订场，3_购票"这样的枚举含义，按正确分布生成
- **跨表一致性提示**：可在 Prompt 中说明表间关系（如"userid 需与 coupon_grant_ref 中的 userid 一致"）
- **快速迭代**：调整提示词即可改变数据分布、增加异常案例

#### 局限
- **单次生成长度限制**：一次性生成全量数据（尤其多表）可能超出 Context 限制
- **外键一致性需额外设计**：LLM 不 guarantee 同一个体在不同表中的 ID 一致，需分层生成策略
- **统计分布的可控性较弱**：难以精确控制"退票率为5%"这样的业务指标，除非显式提示

#### 代表实践
- **Microsoft Azure OpenAI**：Few-shot + JSON Mode 生成结构化员工数据，用于 HR Agent PoC [1]
- **Databricks Agent Evaluation Synthetic Data API**：输入文档/知识库，生成<问题, 答案, 来源>评估数据集，基于企业自有数据生成评估集 [7][8]
- **Tonic Fabricate Data Agent**：通过对话式界面描述需要的 schema、volume、distribution、relationship，AI Agent 自动生成完整的关系型数据库 [9][10]

---

### 3.2 基于 Agent 的多角色 Behavioural 模拟（Persona-Driven Simulation）

这是 2025-2026 年最前沿的方向之一。与"生成静态表记录"不同，**这种方式模拟的是"用户行为轨迹"**——即一个虚拟用户（Persona）如何与文体业务系统交互，产生了哪些操作数据。

#### 核心理论基础

- **Tencent Persona Hub**：从 web 数据中自动构建了 10 亿个多样化 Persona，每个 Persona 具有职业、爱好、消费习惯、 demographic 特征等。通过将不同 Persona 注入 LLM Prompt，可以生成极其多样化的行为数据 [11][12]
- **Customisable Conversation Agent Framework**（EMNLP 2025）：通过个性化特征注入，让 LLM 扮演特定角色进行多轮对话，所得对话数据可用于训练或评估 [13]

#### 在文体业务中的映射

可以设计如下虚拟 Persona 类别来生成符合业务语义的行为数据：

| Persona 维度 | 示例 | 产生的数据痕迹 |
|-------------|------|---------------|
| **消费意图** | 家庭亲子（买儿童电影票+优惠券）、学生群体（场地订场+团体折扣）、企业培训（场地+课程包） | 不同的 ticket_type、coupon_range 组合、场馆类型偏好 |
| **行为深度** | 浅层（只买票）、中层（买票+领券）、深层（买票+领券+分享+参加活动+报培训） | 多表关联数据的自然生成 |
| **价格敏感度** | 敏感型（大量使用优惠券、关注折扣）、忠诚型（全价、较少比价）、礼品型（购买礼包） | discount 分布、coupon 使用率差异 |
| **渠道偏好** | 小程序用户、IOS 用户、Android 用户、线下导入 | user_range 分布真实化 |
| **时间模式** | 工作日白天（场地租赁）、周末（票务+活动）、节假日峰值 | order_time/create_time 分布的自然模式 |
| **地理位置** | 不同城市/区域的用户，影响场馆选择、活动参与 | venue_id 的地域分布 |

#### 实现方式

**方案 A：单 Agent 模拟器（Future AGI fi.simulate 模式）**
- 定义 Persona（如"北京某中学体育老师，经常带学生租借场地，价格敏感"）
- 定义 Scenario（如"周五晚上为期末考试后的学生活动购买票务和优惠券"）
- Agent 扮演 Persona 与"文体业务系统"（可为另一个 LLM 扮演的 API）交互
- 记录交互产生的所有操作轨迹，映射为数据库插入记录
- 参考：Future AGI 的 fi.simulate 模块 [2][3]

**方案 B：多 Agent 对话演化（CrewAI / LangGraph 模式）**
- Agent 1（用户）：根据 Persona 决定本次要购买什么
- Agent 2（系统）：负责生成该操作对应的订单/券信息
- Agent 3（验证者）：检查生成的数据是否符合业务规则（如优惠券适用范围是否匹配）
- 多轮对话自然产生用户的"行为序列"，非常适合生成时序一致的多表数据

**方案 C：Agent 工作流生成（自研 CrewAI  Pipeline）**
```
[crewai.flow]  # 事件驱动流程模式（CrewAI 2025年新增 Flows）[14]
  ├─ 用户生成 Agent (Persona + 行为意图)
  │    └─ 输出: {"user_type": "学生", "intent": "周末看电影", "budget": 200}
  ├─ 订单生成 Agent (根据用户意图生成票务订单)
  │    └─ 输出: ods_vmdb_theatre_ticket_sell_detail 行
  ├─ 优惠券生成 Agent (根据用户画像和订单类型匹配可用的券)
  │    └─ 输出: ods_coupon_grant + _ref 行
  ├─ 第三方订单 Agent (模拟大麦/猫眼渠道)
  │    └─ 输出: ods_vmdb_theatre_ticket_third_order 行
  └─ 验证 Agent (检查跨表一致性、枚举值有效性、金额一致性)
       └─ 输出: 验证报告 + 修正建议
```

#### 优势
- **数据宽度天然大**：Persona 的组合空间极大，能够探索传统人工规则覆盖不到的边缘场景
- **行为序列天然一致**：同一虚拟用户的多个操作自然关联，无需手工维护外键
- **直接面向标签设计**：生成的 Persona 属性本身就可以作为标签候选（如"价格敏感型"、"企业培训采购者"）

---

### 3.3 多 Agent 协作生成 Pipeline（Agentic Workflows for Data Synthesis）

2024-2025 年涌现出大量研究探索"多个 LLM Agent 协作生成合成数据"的模式。代表性工作包括：

| 研究/项目 | 核心思想 | 对文体数据模拟的启发 |
|-----------|---------|---------------------|
| **AgentInstruct** (Microsoft, 2024) [15] | 通过 Agent 网络将原始内容（文档、代码）转化为 2500 万条指令-响应对，用于指令微调 | 可借鉴"原始规则 → Agent 解释 → 数据生成"的多阶段范式 |
| **ToolACE** (2024) [15] | 多 Agent 自演化合成复杂的工具调用（function calling）训练数据 | 文体业务中的"优惠券计算""场馆订座"等可抽象为工具调用，Agent 可生成包含工具调用轨迹的数据 |
| **MALLM-GAN** (2024) [15] | 多 Agent 大模型作为生成对抗网络，提升表格数据生成质量 | 多 Agent 相互校验的方式可提高生成数据的真实性 |
| **Concordia** (2026) [15] | 联邦 LLM 上的表格任务自我改进循环：用合成表训练 LoRA → 重加权样本 → 优化生成器 | 迭代优化合成数据质量的闭环思路 |
| **CausalSynth** (2026) [15] | 从结构因果模型构建因果骨架，用 LLM 作为受限实现器，迭代一致性验证 | 适合文体业务中"优惠券导致销量变化"这类因果关系的合成 |

#### 通用模式：生成 - 验证 - 修正循环

```
Agent Generator → 生成候选数据
       ↓
Agent Validator → 检查业务规则（枚举值、金额、正负号、时间先后、外键存在性）
       ↓
       如果失败 → Agent Fixer → 修正后重新验证
       ↓
    通过 → 输出到数据集中
```

#### 推荐框架选择（依据2026年综合评测 [14][16][17]）

| 框架 | 特性 | 适合文体数据模拟的方面 |
|------|------|------------------------|
| **CrewAI** | 角色+任务+crew 模型，流程预测性强，适合结构化 pipeline，YAML+Python 配置， Flows 支持事件驱动 | **首选**：文体数据模拟是结构化 pipeline，角色分工明确（用户生成、订单生成、券生成、验证），CrewAI 的角色模型天然匹配 |
| **LangGraph** | 有向图工作流，节点=函数/LLM 调用，边=控制流，状态通过 typed dict 传递， LangSmith 追踪调试能力强 | 若需要复杂的条件分支（如不同交易类型走不同生成逻辑）、循环修正，对可观测性要求高，则选 LangGraph |
| **AutoGen** | 对话式 Agent，GroupChat 模式，适合多 Agent 辩论/共识场景。注意：2026年已进入维护模式，微软战略重心转向 Agent Framework [14] | 若想用对话方式让多个 Agent 讨论"这条数据合理吗"，可作為補充，但不建议作為主框架 |
| **Microsoft Agent Framework** | AutoGen 的正式继任者，Azure 原生，支持任何提供方 | 若企业已在用 Azure，可考虑 |

---

### 3.4 本地模型驱动的私有化模拟

你提到**有本地服务器跑模型**，这是非常好的条件。使用本地模型进行数据模拟的优势：
- **数据零外泄**：生成过程完全在内网，避免将业务 Schema 发送到外部 API
- **成本可控**：无 API 调用费用，适合生成大规模数据
- **可定制**：可微调本地模型来更好理解文体业务的特定术语和规则

#### 适合本地部署的模型（2026年7月 기준 [18]）

| 模型 | 特点 | 本地部署门槛 | 适合数据生成任务 |
|------|------|-------------|-----------------|
| **Qwen3 / Qwen3.6** | Apache 2.0，强推理、编码、多语言（201种），262K上下文 | 较大模型（27B+）需要多卡，小模型（4B/8B）单卡可跑 | **推荐**：优秀的指令遵循能力适合 Schema 到数据的生成任务 |
| **gpt-oss-120b** | Apache 2.0，MoE (21B total / 3.6B active)，推理能力强 | 80GB GPU 或量化后较低 | 生成质量高，适合复杂关系的数据 |
| **DeepSeek V4 Flash/Pro** | MIT 许可，千万 token 上下文，强代码/推理 | API 为主，本地需要较大算力 | 如果有大算力，本地部署可实现高质量生成 |
| **Gemma 3 12B/27B** | Google 出品，128K 上下文，单 GPU riendli | 27B 需要较好 GPU，12B 较易部署 | 中等质量，部署容易 |
| **Phi-4-mini** | MIT，3.8B，128K 上下文，小机器也能跑 | 很低，CPU 都可勉强运行 | 作为验证/小规模测试使用 |

#### 本地部署基础设施

- **vLLM**：高吞吐、动态批处理、多 GPU 支持，是本地大规模生成的首选推理引擎 [19]
- **Ollama**：轻量级，本地快速部署，适合小规模原型验证
- **TGI (Text Generation Inference)**：HuggingFace 出品，生产级部署

#### 混合策略建议

```
[外部 LLM (GPT-5.4/Claude)]  → 生成高质量种子数据、设计 Persona 模板、验证规则
         ↓
[本地 LLM (Qwen3/Distill)]  → 大规模扩展生成、批量填充、离线产生海量测试数据
         ↓
[传统工具 (SDV/Gretel)]     → 如有少量真实数据，可用作统计分布校准
```

---

### 3.5 传统生成式模型（GAN/VAE/CTGAN）与 AI 的混合

虽然你强调不想用"人工规则写入"的传统方法，但传统生成式模型在某些环节仍可与 AI 方法互补：

| 方法 | 适用场景 | AI 结合方式 |
|------|---------|------------|
| **SDV (CTGAN / GaussianCopula / TVAE)** [20][21] | 有少量真实数据时，学习统计分布生成结构相似的数据 | 用 AI 生成少量高质量种子 → SDV 学习分布 → 大规模生成；或用 SDV 生成的统计分布来校准 AI 生成的分布 |
| **Gretel (NVIDIA 收购，Amplify/Transformer模型)** [22] | 隐私敏感的表格/文本/时间序列合成，差分隐私保障 | Gretel 的 Relational MultiTable 模型支持外键关系的多表合成 [23]，适合文体业务的多表场景 |
| **MOSTLY AI** [24] | 企业级表格合成，SD Metrics 评估 | 适合对合成数据质量有正式评估需求的场景 |
| **Tonic Structural + Fabricate** [9][10] | 从现有数据库去标识化 + 从零生成关系型数据库 | Fabricate 的 Data Agent 可通过对话生成完整数据库，结合 Structural 处理已有数据 |

**混合策略示例**：
- 先用 LLM 从零生成一批高质量的"种子数据"（如1000条用户、100个场馆、50个优惠券）
- 将种子数据（尤其是用户行为相关的）作为 SDV/Gretel 的训练输入，学习其分布
- 用训练好的生成模型大规模扩展，同时保持业务关系

---

## 四、主流工具与平台对比

### 4.1 综合对比矩阵

| 工具/平台 | 类型 | 数据形态 | 是否需要真实数据 | Agent/LLM 原生 | 外键/多表支持 | 私有化部署 | 成本 | 适合文体场景的方面 |
|-----------|------|----------|-----------------|---------------|--------------|-----------|------|-------------------|
| **自研 CrewAI/LangGraph Pipeline** | 代码框架 | 表格 + 行为序列 | 否（可选） | **是** | 可编程控制 | 本地 | 仅算力成本 | 灵活度最高，可完全贴合文体业务逻辑 |
| **Future AGI (fi.simulate)** [2][3] | 云平台 | 对话/行为轨迹 + 评分 | 否 | **是** (Persona 驱动) | 行为数据形式 | 云 (BYOK) | 商业 | 直接产出带评分的行为数据集，适合后续标签设计探索 |
| **Tonic Fabricate Data Agent** [9][10] | 云平台 | 关系型数据库 | 否（也可连接真实数据） | **是** (对话式) | **强** (完整 referential integrity) | 部分 | 商业 (有免费 tier) | 可直接从 Schema 描述生成完整关系数据库，省去外键编程 |
| **Databricks Agent Evaluation Synthetic Data API** [7][8] | 云平台 | 评估数据集 (Q-A-文档) | 是 (企业自有数据) | **是** | 文档级 | 云 (Databricks) | 商业 | 更适合评估数据集生成，非业务模拟数据 |
| **SDV (开源)** [20][21] | Python库 | 表格/多表/时序 | **是** (需要种子数据) | 否 (传统ML) | **强** (HMA1多表模型) | 本地 | 免费 (MIT/BSL) | 若有少量真实数据，可快速学习分布生成大量数据 |
| **Gretel (NVIDIA)** [22][23] | 云+SDK | 表格/文本/时序 | 是 (用于训练生成器) | 部分 (文本) | **强** (Relational MultiTable) | 混合 | 商业 (NVIDIA) | 差分隐私保障，适合敏感数据场景 |
| **MOSTLY AI** [24] | 云 + SDK (Apache 2.0) | 表格 | 是 | 否 | 强 | 混合 | 商业 | 企业级质量评估报告 |
| **NVIDIA Data Designer (NeMo)** [10] | 开源框架 | 表格/文本 | 否 (也可种子) | 是 (LLM+统计) | 支持 | 本地 | 免费 (Apache 2.0) | 开发者导向，Python 框架，内置验证和 LLM-as-judge |
| **Faker / Mockaroo** | 库/工具 | 简单表格 | 否 | 否 | 弱 | 本地 | 免费 | 仅作基础字段生成补充（如姓名、手机号） |

### 4.2 针对文体业务的推荐组合

| 目标 | 推荐工具/方法 | 理由 |
|------|---------------|------|
| **从零生成全套模拟数据库（含外键一致性）** | Tonic Fabricate Data Agent 或 自研 CrewAI Pipeline | Fabricate 可以对话式生成完整关系库；CrewAI 可完全自定义业务逻辑 |
| **生成用户行为轨迹以探索标签维度** | 自研 CrewAI/LangGraph + Persona 设计 或 Future AGI fi.simulate | Persona 驱动能产生行为多样性，直接产出标签候选 |
| **大规模低成本扩展生成** | 本地 Qwen3 + vLLM 批量生成 | 本地模型零 API 费，适合生成十万级以上记录 |
| **统计分布校准** | SDV 或 Gretel，以 AI 生成的种子为训练数据 | 混合使用可兼顾语义 richness 和统计真实性 |
| **生成异常/脏数据用于清洗方案测试** | LLM 提示中显式要求"生成包含如下错误的数据..." | LLM 天然擅长生成边缘案例和错误模式 |
| **验证数据质量** | SDMetrics (SDV) / MOSTLY AI SD Metrics / 自定义 LLM 校验 Agent | 多重验证保证数据可用性 |

---

## 五、面向文体业务的分层模拟架构设计

以下是一个具体的分层生成架构建议，综合了上述技术：

```
┌──────────────────────────────────────────────────────────┐
│                  第0层：Schema与业务知识注入                │
│  · 文体ODS建表SQL全文（表名、字段、类型、注释、枚举值）      │
│  · 业务领域描述（文体业务是什么、各业务域如何关联）           │
│  · 核心业务规则（优惠券适用范围逻辑、交易类型分类、状态流转）   │
│  · 参考真实数据分布（如有）（用户年龄、消费金额、渠道分布等）   │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│                第1层：枚举值与参考数据生成                   │
│  目标：生成所有"字典表"级别的基础数据，为后续关联提供素材      │
│                                                          │
│  生成内容：                                              │
│  · 场馆字典 (venue_id, venue_name, venuType, 地址, 容量...) │
│  · 运动类型字典 (sportId, sport_name)                      │
│  · 培训基地/类型/课程字典 (traningVenueId, traningTypeId...)│
│  · 商品类型/商品字典 (goodsTypeId, goodsId, 商品名, 价格...)  │
│  · 活动类型/活动字典 (activityTypeId, activityId...)        │
│  · 票价字典 (price_id, 场次, 价格, 折扣...)                │
│  · 商户字典 (merchant_id, 商户名, 类型...)                  │
│  · 优惠券模板 (couponId, 类型, 面值, 条件, 有效期...)        │
│                                                          │
│  方法：LLM (提示词中说明各字典项的语义，要求生成符合中国文体   │
│       市场特征的参考数据，如场馆名称涵盖"体育馆/舞蹈室/羽毛球厅"│
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│             第2层：用户 Persona 生成 (标签种子)              │
│  目标：生成具有多维度特征的虚拟用户群体，直接服务于标签设计    │
│                                                          │
│  生成内容：每条用户记录包含显式和隐式标签属性：              │
│  · 人口统计：年龄段、性别、所在城市/区                     │
│  · 消费特征：价格敏感度(敏感/中等/忠诚)、人均消费、消费频次   │
│  · 行为偏好：偏好的运动类型、场馆类型、活动类型、培训类型      │
│  · 渠道特征：注册渠道(小程序/IOS/Android/线下)、活跃时段    │
│  · 券使用行为：优惠券领取率、使用率、分享行为              │
│  · 生命周期：新注册(0-1月)、成长(1-3月)、成熟(3-12月)、流失  │
│                                                          │
│  方法：基于 Persona Hub 思想，设计文体业务专属 Persona 模板  │
│       每条 Persona 记录即作为用户标签的候选维度              │
│  规模：先生成 100-500 条高质量 Persona，供标签设计讨论       │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│         第3层：行为事件生成 (核心多表数据)                   │
│  目标：按 Persona 的特征，生成自然关联的多表交易/操作数据    │
│                                                          │
│  Agent 分工 (CrewAI 角色示例)：                            │
│                                                          │
│  [用户行为 Agent] → 决定本次交互意图                         │
│    输入：Persona 特征 + 当前时间上下文                      │
│    输出：{"action": "购买票务+领取优惠券", "场次ID": 12,      │
│           "选择优惠券": true, "第三方渠道": "大麦"}          │
│                                                          │
│  [订单生成 Agent] → 根据行为生成订单明细                     │
│    输入：用户行为决策 + 场馆/票价字典 + 座位信息              │
│    输出：ods_vmdb_theatre_ticket_sell_detail 行             │
│          (座位号、价格、折扣、状态等真实分布)                 │
│                                                          │
│  [第三方订单 Agent] → 模拟大麦/猫眼渠道                      │
│    输入：订单信息 + 第三方类型                              │
│    输出：ods_vmdb_theatre_ticket_third_order 行             │
│                                                          │
│  [优惠券发放 Agent] → 根据用户和订单生成优惠券              │
│    输入：用户特征、订单类型、优惠券模板字典                   │
│    输出：ods_coupon_grant + ods_coupon_grant_ref 行         │
│    (注意：coupon_range 中的适用范围需与订单的场馆/活动/培训等  │
│     类型匹配，这是本架构中最复杂的一致性要求)                 │
│                                                          │
│  [验证 Agent] → 跨表一致性和业务规则检查                     │
│    检查项：枚举值有效性、金额一致性(order.pay_amount vs        │
│    third_order.real_amount)、外键存在性、时间先后顺序、优惠券   │
│    适用范围与订单类型匹配                                   │
│    输出：验证通过/失败及具体问题清单                         │
│                                                          │
│  方法：CrewAI Sequential/Hierarchical Process 或             │
│       LangGraph 有向图工作流，验证失败则回退给对应 Agent 重试  │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│          第4层：数据后处理与质量评估                          │
│                                                          │
│  · 插入 SQL 生成：将 JSON/CSV 数据转换为 INSERT 语句         │
│  · 统计分布检查：生成数据的各字段分布是否合理                │
│    (如交易类型1-6的比例、状态分布、折扣分布)                 │
│  · 一致性检查：外键完整性、优惠券范围匹配性                  │
│  · 去重和多样性检查：避免生成大量雷同记录                    │
│  · 合成数据质量评估：SDMetrics / 自定义 LLM 裁判             │
│                                                          │
│  输出：可直接加载到 ODS 测试库的 SQL 文件或数据文件            │
└──────────────────────────────────────────────────────────┘
```

---

## 六、标签设计前置：模拟数据如何赋能标签体系

这是你特别指出的**核心目的**。模拟数据不仅仅是为了测试，更是为了**通过观察数据的广度来启发标签设计**。

### 6.1 从模拟数据中发现标签维度的思路

#### 思路一：从 Persona 属性中提取显式标签

在第2层生成的 Persona 本身就是候选标签：

| Persona 属性 | 可直接转化的标签 | 标签值示例 |
|-------------|-----------------|------------|
| 价格敏感度 | `user_price_sensitivity` | 敏感型、普通型、忠诚型 |
| 偏好运动类型 | `user_pref_sport` | 羽毛球、篮球、舞蹈、戏剧... |
| 生命周期阶段 | `user_lifecycle_stage` | 新客(0-1M)、成长(1-3M)、成熟(3-12M)、流失(>12M未活动) |
| 渠道偏好 | `user_channel_pref` | 小程序为主、IOS为主、Android为主、线下为主 |
| 活跃时段 | `user_active_period` | 工作日白天、工作日晚间、周末全天、节假日 |
| 消费层级 | `user_consume_tier` | 低消(<100元/次)、中消(100-500)、高消(500-2000)、超高消(>2000) |
| 优惠券依赖度 | `user_coupon_dependency` | 高依赖(订单都用券)、中依存、低依赖(极少用券) |

#### 思路二：从 Agent 生成的行为序列中发现隐式标签

通过观察虚拟用户的实际行为轨迹，可以归纳出意料之外的行为模式：

| 观察到的行为模式 | 可能的标签含义 | 业务价值 |
|-----------------|---------------|----------|
| "学生团体——订场+购买多张票+使用团体券+分享给同学" | **团体组织者**标签 | 可针对此类用户设计团体套餐、分享有奖 |
| "企业行政——反复订场+购买培训课程+使用大额礼包券" | **企业采购客户**标签 | B2B 客户识别与专属运营 |
| "家庭家长——周末带孩子看演出+使用亲子优惠券+跨场馆消费" | **亲子家庭用户**标签 | 家庭套餐、亲子活动推荐 |
| "价格极端敏感——只在打折时购买+只用最高折扣券+从不分享" | **纯价格驱动型** | 折扣策略优化，避免利润损失 |
| "高频商城购买+极少票务消费" | **商城导向用户** | 商品推荐、商城优惠券策略 |
| "第三方渠道(大麦)用户——只通过大麦购票，从不直接购买" | **第三方依赖用户** | 第三方渠道策略、直接转化运营 |

#### 思路三：通过数据探索性分析发现意外的特征组合

生成大量模拟数据后，可以通过数据分析发现一些有趣的相关关系：

- 哪些运动类型 + 哪些优惠券组合最容易导致高消费？
- 什么时间段的退票率最高？是否与某些活动类型相关？
- 第三方渠道用户与直销用户在消费金额上有无显著差异？
- 领取优惠券但未使用的人群，其后续转化特征是什么？

这些探索性发现可以直接转化为新的标签维度。

### 6.2 模拟数据驱动标签设计的工作流

```
生成模拟数据 → 数据探索分析 → 发现候选标签 → 与业务方讨论确认 →
更新标签体系 → 基于新标签生成更多针对性模拟数据 → 验证标签有效性
```

**关键点**：这是一个**迭代循环**的过程。AI 生成的数据越多样化，发现的候选标签就越丰富；标签体系越完善，生成的数据就可以越有针对性。

---

## 七、实施路线建议

### 7.1 分阶段推进

#### 阶段 0：准备阶段（1周）
- [ ] 整理文体 ODS 建表 SQL 中的所有表结构、字段类型、枚举值、注释，制作成结构化的 Schema 文档（JSON/Markdown）
- [ ] 列出已知的业务规则（如优惠券适用范围的匹配逻辑、交易类型定义、状态流转规则），哪怕不完整也先记录
- [ ] 整理供应商 API 可以提供哪些基础数据（如场馆列表、商品目录等），可以作为模拟数据的参考
- [ ] 评估本地服务器的算力，选择合适的本地 LLM 模型

#### 阶段 1：MVP - 从零生成小规模种子数据（2-3周）
- [ ] 使用 LLM (可先用外部 API 如 GPT-5.4/Claude，再迁移到本地) 基于 Schema 生成各"字典表"的基础数据（场馆、商品、票价、优惠券模板等），生成 50-200 条/类
- [ ] 设计 50-100 个文体业务 Persona 模板，覆盖不同用户类型
- [ ] 使用 CrewAI 构建基础 Pipeline：用户行为 Agent + 订单生成 Agent + 验证 Agent，生成100-500条多表关联记录
- [ ] 验证数据的一致性和合理性，调整提示词和 Pipeline 逻辑
- [ ] **输出**：可加载的测试数据 + 初步的 Persona/标签候选列表

#### 阶段 2：扩大规模 + 深化行为模拟（3-4周）
- [ ] 将阶段1中的 Pipeline 迁移到本地 LLM (如 Qwen3 + vLLM) 以实现大规模批量生成
- [ ] 增加更多 Persona 维度和行为模式，扩大数据多样性
- [ ] 增加异常/脏数据生成 Agent，专门生成用于清洗方案测试的边缘案例
- [ ] 引入数据质量评估环节（SDMetrics 或自定义 LLM 裁判）
- [ ] **输出**：大规模模拟数据集（千万级记录）+ 丰富的标签候选清单

#### 阶段 3：标签设计工作坊 + 数据迭代（2-3周）
- [ ] 基于模拟数据和 Persona 清单，组织标签设计讨论（内部或与业务方）
- [ ] 初步确定标签体系，设计标签计算逻辑
- [ ] 基于确定的标签体系，生成更多针对性模拟数据，验证标签计算的正确性
- [ ] 为后续数据清洗/填充方案的开发提供完整的测试数据集
- [ ] **输出**：初步标签体系 + 验证通过的标签计算逻辑 + 全套测试数据

#### 阶段 4：持续运营（长期）
- [ ] 在真实数据接入后，用真实数据校准/替代模拟数据中的统计分布
- [ ] 保留 Agent Pipeline 作为数据开发的测试数据生成工具，持续为新功能开发提供测试数据
- [ ] 根据新发现的业务场景，扩展 Persona 库和行为模式

### 7.2 技术栈建议

| 环节 | 推荐技术 | 理由 |
|------|---------|------|
| **Agent 框架** | CrewAI (Python) | 角色模型贴合文体业务的多 Agent 分工，Flows 支持事件驱动，学习曲线适中 |
| **本地 LLM 推理** | vLLM + Qwen3 (或 Qwen3.6) | 高吞吐、Apache 2.0、本地私有、指令遵循能力强 |
| **辅助数据生成** | Faker (Python) | 生成基础的姓名、手机号、地址等，作为 LLM 生成的补充 |
| **质量评估** | SDMetrics (SDV 生态) + 自定义验证 Agent | 统计指标 + 语义校验双重保障 |
| **数据存储/处理** | pandas + SQLAlchemy + SQLite/MySQL 测试库 | 灵活处理和加载生成的数据 |
| **提示词管理** | 结构化的 YAML/JSON prompt 模板 + 版本控制 | 便于迭代和复现 |

---

## 八、风险与注意事项

### 8.1 数据质量风险

| 风险 | 缓解策略 |
|------|----------|
| **LLM 生成的枚举值超出定义范围** | 在验证 Agent 中严格检查所有枚举字段；在提示词中显式列出所有合法枚举值 |
| **跨表外键不一致** | 分层生成策略：先生成"被引用表"的数据（如场馆、用户），再生成"引用表"的数据（如订单），引用时使用已生成的 ID |
| **金额计算不一致**（如订单金额 vs 第三方订单金额 vs 折扣后金额）| 验证 Agent 中添加数值校验规则；或在生成时由 Agent 计算而非自由生成 |
| **优惠券适用范围语义错误**（核心风险） | 在验证 Agent 中实现优惠券范围匹配逻辑的简化版本；或在生成订单的 Agent 中约束其选择的优惠券必须匹配 |

### 8.2 业务语义风险

| 风险 | 缓解策略 |
|------|----------|
| **生成的数据看似合理实则不符合业务逻辑** | 邀请业务方抽查生成的数据；迭代调整提示词和验证规则 |
| **Persona 设计存在偏见或刻板印象** | Persona 模板 design review；确保覆盖不同年龄、性别、地域、消费能力的用户 |
| **过度依赖 AI 生成的"合理性"，错过真实数据中的关键模式** | 模拟数据只能作为探索工具，真实数据接入后必须进行对比分析，发现模拟数据未覆盖的模式 |

### 8.3 技术实施风险

| 风险 | 缓解策略 |
|------|----------|
| **Prompt engineering 迭代效率低** | 将提示词结构化、模块化，便于批量调整和测试 |
| **CrewAI/LangGraph 调试复杂度高** | 从简单的 2-3 个 Agent 开始，逐步增加复杂度；充分利用 CrewAI 的日志和 LangSmith 的追踪能力 |
| **生成数据量与成本平衡** | 先用外部 LLM 进行提示词设计和小规模验证，确认效果后再迁移到本地模型进行大规模生成 |
| **模拟数据真实性不足以支撑模型训练** | 明确模拟数据的用途边界：用于测试/探索/标签设计，不用于最终模型训练（除非经严格验证） |

---

## 九、参考文献与信息源

- [1] Microsoft Tech Community. *Kickstarting AI Agent Development with Synthetic Data: A GenAI Approach on Azure*. 2025-03-31. https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/kickstarting-ai-agent-development-with-synthetic-data-a-genai-approach-on-azure/4399235
- [2] Future AGI. *Top 5 Synthetic Dataset Generators in 2026: Ranked for Production*. 2026-05-14. https://futureagi.com/blog/top-5-synthetic-dataset-generators-2025/
- [3] Future AGI. *Build Reliable Multi-Agent AI Flows with Future AGI in 2026*. 2026. https://futureagi.com/blog/build-multi-agent-ai-future-agi-2025/
- [4] Future AGI. *Synthetic Data for AI in 2026: Guide + Best Tools*. 2026-05-14. https://futureagi.com/blog/synthetic-data-guide/
- [5] Syncora.ai. *How Agentic Infrastructure is Revolutionizing Synthetic Data*. 2025-08-28. https://www.syncora.ai/blogs/how-agentic-infrastructure-revolutionizes-synthetic-data-2025
- [6] XenonStack. *Synthetic Data Generation with Agentic AI*. 2025-09-04. https://www.xenonstack.com/blog/synthetic-data-generation
- [7] Databricks Blog. *Streamline AI Agent Evaluation with New Synthetic Data Capabilities*. 2026-06-03. https://www.databricks.com/blog/streamline-ai-agent-evaluation-with-new-synthetic-data-capabilities
- [8] InfoWorld. *Databricks unveils synthetic data generation API to help evaluate agents faster*. 2025-09-15. https://www.infoworld.com/article/3620901/databricks-unveils-synthetic-data-generation-api-to-help-evaluate-agents-faster.html
- [9] Tonic.ai. *Synthetic Data for Agentic Workflows: A Guide*. 2026-01-16. https://www.tonic.ai/guides/synthetic-data-for-agentic-ai-workflows
- [10] Tonic.ai. *Best Synthetic Data Generation Tools Compared for 2026*. 2026-04-30. https://www.tonic.ai/blog/synthetic-data-generation-tools
- [11] Tencent AI Lab. *Persona Hub: A Collection of 1 Billion Diverse Personas*. 2024-07-08. https://github.com/tencent-ailab/persona-hub
- [12] arXiv. *Synthetic Founders: AI-Generated Social Simulations for Startup Validation*. 2025-09. https://arxiv.org/html/2509.02605v1
- [13] Yang et al. *Crafting Customisable Characters with LLMs: A Persona-Driven Role-Playing Agent Framework*. EMNLP 2025 Findings. https://aclanthology.org/2025.findings-emnlp.1100/
- [14] Dev.to. *CrewAI vs LangGraph vs AutoGen: Which Multi-Agent Framework Should You Use in 2026?* 2026-04-30. https://dev.to/emperorakashi20/crewai-vs-langgraph-vs-autogen-which-multi-agent-framework-should-you-use-in-2026-5h2f
- [15] GitHub. *LLM_based_Synthetic_Data_Generation: A curated collection of papers, tools, and datasets*. https://github.com/ahmad-alismail/LLM_based_Synthetic_Data_Generation
- [16] Adopt.ai. *Multi-Agent Frameworks Explained for Enterprise AI Systems [2026]*. 2026-02-26. https://www.adopt.ai/blog/multi-agent-frameworks
- [17] Kunal Ganglani. *AutoGen vs CrewAI 2026: Which Framework Wins?* 2026-07-02. https://www.kunalganglani.com/blog/autogen-vs-crewai
- [18] HuggingFace Blog. *The Best Open Source and Open-Weight LLM Models to Run Locally in 2026*. 2026-07-27. https://huggingface.co/blog/daya-shankar/open-source-llm-models-to-run-locally
- [19] Reddit r/LocalLLaMA. *Synthetic data generation via open source LLM*. 2024-09-28. https://www.reddit.com/r/LocalLLaMA/comments/1frqihm/synthetic_data_generation_via_open_source_llm/
- [20] SDV (Synthetic Data Vault). *Welcome to the SDV!*. https://docs.sdv.dev/sdv
- [21] GitHub. *sdv-dev/SDV: Synthetic data generation for tabular data*. https://github.com/sdv-dev/SDV
- [22] Future AGI. *Top Synthetic Data Companies Driving AI Innovation*. 2026-07-18. https://www.econmarketresearch.com/blog/top-synthetic-data-companies
- [23] Medium (Moez Karim). *Revolutionizing Data Privacy: Generate Synthetic Databases with Gretel Relational*. 2023-05-10. https://moez-62905.medium.com/revolutionizing-data-privacy-generate-synthetic-databases-with-gretel-relational-3232e534dc58
- [24] MOSTLY AI. *Synthetic Data SDK (Apache 2.0)*. Open-sourced late 2024. https://mostly.ai
- [25] Polaris Market Research. *Synthetic Data Generation Market Size*. 2026-06-26. https://www.polarismarketresearch.com/industry-analysis/synthetic-data-generation-market
- [26] Freeform Agency. *Synthetic Data Generation: A Guide for Enterprises in 2026*. 2026-07-14. https://www.freeformagency.com/post/synthetic-data-generation
- [27] BuildMVPFast. *Synthetic Data 2026: Tools, Use Cases, and Risks*. 2026-03-19. https://www.buildmvpfast.com/blog/synthetic-data-ai-training-generation-tools-2026
- [28] Salesforce Architect. *The Agentic Enterprise - The IT Architecture for the AI-Powered Enterprise*. https://architect.salesforce.com/docs/architect/fundamentals/guide/agentic-enterprise-it-architecture.html
- [29] 文体 ODS 建表脚本: https://github.com/jerryloopback-hash/temp/blob/main/文体_ods_建表(1).sql

---

*报告生成于 2026年8月5日 | Arena.ai Agent Mode | Solar Pro4*
