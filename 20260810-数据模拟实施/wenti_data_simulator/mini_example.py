#!/usr/bin/env python3
"""
P1 冒烟测试 — mini_example.py
演示：随机抽取1条实例 → 层一行为决策(LLM) → 层二字段翻译(LLM) → 3张CSV
单文件独立运行，不依赖项目其他模块。

用法：
    cd 20260810-数据模拟实施
    python wenti_data_simulator/mini_example.py
    python wenti_data_simulator/mini_example.py --instance-id INST_0042
    python wenti_data_simulator/mini_example.py --dry-run   # 不写文件，仅打印

数据源：仅读取 wenti_persona_instances.jsonl（实例库），文件不存在则报错退出。
"""

import argparse
import csv
import json
import random
import sys
import time
from datetime import datetime, timedelta
from pathlib import Path

import requests

sys.stdout.reconfigure(encoding="utf-8")

# ── 配置 ─────────────────────────────────────────────────────────────────────
API_BASE  = "http://10.20.77.89:8000/v1"
API_KEY   = "shuangan645310"
API_MODEL = "Qwen3.6-35B-A3B"

DATA_DIR      = Path("wenti_data_simulator/data/personas")
OUTPUT_DIR    = Path("wenti_data_simulator/mini_example_output")
INSTANCE_FILE = DATA_DIR / "wenti_persona_instances.jsonl"

SEED = 42
random.seed(SEED)


# ── LLM 调用 ──────────────────────────────────────────────────────────────────
def call_llm(system: str, user: str, temperature: float = 0.7) -> str:
    """调用远端 vllm API，返回响应文本（已 strip）。"""
    resp = requests.post(
        f"{API_BASE}/chat/completions",
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json",
        },
        json={
            "model":       API_MODEL,
            "messages":    [
                {"role": "system", "content": system},
                {"role": "user",   "content": user},
            ],
            "temperature": temperature,
            "max_tokens":  2048,
            "chat_template_kwargs": {"enable_thinking": False},
        },
        timeout=120,
    )
    resp.raise_for_status()
    content = resp.json()["choices"][0]["message"].get("content") or ""
    if not content.strip():
        raise ValueError("API 返回空 content")
    return content.strip()


def extract_json(text: str) -> dict:
    """从 LLM 响应中提取第一个完整 JSON 对象（兼容前后有说明文字的情况）。"""
    start = text.find("{")
    end   = text.rfind("}") + 1
    if start == -1 or end == 0:
        raise ValueError(f"响应中未找到 JSON 对象: {text[:200]}")
    return json.loads(text[start:end])


# ── 加载实例 ──────────────────────────────────────────────────────────────────
def load_instance(instance_id: str | None = None) -> dict:
    """从 wenti_persona_instances.jsonl 加载实例，文件不存在则报错退出。"""
    if not INSTANCE_FILE.exists():
        print(f"[错误] 实例库不存在：{INSTANCE_FILE}")
        print("请先运行 run_instantiate.bat 完成 P0-5 实例化。")
        sys.exit(1)

    lines = INSTANCE_FILE.read_text(encoding="utf-8").strip().splitlines()
    print(f"[数据源] {INSTANCE_FILE.name}（{len(lines)} 条已生成）")

    if instance_id:
        candidates = [json.loads(l) for l in lines
                      if f'"instance_id": "{instance_id}"' in l]
        if not candidates:
            print(f"[错误] 未找到 instance_id={instance_id}")
            sys.exit(1)
        return candidates[0]

    # 随机抽取 jianengliang / cross_system 类型
    candidates = [json.loads(l) for l in lines
                  if '"jianengliang"' in l or '"cross_system"' in l]
    if not candidates:
        print("[错误] 实例库中无 jianengliang/cross_system 类型实例")
        sys.exit(1)
    return random.choice(candidates)


# ── 层一：行为决策（Prompt C 简化版）────────────────────────────────────────────
BEHAVIOR_SYSTEM = (
    "你是文体消费行为模拟专家。"
    "根据用户画像，在给定场景下做出真实合理的消费行为决策。"
    "只输出一个 JSON 对象，不要任何 markdown 代码块或解释文字。"
)

