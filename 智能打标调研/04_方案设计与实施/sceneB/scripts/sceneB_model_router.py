# -*- coding: utf-8 -*-
"""
场景B · 训练 + 打标 路由程序（多方法版）
============================================================
一个脚本、一个参数选方法。原 sceneB_train_xgboost.py 升级而来（文件职责扩展为路由）。

方法注册表（--model 参数）：
  xgboost  梯度提升树（主方法：XGBClassifier，early-stopping + 类别平衡 + 版本自适应）
  lr       逻辑回归（线性基线：StandardScaler + class_weight=balanced，系数可解释）
  rf       随机森林（bagging 树基线：class_weight=balanced）
  rule     RFM 规则评分卡（传统非ML对照：R最近行为/F频次/M金额 分箱加权打分，无训练过程）

用法（路由）：
  python scripts/sceneB_model_router.py                          # 默认 xgboost：训练+评估+全量打标（只产新版本，不改上线指针）
  python scripts/sceneB_model_router.py --model lr               # 指定方法：训练+打标
  python scripts/sceneB_model_router.py --model rule             # 传统评分卡（直接打分，无训练）
  python scripts/sceneB_model_router.py --compare                # 四方法同台对比（同一测试集，给出最优建议）
  python scripts/sceneB_model_router.py --deploy <版本号>         # 显式上线：把指定版本设为 latest 指针（如 rf_20260901_144143）
  python scripts/sceneB_model_router.py --model lr --deploy true  # 训练+评估+打标后【立即上线刚训出的版本】（一步到位）
  python scripts/sceneB_model_router.py --mode predict           # 日常打标：用 latest 指针所指模型，不训练
  python scripts/sceneB_model_router.py --mode predict --input 新特征.csv
  python scripts/sceneB_model_router.py --input features_augmented.csv   # 指定训练数据（含 y_aug 列时优先用 LLM 校准标签）
  python scripts/sceneB_rfm_tuner.py --auto                              # RFM 评分卡调参（传参/自动，免改代码；产出 rule 版本后 --deploy 上线）

⚠️ 上线指针 latest.json 只由 --deploy 修改（训练/对比只产生新版本文件，避免测试性训练
   意外覆盖线上模型——2026-09-01 曾发生 rule 测试训练覆盖 RF 上线指针的事故）。--deploy
   双语义：传版本号=上线指定版本；传 true=train 模式训练后立即上线刚训出的版本（--compare
   永不支持该写法，直接报错）。回滚 = --deploy 旧版本号。

输入：output/features.csv（uid + 15 特征 + y）+ output/split.json（缺失时自动按 70/15/15 分层生成；
      --input 可指定其他训练数据，含 y_aug 列时优先作为 y）
输出：
  output/model/model_<方法>_<ts>.<json|joblib>   —— 模型（版本化，历史全保留；训练不改指针）
  output/model/latest.json                       —— 上线指针（仅由 --deploy 写入；含方法/特征列/阈值，供 predict 模式）
  output/sceneB_churn_labels.csv                 —— 全量打标（user_id, churn_prob, churn_label, model_version, as_of_date）
  output/sceneB_eval_report.txt                  —— 测试集评估报告（AUC/PR-AUC/混淆矩阵/分类报告/特征重要性）
  output/sceneB_model_comparison.txt             —— (--compare 时) 四方法同台对比表

依赖：numpy, pandas, scikit-learn, xgboost（rule/lr/rf 只需 sklearn）。
增量重训与回滚：重跑 train 即新增版本（不动线上）；上线/回滚 = --deploy 目标版本号。
"""
import os, json, csv, glob, time, argparse, datetime

import numpy as np
import pandas as pd
from sklearn.metrics import (
    roc_auc_score, average_precision_score,
    confusion_matrix, classification_report,
)
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

SEED = 20260831
BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(BASE, "output")
MODEL_DIR = os.path.join(OUT, "model")
os.makedirs(MODEL_DIR, exist_ok=True)

