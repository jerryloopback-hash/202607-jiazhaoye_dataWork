"""
P0-4：PersonaHub -> 文体 Persona 改造器 (hub_adapter.py)
用法：
  python wenti_data_simulator/persona/hub_adapter.py --dry-run --limit 10
  python wenti_data_simulator/persona/hub_adapter.py --limit 200

说明：
  - 对每条候选调用远端 OpenAI-compatible LLM API（Prompt B），改造为结构化 WentiPersona JSON
  - 支持并发（--workers）、断点续传（--resume）、干运行测试（--dry-run）
  - 失败重试3次，最终失败记入 error_log.jsonl，不阻断主流程
  - LLM 提供方：http://10.20.77.89:8000/v1，模型：Qwen3.6-35B-A3B
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

# ─── 配置 ─────────────────────────────────────────────────────────────────────
# 远端 OpenAI-compatible API（vllm 部署 Qwen3.6-35B-A3B）
API_BASE  = "http://10.20.77.89:8000/v1"
API_KEY   = "shuangan645310"
API_MODEL = "Qwen3.6-35B-A3B"

SCHEMA_REQUIRED = [
    "persona_id", "name", "source", "system", "dimensions",
    "behavior_probabilities", "typical_order_types",
    "avg_monthly_orders", "avg_order_amount_range", "dirty_data_probability",
]
DIM_REQUIRED = [
    "user_type", "price_sensitivity", "preferred_scenes",
    "active_hours", "consumption_frequency", "registration_channel",
    "lifecycle_stage", "id_verification_status",
]
PROB_REQUIRED = [
    "use_coupon", "bind_wechat", "add_ticket_person",
    "accumulate_points", "use_time_card", "complete_id_check",
    "complete_health_check",
]
SYSTEM_WEIGHTS_TARGET = {
    "jianengliang":  (0.45, 0.65),
    "training":      (0.12, 0.28),
    "vmdb":          (0.08, 0.22),
    "cross_system":  (0.04, 0.14),
}

# Prompt B system 内嵌版本（当 prompts/persona_adapt.txt 不存在时使用）
_PROMPT_B_SYSTEM_INLINE = """你是一个专业的 Persona 设计师，负责将通用的用户画像改造为文体消费场景下的具体 Persona。

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
- dirty_data_probability 正常用户填 0.01-0.05；冲动/退款/不付款人设填 0.10-0.20
- 输出严格遵循 JSON Schema，不要包含任何解释性文字，直接输出 JSON 对象。"""

# ─── Prompt B 用户消息模板 ─────────────────────────────────────────────────────
USER_PROMPT_TEMPLATE = """请将以下 Persona Hub 原始记录改造为文体消费场景 Persona：

【原始 Persona】：
{original_text}

【改造目标系统】：{target_system}
（可选值：jianengliang | training | vmdb | cross_system）

【8维度定义】：
1. user_type: 用户类型（大学生、上班族、家庭主妇、退休老人、青少年、企业客户、偶发型游客）
2. price_sensitivity: 价格敏感度（high | medium | low）
3. preferred_scenes: 偏好场景列表（游泳、订场、培训课程、演艺活动、赛事参与、健身房）
4. active_hours: 活跃时段（morning | noon | evening | weekend_full_day | irregular）
5. consumption_frequency: 消费频次（high≥8次/月 | medium 3-7次/月 | low 1-2次/月 | dormant 0次/月）
6. registration_channel: 注册渠道（android | ios | miniprogram | backend_entry）
7. lifecycle_stage: 生命周期（new_user<30天 | growing 30-180天 | mature 180天+ | at_risk 90天未消费 | churned 180天未消费）
8. id_verification_status: 身份验证状态（unverified | verified | expired | disabled）

【行为概率维度（0.0-1.0）】：
use_coupon | bind_wechat | add_ticket_person | accumulate_points | use_time_card | complete_id_check | complete_health_check