BEHAVIOR_USER_TPL = """# 任务
根据以下用户信息，模拟一次"工作日晚上购买游泳票"场景的行为决策。

# 用户信息
{user_info}

# 用户行为概率（供参考）
{behavior_probs}

# 可用场馆
[{{"venue_id": 1, "name": "深圳湾体育中心游泳馆", "city": "深圳市"}}]

# 可用优惠券
[{{"coupon_code_id": "C001", "name": "满50减10", "min_amount": 50, "discount": 10}}]

# 输出 JSON（严格遵守以下 keys，purchase_intent=false 时其余字段可填 null）
{{
  "purchase_intent": true,
  "order_type": "3",
  "ticket_type": 1,
  "quantity": 1,
  "preferred_venue_id": 1,
  "use_coupon": true,
  "coupon_code_id": "C001 或 null",
  "payment_method": "2",
  "session_time": "evening",
  "add_ticket_people": false,
  "ticket_people_count": 0,
  "estimated_cost": 60.0,
  "estimated_discount": 10.0,
  "estimated_pay_amount": 50.0,
  "reasoning": "简短说明决策依据"
}}"""


def step1_behavior(instance: dict) -> dict:
    """层一：行为决策"""
    print("\n[层一] 调用 LLM 生成行为决策…", flush=True)

    user_info = {
        "姓名": instance.get("name", ""),
        "性别": instance.get("gender", ""),
        "年龄": instance.get("age", ""),
        "城市": f"{instance.get('province','')} {instance.get('city','')}",
        "年薪": instance.get("annual_income", ""),
        "用户类型": instance.get("dimensions", {}).get("user_type", ""),
        "价格敏感度": instance.get("dimensions", {}).get("price_sensitivity", ""),
        "偏好场景": instance.get("dimensions", {}).get("preferred_scenes", []),
        "活跃时段": instance.get("dimensions", {}).get("active_hours", ""),
    }

    user_msg = BEHAVIOR_USER_TPL.format(
        user_info=json.dumps(user_info, ensure_ascii=False, indent=2),
        behavior_probs=json.dumps(
            instance.get("behavior_probabilities", {}), ensure_ascii=False
        ),
    )

    t0  = time.time()
    raw = call_llm(BEHAVIOR_SYSTEM, user_msg, temperature=0.7)
    print(f"  耗时 {time.time()-t0:.1f}s")

    result = extract_json(raw)
    print(f"  purchase_intent={result.get('purchase_intent')}, "
          f"use_coupon={result.get('use_coupon')}, "
          f"pay={result.get('estimated_pay_amount')}")
    return result


# ── 层二：字段翻译（Prompt D 简化版）────────────────────────────────────────────
FIELD_SYSTEM = (
    "你是数据库记录生成专家。"
    "严格遵守枚举规范，将行为决策翻译为数据库字段值。"
    "只输出一个 JSON 对象，不要任何 markdown 代码块或解释文字。"
)

FIELD_USER_TPL = """# 任务
将以下行为决策翻译为三张数据库表的字段值，直接用于 INSERT。

# 行为决策
{decision_json}

# 用户基本信息（直接使用以下值，不要重新生成）
{user_basic}

# 上下文
- member_id: {member_id}
- order_seq: {order_seq}
- create_time: "{create_time}"
- pay_time: "{pay_time}"（晚于 create_time {offset_minutes} 分钟）

# 枚举约束（必须严格遵守）
- j_member.sex: 1=男 2=女 0=不明
- j_member.source: 1=安卓 2=iOS 3=小程序 4=后台
- j_member_order.type（VARCHAR）: "3"=游泳票
- j_member_order.status（VARCHAR，游泳票）: "0"待支付/"2"已支付待使用/"3"未支付超时/"4"已支付已使用
- j_member_order.pay_way（VARCHAR）: "1"支付宝/"2"微信/"3"小程序
- j_member_order.is_pay: 0=未支付 1=已支付（与 status 一致）
- j_bill.bill_type: 1=充值 2=消费 3=退款 4=赠送

# 字段生成规则
- phone: 11位手机号，从以下号段随机选取：130-139/150-159/170-179/180-189开头，后8位为随机数字；禁止使用 13800138000 等连续测试占位号
- id_card: 18位，前6位用广东省地区码44030x
- order_num: "JN{order_seq:014d}"（固定格式，直接使用上下文中的 order_seq）
- pay_amount = cost - discount_amount（金额必须匹配）
- j_bill.amount = j_member_order.pay_amount（同一笔消费）

# 输出 JSON（严格遵守以下结构，所有 key 必须存在）
{{
  "j_member": {{
    "id": {member_id},
    "phone": "...",
    "nick_name": "...",
    "user_name": "...",
    "sex": 1,
    "age": ...,
    "birthday": "YYYY-MM-DD",
    "province": "...",
    "city": "...",
    "area": "...",
    "source": 3,
    "is_vip": 0,
    "rank": 0,
    "is_blacklist": 0,
    "member_status": 1,
    "id_card": "...",
    "id_card_check": 1,
    "report_check": 1,
    "created_time": "{create_time}"
  }},
  "j_member_order": {{
    "id": 1,
    "order_num": "JN{order_seq:014d}",
    "user_id": {member_id},
    "phone": "...",
    "venue_id": 1,
    "sport_id": 1,
    "type": "3",
    "status": "2",
    "is_pay": 1,
    "pay_way": "2",
    "cost": ...,
    "discount_amount": ...,
    "pay_amount": ...,
    "service_charge": 0.0,
    "is_refund": 0,
    "create_time": "{create_time}",
    "order_time": "{create_time}",
    "pay_time": "{pay_time}"
  }},
  "j_bill": {{
    "id": 1,
    "user_id": {member_id},
    "order_num": "JN{order_seq:014d}",
    "bill_type": 2,
    "amount": ...,
    "balance_after": 0.0,
    "created_time": "{create_time}"
  }}
}}"""


