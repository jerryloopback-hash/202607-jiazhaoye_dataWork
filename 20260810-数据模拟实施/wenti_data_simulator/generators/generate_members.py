"""
P2-2 + P2-3：用户事件 + 营销事件生成脚本 (generate_members.py)

产出物：
  data/output/j_member.csv              - 800条会员记录（LLM生成）
  data/output/j_member_third.csv        - 第三方绑定（代码生成，~600条）
  data/output/buy_ticket_people.csv     - 购票人（代码生成，~320人次）
  data/output/j_member_time_card.csv    - 次卡（代码生成，~240条）
  data/output/j_coupon.csv              - 优惠券（代码生成，~1200条）
  data/output/p2_progress.jsonl         - 断点续传进度文件

用法（从项目根目录运行）：
  cd 20260810-数据模拟实施
  python wenti_data_simulator/generators/generate_members.py
  python wenti_data_simulator/generators/generate_members.py --dry-run --limit 5
  python wenti_data_simulator/generators/generate_members.py --resume

注意：
  - 并发=1（llama.cpp 不支持并发，串行请求）
  - 每次 LLM 调用约 2-3 分钟，800条总计约 25-40 小时
  - 支持断点续传：中断后加 --resume 继续
  - --dry-run 模式跳过 LLM，用规则生成占位数据，用于调试
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

# ─── 配置 ─────────────────────────────────────────────────────────────────────
API_BASE  = "http://10.20.77.89:8080/v1"
API_KEY   = "shuangan645310"
API_MODEL = "/home/lck/c/Qwopus3.6-27B-Fusion-BF16.gguf"

SAMPLE_COUNT    = 800                         # 从 4800 条中抽取
MEMBER_ID_START = 10001                       # j_member.id 起始值
COUPON_ID_START = 30001                       # j_coupon_code.id 范围
COUPON_ID_END   = 30020
CARD_ID_START   = 5001                        # j_member_time_card.id 起始
BTP_ID_START    = 1001                        # buy_ticket_people.id 起始

# 模拟日期范围
SIM_START = datetime(2026, 1, 1)
SIM_END   = datetime(2026, 8, 12)

BASE_DIR    = Path(__file__).parent.parent    # wenti_data_simulator/
DATA_DIR    = BASE_DIR / "data"
OUTPUT_DIR  = DATA_DIR / "output"
DICT_DIR    = DATA_DIR / "dict"
PERSONAS_FILE  = DATA_DIR / "personas" / "wenti_persona_instances.jsonl"
PROGRESS_FILE  = OUTPUT_DIR / "p2_progress.jsonl"


# ─── LLM 调用 ─────────────────────────────────────────────────────────────────
def call_llm(system_prompt: str, user_prompt: str,
             temperature: float = 0.3, retries: int = 3) -> dict:
    """调用远端 LLM，返回解析后的 JSON dict。"""
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    }
    full_system = (system_prompt +
                   "\n\n[IMPORTANT] Output ONLY the final JSON. "
                   "No thinking, no reasoning, no markdown, no explanation.")
    payload = {
        "model": API_MODEL,
        "messages": [
            {"role": "system", "content": full_system},
            {"role": "user",   "content": user_prompt},
        ],
        "temperature": temperature,
        "max_tokens": 3000,        # 需要 ≥2000 让模型先完成 thinking 再输出
    }
    for attempt in range(retries):
        try:
            resp = requests.post(
                f"{API_BASE}/chat/completions",
                headers=headers, json=payload, timeout=600,
            )
            resp.raise_for_status()
            content = resp.json()["choices"][0]["message"]["content"].strip()
            # 去掉可能的 markdown 代码块包裹
            if content.startswith("```"):
                content = content.split("```", 2)[1]
                if content.startswith("json"):
                    content = content[4:]
                content = content.rsplit("```", 1)[0].strip()
            return json.loads(content)
        except Exception as e:
            if attempt < retries - 1:
                wait = 2 ** attempt
                print(f"    [WARN] 第{attempt+1}次调用失败：{e}，{wait}s后重试…")
                time.sleep(wait)
            else:
                raise RuntimeError(f"LLM 调用最终失败: {e}") from e


# ─── 工具函数 ──────────────────────────────────────────────────────────────────

def rand_date(start: datetime, end: datetime) -> datetime:
    """在 [start, end] 内随机返回一个日期时间（时分秒随机）。"""
    delta = (end - start).days
    day = start + timedelta(days=random.randint(0, max(delta, 0)))
    return day.replace(
        hour=random.randint(6, 22),
        minute=random.randint(0, 59),
        second=random.randint(0, 59),
        microsecond=0,
    )


def fmt(dt: datetime) -> str:
    return dt.strftime("%Y-%m-%d %H:%M:%S")


def get_registration_channel_code(channel: str) -> int:
    """把 Persona 的 registration_channel 转为 j_member.source 整数。"""
    return {"android": 1, "ios": 2, "miniprogram": 3, "backend_entry": 4}.get(channel, 3)


def get_id_card_check(status: str) -> int:
    return {"unverified": 1, "verified": 2, "expired": 3, "disabled": 4}.get(status, 1)


def get_report_check(prob: float) -> int:
    """依 complete_health_check 概率决定 report_check 值。"""
    r = random.random()
    if r < prob * 0.7:
        return 3   # 审核通过
    elif r < prob:
        return 2   # 审核中
    else:
        return 1   # 未上传


def make_id_card(province: str, birth_year: int, birth_month: int, birth_day: int) -> str:
    """生成格式合规的18位模拟身份证号。"""
    # 广东省深圳市区县码简化映射
    prefix_map = {
        "广东省": "44030",
        "北京市": "11010",
        "上海市": "31010",
        "浙江省": "33010",
        "四川省": "51010",
    }
    prefix = prefix_map.get(province, "44030")
    suffix = prefix[3:5] if len(prefix) >= 5 else "01"
    area = prefix[:3] + suffix + str(random.randint(1, 9))
    birth = f"{birth_year:04d}{birth_month:02d}{birth_day:02d}"
    seq = f"{random.randint(100, 999)}"
    # 最后一位校验码简化处理
    weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
    check_chars = "10X98765432"
    body = area + birth + seq
    body = (body + "0")[:17]   # 确保17位
    check = check_chars[sum(int(body[i]) * weights[i] for i in range(17)) % 11]
    return body + check


def make_phone(instance: dict) -> str:
    """优先用实例字段，否则 Faker 式随机生成合规手机号。"""
    phone = instance.get("phone", "")
    if phone and len(str(phone)) == 11:
        return str(phone)
    prefixes = ["130","131","132","133","135","136","137","138","139",
                "150","151","152","153","155","156","157","158","159",
                "180","181","182","183","184","185","186","187","188","189"]
    return random.choice(prefixes) + "".join([str(random.randint(0,9)) for _ in range(8)])


# ─── 断点续传进度 ─────────────────────────────────────────────────────────────

def load_progress() -> dict:
    """返回 {instance_id: member_record} 已完成的进度字典。"""
    if not PROGRESS_FILE.exists():
        return {}
    done = {}
    for line in PROGRESS_FILE.read_text(encoding="utf-8").splitlines():
        if line.strip():
            try:
                rec = json.loads(line)
                done[rec["_instance_id"]] = rec
            except Exception:
                pass
    return done


def save_progress(member_rec: dict, instance_id: str):
    """追加一条完成记录到进度文件。"""
    rec = dict(member_rec)
    rec["_instance_id"] = instance_id
    with open(PROGRESS_FILE, "a", encoding="utf-8") as f:
        f.write(json.dumps(rec, ensure_ascii=False) + "\n")


# ─── Prompt：生成 j_member 字段 ───────────────────────────────────────────────

MEMBER_SYSTEM = """你是专业数据工程师，负责为中国文体场馆会员系统生成模拟数据。
你的任务：根据给定的用户实例信息，生成一条完整的 j_member 数据库记录（JSON 对象）。
严格遵守枚举约束和字段规则。只输出一个 JSON 对象，不要数组，不要注释。"""

MEMBER_PROMPT_TPL = """根据以下用户实例，生成一条 j_member 数据库记录。

