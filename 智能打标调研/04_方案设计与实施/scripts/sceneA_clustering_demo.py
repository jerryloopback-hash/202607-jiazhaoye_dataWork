# -*- coding: utf-8 -*-
"""
场景 A · C 端会员消费行为分群（行为偏好簇）——智能打标 demo
=============================================================
定位：跑通完整「特征 → 清洗 → 降维 → 聚类 → 选K → 簇画像 → 命名打标 → 可视化」链路，
作为「框架 / 流程」示范，不追求标签质量。

测试库数据质量极差（性别/年龄几乎全空、订单/活动/积分覆盖极低），因此：
  - 真实可用的字段（login_num、有订单用户的订单聚合、活动参与数、积分）照常从库抽取；
  - 缺失/无效字段用「带固定 seed 的随机模型」补齐，保证可复现、可评审、可演示。
每个特征标  real(真实) / simulated(模拟) 来源，输出质量报告。

用法：python sceneA_clustering_demo.py
产物：output/ 下 CSV + 图片 + 报告
"""
import os, math
import numpy as np
import pandas as pd
import pymysql
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from sklearn.impute import SimpleImputer
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
# 中文字体（避免图内中文乱码）
plt.rcParams["font.sans-serif"] = ["Microsoft YaHei", "SimHei", "DejaVu Sans"]
plt.rcParams["axes.unicode_minus"] = False

# ------------------------- 0. 配置 -------------------------
DB = dict(host="192.168.112.101", port=3306, user="readonly_jnl",
          password="Rjnl@20250101", charset="utf8mb4")
BASE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(os.path.dirname(BASE), "output")   # 04_方案设计与实施/output
os.makedirs(OUT, exist_ok=True)
SEED = 2026
rng = np.random.default_rng(SEED)   # 固定种子，全流程可复现

FEATURES = ["age", "sex", "login_num", "order_cnt", "total_spend",
            "activity_cnt", "points_balance", "recency_days"]

# ------------------------- 1. 取数（真实抽取） -------------------------
def fetch(sql):
    conn = pymysql.connect(**DB)
    try:
        return pd.read_sql(sql, conn)
    finally:
        conn.close()

def load_real_data():
    """从 jianengliang 库抽取真实可用字段。"""
    members = fetch("SELECT id, age, sex, login_num, last_login_time FROM jianengliang.j_member")
    members["login_num"] = pd.to_numeric(members["login_num"], errors="coerce").fillna(0)

    # 订单聚合（少数用户有）
    orders = fetch("""SELECT user_id,
                             COUNT(*) AS order_cnt,
                             SUM(pay_amount) AS total_spend
                      FROM jianengliang.j_member_order
                      GROUP BY user_id""")
    # 活动参与数（极少）
    act = fetch("SELECT user_id, COUNT(*) AS activity_cnt FROM jianengliang.j_platform_activity_person GROUP BY user_id")
    # 积分（极少）；关联键为 member_id
    pts = fetch("""SELECT member_id AS user_id, SUM(IF(points IS NULL,0,points)) AS points_balance
                   FROM jianengliang.j_points_records GROUP BY member_id""")

    df = members.rename(columns={"id": "user_id"})
    df = df.merge(orders, on="user_id", how="left")
    df = df.merge(act,   on="user_id", how="left")
    df = df.merge(pts,   on="user_id", how="left")
    df["order_cnt"]     = df["order_cnt"].fillna(0)
    df["total_spend"]   = df["total_spend"].fillna(0)
    df["activity_cnt"]  = df["activity_cnt"].fillna(0)
    df["points_balance"]= df["points_balance"].fillna(0)

    # 距今天数（最近一次登录）；null 时后续模拟
    ref = pd.Timestamp.now().normalize()
    llt = pd.to_datetime(df["last_login_time"], errors="coerce")
    df["recency_days"] = (ref - llt).dt.days
    df.loc[df["recency_days"] < 0, "recency_days"] = np.nan
    return df