def step2_fields(decision: dict, instance: dict, member_id: int, order_seq: int) -> dict:
    """层二：字段翻译"""
    print("\n[层二] 调用 LLM 翻译字段值…", flush=True)

    now      = datetime.now()
    create_t = now.strftime("%Y-%m-%d %H:%M:%S")
    offset   = random.randint(1, 15)
    pay_t    = (now + timedelta(minutes=offset)).strftime("%Y-%m-%d %H:%M:%S")

    user_basic = {
        "姓名（user_name）": instance.get("name", ""),
        "性别（sex）": 1 if instance.get("gender") == "male" else 2,
        "年龄（age）": instance.get("age", 28),
        "省份（province）": instance.get("province", "广东省"),
        "城市（city）": instance.get("city", "深圳市"),
        "区（area）": instance.get("district", ""),
        "说明": "以上字段请直接使用，不要重新生成",
    }

    user_msg = FIELD_USER_TPL.format(
        decision_json=json.dumps(decision, ensure_ascii=False, indent=2),
        user_basic=json.dumps(user_basic, ensure_ascii=False, indent=2),
        member_id=member_id,
        order_seq=order_seq,
        create_time=create_t,
        pay_time=pay_t,
        offset_minutes=offset,
    )

    t0  = time.time()
    raw = call_llm(FIELD_SYSTEM, user_msg, temperature=0.3)
    print(f"  耗时 {time.time()-t0:.1f}s")

    return extract_json(raw)


# ── 验证 ───────────────────────────────────────────────────────────────────────
VALID_ORDER_STATUS = {"0", "2", "3", "4", "5", "6", "7", "8",
                      "30", "31", "32", "33", "34", "35", "36",
                      "37", "38", "39", "40", "41", "42"}
VALID_PAY_WAY   = {"1", "2", "3"}
VALID_BILL_TYPE = {1, 2, 3, 4}


def validate(records: dict) -> list[str]:
    """基本字段验证，返回 warning 列表（不阻断写出）。"""
    warnings = []
    order = records.get("j_member_order", {})
    bill  = records.get("j_bill", {})

    ct = order.get("create_time") or order.get("order_time")
    pt = order.get("pay_time")
    if ct and pt and pt < ct:
        warnings.append(f"[时序] pay_time({pt}) < create_time({ct})")

    cost    = float(order.get("cost", 0) or 0)
    disc    = float(order.get("discount_amount", 0) or 0)
    pay_amt = float(order.get("pay_amount", 0) or 0)
    expected = round(cost - disc, 2)
    if abs(pay_amt - expected) > 0.01:
        warnings.append(
            f"[金额] pay_amount({pay_amt}) ≠ cost({cost}) - discount({disc}) = {expected}"
        )

    status = str(order.get("status", ""))
    is_pay = order.get("is_pay")
    if status in {"2", "4", "7"} and is_pay != 1:
        warnings.append(f"[状态] status={status} 但 is_pay={is_pay}，应为 1")
    if status in {"0", "3"} and is_pay not in (0, None):
        warnings.append(f"[状态] status={status} 但 is_pay={is_pay}，应为 0")

    if status and status not in VALID_ORDER_STATUS:
        warnings.append(f"[枚举] order.status={status!r} 不在合法值集合中")
    pw = str(order.get("pay_way", "")) if order.get("pay_way") else ""
    if pw and pw not in VALID_PAY_WAY:
        warnings.append(f"[枚举] pay_way={pw!r} 应为 1/2/3")
    bt = bill.get("bill_type")
    if bt is not None and bt not in VALID_BILL_TYPE:
        warnings.append(f"[枚举] bill.bill_type={bt!r} 应为 1/2/3/4")

    bill_amt = float(bill.get("amount", 0) or 0)
    if abs(bill_amt - pay_amt) > 0.01:
        warnings.append(f"[金额] bill.amount({bill_amt}) ≠ order.pay_amount({pay_amt})")

    return warnings