【用户实例】：
{instance_summary}

【已分配的字段（直接使用，不要修改）】：
- id: {member_id}
- phone: "{phone}"
- source: {source}（1安卓/2iOS/3小程序/4后台）
- id_card_check: {id_card_check}（1未校验/2已校验/3过期/4禁用）
- report_check: {report_check}（1未上传/2审核中/3已通过/4未通过/5过期/6禁用）
- venue_id: {venue_id}（从字典取值，INT 类型）
- create_time: "{create_time}"

【字段约束（你需要生成的字段）】：
- nick_name: 2-8个中文字符，与实例姓名相关但非完全一致（可加称谓/昵称后缀）
- birthday: "YYYY-MM-DD"，年龄 {age} 岁，与 create_time 年份一致
- age: {age}（整数）
- province: "{province}"
- city: "{city}"
- area: "{district}"
- sex: {sex}（0不明/1男/2女）
- rank: 0（普通会员，C端数据全为0）
- is_blacklist: 0（正常用户，除非 dirty_data_probability={dirty_prob}>0.15 时可小概率为1）
- is_vip: 0（绝大多数为0，仅低价格敏感+成熟生命周期用户可为1）
- jwh_vip: 0（同上）
- member_status: 1（正常）
- id_card: "{id_card}"（18位身份证号，已生成，直接使用）
- user_name: "{real_name}"（实例真实姓名，直接使用）
- member_rate: 浮点数 0.0-5.0（可随机）
- content_rate: 浮点数 0.0-5.0（可随机）
- is_audit: {is_audit}（id_card_check=2时为1，否则为0）
- login_num: {login_num}（mature用户50-200，growing用户5-50，new_user用户1-5）
- last_login_time: "{last_login_time}"（create_time 到 2026-08-12 之间随机）
- energy_volume_num: 随机 0-10（整数）
- depart_discount_num: 随机 0-5（整数）
- guess_status: 1
- default_image_index: 随机 0-9（整数）
- register_source: "{venue_id}"（与 venue_id 相同）
- jwh_vip: 0
- id_card_create_time: {id_card_create_time}（id_card_check=2时有值，否则null）
- report_create_time: {report_create_time}（report_check>=2时有值，否则null）