# 特征列（与 featurize / DWS 宽表口径一致，不含 uid/y）
FEATURE_NAMES = [
    "age", "sex", "login_num",
    "n_events", "n_events_30d", "n_order", "n_swim", "n_activity", "n_points", "n_timecard",
    "spend_total", "spend_mean", "spend_max",
    "recency_days", "behavior_diversity",
]

# 流失分档阈值（可按业务 KPI 调）
CHURN_HIGH, CHURN_MID = 0.7, 0.4

METHODS = ["xgboost", "lr", "rf", "rule"]
METHOD_DESC = {
    "xgboost": "XGBoost梯度提升树(主方法)",
    "lr": "逻辑回归(线性基线)",
    "rf": "随机森林(bagging基线)",
    "rule": "RFM规则评分卡(传统对照,无训练)",
}

# RFM 评分卡默认参数（传统方法；打分越高越活跃，churn_prob = 1 - activity）。
# 分箱为升序边界：R 档位越高（越久未动）得分越低、F/M 档位越高得分越高，每档等步长 1/n。
# 全部参数可被 scripts/sceneB_rfm_tuner.py 传参/自动调参产出的新版本覆盖（--deploy 后生效）。
RULE_PARAMS = {
    "r_edges": [7, 30, 90, 180],   # recency_days：<=7天→1.0, <=30→0.75, <=90→0.5, <=180→0.25, 其余→0
    "f_edges": [0, 3, 10, 25],     # n_events：<=0→0.0, <=3→0.25, <=10→0.5, <=25→0.75, 其余→1.0
    "m_edges": [0, 3, 5, 7],       # spend_total(log1p)：<=0→0.0, <=3→0.25, <=5→0.5, <=7→0.75, 其余→1.0
    "weights": {"R": 0.40, "F": 0.35, "M": 0.25},
}
RULE_NOTE = ("R=recency_days分箱(越小越活跃), F=n_events分箱, M=spend_total(log1p)分箱；"
             "activity=R*wR+F*wF+M*wM（权重自动归一化）, churn_prob=1-activity；档位得分等步长 1/n")


def now_tag():
    return datetime.datetime.now().strftime("%Y%m%d_%H%M%S")


# ---------------------------------------------------------------------------
# 数据
# ---------------------------------------------------------------------------
def load(input_path=None):
    src = input_path or os.path.join(OUT, "features.csv")
    df = pd.read_csv(src)
    # LLM 校准标签优先：增强表含 y_aug 列时，用它替代脚本标签 y 作为训练监督信号
    if "y_aug" in df.columns:
        print(f"检测到 y_aug 列（LLM 校准标签，来自 features_augmented 流程），训练以 y_aug 为 y")
        df["y"] = df["y_aug"].astype(int)
    split_path = os.path.join(OUT, "split.json")
    if os.path.exists(split_path):
        split = json.load(open(split_path, encoding="utf-8"))
    else:
        # 真实数据接入时可能没有 split.json：自动按 70/15/15 分层生成（固定 seed 可复现）
        print("未找到 split.json，自动生成 70/15/15 随机分层切分（seed=20260831）")
        import random
        rng = random.Random(SEED)
        tr, va, te = [], [], []
        for y_val in (0, 1):
            uids = [u for u, yv in zip(df["uid"], df["y"]) if int(yv) == y_val]
            rng.shuffle(uids)
            n = len(uids)
            n_tr, n_va = int(n * 0.7), int(n * 0.15)
            tr += uids[:n_tr]; va += uids[n_tr:n_tr + n_va]; te += uids[n_tr + n_va:]
        split = {"train": tr, "valid": va, "test": te}
        json.dump(split, open(split_path, "w", encoding="utf-8"))
    return df, split