【输出格式】（严格 JSON，persona_id="{persona_id}"）：
{{
  "persona_id": "{persona_id}",
  "name": "中文名称（简短描述）",
  "source": "persona_hub_adapted",
  "system": "{target_system}",
  "dimensions": {{
    "user_type": "...",
    "price_sensitivity": "high|medium|low",
    "preferred_scenes": ["..."],
    "active_hours": "...",
    "consumption_frequency": "...",
    "registration_channel": "...",
    "lifecycle_stage": "...",
    "id_verification_status": "..."
  }},
  "behavior_probabilities": {{
    "use_coupon": 0.0,
    "bind_wechat": 0.0,
    "add_ticket_person": 0.0,
    "accumulate_points": 0.0,
    "use_time_card": 0.0,
    "complete_id_check": 0.0,
    "complete_health_check": 0.0
  }},
  "typical_order_types": ["..."],
  "avg_monthly_orders": 0,
  "avg_order_amount_range": [0, 0],
  "dirty_data_probability": 0.02,
  "notes": "改造说明（可选）"
}}"""


# ─── 核心函数 ─────────────────────────────────────────────────────────────────
def _load_system_prompt() -> str:
    p = Path("prompts/persona_adapt.txt")
    return p.read_text(encoding="utf-8") if p.exists() else _PROMPT_B_SYSTEM_INLINE


def call_llm(system_prompt: str, user_msg: str, model: str = API_MODEL) -> str:
    """调用远端 OpenAI-compatible API，返回响应文本。

    Qwen3 系列 thinking 模式处理策略：
    - 顶层 enable_thinking=False 在 vllm 0.26.0 上无效
    - 使用 chat_template_kwargs={"enable_thinking": False} 直接控制 chat template，关闭 thinking
    - 备用方案（两种均无效时）：max_tokens=8192，thinking token 先跑完再输出 content
    """
    resp = requests.post(
        f"{API_BASE}/chat/completions",
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json",
        },
        json={
            "model": model,
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user",   "content": user_msg},
            ],
            "temperature": 0.7,
            "max_tokens": 2048,
            "chat_template_kwargs": {"enable_thinking": False},
        },
        timeout=120,
    )
    resp.raise_for_status()
    choice = resp.json()["choices"][0]["message"]
    content = choice.get("content") or ""
    if not content.strip():
        raise ValueError(f"API 返回空 content（finish_reason={resp.json()['choices'][0]['finish_reason']}）")
    return content.strip()


def _infer_target_system(text: str) -> str:
    """
    根据原始 Persona 文本推断改造目标系统。
    目标分布：jianengliang ~60%，training ~20%，vmdb ~20%（cross_system ~8% 随机）。
    优先级：vmdb > training > cross_system > jianengliang

    63K候选库词频分析结论：
    - vmdb 加入 music/performance/show/opera/stadium/theater/festival 等高频词后可覆盖约12%
    - training 精准词覆盖约13%，接近目标
    - 两者合计25%，剩余约67%落 jianengliang，与目标60%接近（偏差由cross_system随机稍降jia）
    """
    t = text.lower()

    # vmdb（场馆门禁/票务/演艺）：观演/赛事/音乐/演出场景
    VMDB_KW = [
        # 票务/球迷精准词
        "season ticket", "sports fan", "football fan", "basketball fan", "hockey fan",
        "concert", "ticket", "tickets", "live event", "live music",
        "live performance", "live show", "live game", "live match",
        "cinema", "film enthusiast", "moviegoer", "movie theater",
        "theater goer", "theatre goer", "music fan", "music lover",
        "festival goer", "box office", "spectator",
        "fan of", "fans of", "attend the", "season pass",
        # 演艺场馆高频词
        "theater", "theatre", "stadium", "arena",
        "opera", "opera fan", "opera lover",
        "performance", "show", "music",
        "festival", "tournament", "championship",
        "audience", "stage",
        # 舞蹈/表演者
        "dancer", "choreographer", "ballet",
        # 赛事/活动
        "hockey", "playoff", "commentator", "broadcaster",
        "sports enthusiast", "event organizer", "event planner",
    ]
    if any(kw in t for kw in VMDB_KW):
        return "vmdb"

    # training（培训课程）：教学/训练角色
    TRAINING_STRICT = [
        "coach", "coaching", "instructor",
        "teaches", "teaching", "teacher",
        "professor", "tutor", "tutoring", "trainee",
        "class", "classes", "course", "courses",
        "lesson", "lessons",
    ]
    TRAINING_ATHLETE = [
        "player", "players", "athlete", "athletes",
        "youth team", "school team", "club member",
    ]
    TRAINING_STUDENT_SKILL = (
        any(kw in t for kw in ["student", "students"]) and
        any(kw in t for kw in ["train", "training", "practice", "skill", "skills", "technique", "improve", "learn"])
    )

    if any(kw in t for kw in TRAINING_STRICT):
        return "training"
    if any(kw in t for kw in TRAINING_ATHLETE):
        return "training"
    if TRAINING_STUDENT_SKILL:
        return "training"

    # cross_system（小概率随机）
    if random.random() < 0.08:
        return "cross_system"

    return "jianengliang"


def _extract_json(raw: str) -> dict:
    """从 LLM 响应中提取第一个完整 JSON 对象。"""
    start = raw.find("{")
    end   = raw.rfind("}") + 1
    if start == -1 or end == 0:
        raise ValueError("响应中未找到 JSON 对象")
    return json.loads(raw[start:end])


def _validate(parsed: dict) -> list[str]:
    """返回缺失字段列表；空列表=通过。"""
    missing = [k for k in SCHEMA_REQUIRED if k not in parsed]
    if "dimensions" in parsed:
        missing += [f"dimensions.{k}" for k in DIM_REQUIRED if k not in parsed["dimensions"]]
    if "behavior_probabilities" in parsed:
        missing += [f"behavior_probabilities.{k}" for k in PROB_REQUIRED if k not in parsed["behavior_probabilities"]]
    return missing


def adapt_persona(raw: dict, index: int, model: str, system_prompt: str) -> dict | None:
    """将单条原始 PersonaHub 改造为 WentiPersona JSON，失败重试3次。"""
    original_text = raw.get("input_persona", raw.get("persona", "")).strip()
    if not original_text:
        return None

    # 优先使用分层采样预分配的 system，否则自动推断
    target_system = raw.get("_preset_system") or _infer_target_system(original_text)
    persona_id    = f"P_HUB_{index:04d}"

    user_msg = USER_PROMPT_TEMPLATE.format(
        original_text=original_text,
        target_system=target_system,
        persona_id=persona_id,
    )

    for attempt in range(3):
        try:
            raw_resp = call_llm(system_prompt, user_msg, model)
            parsed   = _extract_json(raw_resp)
            missing  = _validate(parsed)
            if missing:
                raise ValueError(f"缺少字段: {missing}")
            parsed["original_persona"] = original_text  # 保留原始描述
            return parsed
        except Exception as e:
            wait = 2 ** attempt
            print(f"  [retry {attempt+1}/3] index={index} err={e}, wait {wait}s", flush=True)
            time.sleep(wait)
    return None  # 三次全败，交由调用方记录错误


def check_distribution(personas: list[dict]) -> bool:
    """打印 system 分布并返回是否全部达标。"""
    from collections import Counter
    total  = len(personas)
    counts = Counter(p.get("system", "unknown") for p in personas)
    ok     = True
    print(f"\n[分布校验] 共 {total} 条")
    for sys_name, (lo, hi) in SYSTEM_WEIGHTS_TARGET.items():
        n     = counts[sys_name]
        ratio = n / total if total else 0
        flag  = "OK  " if lo <= ratio <= hi else "WARN"
        print(f"  {flag} {sys_name:15s}: {ratio:.1%} (目标 {lo:.0%}-{hi:.0%}, n={n})")
        if flag != "OK  ":
            ok = False
    dirty_n = sum(1 for p in personas if p.get("dirty_data_probability", 0) >= 0.10)
    dirty_r = dirty_n / total if total else 0
    flag    = "OK  " if 0.05 <= dirty_r <= 0.12 else "WARN"
    print(f"  {flag} dirty_data(>=0.10)  : {dirty_r:.1%} (目标 5%-12%, n={dirty_n})")
    return ok


# ─── 入口 ─────────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description="PersonaHub -> 文体Persona 改造器")
    parser.add_argument("--input",   default="wenti_data_simulator/data/personas/persona_hub_candidates.jsonl")
    parser.add_argument("--output",  default="wenti_data_simulator/data/personas/wenti_personas.jsonl")
    parser.add_argument("--errors",  default="wenti_data_simulator/data/personas/error_log.jsonl")
    parser.add_argument("--model",   default=API_MODEL)
    parser.add_argument("--limit",   type=int, default=None, help="只处理前N条（测试用）")
    parser.add_argument("--workers", type=int, default=4,    help="并发线程数（远端API可适当并发，建议4-8）")
    parser.add_argument("--dry-run", action="store_true",    help="测试模式：不写输出文件")
    parser.add_argument("--resume",  action="store_true",    help="跳过已写入输出文件中的 persona_id")
    args = parser.parse_args()

    inp_path = Path(args.input)
    out_path = Path(args.output)
    err_path = Path(args.errors)

    if not inp_path.exists():
        print(f"错误：输入文件不存在 {inp_path}")
        sys.exit(1)

    lines = inp_path.read_text(encoding="utf-8").strip().splitlines()
    if args.limit:
        lines = lines[:args.limit]

    # 断点续传：跳过已有 persona_id
    done_ids: set[str] = set()
    if args.resume and out_path.exists():
        for l in out_path.read_text(encoding="utf-8").splitlines():
            try:
                done_ids.add(json.loads(l)["persona_id"])
            except Exception:
                pass
        print(f"续传模式：已跳过 {len(done_ids)} 条")

    pending = []
    for i, line in enumerate(lines):
        pid = f"P_HUB_{i:04d}"
        if pid not in done_ids:
            pending.append((i, json.loads(line)))

    print(f"待处理：{len(pending)} 条 | 模型：{args.model} | workers：{args.workers}")

    system_prompt = _load_system_prompt()
    results: list[dict] = []
    errors:  list[dict] = []

    out_path.parent.mkdir(parents=True, exist_ok=True)

    mode = "a" if args.resume else "w"
    out_f = open(out_path, mode, encoding="utf-8") if not args.dry_run else None
    err_f = open(err_path, mode, encoding="utf-8") if not args.dry_run else None

    def process_one(item):
        idx, raw = item
        result = adapt_persona(raw, idx, args.model, system_prompt)
        return idx, raw, result

    try:
        with ThreadPoolExecutor(max_workers=args.workers) as executor:
            futures = {executor.submit(process_one, item): item for item in pending}
            done_count = 0
            for future in as_completed(futures):
                idx, raw, result = future.result()
                done_count += 1
                original_text = raw.get("input_persona", raw.get("persona", ""))[:60]
                if result:
                    results.append(result)
                    if out_f:
                        out_f.write(json.dumps(result, ensure_ascii=False) + "\n")
                        out_f.flush()
                    print(f"  [{done_count}/{len(pending)}] OK  P_HUB_{idx:04d} | {original_text[:50]}...", flush=True)
                else:
                    error_rec = {"persona_id": f"P_HUB_{idx:04d}", "original": original_text, "status": "failed"}
                    errors.append(error_rec)
                    if err_f:
                        err_f.write(json.dumps(error_rec, ensure_ascii=False) + "\n")
                        err_f.flush()
                    print(f"  [{done_count}/{len(pending)}] FAIL P_HUB_{idx:04d} | {original_text[:50]}...", flush=True)
    finally:
        if out_f:
            out_f.close()
        if err_f:
            err_f.close()

    print(f"\n改造完成：成功 {len(results)} 条，失败 {len(errors)} 条")
    pass_rate = len(results) / len(pending) * 100 if pending else 0
    print(f"JSON验证通过率：{pass_rate:.1f}%", end="")
    if pass_rate < 80:
        print(" [WARN] 低于80%，建议优化 Prompt B（prompts/persona_adapt.txt）或更换模型")
    else:
        print(" [OK]")

    if results:
        check_distribution(results)

    if args.dry_run:
        print("\n[干运行模式] 结果未写入文件，以上为预览。")


if __name__ == "__main__":
    main()