# ── CSV 写出 ──────────────────────────────────────────────────────────────────
def write_csv(table: str, rows: list[dict], output_dir: Path):
    if not rows or not rows[0]:
        print(f"  [跳过] {table}：空记录")
        return
    fpath = output_dir / f"{table}.csv"
    with open(fpath, "w", newline="", encoding="utf-8-sig") as fh:
        writer = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)
    print(f"  → {fpath}（{len(rows)} 行）")


# ── 主流程 ────────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description="P1 冒烟测试")
    parser.add_argument("--instance-id", default=None,
                        help="指定 instance_id（如 INST_0042），默认随机抽取")
    parser.add_argument("--dry-run", action="store_true",
                        help="不写 CSV，仅打印结果")
    args = parser.parse_args()

    t_start = time.time()
    print("=" * 60)
    print("P1 冒烟测试 — mini_example.py")
    print("=" * 60)

    instance = load_instance(args.instance_id)
    pid   = instance.get("instance_id", "?")
    pname = instance.get("name", "")
    print(f"实例: {pid}  {pname}")
    print(f"System: {instance.get('system')}  "
          f"用户类型: {instance.get('dimensions', {}).get('user_type', '?')}")
    print(f"年龄: {instance.get('age')}  "
          f"城市: {instance.get('province', '')} {instance.get('city', '')}")
    print()

    decision = step1_behavior(instance)
    if not decision.get("purchase_intent", True):
        print("\n[结果] 该实例无购买意向（purchase_intent=false），冒烟测试结束。")
        print("提示：重新运行或用 --instance-id 指定其他实例。")
        return

    member_id = random.randint(10001, 99999)
    order_seq = random.randint(1, 9999)
    records   = step2_fields(decision, instance, member_id, order_seq)

    print("\n[验证]")
    warns = validate(records)
    if warns:
        for w in warns:
            print(f"  ⚠️  {w}")
    else:
        print("  ✅ 全部通过（时序 / 金额 / 枚举）")

    order = records.get("j_member_order", {})
    print(f"\n[摘要]")
    print(f"  member_id  : {member_id}")
    print(f"  order_num  : {order.get('order_num', '?')}")
    print(f"  status     : {order.get('status', '?')}")
    print(f"  cost       : {order.get('cost', '?')}")
    print(f"  pay_amount : {order.get('pay_amount', '?')}")
    print(f"  pay_time   : {order.get('pay_time', '?')}")

    if args.dry_run:
        print("\n[干运行] 跳过文件写出，以下为原始 JSON：")
        print(json.dumps(records, ensure_ascii=False, indent=2))
    else:
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
        print(f"\n[写出] → {OUTPUT_DIR}/")
        write_csv("j_member",       [records.get("j_member", {})],       OUTPUT_DIR)
        write_csv("j_member_order", [records.get("j_member_order", {})], OUTPUT_DIR)
        write_csv("j_bill",         [records.get("j_bill", {})],         OUTPUT_DIR)

    total = time.time() - t_start
    print(f"\n完成！总耗时 {total:.1f}s，LLM 调用 2 次。")
    if not args.dry_run:
        print(f"输出目录: {OUTPUT_DIR.resolve()}")
    print("=" * 60)


if __name__ == "__main__":
    main()


import argparse
import csv
import json
import random
import re
import sys
import time
from datetime import datetime, timedelta
from pathlib import Path

import requests

sys.stdout.reconfigure(encoding="utf-8")

# ── 配置 ─────────────────────────────────────────────────────────────────────
API_BASE  = "http://10.20.77.89:8000/v1"
API_KEY   = "shuangan645310"
API_MODEL = "Qwen3.6-35B-A3B"

DATA_DIR   = Path("wenti_data_simulator/data/personas")
OUTPUT_DIR = Path("wenti_data_simulator/mini_example_output")

INSTANCE_FILE = DATA_DIR / "wenti_persona_instances.jsonl"
PERSONA_FILE  = DATA_DIR / "wenti_personas.jsonl"

