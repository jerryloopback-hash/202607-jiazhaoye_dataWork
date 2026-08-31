# 实施日志

> 项目：佳兆业文体数据模拟实施  
> 工作目录：`202607-佳兆业项目数据调研\20260810-数据模拟实施`  
> 规范文档：[数据模拟实施Hub.md](数据模拟实施Hub.md) v1.2  
> 日志维护：Claude Code 自动记录，敏感操作/不确定决策需标注 ⚠️

---

## 格式说明

每条记录格式：
```
### YYYY-MM-DD HH:MM [阶段] 事件标题
内容描述
决策说明（如有）
```

标签：`[决策]` = 不确定决策；`[敏感]` = 可能影响文件/数据的操作；`[问题]` = 遇到的问题；`[确认]` = 已验证的事实

---

## 2026-08-10

### 08:48 [P0-0] 工作目录初始化

**操作**：建立项目目录骨架
```
20260810-数据模拟实施/
├── scripts/                        # 工具脚本
├── prompts/                        # LLM Prompt 模板
├── wenti_data_simulator/
│   ├── data/personas/              # 数据文件
│   └── persona/                    # Persona 模块
├── LOG.md                          # 本文件
├── README.md                       # 已存在
└── PLAN.md                         # 已存在
```

**环境确认**：
- Python: 3.14.3（D:\devWorkshopForCC\.venv）
- Ollama 已启动，可用模型：
  - `qw35_dsv4pro_9b_mtp:latest`（9.3GB）
  - `qwythos-9b-mtp:latest`（10.0GB）
  - `qwopus-3.6-27b-v2-mtp:latest`（13.8GB）

**[决策] Ollama 模型选择**：
- PLAN.md 推荐 `qwen2.5:7b`，但本地未安装
- 实际可用最接近的为 `qw35_dsv4pro_9b_mtp:latest`（9B 量级，推测为 qwen3.5/dsr4 混合微调版）
- 选用 `qw35_dsv4pro_9b_mtp:latest` 作为默认改造模型
- hub_adapter.py 的 `OLLAMA_MODEL` 常量更新为此名称
- ⚠️ 若改造质量不达标（JSON 验证通过率 < 80%），可切换 `qwythos-9b-mtp:latest` 重测

### 08:48 [P0-1] 安装 Python 依赖

**操作**：`pip install datasets huggingface_hub faker python-dotenv`

**结果**：全部安装成功
- datasets 5.0.1
- huggingface_hub 1.27.0
- Faker 40.36.0
- python-dotenv 1.2.2
- pandas 3.0.5（依赖）

> ⚠️ 安装过程中出现 `[WinError 32]` 文件锁错误（pandas tests 目录），但实际包已正常安装，验证通过。

### 09:25 [P0-1] 项目目录骨架创建完成

```
scripts/                  <- P0 工具脚本
prompts/                  <- Prompt 模板
wenti_data_simulator/
  data/personas/          <- 数据目录
  persona/                <- Persona 模块
```

## 2026-08-11

### 09:30 [P0-4] Ollama 链路 dry-run 验证

**[决策] 模型选择**：PLAN.md 推荐 `qwen2.5:7b` 本地未安装，改用 `qw35_dsv4pro_9b_mtp:latest`（9.3GB）

**[问题] 超时排查**：首次 dry-run（workers=3）全部超时。
- 根因：Ollama 串行处理请求，3个并发线程排队导致后两条超过 120s timeout
- 修复：`timeout 120s → 300s`，`workers 默认值 3 → 1`

**验证结果（修复后 dry-run 3条）**：
```
[1/3] OK  P_HUB_0000 | A 28-year-old office worker who enjoys swimming...
[2/3] OK  P_HUB_0001 | A 35-year-old parent who enrolls his 8-year-old...
[3/3] OK  P_HUB_0002 | A 22-year-old college student who loves badminton...
改造完成：成功 3 条，失败 0 条
JSON验证通过率：100.0% [OK]
```
分布 WARN 是3条样例量太小的正常现象，非问题。

**结论**：Ollama 链路可用，hub_adapter.py 正常工作，P0-4 脚本就绪。

### 09:35 [P0-2] PersonaHub 下载完成

