# 佳兆业文体数据模拟实施工作区

> 版本：v1.4 | 2026-08-12 | 项目规范：[数据模拟实施Hub.md](数据模拟实施Hub.md) v1.7

本目录是**实际动手实施**的工作区，Hub.md 是设计规范（SSOT），本目录存放落地代码、脚本、中间数据、执行日志。

---

## 核心思路

```
Tencent PersonaHub (200K 条自由文本 Persona)
        │
        ▼  scripts/filter_personas.py（关键词筛选 → 63K 候选）
        │
        ▼  scripts/stratified_sample_4800.py（分层采样 j:t:v=60%:20%:20%）
        │
persona_hub_stratified_4800.jsonl（4800条，附 _preset_system 字段）
        │
        ▼  hub_adapter.py（远端 LLM API 逐条改造 → WentiPersona JSON）
        │
wenti_personas.jsonl（4800 条文体化 Persona，含8维度+行为概率矩阵）
        │
        ▼  instantiate_personas.py（远端 LLM API 逐条实例化 → 具体个人信息）
        │
wenti_persona_instances.jsonl（4800 条实例库：姓名/省市/年龄/家庭/收入/行为概率变异）
        │
        ▼  P2-0：行为表映射（Planning，尚未执行）
   wenti_jianengliang_event 事件库
   行为事件 → 表动作/行数/共享键/状态更新
        │
        ▼  main.py（P2 后续 DAG 批次调度）
        │
   对每条待生成用户：随机抽取一条实例
        │
        ├─ 第3层：行为决策 LLM（远端 API Qwen3.6-35B-A3B）
        │         输入：Persona + 场景 + 字典数据
        │         输出：行为决策 JSON
        │
        ├─ 第4层：字段翻译 LLM
        │         输入：行为决策 + 表结构 + 枚举约束
        │         输出：数据库记录 JSON
        │
        └─ 第5层：脏数据注入 + 质量检查 + 写出 CSV
```

---

## 目录结构（当前实际状态）

```
20260810-数据模拟实施/
├── README.md                        ← 本文件
├── PLAN.md                          ← 分阶段实施计划（含细粒度 TODO）
├── LOG.md                           ← 实施日志（敏感操作/决策记录）
├── 数据模拟实施Hub.md                ← 项目规范 SSOT v1.2
├── run_batch.bat                    ← 本地一键运行改造（ASCII 编码，无乱码）
├── check_progress.bat               ← 查看 wenti_personas.jsonl 当前行数
├── run_instantiate.bat              ← P0-5：本地一键运行实例化（ASCII 编码）
│
├── scripts/                         ← 独立辅助脚本（P0 已完成）
│   ├── download_persona_hub.py      ← HuggingFace 流式下载 200K 条
│   ├── filter_personas.py           ← 关键词筛选，产出 63K 候选
│   ├── stratified_sample.py         ← 分层采样 200 条（测试批次）
│   └── stratified_sample_4800.py    ← 分层采样 4800 条（正式批次，排除已用200条）
│
├── prompts/
│   └── persona_adapt.txt            ← Prompt B：system prompt，含 vmdb/training 业务含义说明
│
├── P2-0 行为表映射（规划中，尚未执行）
│   └── 目标：wenti_data_simulator/data/events/wenti_jianengliang_event.json
│
└── wenti_data_simulator/            ← Python 项目主体
    ├── mini_example.py              ← ★ P1 冒烟测试入口（已完成 ✅）
    ├── main.py                      ← 待编写（P2-P3 DAG 调度）
    ├── config.yaml                  ← 待编写
    ├── .env.example                 ← 待编写
    ├── persona/
    │   ├── hub_adapter.py           ← ★ PersonaHub 改造核心（远端 API 版）
    │   └── instantiate_personas.py  ← ★ P0-5 Persona 实例化脚本（远端 API 版）
    ├── llm/                         ← 待实现（LLM provider 封装）
    ├── generators/                  ← 待实现（各表生成器）
    ├── validation/                  ← 待实现（质量检查）
    └── data/
        └── personas/
            ├── persona_hub_raw.jsonl              ← 200K 条原始 PersonaHub（21MB）
            ├── persona_hub_candidates.jsonl       ← 63,493 条关键词筛选结果
            ├── persona_hub_stratified_200.jsonl   ← 200 条测试分层样本
            ├── persona_hub_stratified_4800.jsonl  ← 4800 条正式分层样本
            ├── wenti_personas.jsonl               ← ★ 4800 条文体 Persona（已完成）
            ├── wenti_persona_instances.jsonl      ← ★ P0-5：4800 条实例库（✅ 已完成）
            ├── error_log.jsonl                    ← Persona 改造失败记录（当前为空）
            └── instance_error_log.jsonl           ← 实例化失败记录（待生成）
```

---

## P0-5 实例化 ✅（已完成）

**最终状态**：`wenti_persona_instances.jsonl` 共 **4800 条**
- jianengliang: 2883 (60.1%)
- training: 952 (19.8%)
- vmdb: 965 (20.1%)
- dirty_data_probability ≥ 0.10: 261 (5.4%)

