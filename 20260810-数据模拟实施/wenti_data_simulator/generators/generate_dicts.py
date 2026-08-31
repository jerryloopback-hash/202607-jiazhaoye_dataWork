"""
P2-1：字典数据生成脚本 (generate_dicts.py)

产出物：
  data/dict/venues.json       - 10个场馆 (venue_id V001-V010)
  data/dict/sports.json       - 20个运动类型 (sport_id S001-S020)
  data/dict/merchants.json    - 5个商户 (merchant_id M001-M005)
  data/output/j_coupon_code.csv - 20条优惠券模板

用法：
  cd 20260810-数据模拟实施
  python wenti_data_simulator/generators/generate_dicts.py
  python wenti_data_simulator/generators/generate_dicts.py --dry-run
"""

import argparse
import csv
import json
import sys
import time
from pathlib import Path

import requests

sys.stdout.reconfigure(encoding="utf-8")

# ─── API 配置（新模型：llama.cpp server，8080端口）──────────────────────────────
API_BASE  = "http://10.20.77.89:8080/v1"
API_KEY   = "shuangan645310"
API_MODEL = "/home/lck/c/Qwopus3.6-27B-Fusion-BF16.gguf"
# 注意：该模型内置 thinking 模式，需在 system prompt 中明确禁止输出 thinking，
# 并发数设为 1（llama.cpp 不支持真正并发，多请求串行排队）

BASE_DIR    = Path(__file__).parent.parent          # wenti_data_simulator/
DICT_DIR    = BASE_DIR / "data" / "dict"
OUTPUT_DIR  = BASE_DIR / "data" / "output"

# ─── LLM 调用 ─────────────────────────────────────────────────────────────────

def call_llm(system_prompt: str, user_prompt: str, temperature: float = 0.7,
             max_tokens: int = 4096, retries: int = 3) -> dict:
    """调用远端 OpenAI-compatible API，返回解析后的 JSON dict。"""
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    }
    # 新模型为 llama.cpp serving，thinking 模式通过 system prompt 末尾指令压制
    # （不支持 chat_template_kwargs，不要传该参数）
    full_system = system_prompt + "\n\n[IMPORTANT] Output ONLY the final answer. Do NOT output any thinking, reasoning, or internal monologue."
    # 模型需要足够的 max_tokens 完成 thinking 后再输出 content；
    # reasoning_content 由模型内部消耗，不影响 content。
    effective_max_tokens = max(max_tokens, 2000)
    payload = {
        "model": API_MODEL,
        "messages": [
            {"role": "system", "content": full_system},
            {"role": "user",   "content": user_prompt},
        ],
        "temperature": temperature,
        "max_tokens":  effective_max_tokens,
    }
    for attempt in range(retries):
        try:
            resp = requests.post(
                f"{API_BASE}/chat/completions",
                headers=headers, json=payload, timeout=600,
            )
            resp.raise_for_status()
            content = resp.json()["choices"][0]["message"]["content"].strip()
            # 去掉 markdown 代码块包裹
            if content.startswith("```"):
                content = content.split("```", 2)[1]
                if content.startswith("json"):
                    content = content[4:]
                content = content.rsplit("```", 1)[0].strip()
            return json.loads(content)
        except Exception as e:
            if attempt < retries - 1:
                print(f"  [WARN] 第{attempt+1}次调用失败：{e}，2s后重试…")
                time.sleep(2 ** attempt)
            else:
                raise RuntimeError(f"LLM 调用最终失败: {e}") from e


# ─── 生成场馆字典 ──────────────────────────────────────────────────────────────

VENUES_SYSTEM = "你是专业的数据工程师，负责生成中国文体场馆字典数据。只输出纯 JSON 数组，不要任何说明文字或 markdown。"

VENUES_PROMPT = """请生成10个深圳市文体场馆的字典数据，venue_id 格式为 V001-V010。

要求：
- 场馆名称符合中国文体中心命名习惯（XX体育中心/XX游泳馆/XX文体活动中心等）
- 地理位置在深圳市各区（南山/福田/宝安/龙华/龙岗/罗湖/光明/坪山等）
- 容量范围 500-5000 人
- 营业时间一般为 06:00-22:00
- venue_id 为字符串 "V001" 格式（后续所有订单的 venue_id FK 均从此处取值）

输出格式（纯 JSON 数组，10条）：
[
  {
    "venue_id": "V001",
    "venue_name": "深圳湾体育中心游泳馆",
    "province": "广东省",
    "city": "深圳市",
    "area": "南山区",
    "address": "深圳市南山区深圳湾体育中心",
    "capacity": 2000,
    "open_time": "06:00",
    "close_time": "22:00",
    "venue_type": "游泳馆"
  },
  ...
]"""