**操作**：`python scripts/download_persona_hub.py`  
**结果**：200,000 条，21MB → `wenti_data_simulator/data/personas/persona_hub_raw.jsonl`  

注意事项（已修复到脚本）：
- `trust_remote_code=True` 在新版 datasets 中废弃，PersonaHub 已是标准 Parquet，去掉即可
- 符号链接警告（Windows symlink 降级）：不影响功能，仅缓存效率略低

### 09:40 [P0-3] 关键词筛选完成

**操作**：`python scripts/filter_personas.py`  
**结果**：200,000 → **63,493 条**（31.7%）→ `persona_hub_candidates.jsonl`

**注意**：PersonaHub 字段名为 `persona`（非 `input_persona`）。  
hub_adapter.py 中已用 `raw.get("input_persona", raw.get("persona", ""))` 兼容处理，无需修改。

**[决策] 候选量 63K 条远超目标（500-2000），正式改造取前 2000 条**  
理由：关键词偏宽泛，覆盖了医疗、法律等非文体场景；通过 `--limit 2000` 限制，后续如需补充特定人群可增加条数。

### 10:15 [P0-4] API调试 — Qwen3 thinking 模式问题排查

**[问题]** 首次 dry-run 失败：`content=None`，`finish_reason=length`
- 根因：Qwen3.6-35B 默认开启 thinking 模式，推理 token 占满 `max_tokens`，content 无法输出
- 尝试1：顶层 `enable_thinking: False` → 无效（vllm 0.26.0 不支持此顶层参数）
- 尝试2：`chat_template_kwargs: {"enable_thinking": False}` → **有效**，content 正常输出
- 最终修复：`chat_template_kwargs` 参数 + `max_tokens=2048`

### 10:35 [P0-4] 200条改造完成

**结果**：成功 200/200，失败 0，JSON验证通过率 **100%**
**产出**：`wenti_data_simulator/data/personas/wenti_personas.jsonl`（200 条）

**分布统计**：

| 维度 | 结果 | 目标 | 状态 |
|------|------|------|------|
| jianengliang | 81.0% (162条) | 45%-65% | ⚠️ 偏高 |
| training | 11.0% (22条) | 12%-28% | 基本达标 |
| vmdb | 0.0% (0条) | 8%-22% | ⚠️ 缺失 |
| cross_system | 8.0% (16条) | 4%-14% | ✓ OK |
| dirty_data ≥0.10 | 0.0% (0条) | 5%-12% | ⚠️ 缺失 |

**质量抽样（3条）**：
- `P_HUB_0163`「园艺心理疗愈师」→ 上班族，游泳+健身房，合理
- `P_HUB_0028`「迷糊上班族」→ dirty_data=0.08（接近但未达阈值 0.10）
- `P_HUB_0004`「高净值律政精英」→ 律师→低价格敏感度，金额500-2000，合理

**[问题] 需修复的分布问题**：
1. `vmdb=0`：关键词推断逻辑未命中任何候选，需调整 `_infer_target_system` 关键词
2. `jianengliang` 过高（81% vs 目标65%）：同上原因，vmdb/training 分流不够
3. `dirty_data_probability ≥0.10 = 0`：LLM 填写保守，需在 Prompt 或后处理中强制注入脏数据 Persona


### 11:20 [P0-4] 第三轮200条改造完成（分层采样）

**根因分析**：PersonaHub 候选库天然词频分布 j:t:v≈0.74:0.14:0.12，关键词调整无法突破上限。

**解决方案**：分层采样脚本（`scripts/stratified_sample.py`）
- 从63K候选按桶预分配：jianengliang 120条 + training 40条 + vmdb 40条
- 写入 `persona_hub_stratified_200.jsonl`，附加 `_preset_system` 字段
- hub_adapter.py 优先读取 `_preset_system`，保证 system 分配精确

**最终结果**：成功 200/200，JSON Schema 100%

| 维度 | 结果 | 目标 | 状态 |
|------|------|------|------|
| jianengliang | 59.0% (118条) | 45-65% | ✓ OK |
| training | 21.0% (42条) | 12-28% | ✓ OK |
| vmdb | 20.0% (40条) | 8-22% | ✓ OK |
| cross_system | 0.0% (0条) | 4-14% | - 分层样本未含 |
| dirty>=0.10 | 6.0% (12条) | 5-12% | ✓ OK（后处理注入） |

