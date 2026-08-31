"""
P0-5: WentiPersona 实例化器 (instantiate_personas.py)
用法:
  python wenti_data_simulator/persona/instantiate_personas.py --dry-run --limit 5
  python wenti_data_simulator/persona/instantiate_personas.py --limit 4800 --workers 4 --resume

说明:
  - 读取 wenti_personas.jsonl，对每条 Persona 调用远端 LLM 生成具体实例人
  - 实例人包含姓名/省市/性别/年龄/家庭/房车/年薪/健康状况等基本信息
  - 行为概率在原值基础上变异（大概率小波动，小概率大波动）
  - 全部设定为中国场景（海外 Persona 改写为中国地址/背景）
  - 基本信息不得与性格/描述冲突
  - 支持 --resume 断点续传，--workers 并发，--dry-run 测试
  - LLM: http://10.20.77.89:8000/v1, Qwen3.6-35B-A3B
"""
import argparse
import json
import random
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

import requests

sys.stdout.reconfigure(encoding="utf-8")

# --- Config ------------------------------------------------------------------
API_BASE  = "http://10.20.77.89:8000/v1"
API_KEY   = "shuangan645310"
API_MODEL = "Qwen3.6-35B-A3B"

INSTANCE_REQUIRED = [
    "instance_id", "persona_id", "name", "gender", "age",
    "province", "city", "family_status", "has_house", "has_car",
    "annual_income", "health_status", "behavior_probabilities",
]
FAMILY_REQUIRED = ["married", "has_children", "children_count"]
PROB_REQUIRED = [
    "use_coupon", "bind_wechat", "add_ticket_person",
    "accumulate_points", "use_time_card", "complete_id_check",
    "complete_health_check",
]

# --- System Prompt -----------------------------------------------------------
SYSTEM_PROMPT = """你是一个专业的用户画像实例化设计师。

你的任务：
给定一条已完成文体化改造的 WentiPersona JSON，为它生成一个具体的"实例人"——一个有名字、住址、家庭背景、收入状况的真实感中国人。

实例化规则：
1. 全部设定在中国境内。若原 Persona 描述涉及海外场景（美国、欧洲等），将其改写为中国等价背景（如"硅谷工程师"→"深圳程序员"，"百老汇舞台演员"→"上海话剧演员"）。
2. 基本信息必须与 Persona 描述内在一致，不能冲突（如：描述是"高净值律师"则年薪应在60万以上；"大学生"则年龄18-24、未婚无房概率高）。
3. 行为概率变异规则（在原值基础上调整）：
   - 85%概率：每个概率值在 ±0.08 以内小幅变动（不超出 0.0-1.0 范围）
   - 15%概率：某1-2个字段发生大波动（±0.20 以内）
   - 变异后所有值保持在 [0.0, 1.0] 范围
4. avg_monthly_orders 和 avg_order_amount_range 也进行小幅变异（±20%以内）。
5. dirty_data_probability 保持原值不变（由后处理统一控制）。
6. 输出严格遵循 JSON Schema，不包含任何解释性文字，直接输出 JSON 对象。"""

# --- User Prompt Template ----------------------------------------------------
USER_PROMPT_TEMPLATE = """请为以下 WentiPersona 生成实例人：

【WentiPersona JSON】：
{persona_json}

【输出格式】（严格 JSON，instance_id="{instance_id}"，persona_id="{persona_id}"）：
{{
  "instance_id": "{instance_id}",
  "persona_id": "{persona_id}",
  "name": "中文姓名（2-3字）",
  "gender": "male 或 female",
  "age": 28,
  "province": "XX省/直辖市",
  "city": "XX市/区",
  "district": "XX区（可选）",
  "family_status": {{
    "married": true,
    "has_children": false,
    "children_count": 0
  }},
  "has_house": true,
  "has_car": false,
  "annual_income": 120000,
  "health_status": "good（好/一般/差对应 good/fair/poor）",
  "behavior_probabilities": {{
    "use_coupon": 0.0,
    "bind_wechat": 0.0,
    "add_ticket_person": 0.0,
    "accumulate_points": 0.0,
    "use_time_card": 0.0,
    "complete_id_check": 0.0,
    "complete_health_check": 0.0
  }},
  "avg_monthly_orders": 0,
  "avg_order_amount_range": [0, 0],
  "notes": "实例化说明（简短，可选）"
}}"""