def gen_venues(dry_run: bool) -> list:
    DICT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = DICT_DIR / "venues.json"
    print("=== 生成 venues.json ===")

    if dry_run:
        data = [
            {"venue_id": f"V{i:03d}", "venue_name": f"测试场馆{i:03d}", "province": "广东省",
             "city": "深圳市", "area": "南山区", "address": f"深圳市南山区测试{i}路",
             "capacity": 1000, "open_time": "06:00", "close_time": "22:00",
             "venue_type": "综合体育中心"}
            for i in range(1, 11)
        ]
        print(f"  [DRY-RUN] 跳过 LLM，生成占位数据 {len(data)} 条")
    else:
        print("  调用 LLM 生成场馆数据…")
        data = call_llm(VENUES_SYSTEM, VENUES_PROMPT, temperature=0.5)
        # 校验 venue_id 格式
        for i, v in enumerate(data):
            expected = f"V{i+1:03d}"
            if v.get("venue_id") != expected:
                v["venue_id"] = expected
        print(f"  生成 {len(data)} 条场馆数据")

    out_path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"  写出 → {out_path}")
    return data


# ─── 生成运动类型字典 ──────────────────────────────────────────────────────────

SPORTS_SYSTEM = "你是专业的数据工程师，负责生成中国文体运动类型字典。只输出纯 JSON 数组，不要任何说明文字。"

SPORTS_PROMPT = """请生成20个文体场馆常见运动类型字典，sport_id 格式为 S001-S020。

覆盖范围：游泳、羽毛球、篮球、网球、乒乓球、健身、瑜伽、舞蹈、武术、跆拳道、
综合格斗、跑步、攀岩、击剑、体操、排球、足球、冰壶、台球、壁球（可自行调整顺序）。

输出格式（纯 JSON 数组，20条）：
[
  {
    "sport_id": "S001",
    "sport_name": "游泳",
    "sport_category": "水上运动",
    "order_type_compatible": ["3"],
    "notes": "需要购买游泳票(order_type=3)"
  },
  {
    "sport_id": "S002",
    "sport_name": "羽毛球",
    "sport_category": "球类运动",
    "order_type_compatible": ["2"],
    "notes": "需要订场(order_type=2)"
  },
  ...
]"""


def gen_sports(dry_run: bool) -> list:
    DICT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = DICT_DIR / "sports.json"
    print("=== 生成 sports.json ===")

    SPORTS_FALLBACK = [
        ("S001", "游泳",   "水上运动",   ["3"]),
        ("S002", "羽毛球", "球类运动",   ["2"]),
        ("S003", "篮球",   "球类运动",   ["2"]),
        ("S004", "网球",   "球类运动",   ["2"]),
        ("S005", "乒乓球", "球类运动",   ["2"]),
        ("S006", "健身",   "健身运动",   ["2"]),
        ("S007", "瑜伽",   "休闲运动",   ["2"]),
        ("S008", "舞蹈",   "表演艺术",   ["5"]),
        ("S009", "武术",   "传统武术",   ["2"]),
        ("S010", "跆拳道", "格斗运动",   ["2"]),
        ("S011", "综合格斗","格斗运动",  ["2"]),
        ("S012", "跑步",   "田径运动",   ["2"]),
        ("S013", "攀岩",   "极限运动",   ["2"]),
        ("S014", "击剑",   "传统运动",   ["2", "6"]),
        ("S015", "体操",   "技巧运动",   ["5", "6"]),
        ("S016", "排球",   "球类运动",   ["2"]),
        ("S017", "足球",   "球类运动",   ["2"]),
        ("S018", "冰壶",   "冰雪运动",   ["2"]),
        ("S019", "台球",   "球类运动",   ["2"]),
        ("S020", "壁球",   "球类运动",   ["2"]),
    ]

    if dry_run:
        data = [{"sport_id": sid, "sport_name": name, "sport_category": cat,
                 "order_type_compatible": ot, "notes": ""}
                for sid, name, cat, ot in SPORTS_FALLBACK]
        print(f"  [DRY-RUN] 跳过 LLM，生成占位数据 {len(data)} 条")
    else:
        print("  调用 LLM 生成运动类型数据…")
        try:
            data = call_llm(SPORTS_SYSTEM, SPORTS_PROMPT, temperature=0.3)
            for i, s in enumerate(data):
                expected = f"S{i+1:03d}"
                if s.get("sport_id") != expected:
                    s["sport_id"] = expected
            print(f"  生成 {len(data)} 条运动类型")
        except Exception as e:
            print(f"  [WARN] LLM 失败({e})，使用内置 fallback 数据")
            data = [{"sport_id": sid, "sport_name": name, "sport_category": cat,
                     "order_type_compatible": ot, "notes": "内置fallback"}
                    for sid, name, cat, ot in SPORTS_FALLBACK]

    out_path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"  写出 → {out_path}")
    return data


