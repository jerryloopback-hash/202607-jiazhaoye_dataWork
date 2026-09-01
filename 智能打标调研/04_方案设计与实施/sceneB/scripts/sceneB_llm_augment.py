# -*- coding: utf-8 -*-
"""
场景B · LLM 增强数据模块（pluggable + 离线 mock 回退）
=======================================================
用本地 LLM 对「脚本生成的样本」做**业务合理性增强**：
对部分样本，把 用户画像+观察窗行为摘要 交给 LLM，请它判断"未来30天是否流失"，
据此对标签 y 做**有业务语义的二次校准**，并输出一句可解释原因。

这样在"脚本数据"基础上叠加"LLM 业务常识"，兼顾可复现性与真实性——
这正是所选“脚本 + LLM 混合”数据路线的 LLM 一侧。

接线方式（pluggable）：
  1) 编辑 sceneB/config/llm_config.json：
       { "enabled": true, "base_url": "http://10.20.77.89:8888/v1",
         "model": "Qwen3.8-27B-UD-Q8_K_XL", "api_key": "...", "timeout": 120 }
     兼容 OpenAI /chat/completions 协议（本地 vLLM / Ollama / LM Studio / unsloth-studio 等均支持）。
  2) 运行：python sceneB_llm_augment.py
  - 当 enabled=false 或请求失败/超时时，自动回退到**启发式 mock 判定**（离线可运行、
    确定性、带 MOCK 标记），保证管线不因 LLM 不可用而中断。
  ⚠️ unsloth-studio 服务器需先加载模型（POST /v1/load 或网页开启 auto-switch），
     否则 chat/completions 会挂起——详见 环境安装指南.md §2。

输出：output/features_augmented.csv  —— 含 y_aug(LLM校准后)、llm_reason、llm_source(mock/llm)
说明：仅对 frac 比例的样本做 LLM 二次判定，其余保持脚本标签，控制增强幅度与成本。
"""
import os, json, csv, random, urllib.request

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CFG_PATH = os.path.join(BASE, "config", "llm_config.json")
SRC = os.path.join(BASE, "output", "features.csv")
DST = os.path.join(BASE, "output", "features_augmented.csv")

FRAC = 0.3      # 被 LLM 二次判定的样本比例（可用 config "frac" 覆盖）
SEED = 20260831

DEFAULT_CFG = {
    "enabled": False,                       # 默认离线；接好本地 LLM 后置 True
    "base_url": "http://127.0.0.1:8000/v1", # 本地 LLM OpenAI 兼容端点
    "model": "local-model",
    "api_key": "",
    "timeout": 120,
    "max_batch": 20,
}


def load_cfg():
    if os.path.exists(CFG_PATH):
        with open(CFG_PATH, encoding="utf-8") as f:
            cfg = json.load(f)
        merged = dict(DEFAULT_CFG)
        merged.update(cfg)
        return merged
    return dict(DEFAULT_CFG)


# ---------- LLM 调用（OpenAI /chat/completions 兼容） ----------
def llm_judge(cfg, profile):
    """调用本地 LLM 输出 纯JSON：{"churn":0|1,"reason":"..."}"""
    prompt = (
        "你是文体会所用户运营专家。根据以下用户画像与近180天行为摘要，"
        "判断其在未来30天内是否流失（30天内无任何消费/入场/活动行为视为流失）。"
        "只输出JSON：{\"churn\":0或1,\"reason\":\"一句中文理由\"}\n\n"
        "画像：" + profile
    )
    body = json.dumps({
        "model": cfg["model"],
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.2,
        "max_tokens": int(cfg.get("max_tokens", 300)),
    }).encode("utf-8")
    req = urllib.request.Request(
        cfg["base_url"] + "/chat/completions", data=body,
        headers={"Content-Type": "application/json",
                 "Authorization": f"Bearer {cfg['api_key']}"},
    )
    with urllib.request.urlopen(req, timeout=cfg["timeout"]) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    content = data["choices"][0]["message"]["content"]
    # 解析 JSON（容忍 <think> 推理段与代码块包裹）
    if "</think>" in content:
        content = content.split("</think>", 1)[1]
    content = content.strip()
    if content.startswith("```"):
        content = content.split("\n", 1)[1].rsplit("```", 1)[0]
    j = json.loads(content.strip())
    return int(j["churn"]), str(j.get("reason", ""))


# ---------- 启发式 mock（离线回退，确定性） ----------
def mock_judge(row):
    """基于观察窗行为特征的业务规则判定（仅供链路演示，非生产口径）。"""
    f = lambda k: float(row[k])                    # csv 读取为字符串，先转数值
    score = 0
    score += min(f("n_events"), 8) * 1.0           # 行为量越大越不易流失
    rec = f("recency_days")
    if rec >= 90: score += 0
    elif rec >= 30: score += 2
    elif rec >= 7:  score += 4
    else: score += 6
    if f("n_order") + f("n_swim") > 2: score += 1
    if f("login_num") >= 10: score += 1
    # score 越大越活跃 → 流失概率越低
    churn = 1 if score < 4 else 0
    reason = f"MOCK规则: 行为量={int(f('n_events'))} 最近行为距今={int(rec)}天 得分={score:.0f}"
    return churn, reason


def build_profile(row):
    return (f"性别={ {0:'未知',1:'男',2:'女'}.get(int(row['sex']),'?') }, "
            f"年龄={int(row['age'])}, 登录次数={int(row['login_num'])}, "
            f"近180天事件数={int(row['n_events'])}、近30天事件数={int(row['n_events_30d'])} "
            f"(订单{int(row['n_order'])}/游泳票{int(row['n_swim'])}/"
            f"活动{int(row['n_activity'])}/积分{int(row['n_points'])}/次卡{int(row['n_timecard'])}), "
            f"消费总额log1p={row['spend_total']}, 最近行为距今={int(row['recency_days'])}天, "
            f"行为多样性={row['behavior_diversity']}")


def main():
    cfg = load_cfg()
    rows = list(csv.DictReader(open(SRC, encoding="utf-8")))
    rng = random.Random(SEED)

    # 可选：仅对 frac 比例样本做 LLM 判定（比例可在 config 的 "frac" 配置，默认 0.3）
    frac = float(cfg.get("frac", FRAC))
    targets = rng.sample(range(len(rows)), int(len(rows) * frac)) if cfg["enabled"] else []
    llm_used = mock_used = 0

    for i, r in enumerate(rows):
        profile = build_profile(r)
        if i in targets:
            try:
                churn, reason = llm_judge(cfg, profile)
                src = "llm"
                llm_used += 1
            except Exception as e:  # 请求失败/解析失败 → 回退 mock
                churn, reason = mock_judge(r)
                reason += f" [llm失败回退: {type(e).__name__}]"
                src = "mock"
                mock_used += 1
        else:
            churn, reason = mock_judge(r)
            reason += " [keep-script]"
            src = "mock"
            mock_used += 1
        r["y_aug"] = int(churn)
        r["llm_reason"] = reason
        r["llm_source"] = src

    fieldnames = list(csv.DictReader(open(SRC, encoding="utf-8")).fieldnames) + \
                 ["y_aug", "llm_reason", "llm_source"]
    with open(DST, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for r in rows:
            w.writerow(r)

    print(f"LLM增强完成: {len(rows)} 样本 (frac={frac})")
    print(f"  写入: {DST}")
    print(f"  LLM判定={llm_used}  mock/保留={mock_used}  (enabled={cfg['enabled']})")
    if cfg["enabled"]:
        print(f"  本地LLM端点: {cfg['base_url']}  model={cfg['model']}")


if __name__ == "__main__":
    main()