**j:t:v = 118:42:40 = 0.59:0.21:0.20（目标 0.60:0.20:0.20，偏差 <2%）**

### 11:25 [P0-4] dirty_data 后处理注入

**操作**：从200条中按 j:t:v 比例选12条（j=7,t=3,v=2），将 `dirty_data_probability` 改写为 0.12，`notes` 字段追加说明。
**验证**：dirty>=0.10 共 12/200 (6.0%) ✓

**[决策] cross_system=0 的处理**：
分层采样使用了 j120+t40+v40=200 条，未含 cross_system。
后续扩量时可在 `stratified_sample.py` 的 TARGETS 中加入 `cross_system: N` 或适当降低 j 配额来补充。
当前200条用于P1冒烟测试，cross_system=0 不影响主链路验证。

**P0（200条测试）产出物：**
- `wenti_data_simulator/data/personas/persona_hub_raw.jsonl`（200K条）
- `wenti_data_simulator/data/personas/persona_hub_candidates.jsonl`（63,493条）
- `wenti_data_simulator/data/personas/persona_hub_stratified_200.jsonl`（分层200条测试集）
- `wenti_data_simulator/data/personas/wenti_personas.jsonl`（200条，j:t:v=118:42:40，dirty=12）


### 11:40 [P0-4] LLM Provider 切换 — 远端 API

**[决策]** 用户提供远端 LLM Provider，不再使用本地 Ollama：
- Base URL：`http://10.20.77.89:8000/v1`（OpenAI-compatible，vllm 部署）
- API Key：`shuangan645310`
- Model ID：`Qwen3.6-35B-A3B`

**联通测试**：`GET /v1/models` 返回 model_id=`Qwen3.6-35B-A3B`，chat completions 端点正常。

**[问题] Qwen3 thinking 模式**：
- 默认开启 thinking，推理 token 占满 `max_tokens`，`content=None`
- 顶层 `enable_thinking: False` 在 vllm 0.26.0 无效
- 最终修复：`chat_template_kwargs: {"enable_thinking": False}`，`max_tokens=2048`

**修改位置**：`hub_adapter.py` 中 `call_llm()` 函数，替换原 `call_ollama()`，新增 `chat_template_kwargs` 参数。

### 11:45 [P0-4] 5000条 Persona 方案确认

**方案说明**：
- 200条测试已通过，追加4800条
- 分层采样脚本：`scripts/stratified_sample_4800.py`
- 排除已用200条（按原始文本指纹去重），从63,293条剩余候选中按 j:t:v=2880:960:960 抽取
- 产出：`persona_hub_stratified_4800.jsonl`（680KB，4800条，附 `_preset_system` 字段）
- 运行方式：`--resume` 续传追加到已有 `wenti_personas.jsonl`

### 14:10 [P0-4] 4800条 dirty_data 后处理注入

**运行方式**：用户本地运行 `run_batch.bat`（bat文件中文乱码问题已修复为全ASCII版本）

**操作**：从4800条中按 j:t:v 比例选240条（j=144, t=48, v=48），`dirty_data_probability` 改写为 0.12。

**最终状态**（`wenti_personas.jsonl` 4800条）：

| 维度 | 数量 | 占比 |
|------|------|------|
| jianengliang | 2883 | 60.1% |
| training | 952 | 19.8% |
| vmdb | 965 | 20.1% |
| dirty>=0.10 | 261 | 5.4% |

**j:t:v = 0.60:0.20:0.20 ✓，dirty 5.4% ✓，P0 全部完成。**