# --- Core Functions ----------------------------------------------------------
def call_llm(user_msg: str, model: str = API_MODEL) -> str:
    resp = requests.post(
        f"{API_BASE}/chat/completions",
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json",
        },
        json={
            "model": model,
            "messages": [
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user",   "content": user_msg},
            ],
            "temperature": 0.75,
            "max_tokens": 1024,
            "chat_template_kwargs": {"enable_thinking": False},
        },
        timeout=120,
    )
    resp.raise_for_status()
    content = resp.json()["choices"][0]["message"].get("content") or ""
    if not content.strip():
        raise ValueError(
            f"API 返回空 content (finish_reason={resp.json()['choices'][0]['finish_reason']})"
        )
    return content.strip()


def _extract_json(raw: str) -> dict:
    start = raw.find("{")
    end   = raw.rfind("}") + 1
    if start == -1 or end == 0:
        raise ValueError("响应中未找到 JSON 对象")
    return json.loads(raw[start:end])


def _validate(parsed: dict) -> list[str]:
    missing = [k for k in INSTANCE_REQUIRED if k not in parsed]
    if "family_status" in parsed:
        missing += [
            f"family_status.{k}"
            for k in FAMILY_REQUIRED
            if k not in parsed["family_status"]
        ]
    if "behavior_probabilities" in parsed:
        missing += [
            f"behavior_probabilities.{k}"
            for k in PROB_REQUIRED
            if k not in parsed["behavior_probabilities"]
        ]
    return missing


def _merge_instance(persona: dict, llm_result: dict, instance_id: str) -> dict:
    """将 LLM 生成的实例字段与原 Persona 字段合并，构成完整实例记录。"""
    instance = {
        # 实例唯一标识
        "instance_id":   instance_id,
        "persona_id":    persona["persona_id"],
        # LLM 生成的个人基本信息
        "name":          llm_result["name"],
        "gender":        llm_result["gender"],
        "age":           llm_result["age"],
        "province":      llm_result["province"],
        "city":          llm_result["city"],
        "district":      llm_result.get("district", ""),
        "family_status": llm_result["family_status"],
        "has_house":     llm_result["has_house"],
        "has_car":       llm_result["has_car"],
        "annual_income": llm_result["annual_income"],
        "health_status": llm_result["health_status"],
        # 继承自 Persona（不变）
        "system":                  persona.get("system"),
        "dimensions":              persona.get("dimensions"),
        "typical_order_types":     llm_result.get("typical_order_types", persona.get("typical_order_types")),
        # 变异后的行为概率（来自 LLM）
        "behavior_probabilities":  llm_result["behavior_probabilities"],
        "avg_monthly_orders":      llm_result.get("avg_monthly_orders", persona.get("avg_monthly_orders")),
        "avg_order_amount_range":  llm_result.get("avg_order_amount_range", persona.get("avg_order_amount_range")),
        # 保持原值（后处理统一注入）
        "dirty_data_probability":  persona.get("dirty_data_probability", 0.02),
        # 原始描述保留
        "original_persona":        persona.get("original_persona", ""),
        "notes":                   llm_result.get("notes", ""),
    }
    return instance


def instantiate_one(
    persona: dict,
    index: int,
    model: str,
) -> dict | None:
    """为单条 Persona 生成实例，失败重试3次。"""
    persona_id  = persona.get("persona_id", f"P_HUB_{index:04d}")
    instance_id = f"INST_{index:04d}"

    # 只传递关键字段给 LLM，减少 token 消耗
    persona_summary = {
        "persona_id":             persona_id,
        "name":                   persona.get("name", ""),
        "system":                 persona.get("system", ""),
        "dimensions":             persona.get("dimensions", {}),
        "behavior_probabilities": persona.get("behavior_probabilities", {}),
        "avg_monthly_orders":     persona.get("avg_monthly_orders", 0),
        "avg_order_amount_range": persona.get("avg_order_amount_range", [0, 0]),
        "original_persona":       (persona.get("original_persona") or "")[:300],
    }

    user_msg = USER_PROMPT_TEMPLATE.format(
        persona_json=json.dumps(persona_summary, ensure_ascii=False, indent=2),
        instance_id=instance_id,
        persona_id=persona_id,
    )

    for attempt in range(3):
        try:
            raw_resp = call_llm(user_msg, model)
            parsed   = _extract_json(raw_resp)
            missing  = _validate(parsed)
            if missing:
                raise ValueError(f"缺少字段: {missing}")
            return _merge_instance(persona, parsed, instance_id)
        except Exception as e:
            wait = 2 ** attempt
            print(
                f"  [retry {attempt+1}/3] index={index} err={e}, wait {wait}s",
                flush=True,
            )
            time.sleep(wait)
    return None


