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
- 用「潜在活跃倾向 latent」驱动用户行为总量，用「活跃趋势 trend」模拟流失前的
  行为衰减（trend 低 → 事件集中在观察窗远期、近期稀疏——真实流失的典型前兆），
  使特征与流失目标存在**可学习**的关联（而非纯随机或纯单次抽样噪声）。
- 标签窗 y：P(未来30天活跃) = 0.04 + 0.55*latent + 0.35*min(近30天事件数,4)/4，
  既由 latent 决定基线，又由"近期行为"增强——这正是流失预测可利用的信号结构。
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
    # 潜在活跃倾向 latent ∈ [0,1)：驱动行为量与流失基线（Beta(1.3,1.3) 偏两极：稳定/沉睡两类人群明显）
    latent = rng.betavariate(1.3, 1.3)
    # 活跃趋势 trend ∈ [0,1)：1=近期持续活跃；0=行为衰减（流失前兆）
    trend = rng.betavariate(2.0, 2.0)
    return {
        "uid": f"U{i:06d}",
        "age": max(6, min(80, int(rng.gauss(33, 12)))),
        "sex": rng.choices([0, 1, 2], weights=[0.05, 0.52, 0.43])[0],
        "login_num": int(rng.expovariate(1/ (3 + latent * 40))),
        "latent": round(latent, 4),   # 仅用于生成，不进入模型特征
        "trend": round(trend, 4),     # 仅用于生成，不进入模型特征
    }

# ---------- 生成行为事件 ----------
def make_events(u):
    """按 latent/trend 生成观察窗事件；标签窗 y 由 latent + 近30天行为共同驱动。"""
    latent, trend = u["latent"], u["trend"]
    # 行为强度基准：观察窗内平均事件数（活跃者更多）
    mean_events = 2 + latent * 25.0
    n_events = int(rng.expovariate(1.0 / mean_events))   # 长尾：多数少、少数活跃
    n_events = min(n_events, 90)
    events = []
    recent30 = 0
    for _ in range(n_events):
        # 日期分布倾斜：trend 高 → 事件集中近期（d 小）；trend 低 → 集中远期（行为衰减）
        k = 0.5 + 3.0 * trend                # 幂指数：trend=1→k=3.5(偏近)，trend=0→k=0.5(偏远)
        d = 1 + int((OBS_DAYS - 1) * (rng.random() ** k))
        if d <= 30:
            recent30 += 1
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
    # 标签窗 y：P(未来30天活跃) 由 latent 基线 + 近30天行为共同决定（流失=0）
    prob_active = min(0.98, max(0.02, 0.04 + 0.55 * latent + 0.35 * min(recent30, 4) / 4.0))
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
        w = csv.DictWriter(f, fieldnames=["uid", "age", "sex", "login_num", "latent", "trend"])
        w.writeheader()
        for u in users:
            w.writerow({k: u[k] for k in ["uid", "age", "sex", "login_num", "latent", "trend"]})

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