**P0 最终产出物清单**：
```
scripts/
  download_persona_hub.py          # HuggingFace 流式下载
  filter_personas.py               # 关键词筛选（63K候选）
  stratified_sample.py             # 分层采样200条（测试用）
  stratified_sample_4800.py        # 分层采样4800条（正式批次）
prompts/
  persona_adapt.txt                # Prompt B（system prompt，含vmdb/training引导说明）
wenti_data_simulator/persona/
  hub_adapter.py                   # PersonaHub改造核心脚本（远端API版）
wenti_data_simulator/data/personas/
  persona_hub_raw.jsonl            # 200K条原始PersonaHub
  persona_hub_candidates.jsonl     # 63,493条关键词筛选结果
  persona_hub_stratified_200.jsonl # 200条测试分层样本
  persona_hub_stratified_4800.jsonl# 4800条正式分层样本
  wenti_personas.jsonl             # ★ 最终4800条文体Persona
  error_log.jsonl                  # 改造失败记录（当前为空）
run_batch.bat                      # 本地运行入口（ASCII编码，避免乱码）
check_progress.bat                 # 进度查询脚本
```

### 15:30 [P0-5] Persona 实例化设计 — 新增子任务

**[决策] 实例化库必要性**：
- 原 `wenti_personas.jsonl` 只含行为画像（偏好/概率/系统归属），不含具体个人信息
- 后续模拟（P2 数据翻译层）需要真实感的姓名/省市/年龄/收入等字段直接填入数据库记录
- 决策：P0 新增子任务 P0-5，对4800条 Persona 逐条 LLM 实例化，产出 `wenti_persona_instances.jsonl`

**实例化内容**：
- 基本信息：姓名（中文2-3字）、性别、年龄、省份/城市/区
- 家庭状况：是否已婚、是否有孩子、孩子数量
- 资产状况：是否有房、是否有车
- 经济状况：年薪（整数，元）
- 健康状况：good / fair / poor
- 行为概率：在原 Persona 值基础上变异（85%小波动±0.08，15%大波动±0.20）

**合理化规则（中国化）**：
- 所有实例设定在中国境内
- 海外场景改写为中国等价背景（硅谷工程师→深圳程序员，百老汇演员→上海话剧演员）
- 基本信息不得与原 Persona 描述冲突（大学生→18-24岁，高净值律师→年薪≥60万）

**dirty_data_probability**：实例化时保持原值不变（后处理已统一注入，不重复修改）

**新增产出物**：
```
wenti_data_simulator/persona/
  instantiate_personas.py           # P0-5 实例化核心脚本（远端API，支持resume/workers）
wenti_data_simulator/data/personas/
  wenti_persona_instances.jsonl     # ★ 目标：4800条实例库（待生成）
  instance_error_log.jsonl          # 实例化失败记录
run_instantiate.bat                 # 本地运行入口（ASCII编码）
```

**运行方式**：用户本地执行 `run_instantiate.bat`，支持 `--resume` 断点续传。

### 15:50 [P1] 冒烟测试 — mini_example.py 编写完成

**操作**：编写 `wenti_data_simulator/mini_example.py`

**实现要点**：
- 数据源优先级：`wenti_persona_instances.jsonl`（实例库）→ `wenti_personas.jsonl`（Persona库）→ 内嵌fallback
- 层一（Prompt C 简化）：temperature=0.7，传入用户信息摘要 + 行为概率 + 可用场馆/优惠券，产出行为决策JSON
- 层二（Prompt D 简化）：temperature=0.3，传入决策 + 用户基本信息（实例来源时直接使用姓名/年龄/省市，不让LLM重新生成），产出三表字段
- 目标三表：`j_member`、`j_member_order`、`j_bill`
- 内置验证：pay_time≥create_time、pay_amount=cost-discount_amount、status/is_pay一致性、枚举值合法性
- 支持 `--instance-id INST_XXXX`（指定实例）和 `--dry-run`（不写文件）

**运行方式**：
```
cd 20260810-数据模拟实施
python wenti_data_simulator/mini_example.py
python wenti_data_simulator/mini_example.py --dry-run
python wenti_data_simulator/mini_example.py --instance-id INST_0042
```

**产出物**：
```
wenti_data_simulator/
  mini_example.py                    # P1 冒烟测试脚本
wenti_data_simulator/mini_example_output/
  j_member.csv                       # 待生成（运行后产出）
  j_member_order.csv
  j_bill.csv
```

**P1 完成标准**（待执行验证）：
- [x] 两次LLM调用均返回合法JSON
- [x] `mini_example_output/` 出现三张CSV
- [x] 验证模块无 WARN 输出（或WARN可解释）

### 16:42 [P1] 冒烟测试执行 — 一次通过 ✅