def build_sets(df, split):
    tr = df[df["uid"].isin(set(split["train"]))]
    va = df[df["uid"].isin(set(split["valid"]))]
    te = df[df["uid"].isin(set(split["test"]))]
    X = {k: v[FEATURE_NAMES].astype(float) for k, v in [("tr", tr), ("va", va), ("te", te)]}
    y = {k: v["y"].astype(int) for k, v in [("tr", tr), ("va", va), ("te", te)]}
    return X, y, (tr, va, te)


# ---------------------------------------------------------------------------
# 方法实现
# ---------------------------------------------------------------------------
def fit_method(method, X, y):
    """训练（rule 无训练）。返回 (model, 耗时秒)。"""
    t0 = time.time()
    if method == "xgboost":
        import inspect
        import xgboost as xgb
        init_kwargs = dict(
            n_estimators=300, max_depth=5, learning_rate=0.05,
            subsample=0.8, colsample_bytree=0.8, min_child_weight=3,
            # 正类=流失(1)：scale_pos_weight=负样本数/正样本数
            scale_pos_weight=(1 - y["tr"].mean()) / y["tr"].mean(),
            objective="binary:logistic", verbosity=0, random_state=SEED,
        )
        sig = inspect.signature(xgb.XGBClassifier.__init__).parameters
        if "early_stopping_rounds" in sig:      # xgboost >= 1.6
            init_kwargs["early_stopping_rounds"] = 30
            init_kwargs["eval_metric"] = "auc"
        if "use_label_encoder" in sig:          # xgboost < 2.0
            init_kwargs["use_label_encoder"] = False
        model = xgb.XGBClassifier(**init_kwargs)
        fit_kwargs = dict(eval_set=[(X["va"], y["va"])], verbose=False)
        if "early_stopping_rounds" in inspect.signature(model.fit).parameters:
            fit_kwargs["early_stopping_rounds"] = 30
        model.fit(X["tr"], y["tr"], **fit_kwargs)
    elif method == "lr":
        model = Pipeline([
            ("scaler", StandardScaler()),
            ("clf", LogisticRegression(max_iter=1000, class_weight="balanced",
                                       random_state=SEED)),
        ]).fit(X["tr"], y["tr"])
    elif method == "rf":
        model = RandomForestClassifier(
            n_estimators=300, max_depth=10, min_samples_leaf=5,
            class_weight="balanced", n_jobs=-1, random_state=SEED,
        ).fit(X["tr"], y["tr"])
    elif method == "rule":
        model = dict(RULE_PARAMS)   # 规则无训练，返回默认参数（调参版本由 sceneB_rfm_tuner.py 产出）
    else:
        raise ValueError(f"未知方法: {method}")
    return model, time.time() - t0


def rfm_tier(x, edges):
    """升序边界分箱档位：x<=edges[0]→0 … x>edges[-1]→n（共 n+1 档，边界值取左档）。"""
    return np.searchsorted(np.asarray(edges, dtype=float), x, side="left")


def rfm_score_params(X, params):
    """按参数对 RFM 打分（rule 方法唯一打分实现；默认参数 = RULE_PARAMS）。
    R 档位越高（越久未动）得分越低，F/M 档位越高得分越高，每档等步长 1/n；
    activity = wR*R + wF*F + wM*M（权重归一化），churn_prob = 1 - activity。"""
    n = (len(params["r_edges"]), len(params["f_edges"]), len(params["m_edges"]))
    w = params["weights"]
    tot = w["R"] + w["F"] + w["M"]
    R_ = 1.0 - rfm_tier(X["recency_days"].astype(float).values, params["r_edges"]) / n[0]
    F_ = rfm_tier(X["n_events"].astype(float).values, params["f_edges"]) / n[1]
    M_ = rfm_tier(X["spend_total"].astype(float).values, params["m_edges"]) / n[2]
    return 1.0 - (w["R"] * R_ + w["F"] * F_ + w["M"] * M_) / tot


def predict_proba(method, model, X):
    """统一打分入口。X 为含 FEATURE_NAMES 列的 DataFrame。"""
    if method == "rule":
        params = model if isinstance(model, dict) and "r_edges" in model else RULE_PARAMS
        return rfm_score_params(X, params)
    return model.predict_proba(X)[:, 1]


