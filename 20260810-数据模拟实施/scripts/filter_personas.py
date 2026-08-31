"""
P0-3：关键词筛选脚本
用法：python scripts/filter_personas.py
输入：wenti_data_simulator/data/personas/persona_hub_raw.jsonl
输出：wenti_data_simulator/data/personas/persona_hub_candidates.jsonl

说明：
  - 从 200K 原始条目中筛选与文体消费场景相关的候选 Persona
  - 目标候选数：500-2000 条；不足 500 时自动提示扩充关键词
"""
import json
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")

INP = Path("wenti_data_simulator/data/personas/persona_hub_raw.jsonl")
OUT = Path("wenti_data_simulator/data/personas/persona_hub_candidates.jsonl")

KEYWORDS = [
    # 运动/健身
    "fitness", "gym", "swimming", "sports", "exercise", "workout",
    "badminton", "basketball", "tennis", "yoga", "martial arts", "athlete",
    "cycling", "running", "dance", "aerobics", "pilates", "crossfit",
    # 消费行为
    "shopping", "consumer", "purchase", "budget", "price", "discount",
    "membership", "subscription", "coupon", "deal", "value", "spend",
    "bargain", "sale", "offer", "loyalty",
    # 人群类型
    "student", "office worker", "parent", "retiree", "young professional",
    "family", "beginner", "enthusiast", "worker", "employee", "housewife",
    "college", "university", "teenager", "elderly", "senior",
    # 文体娱乐
    "entertainment", "concert", "event", "ticketing", "leisure",
    "recreation", "community center", "sports facility", "swimming pool",
    "arena", "stadium", "court", "playground", "park",
    # 生活方式
    "health", "wellness", "active", "lifestyle", "hobby", "routine",
    "work-life balance", "morning routine", "weekend", "free time",
    "relaxation", "stress relief", "outdoor",
    # 消费倾向（脏数据Persona来源）
    "impulsive", "cart abandonment", "returns", "refund", "indecisive",
    "bargain hunter", "frugal", "price-sensitive", "cancel", "hesitant",
]


def is_relevant(text: str) -> bool:
    t = text.lower()
    return any(kw in t for kw in KEYWORDS)


if __name__ == "__main__":
    if not INP.exists():
        print(f"错误：原始文件不存在 {INP}，请先运行 download_persona_hub.py")
        sys.exit(1)

    kept = 0
    total = 0
    OUT.parent.mkdir(parents=True, exist_ok=True)

    with open(INP, encoding="utf-8") as fin, open(OUT, "w", encoding="utf-8") as fout:
        for line in fin:
            if not line.strip():
                continue
            row = json.loads(line)
            text = row.get("input_persona", row.get("persona", ""))
            total += 1
            if is_relevant(text):
                fout.write(json.dumps(row, ensure_ascii=False) + "\n")
                kept += 1
            if total % 50000 == 0:
                print(f"  已处理 {total:,} 条，保留 {kept:,} 条...", flush=True)

    ratio = kept / total * 100 if total > 0 else 0
    print(f"\n筛选完成：{total:,} -> {kept:,} 条（{ratio:.1f}%）-> {OUT}")
    if kept < 500:
        print("警告：候选数量不足 500 条，建议在 KEYWORDS 中追加更多关键词后重新运行。")
    elif kept > 3000:
        print(f"提示：候选数量 {kept} 条较多，hub_adapter.py 运行时可用 --limit 2000 控制改造数量。")
    else:
        print(f"候选数量 {kept} 条，在目标范围内（500-2000），可直接进行下一步改造。")