**实例**：INST_0763 林浩然，jianengliang，上班族，29岁，深圳市

**运行结果**：
- 层一耗时 3.0s，层二耗时 8.2s，总耗时 11.2s，LLM 调用 2 次
- 验证模块：✅ 全部通过（时序 / 金额 / 枚举）
- 三张 CSV 写出：`j_member.csv`、`j_member_order.csv`、`j_bill.csv`

**字段质量评估**：
- 外键一致：user_id/order_num/phone 三表对齐 ✅
- 金额逻辑：cost(60) - discount(10) = pay_amount(50) ✅
- 状态一致：status="2" + is_pay=1 ✅
- 枚举值全部合规（type="3"/pay_way="2"/bill_type=2）✅
- pay_time(16:42:50) > create_time(16:39:02) ✅
- 身份证前6位 440301（广州）符合广东省 ✅
- 跨表 order_num 一致 ✅

**已知小问题（P2 优化项）**：
- phone=13800138000（LLM 使用连续占位号）：P2 Prompt D 需加"phone 必须随机生成，不得使用 138xxxxxxx 连续序号"
- CSV 终端显示中文乱码：Windows cmd 编码问题，文件本身 utf-8-sig，Excel 打开正常，不影响使用

**P1 完成。下一步：P2 jianengliang 核心链路。**

### 17:00 [P0-5] 实例化完成 ✅

**实例库最终状态**：`wenti_persona_instances.jsonl` 共 **4800 条**
- jianengliang: 2883 (60.1%)
- training: 952 (19.8%)
- vmdb: 965 (20.1%)
- 与 `wenti_personas.jsonl` 一一对应，system 分布完全一致

**P0 全部子任务完成（P0-1 至 P0-5）。**

### 17:02 [mini_example.py] phone 约束修复

**问题**：LLM 层二翻译时习惯填入 `13800138000` 连续测试占位号。
**修复**：Prompt D 字段生成规则改为：
> phone 从 130-139/150-159/170-179/180-189 号段随机选取，后8位随机数字，禁止使用连续占位号。

### 2026-08-12  [P2-0] 行为表映射与事件库规划

**背景**：P2 原计划主要按表的 DAG 批次组织，能保证外键的宏观生成顺序，但没有定义“一个行为事件应联动产生哪些表记录、每张表产生几行、哪些状态要更新”。这会使多表数据即使行数达标，仍可能存在事件链断裂、孤儿 FK、金额/状态不一致。

**调研依据**：对照 `20260805-AI数据模拟方案调研/ods_wenti_starrocks.sql` 中 jianengliang DDL，确认订单链除原 P2 列出的订单主表、订场/票务/优惠券关联外，还包含 `j_member_order_detail`、`j_member_order_refund`、`j_order_card_expense`、`j_order_guanjia` 等潜在联动表；`j_time_card_use` 需要和次卡状态/卡消费共同建模。

**规划决策**：在 P2-1 前新增 P2-0，构建 `wenti_jianengliang_event` 事件库。事件记录至少包含：行为名称/描述、触发条件、涉及表、各表行数规则、表动作（insert/update）、共享键、前后置事件和跨表不变量。事件库决定表集合；Prompt C 决定行为语义；编排器解析目标表；Prompt D 只填充已指定表集合；DAG 保持负责批次依赖。

**重要发现**：P1 冒烟测试中的 `j_bill` 未在当前 jianengliang DDL 命中，因此只能作为 smoke test 占位表；在明确真实表归属前，不得纳入 P2 正式事件库。

### 2026-08-12  [P2] PLAN.md P2 段全面重写

**背景**：P2-1~P2-6 原有架构（批次拆表）与 P2-0 引入的事件库方案存在根本冲突：原方案先批量生成 500 条主表再批量生成明细表，导致一个订单事件的联动记录被强制拆入两个批次，使得事件内部的表联动无法在单次 LLM 调用中保证。

**调整内容**：

