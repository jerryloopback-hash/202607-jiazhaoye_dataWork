# -*- coding: utf-8 -*-
"""
场景B · 合成数据生成器（模拟 ODS 层原始事件流）
================================================
定位：模拟「佳兆业文体」C 端用户库的 ODS 原始层，产出：
  1) users : 用户主表（对应 ods_wenti_jianengliang_j_member，脱敏后字段）
  2) events: 用户行为事件表（对应 订单/游泳票/活动/积分 等的合并简化视图）

供下游「特征宽表(场景B_featurize) → 自造标签 → XGBoost 训练」使用。
纯 Python 标准库实现，无第三方依赖，可在任意环境复现。

设计说明（关键）：
- 用一个「潜在活跃倾向 latent」驱动用户行为，使特征与真实流失目标存在内在关联，
  从而让监督模型能学到有意义的信号（而非纯随机），便于展示链路与评估。
- 观察窗/标签窗：事件覆盖 [ -180, +30 ] 天（以"今天"为 0）。
    - 观察窗 = [-180, -1]   → 特征
    - 标签窗 = [  0, +30]   → 定义 y（未来 30 天是否无任何行为 = 流失）
  这样严格切分，训练时只用观察窗特征预测标签窗事件，防数据泄漏。
- seed 固定 → 全流程可复现。
"""
import csv, os, random, datetime

SEED = 20260831
rng = random.Random(SEED)

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW  = os.path.join(BASE, "output", "raw")
os.makedirs(RAW, exist_ok=True)

N_USERS  = 12000          # 用户数（C 端）
OBS_DAYS = 180            # 观察窗天数（过去）
LABEL_DAYS = 30           # 标签窗天数（未来）

EVENT_TYPES = ["order", "swim_ticket", "activity", "points", "time_card"]

# ---------- 生成用户 ----------
def make_user(i):
    # 潜在活跃倾向 latent ∈ [0,1)，驱动行为量与流失
    latent = rng.betavariate(2.0, 2.0)
    return {
        "uid": f"U{i:06d}",
        "age": max(6, min(80, int(rng.gauss(33, 12)))),
        "sex": rng.choices([0, 1, 2], weights=[0.05, 0.52, 0.43])[0],
        "login_num": int(rng.expovariate(1/ (3 + latent * 40))),
        "latent": round(latent, 4),   # 仅用于生成，不进入模型特征
    }

# ---------- 生成行为事件 ----------
def make_events(u):
    """按 latent 生成观察窗事件；标签窗事件仅用于得 y。"""
    latent = u["latent"]
    # 行为强度基准：观察窗内平均事件数（活跃者更多；用于展示，不直接进特征）
    mean_events = 2 + latent * 25.0
    n_events = int(rng.expovariate(1.0 / mean_events))   # 长尾：多数少、少数活跃
    n_events = min(n_events, 90)
    events = []
    for _ in range(n_events):
        d = rng.randint(1, OBS_DAYS)                     # 事件落在观察窗某天
        typ = rng.choices(
            EVENT_TYPES,
            weights=[0.30, 0.25, 0.15, 0.20, 0.10],
        )[0]
        events.append({
            "uid": u["uid"],
            "days_ago": d,
            "event_type": typ,
            "amount": round(rng.lognormvariate(3.2, 0.8), 2) if typ in ("order", "swim_ticket") else 0,
        })
    # 标签窗 y：由 latent 驱动的"未来 30 天是否活跃"（流失=0）
    # P(active) = 0.25 + 0.72*latent  →  低活跃倾向流失率更高，整体含充分正负样本
    prob_active = 0.25 + 0.72 * latent
    label_active = rng.random() < prob_active
    return events, label_active

def main():
    users = [make_user(i) for i in range(N_USERS)]
    all_events = []
    label_rows = []
    for u in users:
        ev, active = make_events(u)
        all_events.extend(ev)
        label_rows.append({"uid": u["uid"], "label_active": int(active)})

    # 写 users.csv（脱敏：不含手机号/身份证/姓名）
    with open(os.path.join(RAW, "users.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["uid", "age", "sex", "login_num", "latent"])
        w.writeheader()
        for u in users:
            w.writerow({k: u[k] for k in ["uid", "age", "sex", "login_num", "latent"]})

    # 写 events.csv
    ev_fields = ["uid", "days_ago", "event_type", "amount"]
    with open(os.path.join(RAW, "events.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=ev_fields)
        w.writeheader()
        for e in all_events:
            w.writerow({k: e[k] for k in ev_fields})

    # 写 label.csv（真实 y 现值，仅示范/评估用；生产中由标签窗事件 SQL 构造）
    with open(os.path.join(RAW, "label.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["uid", "label_active"])
        w.writeheader()
        w.writerows(label_rows)

    print(f"生成完成: {N_USERS} 用户, {len(all_events)} 条观察窗事件")
    print("输出目录:", RAW)

if __name__ == "__main__":
    main()