def feature_importance(method, model):
    """返回 [(特征, 重要性)]（rule 用分箱说明替代；lr 用 |系数|）。"""
    if method in ("xgboost", "rf"):
        return sorted(zip(FEATURE_NAMES, model.feature_importances_), key=lambda t: -t[1])
    if method == "lr":
        coef = model.named_steps["clf"].coef_[0]
        return sorted(zip(FEATURE_NAMES, abs(coef)), key=lambda t: -t[1])
    return [("RFM规则(R近行为0.4/F频次0.35/M金额0.25)", 1.0)]


# ---------------------------------------------------------------------------
# 模型保存 / 加载（版本化 + latest 指针）
# ---------------------------------------------------------------------------
def save_model(method, model, version, thresholds=None):
    """只保存模型文件（版本化）。不写上线指针——上线一律走 deploy_version()。"""
    ext = "joblib" if method in ("lr", "rf") else "json"
    path = os.path.join(MODEL_DIR, f"model_{version}.{ext}")
    if method == "xgboost":
        model.save_model(path)
    elif method in ("lr", "rf"):
        import joblib
        joblib.dump(model, path)
    elif method == "rule":
        with open(path, "w", encoding="utf-8") as f:
            json.dump({"method": "rule", "params": model if isinstance(model, dict) else RULE_PARAMS,
                       "note": RULE_NOTE,
                       "thresholds": list(thresholds or [CHURN_HIGH, CHURN_MID])},
                      f, ensure_ascii=False, indent=2)
    return path


def deploy_version(version):
    """显式上线：把指定版本写入 latest.json 指针（唯一改指针的入口；回滚同样用它）。"""
    method = next((m for m in METHODS if version == m or version.startswith(m + "_")), None)
    if not method:
        raise ValueError(f"版本号 {version} 无法解析出方法（前缀须为 {'/'.join(METHODS)}）")
    matches = [p for p in list_versions() if f"model_{version}." in os.path.basename(p)]
    if not matches:
        raise FileNotFoundError(f"未找到版本 {version} 的模型文件（output/model/ 下无 model_{version}.*）")
    prev = {}
    pointer_path = os.path.join(MODEL_DIR, "latest.json")
    if os.path.exists(pointer_path):
        prev = json.load(open(pointer_path, encoding="utf-8"))
    thresholds = [CHURN_HIGH, CHURN_MID]
    if method == "rule":
        # rule 版本自带调参阈值（sceneB_rfm_tuner.py 产出），上线时随指针带入供分档使用
        mdata = json.load(open(matches[0], encoding="utf-8"))
        if isinstance(mdata.get("thresholds"), list) and len(mdata["thresholds"]) == 2:
            thresholds = [float(t) for t in mdata["thresholds"]]
    meta = {
        "latest_version": version, "method": method, "path": matches[0],
        "feature_names": FEATURE_NAMES, "thresholds": thresholds,
        "as_of_date": datetime.datetime.now().isoformat(),
    }
    with open(pointer_path, "w", encoding="utf-8") as f:
        json.dump(meta, f, ensure_ascii=False, indent=2)
    print(f"上线指针已更新: {prev.get('latest_version', '(无)')} -> {version}（{METHOD_DESC[method]}）")
    if prev.get("method") and prev["method"] != method:
        print(f"  ⚠️ 方法切换: {prev['method']} -> {method}，历史版本仍在 output/model/ 可随时 --deploy 回滚")
    return pointer_path


def load_latest():
    """读 latest.json 指针，返回 (method, model)。rule 返回 (method, 调参参数dict|None)。"""
    meta = json.load(open(os.path.join(MODEL_DIR, "latest.json"), encoding="utf-8"))
    method, path = meta["method"], meta["path"]
    if method == "xgboost":
        import xgboost as xgb
        m = xgb.XGBClassifier()
        m.load_model(path)
        return method, m
    if method in ("lr", "rf"):
        import joblib
        return method, joblib.load(path)
    if method == "rule":
        with open(path, encoding="utf-8") as f:
            data = json.load(f)
        params = data.get("params")
        # 旧格式文件（仅文案 definition、无参数）或字段缺失时回退默认口径
        return method, params if isinstance(params, dict) and "r_edges" in params else None
    return method, None


