# -*- coding: utf-8 -*-
"""
场景B · RFM 评分卡调参器（传参调参，运营/调度免改代码）
====================================================
定位：把 rule 方法（RFM 规则评分卡）的分箱边界 / 三维权重 / 分档阈值全部做成命令行参数。
调度系统或运营同事按需传参运行即可完成调参，无需读改 sceneB_model_router.py 源码。

用法（三种典型）：
  # 1) 按传入参数调参（未传的参数用内置默认口径；M 边界是 spend_total 的 log1p 值）
  python scripts/sceneB_rfm_tuner.py --input output/features.csv \
      --r-bins 7,30,90,180 --f-bins 0,3,10,25 --m-bins 0,3,5,7 \
      --weights 0.4,0.35,0.25 --churn-high 0.7 --churn-mid 0.4

  # 2) 自动调参：分箱按训练集分位数生成 + 权重网格搜索（测试集 AUC 最优；显式传入的参数优先）
  python scripts/sceneB_rfm_tuner.py --auto --input output/features.csv

  # 3) 按业务名单量定分档（如召回预算只够圈 10% 用户 → 高危占比≈10%、中危≈20%）
  python scripts/sceneB_rfm_tuner.py --target-high-rate 0.10 --target-mid-rate 0.20 --input output/features.csv

产出：
  output/model/model_rule_<时间戳>.json        —— 调参版评分卡（含全部分箱/权重/阈值；主程序 --deploy 后生效）
  output/sceneB_churn_labels_rule_tuned.csv    —— 调参版全量打标预览
  output/sceneB_rfm_tune_report.txt            —— 调参报告（参数/AUC 与默认规则对比/分档分布/上线命令）

⚠️ 与训练同规矩：调参不改上线指针 latest.json；按报告里的 --deploy 命令显式上线后，
   --mode predict 的打分与分档才使用本次调参参数（分档阈值随 rule 版本一并带入指针）。
输入：特征宽表 CSV（schema 同主程序 使用说明 §5）。含 y（或 y_aug）列才能评估 AUC / 自动搜索；
      不含 y 时只按参数打分与分档预览（--auto 的权重网格搜索不可用）。
依赖：numpy, pandas（复用主程序 sceneB_model_router 的数据加载、切分与打分实现）。
"""
import os, sys, json, argparse
from collections import Counter

import numpy as np
import pandas as pd

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sceneB_model_router as R

OUT = R.OUT

# 自动调参的权重搜索网格（wM = 1 - wR - wF，越界组合过滤掉）
WEIGHT_GRID = [
    (wr, wf, round(1 - wr - wf, 2))
    for wr in (0.2, 0.3, 0.4, 0.5, 0.6)
    for wf in (0.2, 0.3, 0.4, 0.5)
    if 0.1 <= round(1 - wr - wf, 2) <= 0.6
]


def parse_floats(raw, name, increasing=True):
    """解析逗号分隔数字序列（默认要求严格递增，用于分箱边界）。"""
    try:
        vals = [float(x) for x in str(raw).split(",") if x.strip() != ""]
    except ValueError:
        raise SystemExit(f"--{name} 格式错误：应为逗号分隔数字（如 7,30,90,180），收到: {raw}")
    if len(vals) < 1 or (increasing and any(b <= a for a, b in zip(vals, vals[1:]))):
        raise SystemExit(f"--{name} 必须是严格递增的数字序列，收到: {raw}")
    return vals


def parse_weights(raw):
    """解析 R,F,M 权重并归一化。"""
    vals = parse_floats(raw, "weights", increasing=False)
    if len(vals) != 3 or any(v < 0 for v in vals) or sum(vals) <= 0:
        raise SystemExit(f"--weights 需要 3 个非负数（R,F,M 顺序），收到: {raw}")
    tot = sum(vals)
    return {"R": vals[0] / tot, "F": vals[1] / tot, "M": vals[2] / tot}


def quantile_edges(values, lo=0.0, hi=float("inf"), n_edges=4):
    """按分位数（等频思想）生成分箱边界；有效样本太少时返回 None（调用方回退默认口径）。
    lo/hi 用于排除无意义值：F/M 排除 0（无行为/无消费单独占最低档），R 排除 999 哨兵值。"""
    v = np.asarray(values, dtype=float)
    v = v[np.isfinite(v) & (v > lo) & (v < hi)]
    if len(v) < 10:
        return None
    qs = np.quantile(v, np.linspace(0, 1, n_edges + 2)[1:-1])
    edges = np.unique(np.round(qs, 4))
    return [float(e) for e in edges] if len(edges) else None