# ─── 生成商户字典 ──────────────────────────────────────────────────────────────

MERCHANTS_SYSTEM = "你是专业的数据工程师，负责生成文体场馆商户字典。只输出纯 JSON 数组，不要任何说明文字。"

MERCHANTS_PROMPT = """请生成5个文体场馆运营商户的字典数据，merchant_id 格式为 M001-M005。

要求：
- 商户名称符合中国体育场馆运营公司命名习惯
- 包含集团总部+区域子公司的层级关系
- merchant_id 格式为字符串 "M001"

输出格式（纯 JSON 数组，5条）：
[
  {
    "merchant_id": "M001",
    "merchant_name": "佳兆业文体集团总部",
    "merchant_type": "集团总部",
    "city": "深圳市",
    "contact_phone": "0755-88888001"
  },
  ...
]"""


def gen_merchants(dry_run: bool) -> list:
    DICT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = DICT_DIR / "merchants.json"
    print("=== 生成 merchants.json ===")

    MERCHANTS_FALLBACK = [
        ("M001", "佳兆业文体集团总部",   "集团总部", "深圳市", "0755-88888001"),
        ("M002", "佳兆业南山文体中心",   "区域运营", "深圳市", "0755-88888002"),
        ("M003", "佳兆业福田文体中心",   "区域运营", "深圳市", "0755-88888003"),
        ("M004", "佳兆业宝安文体中心",   "区域运营", "深圳市", "0755-88888004"),
        ("M005", "佳兆业龙华文体中心",   "区域运营", "深圳市", "0755-88888005"),
    ]

    if dry_run:
        data = [{"merchant_id": mid, "merchant_name": name, "merchant_type": mtype,
                 "city": city, "contact_phone": phone}
                for mid, name, mtype, city, phone in MERCHANTS_FALLBACK]
        print(f"  [DRY-RUN] 跳过 LLM，生成占位数据 {len(data)} 条")
    else:
        print("  调用 LLM 生成商户数据…")
        try:
            data = call_llm(MERCHANTS_SYSTEM, MERCHANTS_PROMPT, temperature=0.3)
            for i, m in enumerate(data):
                expected = f"M{i+1:03d}"
                if m.get("merchant_id") != expected:
                    m["merchant_id"] = expected
            print(f"  生成 {len(data)} 条商户数据")
        except Exception as e:
            print(f"  [WARN] LLM 失败({e})，使用内置 fallback 数据")
            data = [{"merchant_id": mid, "merchant_name": name, "merchant_type": mtype,
                     "city": city, "contact_phone": phone}
                    for mid, name, mtype, city, phone in MERCHANTS_FALLBACK]

    out_path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"  写出 → {out_path}")
    return data


# ─── 生成优惠券模板（j_coupon_code）─────────────────────────────────────────────

COUPON_CODE_SYSTEM = (
    "你是专业的数据工程师，负责生成文体场馆优惠券模板数据。"
    "只输出纯 JSON 数组，不要任何说明文字或 markdown 代码块。"
)

COUPON_CODE_PROMPT = """请生成20条 j_coupon_code（优惠券模板）数据。

字段说明：
- id: int，从30001开始自增
- name: 优惠券名称（如"满100减20游泳券"）
- price: 面额，单位元（decimal，如20.00）
- full_cut_price: 满减门槛，0表示无门槛（decimal）
- req_points: 兑换所需积分，0表示直接发放（int）
- rec_type: 领取方式（1注册/2积分兑换/3发老用户/4自定义发放）（tinyint）
- scene_type: 适用场景（0全场/1订场售票）（tinyint）
- days: 有效天数，0不限（int）
- amount: 总发行数量（int，1000-50000）
- ex_amount: 已兑换数量，初始0（int）
- use_amount: 已使用数量，初始0（int）
- expire_amount: 已过期数量，初始0（int）
- send_start_time: 发放开始时间（"2026-01-01 00:00:00"）
- send_end_time: 发放结束时间（send_start_time + 60-90天）
- merchant_id: 商户id，从["M001","M002","M003","M004","M005"]随机选择（VARCHAR，字符串格式）
- status: 0禁用/1启用，初始1（tinyint）
- couponCodeType: 优惠券类型，初始1（int）
- userange: 使用范围，初始0（int）

要求：
- 20条要有多样性：无门槛/满减/积分兑换等不同类型，覆盖游泳/订场/演艺/赛事场景
- 面额范围：5-200元；满减门槛为面额的2-5倍
- 有效天数：7/15/30/60天均有
- 时间范围：send_start_time 在 2026-01-01 至 2026-06-01 之间
- merchant_id 必须是字符串格式（如 "M001"，不是整数）

输出格式（纯 JSON 数组，20条，id 从 30001 开始）：
[{"id": 30001, "name": "...", "price": 20.00, ...}, ...]"""