SEED = 42
random.seed(SEED)


# ── LLM 调用 ──────────────────────────────────────────────────────────────────
def call_llm(system: str, user: str, temperature: float = 0.7) -> str:
    """调用远端 vllm API，返回响应文本（已 strip）。"""
    resp = requests.post(
        f"{API_BASE}/chat/completions",
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json",
        },
        json={
            "model":       API_MODEL,
            "messages":    [
                {"role": "system", "content": system},
                {"role": "user",   "content": user},
            ],
            "temperature": temperature,
            "max_tokens":  2048,
            "chat_template_kwargs": {"enable_thinking": False},
        },
        timeout=120,
    )
    resp.raise_for_status()
    content = resp.json()["choices"][0]["message"].get("content") or ""
    if not content.strip():
        raise ValueError("API 返回空 content")
    return content.strip()


def extract_json(text: str) -> dict:
    """从 LLM 响应中提取第一个完整 JSON 对象（兼容前后有说明文字的情况）。"""
    start = text.find("{")
    end   = text.rfind("}") + 1
    if start == -1 or end == 0:
        raise ValueError(f"响应中未找到 JSON 对象: {text[:200]}")
    return json.loads(text[start:end])


# ── 加载实例 / Persona ────────────────────────────────────────────────────────
def load_instance(instance_id: str | None = None) -> tuple[dict, str]:
    """
    优先从 wenti_persona_instances.jsonl 加载实例，
    不存在时 fallback 到 wenti_personas.jsonl。
    返回 (record, source_type)，source_type: "instance" | "persona" | "fallback"
    """
    # ── 尝试实例库 ──
    if INSTANCE_FILE.exists():
        lines = INSTANCE_FILE.read_text(encoding="utf-8").strip().splitlines()
        if instance_id:
            candidates = [json.loads(l) for l in lines
                          if f'"instance_id": "{instance_id}"' in l]
        else:
            candidates = [json.loads(l) for l in lines
                          if '"jianengliang"' in l or '"cross_system"' in l]
        if candidates:
            rec = random.choice(candidates)
            print(f"[数据源] wenti_persona_instances.jsonl ({len(lines)} 条已生成)")
            return rec, "instance"

    # ── fallback：Persona 库 ──
    if PERSONA_FILE.exists():
        lines = PERSONA_FILE.read_text(encoding="utf-8").strip().splitlines()
        candidates = [json.loads(l) for l in lines
                      if '"jianengliang"' in l or '"cross_system"' in l]
        if candidates:
            rec = random.choice(candidates)
            print(f"[数据源] wenti_personas.jsonl（实例库未就绪，fallback）")
            return rec, "persona"

    # ── 内嵌 fallback ──
    print("[数据源] 内嵌 fallback（数据文件均不存在）")
    return {
        "persona_id": "FALLBACK_001",
        "name": "活力小李",
        "gender": "male",
        "age": 26,
        "province": "广东省",
        "city": "深圳市",
        "annual_income": 120000,
        "system": "jianengliang",
        "dimensions": {
            "user_type": "上班族",
            "price_sensitivity": "medium",
            "preferred_scenes": ["游泳", "订场"],
            "active_hours": "evening",
            "consumption_frequency": "medium",
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
        "avg_monthly_orders": 4,
        "avg_order_amount_range": [40, 120],
        "dirty_data_probability": 0.02,
    }, "fallback"


# ── 层一：行为决策（Prompt C 简化版）────────────────────────────────────────────
BEHAVIOR_SYSTEM = (
    "你是文体消费行为模拟专家。"
    "根据用户画像，在给定场景下做出真实合理的消费行为决策。"
    "只输出一个 JSON 对象，不要任何 markdown 代码块或解释文字。"
)

BEHAVIOR_USER_TPL = """# 任务
根据以下用户信息，模拟一次"工作日晚上购买游泳票"场景的行为决策。

# 用户信息
{user_info}

# 用户行为概率（供参考）
{behavior_probs}

# 可用场馆
[{{"venue_id": 1, "name": "深圳湾体育中心游泳馆", "city": "深圳市"}}]

# 可用优惠券
[{{"coupon_code_id": "C001", "name": "满50减10", "min_amount": 50, "discount": 10}}]

# 输出 JSON（严格遵守以下 keys，purchase_intent=false 时其余字段可填 null）
{{
  "purchase_intent": true,
  "order_type": "3",
  "ticket_type": 1,
  "quantity": 1,
  "preferred_venue_id": 1,
  "use_coupon": true,
  "coupon_code_id": "C001 或 null",
  "payment_method": "2",
  "session_time": "evening",
  "add_ticket_people": false,
  "ticket_people_count": 0,
  "estimated_cost": 60.0,
  "estimated_discount": 10.0,
  "estimated_pay_amount": 50.0,
  "reasoning": "简短说明决策依据"
}}"""


def step1_behavior(instance: dict, source_type: str) -> dict:
    """层一：行为决策"""
    print("\n[层一] 调用 LLM 生成行为决策…", flush=True)

    # 根据数据源构建用户信息摘要
    if source_type == "instance":
        user_info = {
            "姓名": instance.get("name", ""),
            "性别": instance.get("gender", ""),
            "年龄": instance.get("age", ""),
            "城市": f"{instance.get('province','')} {instance.get('city','')}",
            "年薪": instance.get("annual_income", ""),
            "用户类型": instance.get("dimensions", {}).get("user_type", ""),
            "价格敏感度": instance.get("dimensions", {}).get("price_sensitivity", ""),
            "偏好场景": instance.get("dimensions", {}).get("preferred_scenes", []),
            "活跃时段": instance.get("dimensions", {}).get("active_hours", ""),
        }
    else:
        dims = instance.get("dimensions", {})
        user_info = {
            "Persona": instance.get("name", instance.get("persona_id", "")),
            "用户类型": dims.get("user_type", ""),
            "价格敏感度": dims.get("price_sensitivity", ""),
            "偏好场景": dims.get("preferred_scenes", []),
            "活跃时段": dims.get("active_hours", ""),
        }

    user_msg = BEHAVIOR_USER_TPL.format(
        user_info=json.dumps(user_info, ensure_ascii=False, indent=2),
        behavior_probs=json.dumps(
            instance.get("behavior_probabilities", {}), ensure_ascii=False
        ),
    )

    t0  = time.time()
    raw = call_llm(BEHAVIOR_SYSTEM, user_msg, temperature=0.7)
    print(f"  耗时 {time.time()-t0:.1f}s")

    result = extract_json(raw)
    print(f"  purchase_intent={result.get('purchase_intent')}, "
          f"use_coupon={result.get('use_coupon')}, "
          f"pay={result.get('estimated_pay_amount')}")
    return result


# ── 层二：字段翻译（Prompt D 简化版）────────────────────────────────────────────
FIELD_SYSTEM = (
    "你是数据库记录生成专家。"
    "严格遵守枚举规范，将行为决策翻译为数据库字段值。"
    "只输出一个 JSON 对象，不要任何 markdown 代码块或解释文字。"
)

FIELD_USER_TPL = """# 任务
将以下行为决策翻译为三张数据库表的字段值，直接用于 INSERT。

# 行为决策
{decision_json}

# 用户基本信息（直接使用以下值，不要重新生成）
{user_basic}

# 上下文
- member_id: {member_id}
- order_seq: {order_seq}
- create_time: "{create_time}"
- pay_time: "{pay_time}"（晚于 create_time {offset_minutes} 分钟）

# 枚举约束（必须严格遵守）
- j_member.sex: 1=男 2=女 0=不明
- j_member.source: 1=安卓 2=iOS 3=小程序 4=后台
- j_member_order.type（VARCHAR）: "3"=游泳票
- j_member_order.status（VARCHAR，游泳票）: "0"待支付/"2"已支付待使用/"3"未支付超时/"4"已支付已使用
- j_member_order.pay_way（VARCHAR）: "1"支付宝/"2"微信/"3"小程序
- j_member_order.is_pay: 0=未支付 1=已支付（与 status 一致）
- j_bill.bill_type: 1=充值 2=消费 3=退款 4=赠送

# 字段生成规则
- phone: 11位手机号，从以下号段随机选取：130-139/150-159/170-179/180-189开头，后8位为随机数字；禁止使用 13800138000 等连续测试占位号
- id_card: 18位，前6位用广东省地区码44030x
- order_num: "JN{order_seq:014d}"（固定格式，直接使用上下文中的 order_seq）
- pay_amount = cost - discount_amount（金额必须匹配）
- j_bill.amount = j_member_order.pay_amount（同一笔消费）

# 输出 JSON（严格遵守以下结构，所有 key 必须存在）
{{
  "j_member": {{
    "id": {member_id},
    "phone": "...",
    "nick_name": "...",
    "user_name": "...",
    "sex": 1,
    "age": ...,
    "birthday": "YYYY-MM-DD",
    "province": "...",
    "city": "...",
    "area": "...",
    "source": 3,
    "is_vip": 0,
    "rank": 0,
    "is_blacklist": 0,
    "member_status": 1,
    "id_card": "...",
    "id_card_check": 1,
    "report_check": 1,
    "created_time": "{create_time}"
  }},
  "j_member_order": {{
    "id": 1,
    "order_num": "JN{order_seq:014d}",
    "user_id": {member_id},
    "phone": "...",
    "venue_id": 1,
    "sport_id": 1,
    "type": "3",
    "status": "2",
    "is_pay": 1,
    "pay_way": "2",
    "cost": ...,
    "discount_amount": ...,
    "pay_amount": ...,
    "service_charge": 0.0,
    "is_refund": 0,
    "create_time": "{create_time}",
    "order_time": "{create_time}",
    "pay_time": "{pay_time}"
  }},
  "j_bill": {{
    "id": 1,
    "user_id": {member_id},
    "order_num": "JN{order_seq:014d}",
    "bill_type": 2,
    "amount": ...,
    "balance_after": 0.0,
    "created_time": "{create_time}"
  }}
}}"""


def step2_fields(decision: dict, instance: dict, source_type: str,
                 member_id: int, order_seq: int) -> dict:
    """层二：字段翻译"""
    print("\n[层二] 调用 LLM 翻译字段值…", flush=True)

    now      = datetime.now()
    create_t = now.strftime("%Y-%m-%d %H:%M:%S")
    offset   = random.randint(1, 15)
    pay_t    = (now + timedelta(minutes=offset)).strftime("%Y-%m-%d %H:%M:%S")

    # 从实例直接取基本信息，减少 LLM 重新生成的概率
    if source_type == "instance":
        user_basic = {
            "姓名（user_name）": instance.get("name", ""),
            "性别（sex）": 1 if instance.get("gender") == "male" else 2,
            "年龄（age）": instance.get("age", 28),
            "省份（province）": instance.get("province", "广东省"),
            "城市（city）": instance.get("city", "深圳市"),
            "说明": "以上字段请直接使用，不要重新生成",
        }
    else:
        user_basic = {"说明": "请根据行为决策和 Persona 信息合理生成用户基本信息"}

    user_msg = FIELD_USER_TPL.format(
        decision_json=json.dumps(decision, ensure_ascii=False, indent=2),
        user_basic=json.dumps(user_basic, ensure_ascii=False, indent=2),
        member_id=member_id,
        order_seq=order_seq,
        create_time=create_t,
        pay_time=pay_t,
        offset_minutes=offset,
    )

    t0  = time.time()
    raw = call_llm(FIELD_SYSTEM, user_msg, temperature=0.3)
    print(f"  耗时 {time.time()-t0:.1f}s")

    return extract_json(raw)


# ── 验证 ───────────────────────────────────────────────────────────────────────
VALID_ORDER_STATUS = {"0", "2", "3", "4", "5", "6", "7", "8",
                      "30", "31", "32", "33", "34", "35", "36",
                      "37", "38", "39", "40", "41", "42"}
VALID_PAY_WAY      = {"1", "2", "3"}
VALID_BILL_TYPE    = {1, 2, 3, 4}


def validate(records: dict) -> list[str]:
    """基本字段验证，返回 warning 列表（不阻断写出）。"""
    warnings = []
    order = records.get("j_member_order", {})
    bill  = records.get("j_bill", {})

    # 时序
    ct = order.get("create_time") or order.get("order_time")
    pt = order.get("pay_time")
    if ct and pt and pt < ct:
        warnings.append(f"[时序] pay_time({pt}) < create_time({ct})")

    # 金额
    cost     = float(order.get("cost", 0) or 0)
    disc     = float(order.get("discount_amount", 0) or 0)
    pay_amt  = float(order.get("pay_amount", 0) or 0)
    expected = round(cost - disc, 2)
    if abs(pay_amt - expected) > 0.01:
        warnings.append(
            f"[金额] pay_amount({pay_amt}) ≠ cost({cost}) - discount({disc}) = {expected}"
        )

    # is_pay / status 一致性
    status = str(order.get("status", ""))
    is_pay = order.get("is_pay")
    if status in {"2", "4", "7"} and is_pay != 1:
        warnings.append(f"[状态] status={status} 但 is_pay={is_pay}，应为 1")
    if status in {"0", "3"} and is_pay not in (0, None):
        warnings.append(f"[状态] status={status} 但 is_pay={is_pay}，应为 0")

    # 枚举值
    if status and status not in VALID_ORDER_STATUS:
        warnings.append(f"[枚举] order.status={status!r} 不在合法值集合中")
    pw = str(order.get("pay_way", "")) if order.get("pay_way") else ""
    if pw and pw not in VALID_PAY_WAY:
        warnings.append(f"[枚举] pay_way={pw!r} 应为 1/2/3")
    bt = bill.get("bill_type")
    if bt is not None and bt not in VALID_BILL_TYPE:
        warnings.append(f"[枚举] bill.bill_type={bt!r} 应为 1/2/3/4")

    # j_bill 金额与 order 一致
    bill_amt = float(bill.get("amount", 0) or 0)
    if abs(bill_amt - pay_amt) > 0.01:
        warnings.append(f"[金额] bill.amount({bill_amt}) ≠ order.pay_amount({pay_amt})")

    return warnings


# ── CSV 写出 ──────────────────────────────────────────────────────────────────
def write_csv(table: str, rows: list[dict], output_dir: Path):
    if not rows or not rows[0]:
        print(f"  [跳过] {table}：空记录")
        return
    fpath = output_dir / f"{table}.csv"
    with open(fpath, "w", newline="", encoding="utf-8-sig") as fh:
        writer = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)
    print(f"  → {fpath}（{len(rows)} 行）")


