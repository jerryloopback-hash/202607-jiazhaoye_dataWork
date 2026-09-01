# -*- coding: utf-8 -*-
"""
场景B · XGBoost 流失预测：训练 + 评估 + 增量重训 + 批量打标
============================================================
输入：output/features.csv（特征宽表+自造 y）、output/split.json（train/valid/test 切分）
      由 sceneB_featurize.py 生成。
输出：
  output/model/model_v<ts>.json        —— 训练的 XGBoost 模型（版本化）
  output/model/latest.json             —— 指向最新版本
  output/sceneB_churn_labels.csv       —— 全量用户批量打标输出（脱敏，user_id+prob+标签+版本+日期）
  output/sceneB_eval_report.txt        —— 测试集评估报告（AUC / PR-AUC / 混淆矩阵 / 特征重要性）

工程说明（离线批量 + 增量重训）：
  - 离线批量：读 DWS 特征宽表（此处=features.csv），跑 特征→训练→评估→打标 全链路。
  - 增量重训：每日/每周调度触发，用"历史累积样本 + 新增样本"全量重训并**版本化**，
    保留旧模型可回滚；打标输出带 model_version 与 as_of_date 以保证血缘可回溯。
  - 防泄漏：特征只吃观察窗、标签只吃标签窗（见 featurize），切分随机分层（同期 cohort）。
  生产替代：把 features.csv 换成查询 DWS 特征宽表 + DWS 标签的 SQL/接口，模型保存/加载路径不变。

依赖：numpy, pandas, scikit-learn, xgboost。在具备这些依赖的环境运行（如用户本机/训练服务器）。
"""
import os, json, csv, datetime, glob

import numpy as np
import pandas as pd
from sklearn.metrics import (
    roc_auc_score, average_precision_score,
    confusion_matrix, classification_report,
)
import xgboost as xgb

SEED = 20260831
BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(BASE, "output")
MODEL_DIR = os.path.join(OUT, "model")
os.makedirs(MODEL_DIR, exist_ok=True)

# 用于打标的特征列（与 featurize 的 FEATURE_NAMES 一致，不含 uid/y）
FEATURE_NAMES = [
    "age", "sex", "login_num",
    "n_events", "n_events_30d", "n_order", "n_swim", "n_activity", "n_points", "n_timecard",
    "spend_total", "spend_mean", "spend_max",
    "recency_days", "behavior_diversity",
]

# 流失分档阈值（可在生产按业务 KPI 调）
CHURN_HIGH, CHURN_MID = 0.7, 0.4


def now_tag():
    return datetime.datetime.now().strftime("%Y%m%d_%H%M%S")


def load():
    df = pd.read_csv(os.path.join(OUT, "features.csv"))
    split = json.load(open(os.path.join(OUT, "split.json"), encoding="utf-8"))
    return df, split


def build_sets(df, split):
    tr = df[df["uid"].isin(set(split["train"]))]
    va = df[df["uid"].isin(set(split["valid"]))]
    te = df[df["uid"].isin(set(split["test"]))]
    X = {k: v[FEATURE_NAMES].astype(float) for k, v in [("tr", tr), ("va", va), ("te", te)]}
    y = {k: v["y"].astype(int) for k, v in [("tr", tr), ("va", va), ("te", te)]}
    return X, y, (tr, va, te)


def train(X, y, seed=SEED):
    """版本自适应：兼容 xgboost 1.x 与 >=2.x/3.x（early_stopping/eval_metric 参数位置不同）。"""
    import inspect
    init_kwargs = dict(
        n_estimators=300,
        max_depth=5,
        learning_rate=0.05,
        subsample=0.8,
        colsample_bytree=0.8,
        min_child_weight=3,
        # 正类=流失(1)。scale_pos_weight=负样本数/正样本数，上采样少数类权重
        scale_pos_weight=(1 - y["tr"].mean()) / y["tr"].mean(),
        objective="binary:logistic",
        verbosity=0,
        random_state=seed,
    )
    sig_init = inspect.signature(xgb.XGBClassifier.__init__).parameters
    if "early_stopping_rounds" in sig_init:          # xgboost >= 1.6
        init_kwargs["early_stopping_rounds"] = 30
        init_kwargs["eval_metric"] = "auc"
    if "use_label_encoder" in sig_init:              # xgboost < 2.0
        init_kwargs["use_label_encoder"] = False
    model = xgb.XGBClassifier(**init_kwargs)

    fit_kwargs = dict(eval_set=[(X["va"], y["va"])], verbose=False)
    if "early_stopping_rounds" in inspect.signature(model.fit).parameters:  # xgboost < 1.6
        fit_kwargs["early_stopping_rounds"] = 30
    model.fit(X["tr"], y["tr"], **fit_kwargs)
    return model