# ------------------------- 2. 缺失/无效字段模拟（真实模型，固定 seed） -------------------------
def simulate(df):
    """对缺失/无效字段用带注释的随机模型补齐，并记录每列真实/模拟来源。"""
    src = {}
    for f in FEATURES:
        src[f] = set()

    n = len(df)
    # age：真实有效值很少 → 截断正态模拟
    valid_age = (df["age"].notna()) & (df["age"] >= 6) & (df["age"] <= 80)
    df.loc[valid_age, "age"] = df.loc[valid_age, "age"].astype(float)
    miss = ~valid_age
    df.loc[miss, "age"] = np.clip(rng.normal(32, 12, miss.sum()), 6, 80).round(0)
    src["age"] |= {"real"} if valid_age.sum() else set()
    if miss.sum(): src["age"] |= {"simulated"}

    # sex：0=不明 → 模拟为 男/女/未知 类别
    s = df["sex"].fillna(0).astype(int)
    df["sex"] = np.select([s == 1, s == 2], [1, 2], 0)
    miss_sex = s == 0
    r = rng.random(miss_sex.sum())
    m = (r < 0.45).astype(int) * 1 + ((r >= 0.55) & (r < 0.9)).astype(int) * 2
    df.loc[miss_sex, "sex"] = m
    src["sex"] |= {"real"} if (s != 0).sum() else set()
    if miss_sex.sum(): src["sex"] |= {"simulated"}

    # login_num：真实可用，但长度为0视为低活跃；保留真实（含0）
    df["login_num"] = df["login_num"].astype(float)
    src["login_num"] = {"real"}

    # order_cnt：真实覆盖极低；多数为0，少数按幂律模拟出"高频少数"
    no_ord = df["order_cnt"] == 0
    df.loc[no_ord, "order_cnt"] = rng.zipf(2.2, no_ord.sum()) - 1
    df["order_cnt"] = df["order_cnt"].clip(lower=0)
    src["order_cnt"] |= {"real"} if (~no_ord).sum() else set()
    if no_ord.sum(): src["order_cnt"] |= {"simulated"}

    # total_spend：对数正态模拟（约与订单数挂钩，增强簇可分）
    spend_exp = df["total_spend"].replace(0, np.nan)
    has = df["total_spend"] > 0
    df["total_spend"] = df["total_spend"].astype(float)
    no_sp = ~has
    base = np.clip(rng.lognormal(5.5, 1.0, no_sp.sum()), 1, 1e5)
    df.loc[no_sp, "total_spend"] = base * (df.loc[no_sp, "order_cnt"] + 1) ** 0.5
    src["total_spend"] |= {"real"} if has.sum() else set()
    if no_sp.sum(): src["total_spend"] |= {"simulated"}

    # activity_cnt：零膨胀泊松（多数0，少数互动型）
    no_act = df["activity_cnt"] == 0
    poiss = rng.poisson(3, no_act.sum())
    df.loc[no_act, "activity_cnt"] = poiss * (rng.random(no_act.sum()) < 0.20)
    src["activity_cnt"] |= {"real"} if (~no_act).sum() else set()
    if no_act.sum(): src["activity_cnt"] |= {"simulated"}

    # points_balance：对数正态/0
    no_pts = df["points_balance"] == 0
    df.loc[no_pts, "points_balance"] = np.where(
        rng.random(no_pts.sum()) < 0.5, 0, rng.lognormal(5.5, 1.2, no_pts.sum()).round(0))
    src["points_balance"] |= {"real"} if (~no_pts).sum() else set()
    if no_pts.sum(): src["points_balance"] |= {"simulated"}

    # recency_days：指数分布模拟（多数近期有活动）
    no_rec = df["recency_days"].isna()
    df.loc[no_rec, "recency_days"] = rng.exponential(25, no_rec.sum()).round(0).clip(0, 400)
    src["recency_days"] |= {"real"} if (~no_rec).sum() else set()
    if no_rec.sum(): src["recency_days"] |= {"simulated"}

    df["sex"] = df["sex"].astype(int)
    return df, {f: " + ".join(sorted(v)) for f, v in src.items()}

# ------------------------- 3. 清洗变换 -------------------------
def preprocess(df):
    X = df[FEATURES].copy()
    X["total_spend"] = np.log1p(X["total_spend"])      # log压缩长尾
    X["points_balance"] = np.log1p(X["points_balance"])
    X["login_num"] = np.log1p(X["login_num"])
    X["order_cnt"] = np.log1p(X["order_cnt"])
    X["recency_days"] = np.log1p(X["recency_days"])
    imp = SimpleImputer(strategy="median")             # 兜底
    X = pd.DataFrame(imp.fit_transform(X), columns=FEATURES, index=df.index)
    scaler = StandardScaler()                          # 标准化
    Xs = scaler.fit_transform(X)
    return Xs, X, scaler

# ------------------------- 4. 降维 + 聚类 + 选 K -------------------------
def cluster(Xs):
    pca = PCA(n_components=2, random_state=SEED)
    X2 = pca.fit_transform(Xs)
    evr = pca.explained_variance_ratio_.sum()
    best_k, best_s = 2, -1
    sil_scores = {}
    for k in range(2, 11):
        km = KMeans(n_clusters=k, n_init=20, random_state=SEED).fit(Xs)
        s = silhouette_score(Xs, km.labels_)
        sil_scores[k] = s
        if s > best_s:
            best_s, best_k = s, k
    km = KMeans(n_clusters=best_k, n_init=20, random_state=SEED).fit(Xs)
    return km, X2, best_k, best_s, pca, sil_scores, evr