# ── 主流程 ────────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description="P1 冒烟测试")
    parser.add_argument("--instance-id", default=None,
                        help="指定 instance_id（如 INST_0042），默认随机抽取")
    parser.add_argument("--dry-run", action="store_true",
                        help="不写 CSV，仅打印结果")
    args = parser.parse_args()

    t_start = time.time()
    print("=" * 60)
    print("P1 冒烟测试 — mini_example.py")
    print("=" * 60)

    # ── 加载实例 ──
    instance, source_type = load_instance(args.instance_id)
    pid   = instance.get("instance_id") or instance.get("persona_id", "?")
    pname = instance.get("name", "")
    print(f"实例: {pid}  {pname}")
    print(f"System: {instance.get('system')}  "
          f"用户类型: {instance.get('dimensions',{}).get('user_type','?')}")
    if source_type == "instance":
        print(f"年龄: {instance.get('age')}  "
              f"城市: {instance.get('province','')} {instance.get('city','')}")
    print()

    # ── 层一 ──
    decision = step1_behavior(instance, source_type)
    if not decision.get("purchase_intent", True):
        print("\n[结果] Persona 无购买意向（purchase_intent=false），冒烟测试结束。")
        print("提示：可重新运行或换一条实例再试。")
        return

    # ── 层二 ──
    member_id = random.randint(10001, 99999)
    order_seq = random.randint(1, 9999)
    records   = step2_fields(decision, instance, source_type, member_id, order_seq)

    # ── 验证 ──
    print("\n[验证]")
    warns = validate(records)
    if warns:
        for w in warns:
            print(f"  ⚠️  {w}")
    else:
        print("  ✅ 全部通过（时序 / 金额 / 枚举）")

    # ── 摘要 ──
    order = records.get("j_member_order", {})
    print(f"\n[摘要]")
    print(f"  member_id  : {member_id}")
    print(f"  order_num  : {order.get('order_num', '?')}")
    print(f"  status     : {order.get('status', '?')}")
    print(f"  cost       : {order.get('cost', '?')}")
    print(f"  pay_amount : {order.get('pay_amount', '?')}")
    print(f"  pay_time   : {order.get('pay_time', '?')}")

    # ── 写 CSV ──
    if args.dry_run:
        print("\n[干运行] 跳过文件写出，以下为原始 JSON：")
        print(json.dumps(records, ensure_ascii=False, indent=2))
    else:
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
        print(f"\n[写出] → {OUTPUT_DIR}/")
        write_csv("j_member",       [records.get("j_member", {})],       OUTPUT_DIR)
        write_csv("j_member_order", [records.get("j_member_order", {})], OUTPUT_DIR)
        write_csv("j_bill",         [records.get("j_bill", {})],         OUTPUT_DIR)

    total = time.time() - t_start
    print(f"\n完成！总耗时 {total:.1f}s，LLM 调用 2 次。")
    if not args.dry_run:
        print(f"输出目录: {OUTPUT_DIR.resolve()}")
    print("=" * 60)


if __name__ == "__main__":
    main()