# j_coupon_code 表的字段顺序（用于 CSV header）
COUPON_CODE_FIELDS = [
    "id", "name", "price", "full_cut_price", "req_points",
    "rec_type", "scene_type", "days", "amount",
    "ex_amount", "use_amount", "expire_amount",
    "send_start_time", "send_end_time", "merchant_id",
    "status", "couponCodeType", "userange",
]

COUPON_CODE_FALLBACK = [
    # (name, price, full_cut_price, req_points, rec_type, scene_type, days, amount)
    ("新用户注册赠券5元",        5.00,   0.00,   0,   1, 0, 30,  10000),
    ("满50减10游泳优惠券",      10.00,  50.00,   0,   3, 1, 15,  20000),
    ("满80减15订场券",          15.00,  80.00,   0,   3, 1, 15,  20000),
    ("满100减20全场通用券",     20.00, 100.00,   0,   3, 0, 30,  15000),
    ("满150减30游泳季卡券",     30.00, 150.00,   0,   3, 1, 30,  10000),
    ("积分兑换10元游泳券",      10.00,   0.00, 500,   2, 1, 60,   5000),
    ("积分兑换20元全场券",      20.00,   0.00,1000,   2, 0, 60,   5000),
    ("满200减50演艺票券",       50.00, 200.00,   0,   3, 0, 15,   8000),
    ("满120减25赛事特供券",     25.00, 120.00,   0,   4, 0, 7,    5000),
    ("无门槛8元抵扣券",          8.00,   0.00,   0,   4, 0, 7,    3000),
    ("满60减12游泳专属券",      12.00,  60.00,   0,   3, 1, 15,  12000),
    ("满90减18订场专属券",      18.00,  90.00,   0,   3, 1, 15,  10000),
    ("老用户专享30元券",        30.00, 120.00,   0,   3, 0, 30,   6000),
    ("满180减40高净值专属券",   40.00, 180.00,   0,   4, 0, 30,   2000),
    ("积分兑换50元大额券",      50.00,   0.00,2500,   2, 0, 90,   1000),
    ("满250减60超值全场券",     60.00, 250.00,   0,   3, 0, 30,   5000),
    ("无门槛5元小额券",          5.00,   0.00,   0,   1, 0, 7,   50000),
    ("满70减15综合运动券",      15.00,  70.00,   0,   3, 0, 15,  15000),
    ("满130减28节假日专享",     28.00, 130.00,   0,   4, 0, 15,   4000),
    ("满300减80年度会员专享",   80.00, 300.00,   0,   3, 0, 60,   2000),
]