【输出格式】（一个 JSON 对象，只包含以下字段）：
{{
  "id": {member_id},
  "phone": "{phone}",
  "nick_name": "<中文昵称>",
  "birthday": "<YYYY-MM-DD>",
  "age": {age},
  "province": "{province}",
  "city": "{city}",
  "area": "{district}",
  "sex": {sex},
  "rank": 0,
  "is_blacklist": <0或1>,
  "source": {source},
  "is_vip": <0或1>,
  "jwh_vip": 0,
  "venue_id": {venue_id_int},
  "member_rate": <0.0-5.0>,
  "content_rate": <0.0-5.0>,
  "member_status": 1,
  "id_card": "{id_card}",
  "user_name": "{real_name}",
  "id_card_check": {id_card_check},
  "report_check": {report_check},
  "is_audit": {is_audit},
  "login_num": {login_num},
  "last_login_time": "{last_login_time}",
  "energy_volume_num": <0-10>,
  "depart_discount_num": <0-5>,
  "guess_status": 1,
  "default_image_index": <0-9>,
  "register_source": "{venue_id}",
  "create_time": "{create_time}",
  "extract_time": "{create_time}"
}}"""


def build_member_prompt(instance: dict, member_id: int,
                        phone: str, venue: dict, create_time: datetime) -> str:
    """组装 j_member 生成 prompt。"""
    dims = instance.get("dimensions", {})
    probs = instance.get("behavior_probabilities", {})
    lifecycle = dims.get("lifecycle_stage", "growing")
    id_check = get_id_card_check(dims.get("id_verification_status", "unverified"))
    rep_check = get_report_check(probs.get("complete_health_check", 0.3))
    source = get_registration_channel_code(dims.get("registration_channel", "miniprogram"))
    age = instance.get("age", 30)
    birth_year = datetime.now().year - age
    id_card = make_id_card(instance.get("province", "广东省"), birth_year, random.randint(1,12), random.randint(1,28))
    sex = 1 if instance.get("gender") == "male" else (2 if instance.get("gender") == "female" else 0)
    login_num = (random.randint(50,200) if lifecycle=="mature" else
                 random.randint(5,50) if lifecycle=="growing" else random.randint(1,5))
    last_login = rand_date(create_time, SIM_END)
    is_audit = 1 if id_check == 2 else 0
    id_card_create_time = fmt(create_time + timedelta(days=random.randint(1,30))) if id_check >= 2 else "null"
    report_create_time  = fmt(create_time + timedelta(days=random.randint(1,60))) if rep_check >= 2 else "null"
    dirty_prob = instance.get("dirty_data_probability", 0.02)

    # 简短的实例摘要传给 LLM
    instance_summary = json.dumps({
        "name": instance.get("name"),
        "user_type": dims.get("user_type"),
        "price_sensitivity": dims.get("price_sensitivity"),
        "preferred_scenes": dims.get("preferred_scenes"),
        "lifecycle_stage": lifecycle,
        "consumption_frequency": dims.get("consumption_frequency"),
        "notes": instance.get("notes", "")[:80],
    }, ensure_ascii=False)

    # venue_id 是 INT 类型（DDL 确认）
    venue_id_str = venue.get("venue_id", "V001")   # e.g. "V001"
    venue_id_int = int(venue_id_str[1:]) if venue_id_str[0] == "V" else 1

    prompt = MEMBER_PROMPT_TPL.format(
        instance_summary=instance_summary,
        member_id=member_id,
        phone=phone,
        source=source,
        id_card_check=id_check,
        report_check=rep_check,
        venue_id=venue_id_str,
        venue_id_int=venue_id_int,
        create_time=fmt(create_time),
        age=age,
        province=instance.get("province", "广东省"),
        city=instance.get("city", "深圳市"),
        district=instance.get("district", "南山区"),
        sex=sex,
        dirty_prob=dirty_prob,
        id_card=id_card,
        real_name=instance.get("name", ""),
        is_audit=is_audit,
        login_num=login_num,
        last_login_time=fmt(last_login),
        id_card_create_time=id_card_create_time if id_card_create_time != "null" else '""',
        report_create_time=report_create_time if report_create_time != "null" else '""',
    )
    return prompt, {
        "id_card_check": id_check,
        "report_check": rep_check,
        "source": source,
        "id_card": id_card,
        "sex": sex,
        "venue_id_int": venue_id_int,
        "venue_id_str": venue_id_str,
        "create_time": create_time,
    }


# ─── 批次3：代码生成（B/C/D）────────────────────────────────────────────────────

def gen_member_third(member_rec: dict, instance: dict) -> list:
    """P2-2-B：按概率生成 j_member_third，无 LLM。"""
    probs = instance.get("behavior_probabilities", {})
    if random.random() >= probs.get("bind_wechat", 0.5):
        return []
    create_time = member_rec.get("create_time", fmt(SIM_START))
    if isinstance(create_time, str):
        ct = datetime.strptime(create_time[:19], "%Y-%m-%d %H:%M:%S")
    else:
        ct = create_time
    bind_time = ct + timedelta(days=random.randint(1, 14))
    return [{
        "member_id":    member_rec["id"],
        "third_type":   1,            # 1=微信
        "third_source": 1,            # 1=小程序
        "third_id":     "wx_" + "".join([random.choice("abcdef0123456789") for _ in range(24)]),
        "union_id":     "uni_" + "".join([random.choice("abcdef0123456789") for _ in range(25)]),
        "create_time":  fmt(bind_time),
        "extract_time": fmt(bind_time),
    }]


def gen_buy_ticket_people(member_rec: dict, instance: dict,
                          btp_id_counter: list) -> list:
    """P2-2-C：按概率生成 buy_ticket_people，无 LLM。"""
    probs = instance.get("behavior_probabilities", {})
    if random.random() >= probs.get("add_ticket_person", 0.3):
        return []
    count = random.randint(1, 3)
    dims = instance.get("dimensions", {})
    create_time = member_rec.get("create_time", fmt(SIM_START))
    if isinstance(create_time, str):
        ct = datetime.strptime(create_time[:19], "%Y-%m-%d %H:%M:%S")
    else:
        ct = create_time
    rows = []
    sex_choices = ["男", "女", "未知"]
    # 亲子 Persona 倾向
    if "培训" in str(dims.get("preferred_scenes", [])) or probs.get("add_ticket_person", 0) > 0.7:
        sex_pool = ["男", "女"]
    else:
        sex_pool = sex_choices
    for _ in range(count):
        btp_id_counter[0] += 1
        create_offset = random.randint(1, 30)
        rows.append({
            "id":              btp_id_counter[0],
            "member_id":       member_rec["id"],
            "num":             "".join([str(random.randint(0,9)) for _ in range(18)]),  # 模拟证件号
            "type":            1,   # 1=身份证
            "name":            instance.get("name", "张三"),   # 简化用主账户姓名
            "phone":           member_rec["phone"],
            "sex":             random.choice(sex_pool),
            "id_card_status":  random.choice([0, 1]),
            "create_time":     fmt(ct + timedelta(days=create_offset)),
            "update_time":     fmt(ct + timedelta(days=create_offset)),
            "extract_time":    fmt(ct + timedelta(days=create_offset)),
        })
    return rows


def gen_time_card(member_rec: dict, instance: dict,
                  card_id_counter: list) -> list:
    """P2-2-D：按概率生成 j_member_time_card，无 LLM。"""
    probs = instance.get("behavior_probabilities", {})
    dims  = instance.get("dimensions", {})
    # 条件：use_time_card 概率 且 consumption_frequency=high 或 medium
    freq = dims.get("consumption_frequency", "low")
    if freq not in ("high", "medium"):
        return []
    if random.random() >= probs.get("use_time_card", 0.3):
        return []
    card_id_counter[0] += 1
    create_time = member_rec.get("create_time", fmt(SIM_START))
    if isinstance(create_time, str):
        ct = datetime.strptime(create_time[:19], "%Y-%m-%d %H:%M:%S")
    else:
        ct = create_time
    ct_card = ct + timedelta(days=random.randint(1, 60))
    expire   = ct_card + timedelta(days=365)
    # 根据 active_hours 决定可用时段
    active = dims.get("active_hours", "evening")
    stime_map = {"morning": "06:00", "noon": "11:00", "evening": "17:00", "weekend_full_day": "06:00", "irregular": "06:00"}
    etime_map = {"morning": "10:00", "noon": "14:00", "evening": "22:00", "weekend_full_day": "22:00", "irregular": "22:00"}
    return [{
        "id":             card_id_counter[0],
        "card_id":        random.randint(1, 20),    # 次卡售卖ID（字典）
        "status":         0,    # 0=待激活
        "expire_time":    fmt(expire),
        "stime":          stime_map.get(active, "06:00"),
        "etime":          etime_map.get(active, "22:00"),
        "type":           random.choice([1, 2]),     # 1=储值卡 2=次卡
        "limit_num":      random.choice([1, 2, 3]),  # 单日使用限制次数
        "user_id":        member_rec["id"],
        "discount_time":  round(random.uniform(0.5, 2.0), 2),  # 单次可抵扣时长（小时）
        "card_name":      "闲时次卡" if random.random() < 0.5 else "全时通用次卡",
        "create_time":    fmt(ct_card),
        "extract_time":   fmt(ct_card),
    }]


def gen_coupon(member_rec: dict, instance: dict) -> list:
    """P2-3：按概率生成 j_coupon，每人 1-2 张，各张时间间隔 ≥3 天，无 LLM。"""
    probs = instance.get("behavior_probabilities", {})
    if random.random() >= probs.get("use_coupon", 0.4):
        return []
    num_coupons = random.choices([1, 2], weights=[0.55, 0.45])[0]

    create_time = member_rec.get("create_time", fmt(SIM_START))
    if isinstance(create_time, str):
        ct = datetime.strptime(create_time[:19], "%Y-%m-%d %H:%M:%S")
    else:
        ct = create_time

    # 优惠券时间窗口：注册后 ~120 天内，各券至少间隔 3 天
    window_end = min(ct + timedelta(days=120), SIM_END)
    window_days = max((window_end - ct).days, num_coupons * 3 + 1)

    used_days: set = set()
    rows = []
    for _ in range(num_coupons):
        # 找一个与已用天数间隔 ≥3 天的随机天
        for attempt in range(50):
            offset = random.randint(1, window_days)
            if all(abs(offset - d) >= 3 for d in used_days):
                used_days.add(offset)
                break
        else:
            offset = max(used_days) + 3 if used_days else 1
            used_days.add(offset)

        receive_time = ct + timedelta(days=offset,
                                      hours=random.randint(8, 21),
                                      minutes=random.randint(0, 59))
        code_id = random.randint(COUPON_ID_START, COUPON_ID_END)
        days_valid = random.choice([7, 15, 30, 60])
        expire_time = receive_time + timedelta(days=days_valid)

        rows.append({
            "name":        f"优惠券_{code_id}",
            "code_id":     code_id,
            "rec_type":    random.choice([1, 3]),  # 1=注册 3=发老用户
            "scene_type":  0,    # 0=全场通用
            "use_type":    0,    # 0=未使用
            "full_cut_price": round(random.uniform(30, 150), 2),
            "price":       round(random.uniform(5, 50), 2),
            "start_time":  fmt(receive_time),
            "expire_time": fmt(expire_time),
            "status":      1,    # 1=未使用
            "user_id":     member_rec["id"],
            "is_pop":      0,
            "create_time": fmt(receive_time),
            "use_time":    None,
            "grantId":     1,
            "merchant_id": random.choice([1, 2, 3, 4, 5]),
            "extract_time": fmt(receive_time),
        })
    return rows


# ─── CSV 写出 ─────────────────────────────────────────────────────────────────

MEMBER_FIELDS = [
    "id", "phone", "nick_name", "birthday", "age", "province", "city", "area",
    "sex", "rank", "is_blacklist", "source", "is_vip", "jwh_vip", "venue_id",
    "member_rate", "content_rate", "member_status", "id_card", "user_name",
    "id_card_check", "report_check", "is_audit", "login_num", "last_login_time",
    "energy_volume_num", "depart_discount_num", "guess_status", "default_image_index",
    "register_source", "create_time", "extract_time",
]

THIRD_FIELDS = ["id", "member_id", "third_type", "third_source",
                "third_id", "union_id", "create_time", "extract_time"]

BTP_FIELDS = ["id", "member_id", "num", "type", "name", "phone", "sex",
              "id_card_status", "create_time", "update_time", "extract_time"]

TIMECARD_FIELDS = ["id", "card_id", "status", "expire_time", "stime", "etime",
                   "type", "limit_num", "user_id", "discount_time",
                   "card_name", "create_time", "extract_time"]

COUPON_FIELDS = ["id", "name", "code_id", "rec_type", "scene_type", "use_type",
                 "full_cut_price", "price", "start_time", "expire_time",
                 "status", "user_id", "is_pop", "create_time", "use_time",
                 "grantId", "merchant_id", "extract_time"]


def write_csv(path: Path, rows: list, fieldnames: list):
    if not rows:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    mode = "a" if path.exists() else "w"
    with open(path, mode, newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        if mode == "w":
            writer.writeheader()
        writer.writerows(rows)


# ─── 主流程 ────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="P2-2+P2-3 用户事件生成")
    parser.add_argument("--dry-run", action="store_true",
                        help="跳过 LLM，用规则生成占位数据")
    parser.add_argument("--resume",  action="store_true",
                        help="从上次中断处继续")
    parser.add_argument("--limit", type=int, default=SAMPLE_COUNT,
                        help=f"本次最多生成条数（默认 {SAMPLE_COUNT}）")
    args = parser.parse_args()

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # 加载资源
    print("加载实例库…")
    all_instances = [json.loads(l)
                     for l in PERSONAS_FILE.read_text(encoding="utf-8").splitlines() if l.strip()]
    print(f"  实例库共 {len(all_instances)} 条")

    print("加载字典数据…")
    venues    = json.loads((DICT_DIR / "venues.json").read_text(encoding="utf-8"))
    venue_ids = [v["venue_id"] for v in venues]

    # 断点续传
    done = load_progress() if args.resume else {}
    if done:
        print(f"  断点续传：已完成 {len(done)} 条，继续剩余部分")

    # 随机抽样（固定 seed 保证可复现，resume 时保持同样的样本集）
    random.seed(42)
    if len(all_instances) >= args.limit:
        sampled = random.sample(all_instances, args.limit)
    else:
        sampled = all_instances
    print(f"  本次抽取 {len(sampled)} 条实例")

    # 计数器（id 连续，resume 时从已有最大值继续）
    member_id_counter = [MEMBER_ID_START + len(done) - 1]
    btp_id_counter    = [BTP_ID_START]
    card_id_counter   = [CARD_ID_START]
    coupon_id_counter = [0]   # j_coupon.id 自增

    # 读已有 CSV 最后 id（resume 支持）
    if args.resume:
        member_csv = OUTPUT_DIR / "j_member.csv"
        if member_csv.exists():
            rows = list(csv.DictReader(open(member_csv, encoding="utf-8-sig")))
            if rows:
                member_id_counter[0] = max(int(r["id"]) for r in rows)
        btp_csv = OUTPUT_DIR / "buy_ticket_people.csv"
        if btp_csv.exists():
            rows = list(csv.DictReader(open(btp_csv, encoding="utf-8-sig")))
            if rows:
                btp_id_counter[0] = max(int(r["id"]) for r in rows)
        card_csv = OUTPUT_DIR / "j_member_time_card.csv"
        if card_csv.exists():
            rows = list(csv.DictReader(open(card_csv, encoding="utf-8-sig")))
            if rows:
                card_id_counter[0] = max(int(r["id"]) for r in rows)
        coupon_csv = OUTPUT_DIR / "j_coupon.csv"
        if coupon_csv.exists():
            rows = list(csv.DictReader(open(coupon_csv, encoding="utf-8-sig")))
            if rows:
                coupon_id_counter[0] = max(int(r["id"]) for r in rows)

    total      = len(sampled)
    processed  = 0
    skipped    = 0
    t_start    = time.time()

    for idx, instance in enumerate(sampled):
        iid = instance["instance_id"]

        # 断点续传跳过
        if iid in done:
            skipped += 1
            continue

        processed += 1
        member_id_counter[0] += 1
        member_id = member_id_counter[0]
        phone     = make_phone(instance)
        venue     = random.choice(venues)

        # 注册时间：按 lifecycle_stage 约束
        lifecycle = instance.get("dimensions", {}).get("lifecycle_stage", "growing")
        if lifecycle == "new_user":
            reg_start = SIM_END - timedelta(days=30)
        elif lifecycle in ("at_risk", "churned"):
            reg_start = SIM_START
            reg_end   = SIM_END - timedelta(days=90)
            reg_start, reg_end = reg_start, reg_end
        else:
            reg_start = SIM_START
        reg_end = SIM_END
        create_time = rand_date(reg_start, reg_end)

        # ── P2-2-A：生成 j_member（LLM 或 dry-run 规则）──────────────────
        print(f"[{idx+1}/{total}] INST:{iid} member_id:{member_id} ", end="", flush=True)
        t0 = time.time()

        if args.dry_run:
            dims = instance.get("dimensions", {})
            probs = instance.get("behavior_probabilities", {})
            id_check = get_id_card_check(dims.get("id_verification_status", "unverified"))
            rep_check = get_report_check(probs.get("complete_health_check", 0.3))
            src = get_registration_channel_code(dims.get("registration_channel", "miniprogram"))
            age = instance.get("age", 30)
            birth_year = datetime.now().year - age
            venue_id_str = venue.get("venue_id", "V001")
            venue_id_int = int(venue_id_str[1:]) if venue_id_str[0] == "V" else 1
            id_card = make_id_card(instance.get("province", "广东省"), birth_year, random.randint(1,12), random.randint(1,28))
            sex = 1 if instance.get("gender") == "male" else 2
            member_rec = {
                "id": member_id, "phone": phone, "nick_name": instance.get("name", "用户"),
                "birthday": f"{birth_year}-{random.randint(1,12):02d}-{random.randint(1,28):02d}",
                "age": age, "province": instance.get("province", "广东省"),
                "city": instance.get("city", "深圳市"), "area": instance.get("district", "南山区"),
                "sex": sex, "rank": 0, "is_blacklist": 0, "source": src,
                "is_vip": 0, "jwh_vip": 0, "venue_id": venue_id_int,
                "member_rate": round(random.uniform(1,5), 1), "content_rate": round(random.uniform(1,5), 1),
                "member_status": 1, "id_card": id_card, "user_name": instance.get("name", ""),
                "id_card_check": id_check, "report_check": rep_check,
                "is_audit": 1 if id_check == 2 else 0,
                "login_num": random.randint(1, 100),
                "last_login_time": fmt(rand_date(create_time, SIM_END)),
                "energy_volume_num": random.randint(0, 10),
                "depart_discount_num": random.randint(0, 5),
                "guess_status": 1, "default_image_index": random.randint(0, 9),
                "register_source": venue_id_str,
                "create_time": fmt(create_time), "extract_time": fmt(create_time),
            }
            elapsed = 0.0
        else:
            prompt, meta = build_member_prompt(instance, member_id, phone, venue, create_time)
            try:
                member_rec = call_llm(MEMBER_SYSTEM, prompt)
                # 确保必要字段正确（LLM 可能改动）
                member_rec["id"]      = member_id
                member_rec["phone"]   = phone
                member_rec["source"]  = meta["source"]
                member_rec["id_card_check"] = meta["id_card_check"]
                member_rec["report_check"]  = meta["report_check"]
                member_rec["venue_id"]      = meta["venue_id_int"]
                member_rec["register_source"] = meta["venue_id_str"]
                member_rec["create_time"]   = fmt(meta["create_time"])
                member_rec["extract_time"]  = fmt(meta["create_time"])
                elapsed = time.time() - t0
            except Exception as e:
                print(f"[SKIP] {e}")
                continue

        # 写 j_member
        write_csv(OUTPUT_DIR / "j_member.csv", [member_rec], MEMBER_FIELDS)
        save_progress(member_rec, iid)

        # ── P2-2-B/C/D + P2-3：代码生成 ──────────────────────────────────
        thirds  = gen_member_third(member_rec, instance)
        btps    = gen_buy_ticket_people(member_rec, instance, btp_id_counter)
        cards   = gen_time_card(member_rec, instance, card_id_counter)
        coupons = gen_coupon(member_rec, instance)

        # 补充自增 id
        for r in thirds:
            r["id"] = r.get("id", 0) or (hash(r["third_id"]) % 900000 + 100000)
        for r in coupons:
            coupon_id_counter[0] += 1
            r["id"] = coupon_id_counter[0]

        if thirds:
            write_csv(OUTPUT_DIR / "j_member_third.csv", thirds, THIRD_FIELDS)
        if btps:
            write_csv(OUTPUT_DIR / "buy_ticket_people.csv", btps, BTP_FIELDS)
        if cards:
            write_csv(OUTPUT_DIR / "j_member_time_card.csv", cards, TIMECARD_FIELDS)
        if coupons:
            write_csv(OUTPUT_DIR / "j_coupon.csv", coupons, COUPON_FIELDS)

        elapsed_str = f"{elapsed:.0f}s" if not args.dry_run else "dry"
        print(f"✓ | third={len(thirds)} btp={len(btps)} card={len(cards)} coupon={len(coupons)} [{elapsed_str}]")

        # 进度汇报（每 10 条）
        if processed % 10 == 0:
            eta_per = (time.time() - t_start) / processed
            remaining = total - skipped - processed
            print(f"  ── 进度 {processed}/{total-skipped} | "
                  f"耗时 {(time.time()-t_start)/60:.1f}min | "
                  f"预计剩余 {eta_per*remaining/60:.0f}min ──")

    # ── 汇总 ──────────────────────────────────────────────────────────────
    print(f"\n=== P2-2+P2-3 完成 ===")
    for fname in ["j_member", "j_member_third", "buy_ticket_people",
                  "j_member_time_card", "j_coupon"]:
        fpath = OUTPUT_DIR / f"{fname}.csv"
        if fpath.exists():
            count = sum(1 for _ in open(fpath, encoding="utf-8-sig")) - 1
            print(f"  {fname}.csv: {count} 条")
    print(f"  总耗时: {(time.time()-t_start)/60:.1f} 分钟")


if __name__ == "__main__":
    main()

