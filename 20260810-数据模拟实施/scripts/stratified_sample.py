"""
分层采样脚本：按 6:2:2 比例从候选库预分桶抽取 200 条
输入：wenti_data_simulator/data/personas/persona_hub_candidates.jsonl（63K条）
输出：wenti_data_simulator/data/personas/persona_hub_stratified_200.jsonl（200条）

策略：
  jianengliang : training : vmdb = 120 : 40 : 40
  各桶内随机打乱后取前 N 条，保证多样性
"""
import json, sys, random
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")

import sys as _sys
_sys.path.insert(0, str(Path(__file__).parent.parent))
from wenti_data_simulator.persona.hub_adapter import _infer_target_system

INP  = Path("wenti_data_simulator/data/personas/persona_hub_candidates.jsonl")
OUT  = Path("wenti_data_simulator/data/personas/persona_hub_stratified_200.jsonl")
SEED = 2026

TARGETS = {
    "jianengliang": 120,
    "training":     40,
    "vmdb":         40,
}

random.seed(SEED)

# 分桶
buckets: dict[str, list] = {"jianengliang": [], "training": [], "vmdb": [], "cross_system": []}
with open(INP, encoding="utf-8") as f:
    for line in f:
        row = json.loads(line)
        text = row.get("input_persona", row.get("persona", ""))
        sys_name = _infer_target_system(text)
        buckets[sys_name].append(row)

print("分桶结果：")
for k, v in buckets.items():
    print(f"  {k}: {len(v)} 条")

# 分层抽样
sampled: list[tuple[str, dict]] = []
for sys_name, n in TARGETS.items():
    pool = buckets[sys_name]
    if len(pool) < n:
        print(f"  [WARN] {sys_name} 仅 {len(pool)} 条，不足 {n} 条，全量使用")
        n = len(pool)
    chosen = random.sample(pool, n)
    sampled.extend((sys_name, row) for row in chosen)

# 打乱后写出
random.shuffle(sampled)
OUT.parent.mkdir(parents=True, exist_ok=True)
with open(OUT, "w", encoding="utf-8") as f:
    for sys_name, row in sampled:
        # 标记预分配的 system，供 hub_adapter 读取
        row["_preset_system"] = sys_name
        f.write(json.dumps(row, ensure_ascii=False) + "\n")

total = len(sampled)
print(f"\n分层采样完成：{total} 条 -> {OUT}")
from collections import Counter
preset_cnt = Counter(sys_name for sys_name, _ in sampled)
for k, v in preset_cnt.most_common():
    print(f"  {k}: {v} ({v/total:.1%})")
