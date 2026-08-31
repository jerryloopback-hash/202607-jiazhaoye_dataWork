"""
分层采样脚本 v2：生成 4800 条追加样本，排除已用200条，按 6:2:2 比例
输入：wenti_data_simulator/data/personas/persona_hub_candidates.jsonl
      wenti_data_simulator/data/personas/persona_hub_stratified_200.jsonl（已用，排除）
输出：wenti_data_simulator/data/personas/persona_hub_stratified_4800.jsonl

比例：jianengliang:training:vmdb = 2880:960:960
"""
import json, sys, random
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")
sys.path.insert(0, str(Path(__file__).parent.parent))
from wenti_data_simulator.persona.hub_adapter import _infer_target_system

INP      = Path("wenti_data_simulator/data/personas/persona_hub_candidates.jsonl")
USED     = Path("wenti_data_simulator/data/personas/persona_hub_stratified_200.jsonl")
OUT      = Path("wenti_data_simulator/data/personas/persona_hub_stratified_4800.jsonl")
SEED     = 2027

TARGETS = {
    "jianengliang": 2880,
    "training":      960,
    "vmdb":          960,
}

random.seed(SEED)

# 读取已用文本指纹，排除
used_texts: set[str] = set()
if USED.exists():
    with open(USED, encoding="utf-8") as f:
        for line in f:
            row = json.loads(line)
            used_texts.add(row.get("input_persona", row.get("persona", "")))
print(f"排除已用: {len(used_texts)} 条")

# 分桶（排除已用）
buckets: dict[str, list] = {"jianengliang": [], "training": [], "vmdb": [], "cross_system": []}
with open(INP, encoding="utf-8") as f:
    for line in f:
        row = json.loads(line)
        text = row.get("input_persona", row.get("persona", ""))
        if text in used_texts:
            continue
        sys_name = _infer_target_system(text)
        buckets[sys_name].append(row)

print("分桶结果（排除后）：")
for k, v in buckets.items():
    print(f"  {k}: {len(v)} 条")

# 分层抽样
sampled: list[tuple[str, dict]] = []
for sys_name, n in TARGETS.items():
    pool = buckets[sys_name]
    if len(pool) < n:
        print(f"  [WARN] {sys_name} 仅 {len(pool)} 条，不足 {n}，全量使用")
        n = len(pool)
    chosen = random.sample(pool, n)
    sampled.extend((sys_name, row) for row in chosen)

random.shuffle(sampled)
OUT.parent.mkdir(parents=True, exist_ok=True)
with open(OUT, "w", encoding="utf-8") as f:
    for sys_name, row in sampled:
        row["_preset_system"] = sys_name
        f.write(json.dumps(row, ensure_ascii=False) + "\n")

total = len(sampled)
from collections import Counter
cnt = Counter(s for s, _ in sampled)
print(f"\n分层采样完成：{total} 条 -> {OUT}")
for k, v in cnt.most_common():
    print(f"  {k}: {v} ({v/total:.1%})")