def list_versions():
    return sorted(glob.glob(os.path.join(MODEL_DIR, "model_*.json")) +
                  glob.glob(os.path.join(MODEL_DIR, "model_*.joblib")))


# ---------------------------------------------------------------------------
# 评估 / 打标输出
# ---------------------------------------------------------------------------
def churn_label(prob, high=CHURN_HIGH, mid=CHURN_MID):
    if prob >= high:
        return "高危流失"
    if prob >= mid:
        return "中危流失"
    return "低危/稳定"


def evaluate(y_te, proba):
    auc = roc_auc_score(y_te, proba)
    pr_auc = average_precision_score(y_te, proba)
    pred = (proba >= 0.5).astype(int)
    cm = confusion_matrix(y_te, pred)
    return {"auc": float(auc), "pr_auc": float(pr_auc), "proba": proba, "pred": pred,
            "cm": cm, "positive_rate": float(y_te.mean())}


def write_labels(df_all, proba, version, thresholds=None, path=None):
    """全量打标：user_id + 概率 + 分档 + 版本(含方法) + 日期。thresholds=(高危,中危) 可覆盖默认分档。"""
    high, mid = thresholds if thresholds else (CHURN_HIGH, CHURN_MID)
    rows = []
    for uid, p in zip(df_all["uid"], proba):
        rows.append({
            "user_id": uid,
            "churn_prob": round(float(p), 4),
            "churn_label": churn_label(float(p), high, mid),
            "model_version": version,
            "as_of_date": datetime.datetime.now().date().isoformat(),
        })
    path = path or os.path.join(OUT, "sceneB_churn_labels.csv")
    with open(path, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=["user_id", "churn_prob", "churn_label",
                                          "model_version", "as_of_date"])
        w.writeheader()
        w.writerows(rows)
    return path


def write_eval(method, version, ev, y_te, imp):
    report = [f"场景B 流失预测 · 测试集评估报告（方法: {METHOD_DESC[method]}）", "=" * 55,
              f"模型版本: {version}",
              f"测试集样本: {len(y_te)}  真实流失率: {ev['positive_rate']:.1%}",
              f"AUC: {ev['auc']:.4f}   PR-AUC: {ev['pr_auc']:.4f}",
              "混淆矩阵 (阈0.5, 行=实际 列=预测):",
              f"  {ev['cm'][0][0]:<6}{ev['cm'][0][1]}",
              f"  {ev['cm'][1][0]:<6}{ev['cm'][1][1]}",
              "",
              "分类报告 (阈0.5):",
              classification_report(y_te, ev["pred"],
                                    target_names=["未流失(0)", "流失(1)"], digits=4),
              "Top10 特征重要性:" if method != "rule" else "评分卡权重:",
              *[f"  {name:<28}{v:.4f}" if method != "rule" else f"  {name:<28}{v}"
                for name, v in imp[:10]]]
    path = os.path.join(OUT, "sceneB_eval_report.txt")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(report))
    return path


def dist_summary(values, thresholds=None):
    """统计分档占比（输入为概率列表；thresholds=(高危,中危)，缺省用全局阈值）。"""
    from collections import Counter
    high, mid = thresholds if thresholds else (CHURN_HIGH, CHURN_MID)
    c = Counter(churn_label(float(p), high, mid) for p in values)
    n = sum(c.values())
    return f"高危{100*c.get('高危流失',0)/n:.1f}%/中危{100*c.get('中危流失',0)/n:.1f}%/低危{100*c.get('低危/稳定',0)/n:.1f}%"