def evaluate(model, X, y):
    proba = model.predict_proba(X["te"])[:, 1]
    auc = roc_auc_score(y["te"], proba)
    pr_auc = average_precision_score(y["te"], proba)
    pred = (proba >= 0.5).astype(int)
    cm = confusion_matrix(y["te"], pred)
    return {
        "auc": float(auc), "pr_auc": float(pr_auc),
        "proba": proba, "pred": pred,
        "cm": cm, "positive_rate": float(y["te"].mean()),
    }


def churn_label(prob):
    if prob >= CHURN_HIGH:
        return "高危流失"
    if prob >= CHURN_MID:
        return "中危流失"
    return "低危/稳定"


def write_labels(df_all, model, version, as_of):
    """对全量用户批量打标，输出脱敏标签表（user_id + 概率 + 分档 + 版本 + 日期）。"""
    proba = model.predict_proba(df_all[FEATURE_NAMES].astype(float))[:, 1]
    rows = []
    for uid, p in zip(df_all["uid"], proba):
        rows.append({
            "user_id": uid,
            "churn_prob": round(float(p), 4),
            "churn_label": churn_label(float(p)),
            "model_version": version,
            "as_of_date": as_of,
        })
    path = os.path.join(OUT, "sceneB_churn_labels.csv")
    with open(path, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=["user_id", "churn_prob", "churn_label",
                                          "model_version", "as_of_date"])
        w.writeheader()
        w.writerows(rows)
    return path


def write_eval(eval_rep, y_te, version, model=None):
    report = ["场景B 流失预测 · 测试集评估报告", "=" * 55,
              f"模型版本: {version}",
              f"测试集样本: {len(y_te)}  真实流失率: {eval_rep['positive_rate']:.1%}",
              f"AUC: {eval_rep['auc']:.4f}   PR-AUC: {eval_rep['pr_auc']:.4f}",
              "混淆矩阵 (阈0.5, 行=实际 列=预测):",
              f"  {eval_rep['cm'][0][0]:<6}{eval_rep['cm'][0][1]}",
              f"  {eval_rep['cm'][1][0]:<6}{eval_rep['cm'][1][1]}",
              "",
              "分类报告 (阈0.5):",
              classification_report(y_te, eval_rep["pred"],
                                    target_names=["未流失(0)", "流失(1)"], digits=4)]
    if model is not None:
        imp = sorted(zip(FEATURE_NAMES, model.feature_importances_), key=lambda t: -t[1])
        report += ["Top10 特征重要性:",
                   *[f"  {name:<20}{v:.4f}" for name, v in imp[:10]]]
    path = os.path.join(OUT, "sceneB_eval_report.txt")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(report))
    return path


def save_model(model, version):
    path = os.path.join(MODEL_DIR, f"model_{version}.json")
    model.save_model(path)
    with open(os.path.join(MODEL_DIR, "latest.json"), "w", encoding="utf-8") as f:
        json.dump({"latest_version": version, "path": path,
                   "as_of_date": datetime.datetime.now().isoformat()}, f, ensure_ascii=False)
    return path


def list_versions():
    return sorted(glob.glob(os.path.join(MODEL_DIR, "model_*.json")))


def main():
    as_of = datetime.datetime.now().date().isoformat()
    df, split = load()
    X, y, _ = build_sets(df, split)

    print(f"[1/4] 数据: {len(df)} 行 × {len(FEATURE_NAMES)} 特征 | 切分 "
          f"train={len(split['train'])} valid={len(split['valid'])} test={len(split['test'])}")

    print("[2/4] 训练 XGBoost（early-stopping on valid）...")
    model = train(X, y)

    print("[3/4] 测试集评估 ...")
    ev = evaluate(model, X, y)
    print(f"   AUC={ev['auc']:.4f}  PR-AUC={ev['pr_auc']:.4f}  真实流失率={ev['positive_rate']:.1%}")

    version = now_tag()
    print(f"[4/4] 保存模型 + 批量打标 ...")
    mpath = save_model(model, version)
    lpath = write_labels(df, model, version, as_of)
    epath = write_eval(ev, y["te"], version, model)
    print(f"  模型: {mpath}")
    print(f"  标签: {lpath}")
    print(f"  报告: {epath}")
    print(f"  历史版本数: {len(list_versions())}（增量重训会自动新增版本、保留旧模型）")

    # 特征重要性（可解释性）
    imp = sorted(zip(FEATURE_NAMES, model.feature_importances_),
                 key=lambda t: -t[1])
    print("\nTop 特征重要性:")
    for name, v in imp[:8]:
        print(f"  {name:<20} {v:.4f}")


if __name__ == "__main__":
    main()