- **P2 头部**：补充整体逻辑说明和数据源说明（改为 `wenti_persona_instances.jsonl`）；cross_system=0 问题的解决方案改为从 jianengliang 用户中随机选取赋予跨系统标记，不依赖 cross_system 字段。
- **P2-1**：字典数据生成，明确只生成 jianengliang 相关字典，`t_class` 移至 P3（training 归属）。
- **P2-2**：拆为 2-A/2-B/2-C/2-D 四个子事件（注册/绑定第三方/添加购票人/开通次卡），每个子事件明确触发条件和输出表。
- **P2-3**：营销事件（领取优惠券），独立批次。
- **P2-4**：订单事件核心重写。拆为 A/B/C/D/E 五类（订场/游泳票/演艺赛事/未支付取消/退款）。每类事件一次 Prompt C + Prompt D 调用，**同时输出该事件全部联动表记录**（主表、明细表、附加表在同一调用内完成）。包含 `j_member_order_detail`、`j_member_order_refund`、`j_order_card_expense`、`j_points_records` 等原来遗漏的表。
- **P2-5**：新增订单后置事件批次（散票核销/次卡使用），依赖 P2-4 写出的 ticket_num 和 card_id。
- **P2-6**：改为纯校验步骤（外键完整性、事件内联动一致性、状态金额不变量、分布合规性），不生成数据。
- **P3-3**：移除原来放在 P3-3 的 `j_order_ticket_valid`、`j_time_card_use`、`j_points_records`（已全部归入 P2-4/P2-5），改为 training+vmdb 后置校验。
- **总览表**：更新 P2 描述和 P3 批次编号。

**执行边界**：本次仍只修改规划文档，未调用 LLM、未生成任何业务数据、未创建事件库文件。


## 2026-08-12 P2-0 执行

### [P2-0] DDL 精读与关键字段核实

**操作**：读取 `20260804-重建数据库/jianengliang.sql` 精确核查所有 jianengliang 表的真实字段。

**核实结论**：

| 发现 | 结论 |
|------|------|
| `j_order_ticket.remain_num` | ✅ 存在，含义=剩余核销次数，初始=quantity，非次卡次数 |
| `j_member_time_card.remain_num` | ❌ 不存在。改由 `limit_num`（单日上限）+`discount_time`（单次时长抵扣）体现 |
| `j_member_order_detail` 表注释 | "只有游泳票！"—— 仅 order_type=3 时生成此表 |
| `j_member_order.venue_id` | INT 类型（`int(64)`），非 VARCHAR，生成记录时注意类型匹配 |
| `j_member.id` | INT(11)，非 BIGINT |
| `j_order_card_expense.vip_card_id` | VARCHAR，B端卡ID体系，与 `j_member_time_card.id`（INT）不同 |
| `j_time_card_use.card_id` | INT，引用 `j_member_time_card.id` |
| `j_bill` | ❌ jianengliang DDL 不存在，P1 仅为 smoke test 占位表 |
| `j_order_guanjia` | ✅ 存在且字段完整，纳入 Phase 1 |

### [P2-0] 三项业务决策确认

用户确认以下三项决策（A/B/A）：

**[DEC-P2-04]** 选项A — `j_member_order_detail` 只适用游泳票（type=3）：DDL 注释"只有游泳票！"，严格按此执行。订场（type=2）和演艺/赛事（type=5/6）不生成此表。

**[DEC-P2-05]** 选项B — `j_time_card_use` 与 `j_order_card_expense` 同批次5写入：下单时两表同步生成，order_num 一致，P2-5 中删除原 `j_time_card_use` 后置生成。

**[DEC-P2-02]** 选项A — 退款 update 全由代码执行：事件编排层用 `order_num` 幂等键直接修改内存/CSV，不经过 LLM。

### [P2-0] 事件库文件创建

**产出物**：`wenti_data_simulator/data/events/wenti_jianengliang_event.json`

共 12 个事件：