# ---------------------------------------------------------------------------
# 主流程
# ---------------------------------------------------------------------------
def run_train(method, df, split, src=None, auto_deploy=False):
    X, y, _ = build_sets(df, split)
    version = f"{method}_{now_tag()}"
    print(f"[1/4] 数据: {src or 'output/features.csv'} | {len(df)} 行 × {len(FEATURE_NAMES)} 特征 | "
          f"方法: {METHOD_DESC[method]} | "
          f"切分 train={len(split['train'])} valid={len(split['valid'])} test={len(split['test'])}")
    print("[2/4] 训练 ...")
    model, dt = fit_method(method, X, y)
    print(f"   完成（{dt:.1f}s）" if method != "rule" else "   规则方法无训练过程")
    print("[3/4] 测试集评估 ...")
    ev = evaluate(y["te"], predict_proba(method, model, X["te"]))
    print(f"   AUC={ev['auc']:.4f}  PR-AUC={ev['pr_auc']:.4f}  真实流失率={ev['positive_rate']:.1%}")
    print("[4/4] 保存模型版本 + 全量打标 ...")
    mpath = save_model(method, model, version)
    lpath = write_labels(df, predict_proba(method, model, df[FEATURE_NAMES].astype(float)), version)
    epath = write_eval(method, version, ev, y["te"], feature_importance(method, model))
    print(f"  模型: {mpath}")
    print(f"  标签: {lpath}")
    print(f"  报告: {epath}")
    print(f"  历史版本数: {len(list_versions())}（重训自动新增版本、保留旧模型可回滚）")
    if auto_deploy:
        print("  （--deploy true：接下来把本版本写入上线指针）")
    else:
        print(f"  ⚠️ 该版本未上线（训练不改 latest.json）。上线: "
              f"python scripts/sceneB_model_router.py --deploy {version}")
    return version


def run_compare(df, split):
    X, y, _ = build_sets(df, split)
    print(f"四方法同台对比（同一测试集 {len(y['te'])} 条）\n" + "-" * 72)
    results = []
    for m in METHODS:
        model, dt = fit_method(m, X, y)
        proba_te = predict_proba(m, model, X["te"])
        auc = roc_auc_score(y["te"], proba_te)
        pr = average_precision_score(y["te"], proba_te)
        proba_all = predict_proba(m, model, df[FEATURE_NAMES].astype(float))
        version = f"{m}_{now_tag()}"
        save_model(m, model, version)
        write_labels(df, proba_all, version)
        os.replace(os.path.join(OUT, "sceneB_churn_labels.csv"),
                   os.path.join(OUT, f"sceneB_churn_labels_{m}.csv"))
        results.append((m, auc, pr, dt, proba_all, version))
        print(f"  {METHOD_DESC[m]:<26} AUC={auc:.4f}  PR-AUC={pr:.4f}  训练{dt:>6.1f}s  分档 {dist_summary(proba_all)}")
    best = max(results, key=lambda r: r[1])
    best_m, best_auc, best_ver = best[0], best[1], best[5]
    print("-" * 72)
    print(f"AUC 最优: {METHOD_DESC[best_m]} (AUC={best_auc:.4f})")
    print(f"  ⚠️ 对比只产出版本、不改上线指针。确认后上线最优方法: "
          f"python scripts/sceneB_model_router.py --deploy {best_ver}")
    # 对比报告落盘
    lines = ["场景B · 四方法同台对比（同一测试集）", "=" * 72,
             f"{'方法':<24}{'AUC':>8}{'PR-AUC':>9}{'训练耗时(s)':>12}   全量分档分布",
             *[f"{METHOD_DESC[m]:<24}{auc:>8.4f}{pr:>9.4f}{dt:>12.1f}   {dist_summary(p)}"
               for m, auc, pr, dt, p, _ in results],
             "",
             f"结论: AUC 最优 = {METHOD_DESC[best_m]}（版本 {best_ver}）。",
             "上线方式: python scripts/sceneB_model_router.py --deploy <版本号>（对比/训练均不自动改指针）。",
             "分档口径: 高危流失≥0.7 / 中危流失≥0.4 / 低危-稳定<0.4"]
    path = os.path.join(OUT, "sceneB_model_comparison.txt")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"  对比报告: {path}")