重新生成（如需）：

```bat
run_instantiate.bat
```

---

## P0 + P1 完成情况 ✅

### LLM Provider（与原计划差异）

原计划使用本地 Ollama（`qwen2.5:7b`），实际使用远端 OpenAI-compatible API：

| 属性 | 值 |
|------|-----|
| Base URL | `http://10.20.77.89:8000/v1` |
| API Key | `shuangan645310` |
| Model | `Qwen3.6-35B-A3B`（vllm 部署） |
| 关键参数 | `chat_template_kwargs: {enable_thinking: False}`（禁用 Qwen3 thinking 模式，否则 content=None） |

### 分层采样方案（核心决策）

PersonaHub 候选库天然词频结构决定了词典分类上限 j:t:v ≈ 0.74:0.14:0.12，调整关键词无法突破。  
解决方案：预先按词典分桶，再按目标比例分层抽样，附加 `_preset_system` 字段，hub_adapter.py 直接读取。

### wenti_personas.jsonl 当前状态

| 维度 | 数量 | 占比 |
|------|------|------|
| **总条数** | **4800** | — |
| jianengliang | 2883 | 60.1% |
| training | 952 | 19.8% |
| vmdb | 965 | 20.1% |
| cross_system | 0 | 0%（后续扩量补充） |
| dirty_data_probability ≥ 0.10 | 261 | 5.4% |

---

## 腾讯 PersonaHub 调研情况

| 项目 | 结论 |
|------|------|
| 数据集 | `proj-persona/PersonaHub`（腾讯 AI Lab Seattle，arXiv 2406.20094） |
| 可用子集 | 200K 条（`persona.jsonl`，21MB）；3.7亿条 ElitePersonas（更大） |
| 格式 | JSONL，每条含 `persona` 字段（自由文本英文描述）|
| 许可证 | CC BY-NC-SA 4.0 — **仅研究用途，不可商用** |
| 下载方式 | `python scripts/download_persona_hub.py`（流式，无需登录）|
| 筛选结果 | 200K → 63,493 条（31.7%）关键词命中 |
| 实际使用 | 分层采样 4800 条，改造后 j:t:v=60%:20%:20% |

---

## 快速开始

### P1 冒烟测试 ✅（已完成）

**实例 INST_0763 林浩然，总耗时 11.2s，验证全通过。**

```bash
# 重新运行（随机抽取实例）
python wenti_data_simulator/mini_example.py

# 指定实例
python wenti_data_simulator/mini_example.py --instance-id INST_0042

# 干运行（不写文件）
python wenti_data_simulator/mini_example.py --dry-run
```

输出：`wenti_data_simulator/mini_example_output/` 下 `j_member.csv`、`j_member_order.csv`、`j_bill.csv`

### P2-0 行为表映射（规划中，尚未执行）

P2 的业务前置不是直接按表生成，而是先建立 `wenti_jianengliang_event` 事件库。每个事件会定义：行为名称和触发条件、涉及表及各表行数、`insert/update` 动作、共享键、前后置事件以及金额/状态/时序/外键不变量。

事件库负责“一个行为要产生哪些联动记录”，DAG 负责“这些记录在哪个批次生成”。Prompt C 输出行为语义和参数；事件编排器从事件库确定 `target_tables`；Prompt D 只填写已确定表集合的字段，不能自行增删表。

当前仅完成调研和规划，未调用 LLM、未生成 P2 字典或业务数据、未实现生成器。正式执行前还必须完成：真实 DDL 的逐表纳入裁定、事件到表映射矩阵、事件级校验规则，以及 `j_bill` 是否属于 jianengliang 正式链路的确认。

### P0 + P1 完成，P2-0 规划中

```bash
# 查看实例化进度
find /c /v "" wenti_data_simulator\data\personas\wenti_persona_instances.jsonl

# 继续/恢复实例化（P0-5）
run_instantiate.bat
```

### P0 重新生成（如需）

```bash
# 1. 下载原始 PersonaHub
python scripts/download_persona_hub.py

# 2. 关键词筛选
python scripts/filter_personas.py

# 3. 分层采样 4800 条
python scripts/stratified_sample_4800.py

# 4. 批量改造（本地运行，双击 bat 或命令行执行）
run_batch.bat
# 或命令行：
python wenti_data_simulator/persona/hub_adapter.py \
  --input  wenti_data_simulator/data/personas/persona_hub_stratified_4800.jsonl \
  --output wenti_data_simulator/data/personas/wenti_personas.jsonl \
  --limit  4800 --workers 4 --resume

# 5. dirty_data 后处理注入（改造完成后）
#    从结果中随机选 ~5% 条目，将 dirty_data_probability 改写为 0.12
#    （参考 LOG.md 2026-08-11 12:10 的注入脚本）
```

---

## 关联文件

- 设计规范（SSOT）：[数据模拟实施Hub.md](数据模拟实施Hub.md)
- 实施日志：[LOG.md](LOG.md)
- 分阶段计划：[PLAN.md](PLAN.md)
- DDL 参考：`../ods_wenti_starrocks.sql`（如存在）