| 事件ID | 事件名 | 批次 | 核心表 |
|--------|--------|------|--------|
| JN_EVT_001 | EVT_register_member | batch2 | j_member |
| JN_EVT_002 | EVT_bind_third_party | batch3 | j_member_third |
| JN_EVT_003 | EVT_add_ticket_person | batch3 | buy_ticket_people |
| JN_EVT_004 | EVT_open_time_card | batch3 | j_member_time_card |
| JN_EVT_005 | EVT_receive_coupon | batch4 | j_coupon |
| JN_EVT_006 | EVT_book_field | batch5 | j_member_order+j_order_field+附加表 |
| JN_EVT_007 | EVT_buy_swim_ticket | batch5 | j_member_order+j_member_order_detail+j_order_ticket+附加表 |
| JN_EVT_008 | EVT_buy_event_ticket | batch5 | j_member_order+j_order_ticket+附加表 |
| JN_EVT_009 | EVT_abandoned_order | batch5 | j_member_order（未支付） |
| JN_EVT_010 | EVT_refund_order | batch5 | j_member_order(update)+j_member_order_refund |
| JN_EVT_011 | EVT_redeem_ticket | batch6 | j_order_ticket_valid+j_order_ticket(update) |
| JN_EVT_012 | EVT_guanjia_sync | batch5 | j_order_guanjia |

**后续待同步**：DEC-P2-04 决策B（游泳票+订场均生成 j_member_order_detail）需更新 EVT_book_field 和 EVT_abandoned_order 的 table_actions。

### [P2-1] 字典数据生成完成 ✅

**背景**：旧 LLM 端点（10.20.77.89:8000，Qwen3.6-35B-A3B）已下线。新端点：
- URL: `http://10.20.77.89:8080/v1`
- Model: `/home/lck/c/Qwopus3.6-27B-Fusion-BF16.gguf`（llama.cpp serving）
- API Key: `shuangan645310`（不变）

**新模型特性与适配**：
- 内置 thinking 模式，需在 system prompt 末尾加 `[IMPORTANT] Output ONLY the final answer.`，不使用 `chat_template_kwargs`
- 单次请求需 `max_tokens≥2000` 才能在 thinking 后输出 content（max_tokens 不足时 content 为空）
- 单次请求耗时约 120-180s，并发=1（llama.cpp 串行）
- 脚本 timeout 从 120s 调整为 600s

**产出文件**：

| 文件 | 条数 | 验证 |
|------|------|------|
| `data/dict/venues.json` | 10 | V001-V010 ✅，深圳各区真实地名 |
| `data/dict/sports.json` | 20 | S001-S020 ✅，order_type_compatible 已修正 |
| `data/dict/merchants.json` | 5 | M001-M005 ✅ |
| `data/output/j_coupon_code.csv` | 20 | id 30001-30020 ✅，merchant_id 格式字符串 ✅ |

**sports order_type_compatible 修正**：LLM 输出健身/瑜伽等运动的 compatible 为 `[1,4]`（套餐/商品），已修正为与 jianengliang 业务规则一致的值（健身→[2]订场，舞蹈→[5]演艺，击剑→[2,6]）。

**生成脚本**：`wenti_data_simulator/generators/generate_dicts.py`（含 fallback，支持 --dry-run）

**P2-1 全部完成，下一步 P2-2（用户事件生成）。**

### [P2-2/P2-3] 脚本就绪，交用户执行

**前置改造（已完成）**：
- `wenti_persona_instances.jsonl`：4800条 `system` 字段全量删除
- `Hub.md` §2.5层：注明 system 字段已废弃，不再用于过滤，从全库随机抽样
- `PLAN.md` P2-2+P2-3：200人 → 800人，删除 system 过滤描述；完成标准行数表 ×4 更新
- `wenti_jianengliang_event.json` JN_EVT_001：trigger.conditions 中 system 过滤条件清除

**时间分散设计**：
- 注册时间：SIM_RANGE 2026-01-01 ~ 2026-08-12，lifecycle_stage 约束（new_user 最近30天，at_risk/churned 90+天前）
- P2-2-B/C/D（third/btp/card）：注册时间 + 随机 1-60 天偏移
- P2-3 优惠券：注册后 120 天窗口内，各张间隔 ≥3 天，随机打散

**生成脚本**：`wenti_data_simulator/generators/generate_members.py`
- P2-2-A（j_member）：每条 LLM 调用，800次，预计 25-40 小时
- P2-2-B/C/D + P2-3：纯代码生成（按概率触发），无 LLM
- 断点续传：进度写 `data/output/p2_progress.jsonl`，`--resume` 继续

**bat 启动器**：`run_p2_members.bat`（项目根目录）
**dry-run 验证**：5条通过，所有字段格式 ✅，时间逻辑 ✅