def run_predict(input_path):
    method, model = load_latest()
    meta = json.load(open(os.path.join(MODEL_DIR, "latest.json"), encoding="utf-8"))
    df = pd.read_csv(input_path)
    thresholds = meta.get("thresholds") or [CHURN_HIGH, CHURN_MID]
    print(f"打标模式（不训练）：方法={METHOD_DESC[method]} 版本={meta['latest_version']}")
    print(f"  输入: {input_path}（{len(df)} 行）  分档阈值: 高危≥{thresholds[0]} / 中危≥{thresholds[1]}")
    proba = predict_proba(method, model, df[meta["feature_names"]].astype(float))
    lpath = write_labels(df, proba, meta["latest_version"], thresholds=thresholds)
    print(f"  输出: {lpath}")
    print(f"  分档分布: {dist_summary(list(proba), thresholds)}")
    print("  （回滚方法：python scripts/sceneB_model_router.py --deploy 旧版本号 后重跑本命令）")


def main():
    ap = argparse.ArgumentParser(description="场景B 训练+打标路由程序")
    ap.add_argument("--model", choices=METHODS, default="xgboost", help="选择方法（默认 xgboost）")
    ap.add_argument("--mode", choices=["train", "predict"], default="train",
                    help="train=训练+评估+打标（只产新版本，不改指针）；predict=用 latest 指针模型打标（不训练）")
    ap.add_argument("--input", default=None,
                    help="指定特征宽表 CSV（train 模式=训练数据，含 y_aug 列时优先作 y；predict 模式=打标数据）")
    ap.add_argument("--compare", action="store_true", help="四方法同台对比（忽略 --model，不改上线指针；不支持 --deploy true）")
    ap.add_argument("--deploy", nargs="?", const="true", metavar="版本号|true", default=None,
                    help="显式上线（唯一改 latest.json 的入口）：传版本号=上线指定版本（如 rf_20260901_144143，回滚也用它）；"
                         "传 true=train 模式训练完成后立即上线刚训出的新版本（一步到位）。默认 false")
    args = ap.parse_args()

    # --deploy 双语义：版本号=上线指定版本（原有用法，立即执行并退出）；true=训练后上线刚训出的版本
    deploy_train = False
    if args.deploy is not None:
        val = str(args.deploy).strip().lower()
        if val in ("true", "1", "yes", "y"):
            deploy_train = True
        elif val in ("false", "0", "no", "n"):
            deploy_train = False      # 显式 false = 训练后不上线（与缺省等价）
        else:
            deploy_version(str(args.deploy).strip())   # 原有用法：上线指定版本号
            return

    if deploy_train and args.compare:
        raise SystemExit("❌ --compare 不支持 --deploy true：对比永远只产出版本、不改上线指针。"
                         "请先看对比报告 output/sceneB_model_comparison.txt，确认最优后单独 --deploy <版本号>")
    if deploy_train and args.mode == "predict":
        raise SystemExit("❌ --mode predict 不训练、无新版本可上线；--deploy true 仅配 train 模式（默认模式）使用")

    if args.mode == "predict":
        run_predict(args.input or os.path.join(OUT, "features.csv"))
        return

    df, split = load(args.input)
    if args.compare:
        run_compare(df, split)
    elif deploy_train:
        version = run_train(args.model, df, split, src=args.input, auto_deploy=True)
        print("\n[上线] --deploy true：把刚训练的版本写入上线指针 ...")
        deploy_version(version)
        print("  ✅ 下次 --mode predict 即使用新模型；回滚: python scripts/sceneB_model_router.py --deploy <旧版本号>")
    else:
        run_train(args.model, df, split, src=args.input)


if __name__ == "__main__":
    main()
