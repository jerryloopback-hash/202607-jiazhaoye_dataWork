"""
P0-2：PersonaHub 下载脚本
用法：python scripts/download_persona_hub.py
输出：wenti_data_simulator/data/personas/persona_hub_raw.jsonl

说明：
  - 使用 HuggingFace datasets 流式下载，避免全量加载到内存
  - 若网络受限可改用方案B：huggingface-cli download
  - 下载来源：proj-persona/PersonaHub（CC BY-NC-SA 4.0，仅研究用途）
"""
import json
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")

OUT = Path("wenti_data_simulator/data/personas/persona_hub_raw.jsonl")
OUT.parent.mkdir(parents=True, exist_ok=True)


def download_streaming():
    """方案A：流式下载（推荐）"""
    from datasets import load_dataset

    print("开始流式下载 PersonaHub (proj-persona/PersonaHub, split=train)...")
    ds = load_dataset(
        "proj-persona/PersonaHub",
        "persona",
        split="train",
        streaming=True,
        # trust_remote_code 在新版 datasets 中已废弃，PersonaHub 已转为标准 Parquet 格式，无需此参数
    )
    count = 0
    with open(OUT, "w", encoding="utf-8") as f:
        for row in ds:
            f.write(json.dumps(row, ensure_ascii=False) + "\n")
            count += 1
            if count % 10000 == 0:
                print(f"  已下载 {count:,} 条...", flush=True)
    print(f"\n完成：共 {count:,} 条 -> {OUT}")
    return count


if __name__ == "__main__":
    if OUT.exists():
        lines = OUT.read_text(encoding="utf-8").strip().splitlines()
        print(f"文件已存在（{len(lines):,} 行），跳过下载。删除文件可重新下载。")
        sys.exit(0)
    download_streaming()