# ------------------------- 5. 簇画像与命名 -------------------------
def name_clusters(km, X_orig, df):
    med = X_orig.assign(_cluster=km.labels_).groupby("_cluster").median()
    order_count = X_orig.assign(_c=km.labels_)["order_cnt"]

    names = {}
    for c in sorted(med.index):
        row = med.loc[c]
        tags = []
        if row["order_cnt"] >= X_orig["order_cnt"].quantile(0.8):
            tags.append("高频消费")
        if row["total_spend"] >= X_orig["total_spend"].quantile(0.8):
            tags.append("消费力强")
        if row["activity_cnt"] >= X_orig["activity_cnt"].quantile(0.8):
            tags.append("活动互动")
        if row["recency_days"] >= X_orig["recency_days"].quantile(0.8):
            tags.append("沉睡/回流")
        if row["login_num"] >= X_orig["login_num"].quantile(0.8):
            tags.append("高活跃")
        if not tags:
            tags.append("普通型")
        names[c] = "/".join(tags)
    return names

def profile_table(km, X_orig, df, names):
    tab = X_orig.assign(cluster=km.labels_).copy()
    tab["user_id"] = df["user_id"].values
    tab["cluster_name"] = tab["cluster"].map(names)
    return tab

# ------------------------- 6. 可视化 + 输出 -------------------------
def viz(X2, km, names, out):
    fig, ax = plt.subplots(figsize=(8, 6))
    for c in sorted(set(km.labels_)):
        mask = km.labels_ == c
        ax.scatter(X2[mask, 0], X2[mask, 1], s=8, alpha=0.6, label=f"{c}: {names[c]}")
    ax.set_title("场景A 行为偏好簇 · PCA 2D 分布（K-means, K=%d）" % (len(set(km.labels_))))
    ax.set_xlabel("PC1"); ax.set_ylabel("PC2"); ax.legend(fontsize=7)
    fig.tight_layout()
    fig.savefig(out, dpi=120); plt.close(fig)

def main():
    print("[1/6] 取数(真实)...")
    real = load_real_data()
    df = real.copy()   # 保留 user_id 及全部真实特征列，缺失部分交给 simulate 补齐

    print("[2/6] 缺失/无效字段模拟(固定seed=2026)...")
    df, src = simulate(df)

    print("   特征来源:", src)

    print("[3/6] 清洗变换(log1p + StandardScaler)...")
    Xs, X_orig, scaler = preprocess(df)

    print("[4/6] PCA降维 + K-means + 轮廓系数选K...")
    km, X2, best_k, best_s, pca, sil_scores, evr = cluster(Xs)
    print(f"   K={best_k} 轮廓系数={best_s:.3f}  PCA前两维解释方差={evr:.2%}")

    print("[5/6] 簇画像 + 命名...")
    names = name_clusters(km, X_orig, df)
    print("   各簇标签:", names)

    print("[6/6] 输出...")
    tab = profile_table(km, X_orig, df, names)
    # 脱敏输出：只输出 user_id(内部id) + 标签，不含手机号/身份证
    out_label = pd.DataFrame({"user_id": df["user_id"], "cluster": km.labels_,
                              "cluster_name": tab["cluster_name"].values})

    lab_path = os.path.join(OUT, "sceneA_behavior_labels.csv")
    tab_path = os.path.join(OUT, "sceneA_feature_cluster_profiles.csv")
    # 简化输出：标签表
    out_label.to_csv(lab_path, index=False, encoding="utf-8-sig")
    viz(X2, km, names, os.path.join(OUT, "sceneA_pca_clusters.png"))

    # 簇画像（原始尺度中位数）
    prof = X_orig.assign(cluster=km.labels_, cluster_name=tab["cluster_name"].values) \
                 .groupby(["cluster","cluster_name"]).median().round(2)
    prof.to_csv(tab_path, encoding="utf-8-sig")

    # 质量报告
    lines = [
        "场景A 打标模拟 · 质量/来源报告",
        "========================================",
        f"用户数: {len(df)}   K={best_k}  silhouette={best_s:.3f}",
        f"PCA前2维累计解释方差: {evr:.2%}",
        "特征来源(real真实/simulated模拟):",
        *[f"  {k}: {v}" for k, v in src.items()],
        "每簇人数:",
        *[f"  {c}: {(km.labels_==c).sum()} ({names[c]})" for c in sorted(set(km.labels_))],
        "",
        "注: 测试库数据质量差，缺失/无效特征由固定种子随机模型模拟；",
        "分群结果仅证明‘特征→算法→标签’链路可运行，不代表真实业务人群。",
    ]
    with open(os.path.join(OUT, "sceneA_quality_report.txt"), "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print("\n".join(lines))
    print("\n产物已写入:", OUT)

if __name__ == "__main__":
    main()