# --- Entry Point -------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description="WentiPersona 实例化器")
    parser.add_argument(
        "--input",
        default="wenti_data_simulator/data/personas/wenti_personas.jsonl",
        help="输入：wenti_personas.jsonl",
    )
    parser.add_argument(
        "--output",
        default="wenti_data_simulator/data/personas/wenti_persona_instances.jsonl",
        help="输出：wenti_persona_instances.jsonl",
    )
    parser.add_argument(
        "--errors",
        default="wenti_data_simulator/data/personas/instance_error_log.jsonl",
    )
    parser.add_argument("--model",   default=API_MODEL)
    parser.add_argument("--limit",   type=int, default=None, help="只处理前N条（测试用）")
    parser.add_argument("--workers", type=int, default=4,    help="并发线程数")
    parser.add_argument("--dry-run", action="store_true",    help="不写文件，预览结果")
    parser.add_argument("--resume",  action="store_true",    help="跳过已写入的 instance_id")
    args = parser.parse_args()

    inp_path = Path(args.input)
    out_path = Path(args.output)
    err_path = Path(args.errors)

    if not inp_path.exists():
        print(f"错误：输入文件不存在 {inp_path}")
        sys.exit(1)

    lines = inp_path.read_text(encoding="utf-8").strip().splitlines()
    if args.limit:
        lines = lines[: args.limit]

    # 断点续传：跳过已有 instance_id
    done_ids: set[str] = set()
    if args.resume and out_path.exists():
        for line in out_path.read_text(encoding="utf-8").splitlines():
            try:
                done_ids.add(json.loads(line)["instance_id"])
            except Exception:
                pass
        print(f"续传模式：已跳过 {len(done_ids)} 条")

    pending = []
    for i, line in enumerate(lines):
        iid = f"INST_{i:04d}"
        if iid not in done_ids:
            pending.append((i, json.loads(line)))

    print(
        f"待实例化：{len(pending)} 条 | 模型：{args.model} | workers：{args.workers}"
    )

    out_path.parent.mkdir(parents=True, exist_ok=True)
    mode  = "a" if args.resume else "w"
    out_f = open(out_path, mode, encoding="utf-8") if not args.dry_run else None
    err_f = open(err_path, mode, encoding="utf-8") if not args.dry_run else None

    results: list[dict] = []
    errors:  list[dict] = []

    def process_one(item):
        idx, persona = item
        result = instantiate_one(persona, idx, args.model)
        return idx, persona, result

    try:
        with ThreadPoolExecutor(max_workers=args.workers) as executor:
            futures = {executor.submit(process_one, item): item for item in pending}
            done_count = 0
            for future in as_completed(futures):
                idx, persona, result = future.result()
                done_count += 1
                pid    = persona.get("persona_id", f"P_HUB_{idx:04d}")
                label  = persona.get("name", pid)[:20]
                if result:
                    results.append(result)
                    if out_f:
                        out_f.write(json.dumps(result, ensure_ascii=False) + "\n")
                        out_f.flush()
                    print(
                        f"  [{done_count}/{len(pending)}] OK   INST_{idx:04d} | {pid} {label}",
                        flush=True,
                    )
                else:
                    err_rec = {
                        "instance_id": f"INST_{idx:04d}",
                        "persona_id":  pid,
                        "status":      "failed",
                    }
                    errors.append(err_rec)
                    if err_f:
                        err_f.write(json.dumps(err_rec, ensure_ascii=False) + "\n")
                        err_f.flush()
                    print(
                        f"  [{done_count}/{len(pending)}] FAIL INST_{idx:04d} | {pid} {label}",
                        flush=True,
                    )
    finally:
        if out_f:
            out_f.close()
        if err_f:
            err_f.close()

    total     = len(pending)
    pass_rate = len(results) / total * 100 if total else 0
    print(f"\n实例化完成：成功 {len(results)} 条，失败 {len(errors)} 条")
    print(f"JSON 验证通过率：{pass_rate:.1f}%", end="")
    if pass_rate < 80:
        print(" [WARN] 低于 80%，建议检查 Prompt 或模型响应")
    else:
        print(" [OK]")

    if args.dry_run:
        print("\n[干运行模式] 结果未写入文件，以上为预览。")
        if results:
            print("\n--- 示例输出（第1条）---")
            print(json.dumps(results[0], ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