def gen_coupon_codes(dry_run: bool) -> list:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = OUTPUT_DIR / "j_coupon_code.csv"
    print("=== 生成 j_coupon_code.csv ===")

    merchants = ["M001", "M002", "M003", "M004", "M005"]

    if dry_run:
        import random as _rnd
        data = []
        for i, (name, price, fcp, rp, rt, st, days, amount) in enumerate(COUPON_CODE_FALLBACK):
            data.append({
                "id": 30001 + i,
                "name": name,
                "price": price,
                "full_cut_price": fcp,
                "req_points": rp,
                "rec_type": rt,
                "scene_type": st,
                "days": days,
                "amount": amount,
                "ex_amount": 0,
                "use_amount": 0,
                "expire_amount": 0,
                "send_start_time": "2026-01-01 00:00:00",
                "send_end_time":   "2026-03-01 00:00:00",
                "merchant_id": _rnd.choice(merchants),
                "status": 1,
                "couponCodeType": 1,
                "userange": 0,
            })
        print(f"  [DRY-RUN] 跳过 LLM，生成占位数据 {len(data)} 条")
    else:
        print("  调用 LLM 生成优惠券模板数据…")
        try:
            data = call_llm(COUPON_CODE_SYSTEM, COUPON_CODE_PROMPT, temperature=0.4)
            # 修正 id 序号（确保从30001开始连续）
            for i, row in enumerate(data):
                row["id"] = 30001 + i
                # 确保 merchant_id 是字符串
                mid = str(row.get("merchant_id", "M001"))
                if not mid.startswith("M"):
                    mid = merchants[i % len(merchants)]
                row["merchant_id"] = mid
                # 确保必要字段存在
                for f in ["ex_amount", "use_amount", "expire_amount"]:
                    row.setdefault(f, 0)
                row.setdefault("status", 1)
                row.setdefault("couponCodeType", 1)
                row.setdefault("userange", 0)
            print(f"  生成 {len(data)} 条优惠券模板")
        except Exception as e:
            print(f"  [WARN] LLM 失败({e})，使用内置 fallback 数据")
            import random as _rnd
            data = []
            for i, (name, price, fcp, rp, rt, st, days, amount) in enumerate(COUPON_CODE_FALLBACK):
                data.append({
                    "id": 30001 + i,
                    "name": name,
                    "price": price,
                    "full_cut_price": fcp,
                    "req_points": rp,
                    "rec_type": rt,
                    "scene_type": st,
                    "days": days,
                    "amount": amount,
                    "ex_amount": 0,
                    "use_amount": 0,
                    "expire_amount": 0,
                    "send_start_time": "2026-01-01 00:00:00",
                    "send_end_time":   "2026-03-01 00:00:00",
                    "merchant_id": _rnd.choice(merchants),
                    "status": 1,
                    "couponCodeType": 1,
                    "userange": 0,
                })

    # 写 CSV（utf-8-sig，Windows Excel 兼容）
    with open(out_path, "w", newline="", encoding="utf-8-sig") as fh:
        writer = csv.DictWriter(fh, fieldnames=COUPON_CODE_FIELDS, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(data)

    print(f"  写出 {len(data)} 条 → {out_path}")
    return data


# ─── 主流程 ────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="P2-1 字典数据生成")
    parser.add_argument("--dry-run", action="store_true",
                        help="跳过 LLM，生成占位数据用于测试目录结构")
    args = parser.parse_args()

    t0 = time.time()
    print(f"=== P2-1 字典数据生成 {'[DRY-RUN]' if args.dry_run else ''} ===\n")

    venues   = gen_venues(args.dry_run)
    print()
    sports   = gen_sports(args.dry_run)
    print()
    merchants = gen_merchants(args.dry_run)
    print()
    coupons  = gen_coupon_codes(args.dry_run)

    # 摘要
    print(f"\n=== 完成 ===")
    print(f"  venues:      {len(venues)} 条  → data/dict/venues.json")
    print(f"  sports:      {len(sports)} 条  → data/dict/sports.json")
    print(f"  merchants:   {len(merchants)} 条  → data/dict/merchants.json")
    print(f"  j_coupon_code: {len(coupons)} 条  → data/output/j_coupon_code.csv")
    print(f"  总耗时: {time.time()-t0:.1f}s")

    # 简单验证
    errors = []
    venue_ids  = {v["venue_id"] for v in venues}
    sport_ids  = {s["sport_id"] for s in sports}
    merch_ids  = {m["merchant_id"] for m in merchants}
    coupon_ids = {c["id"] for c in coupons}

    expected_vids = {f"V{i:03d}" for i in range(1, 11)}
    expected_sids = {f"S{i:03d}" for i in range(1, 21)}
    expected_mids = {f"M{i:03d}" for i in range(1, 6)}

    if venue_ids != expected_vids:
        errors.append(f"venues venue_id 不符合预期: {venue_ids ^ expected_vids}")
    if sport_ids != expected_sids:
        errors.append(f"sports sport_id 不符合预期: {sport_ids ^ expected_sids}")
    if merch_ids != expected_mids:
        errors.append(f"merchants merchant_id 不符合预期: {merch_ids ^ expected_mids}")
    if len(coupon_ids) != 20:
        errors.append(f"j_coupon_code 条数不为20: {len(coupon_ids)}")
    for c in coupons:
        mid = c.get("merchant_id", "")
        if str(mid) not in expected_mids:
            errors.append(f"j_coupon_code id={c['id']} merchant_id={mid} 不在 M001-M005 内")
            break

    if errors:
        print("\n[FAIL] 验证不通过：")
        for e in errors:
            print(f"  ✗ {e}")
        sys.exit(1)
    else:
        print("\n[PASS] 所有验证通过 ✅")


if __name__ == "__main__":
    main()
