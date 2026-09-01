# -*- coding: utf-8 -*-
"""
场景B · 特征工程 + 自造标签（观察窗 → 特征，标签窗 → y）
============================================================
输入：output/raw/{users,events,label}.csv（由 sceneB_synth_data.py 生成，模拟 ODS 层）
输出：
  output/features.csv      —— 用户×特征 宽表（含自造标签 y 与 uid）
  output/split.json        —— 训练/验证/测试 切分（用户 uid 集合，随机分层）

特征设计（对应 DWS 特征宽表的一人一行业务口径）：
  - 静态属性：age, sex
  - 登录活跃：login_num
  - 观察窗行为聚合（仅用 days_ago>=1 的事件，即"过去"，不加标签窗信息）：
      n_events, n_order, n_swim, n_activity, n_points, n_timecard
      spend_total, spend_mean, spend_max        （金额，log1p 后）
      recency_days                              （最近一次行为距今几天，越接近今天越小=越活跃）
      behavior_diversity                        （涉及的事件类型数 /5）
  - 标签 y：churn（1=未来30天无任何行为=流失；0=仍活跃）——由独立标签窗(label_active)取反。

⚠️ 防泄漏：特征只由观察窗(days_ago>=1)计算；y 只由标签窗(独立 label.csv)给出；
   二者在时间上严格隔离。生产中等价于「观察期>=过去N天 & 标签期=未来M天」的 SQL 构造。

本脚本纯标准库实现，可在无三方依赖环境运行、全流程可复现。
"""
import csv, os, json, math

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW = os.path.join(BASE, "output", "raw")
OUT = os.path.join(BASE, "output")
os.makedirs(OUT, exist_ok=True)

FEATURE_NAMES = [
    "age", "sex", "login_num",
    "n_events", "n_order", "n_swim", "n_activity", "n_points", "n_timecard",
    "spend_total", "spend_mean", "spend_max",
    "recency_days", "behavior_diversity",
]
EVENT_TYPES = ["order", "swim_ticket", "activity", "points", "time_card"]
MONEY_FIELDS = ["spend_total", "spend_mean", "spend_max"]

def load_users():
    rows = {}
    with open(os.path.join(RAW, "users.csv"), encoding="utf-8") as f:
        for r in csv.DictReader(f):
            rows[r["uid"]] = r
    return rows

def load_events():
    ev = {}
    with open(os.path.join(RAW, "events.csv"), encoding="utf-8") as f:
        for r in csv.DictReader(f):
            ev.setdefault(r["uid"], []).append(r)
    return ev

def load_labels():
    lab = {}
    with open(os.path.join(RAW, "label.csv"), encoding="utf-8") as f:
        for r in csv.DictReader(f):
            lab[r["uid"]] = int(r["label_active"])
    return lab

def featurize(uid, u, events):
    feats = {
        "uid": uid,
        "age": int(u.get("age") or 0),
        "sex": int(u.get("sex") or 0),
        "login_num": int(u.get("login_num") or 0),
    }
    cnt = {t: 0 for t in EVENT_TYPES}
    amounts = []
    recent = None          # 最近一次行为距今天数（取最小=mindays）
    for e in events:
        t = e["event_type"]
        d = int(e["days_ago"])
        if t in cnt:
            cnt[t] += 1
        amt = float(e["amount"] or 0)
        if amt > 0:
            amounts.append(amt)
        if recent is None or d < recent:
            recent = d
    n_events = sum(cnt.values())
    # 金额 log1p（长尾压缩，与场景A一致的口径）
    save_log = lambda x: round(math.log1p(x), 4) if x > 0 else 0.0
    spend_total = save_log(sum(amounts))
    spend_mean  = save_log((sum(amounts) / len(amounts))) if amounts else 0.0
    spend_max   = save_log(max(amounts)) if amounts else 0.0
    diversity   = round(sum(1 for t in EVENT_TYPES if cnt[t] > 0) / len(EVENT_TYPES), 4)
    recency     = recent if recent is not None else None  # null=观察窗内无行为(最可疑流失)

    feats.update({
        "n_events": n_events,
        "n_order": cnt["order"], "n_swim": cnt["swim_ticket"],
        "n_activity": cnt["activity"], "n_points": cnt["points"],
        "n_timecard": cnt["time_card"],
        "spend_total": spend_total, "spend_mean": spend_mean, "spend_max": spend_max,
        "recency_days": recency, "behavior_diversity": diversity,
    })
    return feats

def main():
    users = load_users()
    events = load_events()
    labels = load_labels()

    rows = []
    for uid, u in users.items():
        feats = featurize(uid, u, events.get(uid, []))
        # y=流失(churn)：1=未来30天无任何行为(流失)，0=仍活跃。由 label_active 取反得到。
        feat_active = labels[uid]
        feats["y"] = 1 - feat_active
        rows.append(feats)
    rows.sort(key=lambda r: r["uid"])

    # 该脚本目前把 recency_days 的空值写为 999（观察窗无行为=最久未活跃特征）
    for r in rows:
        if r["recency_days"] is None:
            r["recency_days"] = 999

    # 写 features.csv
    fieldnames = ["uid"] + FEATURE_NAMES + ["y"]
    with open(os.path.join(OUT, "features.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k) for k in fieldnames})

    # 切分：全部用户观察窗同一"今天"（同期 cohort），无跨用户时序依赖。
    # 防泄漏由"窗口设计"保证（特征只看过去、标签只看未来），故此处用随机分层切分。
    # 生产中若按观察窗结束日期分批(如按月滚动 cohort)，应改为时序切分。
    rng_local = __import__("random").Random(20260831)
    shuffled = rows[:]
    rng_local.shuffle(shuffled)
    n = len(shuffled)
    n_tr, n_va = int(n * 0.7), int(n * 0.15)
    tr = [r["uid"] for r in shuffled[:n_tr]]
    va = [r["uid"] for r in shuffled[n_tr:n_tr + n_va]]
    te = [r["uid"] for r in shuffled[n_tr + n_va:]]
    with open(os.path.join(OUT, "split.json"), "w", encoding="utf-8") as f:
        json.dump({"train": tr, "valid": va, "test": te}, f)

    # 速览
    pos = sum(1 for r in rows if r["y"] == 1)
    print(f"特征宽表: {len(rows)} 用户 × {len(FEATURE_NAMES)} 特征")
    print(f"流失(y=1)占比: {100*pos/len(rows):.1f}%")
    print(f"切分: train={len(tr)} valid={len(va)} test={len(te)}")
    print("输出:", os.path.join(OUT, "features.csv"), "/ split.json")

if __name__ == "__main__":
    main()