def main():
    ap = argparse.ArgumentParser(
        description="场景B RFM 评分卡调参器：命令行传参调 rule，产出可 --deploy 的版本（不改上线指针）")
    ap.add_argument("--input", default=None, help="特征宽表 CSV（默认 output/features.csv）")
    ap.add_argument("--r-bins", default=None, help="R 分箱升序边界（recency_days，天），如 7,30,90,180")
    ap.add_argument("--f-bins", default=None, help="F 分箱升序边界（n_events，观察窗总次数），如 0,3,10,25")
    ap.add_argument("--m-bins", default=None, help="M 分箱升序边界（spend_total 的 log1p 值），如 0,3,5,7")
    ap.add_argument("--weights", default=None, help="R,F,M 权重（自动归一化），如 0.4,0.35,0.25")
    ap.add_argument("--churn-high", type=float, default=None, help="高危分档阈值（默认 0.7）")
    ap.add_argument("--churn-mid", type=float, default=None, help="中危分档阈值（默认 0.4）")
    ap.add_argument("--auto", action="store_true",
                    help="自动调参：分箱按训练集分位数生成、权重网格搜索测试集 AUC 最优（显式传入的参数优先）")
    ap.add_argument("--target-high-rate", type=float, default=None,
                    help="按目标高危占比自动定高危阈值（如 0.10 = 高危圈定约 10%% 用户）")
    ap.add_argument("--target-mid-rate", type=float, default=None,
                    help="按目标中危占比自动定中危阈值（与 --target-high-rate 连用）")
    args = ap.parse_args()

    src = args.input or os.path.join(OUT, "features.csv")
    if not os.path.exists(src):
        raise SystemExit(f"输入文件不存在: {src}")
    head = pd.read_csv(src, nrows=1)
    has_y = ("y" in head.columns) or ("y_aug" in head.columns)
    if has_y:
        df, split = R.load(src)
    else:
        df, split = pd.read_csv(src), None
        print("⚠️ 输入无 y/y_aug 列：只按参数打分与分档，不做 AUC 评估（--auto 权重网格搜索不可用）")
    df_feat = df[R.FEATURE_NAMES].astype(float)

    # ---- 1) 分箱参数：显式传入 > 自动分位数 > 内置默认 ----
    r_edges = parse_floats(args.r_bins, "r-bins") if args.r_bins else None
    f_edges = parse_floats(args.f_bins, "f-bins") if args.f_bins else None
    m_edges = parse_floats(args.m_bins, "m-bins") if args.m_bins else None
    auto_log = []
    if args.auto:
        df_tr = df[df["uid"].isin(set(split["train"]))] if split else df   # 只用训练集分位数，不偷看测试集
        auto = {
            "R": quantile_edges(df_tr["recency_days"], lo=-0.5, hi=999),
            "F": quantile_edges(df_tr["n_events"], lo=0),
            "M": quantile_edges(df_tr["spend_total"], lo=0),
        }
        fallbacks = {"R": R.RULE_PARAMS["r_edges"], "F": R.RULE_PARAMS["f_edges"], "M": R.RULE_PARAMS["m_edges"]}
        picked = {}
        for k, auto_e in auto.items():
            chosen = auto_e or list(fallbacks[k])
            picked[k] = chosen
            auto_log.append(f"{k} 边界({'分位数自动生成' if auto_e else '样本不足,回退默认'}) = {chosen}")
        r_edges, f_edges, m_edges = picked["R"], picked["F"], picked["M"]
    params = {
        "r_edges": r_edges or list(R.RULE_PARAMS["r_edges"]),
        "f_edges": f_edges or list(R.RULE_PARAMS["f_edges"]),
        "m_edges": m_edges or list(R.RULE_PARAMS["m_edges"]),
        "weights": dict(R.RULE_PARAMS["weights"]),
    }

    # ---- 2) 权重：显式传入 > 网格搜索 > 内置默认 ----
    weight_search = []
    if args.weights:
        params["weights"] = parse_weights(args.weights)
    elif args.auto and has_y:
        X, y, _ = R.build_sets(df, split)
        for wr, wf, wm in WEIGHT_GRID:
            pw = dict(params, weights={"R": wr, "F": wf, "M": wm})
            auc = R.roc_auc_score(y["te"], R.rfm_score_params(X["te"], pw))
            weight_search.append((auc, wr, wf, wm))
        weight_search.sort(reverse=True)
        best_auc, wr, wf, wm = weight_search[0]
        params["weights"] = {"R": wr, "F": wf, "M": wm}
        print(f"权重网格搜索: {len(WEIGHT_GRID)} 组合 → 最优 R={wr}/F={wf}/M={wm}（测试集 AUC={best_auc:.4f}）")
    elif args.auto and not has_y:
        print("⚠️ 无 y 列，跳过权重网格搜索，使用内置默认权重")

    # ---- 3) 分档阈值：目标占比 > 显式传入 > 内置默认 ----
    high = args.churn_high if args.churn_high is not None else R.CHURN_HIGH
    mid = args.churn_mid if args.churn_mid is not None else R.CHURN_MID
    proba_all = R.rfm_score_params(df_feat, params)
    if args.target_high_rate is not None:
        if not (0 < args.target_high_rate < 1):
            raise SystemExit("--target-high-rate 应在 (0,1) 之间，如 0.10")
        high = round(float(np.quantile(proba_all, 1 - args.target_high_rate)), 4)
        if args.target_mid_rate is not None:
            if not (0 < args.target_mid_rate < 1 - args.target_high_rate):
                raise SystemExit("--target-mid-rate 需满足 0 < r < 1 - 高危占比")
            mid = round(float(np.quantile(proba_all, 1 - args.target_high_rate - args.target_mid_rate)), 4)
        else:
            mid = min(mid, high)
        print(f"按目标占比定阈值: 高危≥{high}（约 {args.target_high_rate:.0%}）"
              + (f" / 中危≥{mid}（约 {args.target_mid_rate:.0%}）" if args.target_mid_rate else ""))
    if not (0 <= mid <= high <= 1):
        raise SystemExit(f"分档阈值不合法（需 0 ≤ 中危 ≤ 高危 ≤ 1）: high={high}, mid={mid}")
    thresholds = (round(float(high), 4), round(float(mid), 4))

    # ---- 4) 评估 + 保存 + 报告 ----
    version = f"rule_{R.now_tag()}"
    report = [f"场景B · RFM 评分卡调参报告（{R.now_tag()}）", "=" * 60,
              f"数据: {src}（{len(df)} 行）"
              + (f"  切分 train={len(split['train'])} valid={len(split['valid'])} test={len(split['test'])}"
                 if split else "（无 y 列，未做 AUC 评估）"),
              f"模式: {'自动调参(--auto)' if args.auto else '手动传参'}"
              + (f" + 目标占比（高危{args.target_high_rate}"
                 + (f"/中危{args.target_mid_rate}" if args.target_mid_rate else "") + "）"
                 if args.target_high_rate is not None else ""),
              "",
              "调参后参数:",
              f"  R 边界(recency_days 天):    {params['r_edges']}",
              f"  F 边界(n_events 次):        {params['f_edges']}",
              f"  M 边界(spend_total log1p):  {params['m_edges']}",
              f"  权重 R/F/M: {params['weights']['R']:.2f}/{params['weights']['F']:.2f}/{params['weights']['M']:.2f}（已归一化）",
              f"  分档阈值: 高危≥{thresholds[0]} / 中危≥{thresholds[1]}",
              f"  打分口径: {R.RULE_NOTE}"]
    if auto_log:
        report.append("  自动分箱: " + "；".join(auto_log))

    if has_y:
        X, y, _ = R.build_sets(df, split)
        ev_new = R.evaluate(y["te"], R.rfm_score_params(X["te"], params))
        ev_def = R.evaluate(y["te"], R.rfm_score_params(X["te"], R.RULE_PARAMS))
        report += ["", f"测试集评估（n={len(y['te'])}，真实流失率 {ev_new['positive_rate']:.1%}）:",
                   f"  调参版:   AUC={ev_new['auc']:.4f}  PR-AUC={ev_new['pr_auc']:.4f}",
                   f"  默认规则: AUC={ev_def['auc']:.4f}  PR-AUC={ev_def['pr_auc']:.4f}"
                   f"  （ΔAUC={ev_new['auc'] - ev_def['auc']:+.4f}）"]
        if weight_search:
            report.append("  权重搜索 Top5:")
            report += [f"    R={wr:.2f} F={wf:.2f} M={wm:.2f}  AUC={a:.4f}"
                       for a, wr, wf, wm in weight_search[:5]]

    report += ["", "全量分档分布:",
               f"  调参阈值 ({thresholds[0]}/{thresholds[1]}): {R.dist_summary(list(proba_all), thresholds)}",
               f"  默认阈值 ({R.CHURN_HIGH}/{R.CHURN_MID}):     {R.dist_summary(list(proba_all))}"]
    c = Counter(R.churn_label(float(p), *thresholds) for p in proba_all)
    high_rate = c.get("高危流失", 0) / len(proba_all)
    tip = "合理（经验线 5%~20%）" if 0.05 <= high_rate <= 0.20 else "超出经验线 5%~20%，上线前请复核业务含义"
    report.append(f"  高危占比 {high_rate:.1%} → {tip}")

    mpath = R.save_model("rule", params, version, thresholds=list(thresholds))
    lpath = R.write_labels(df, proba_all, version, thresholds=list(thresholds),
                           path=os.path.join(OUT, "sceneB_churn_labels_rule_tuned.csv"))
    report += ["", "产物:",
               f"  评分卡版本: {mpath}",
               f"  打标预览:   {lpath}",
               "", "上线（显式切换指针；回滚 = --deploy 旧版本号）:",
               f"  python scripts/sceneB_model_router.py --deploy {version}",
               "  上线后 --mode predict 的打分与分档即使用本次调参参数。"]

    rpath = os.path.join(OUT, "sceneB_rfm_tune_report.txt")
    with open(rpath, "w", encoding="utf-8") as f:
        f.write("\n".join(report))
    print("\n".join(report))
    print(f"\n调参报告: {rpath}")


if __name__ == "__main__":
    main()
