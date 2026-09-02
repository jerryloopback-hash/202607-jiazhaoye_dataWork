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
  - enabled=false：全量走确定性启发式 mock（离线可运行），保证管线演示不依赖 LLM；
  - enabled=true：**strict 模式**——先预检端点，端点不可用或中途失败立即中止、不写输出
    （杜绝"跑完全程实为 mock"的假增强产物）；每条成功即写入断点缓存
    output/.llm_augment_cache.jsonl，重跑自动续传；每条失败自动重试 1 次。
  ⚠️ unsloth-studio 服务器需先加载模型（POST /v1/load 或网页开启 auto-switch），
     否则 chat/completions 会挂起——详见 环境安装指南.md §2。

输出：output/features_augmented.csv  —— 含 y_aug(LLM校准后)、llm_reason、llm_source(mock/llm)
说明：仅对 frac 比例的样本做 LLM 二次判定，其余保持脚本标签，控制增强幅度与成本。
"""
import os, json, csv, time, random, urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CFG_PATH = os.path.join(BASE, "config", "llm_config.json")
SRC = os.path.join(BASE, "output", "features.csv")
DST = os.path.join(BASE, "output", "features_augmented.csv")
CACHE_PATH = os.path.join(BASE, "output", ".llm_augment_cache.jsonl")   # 断点续传缓存（成功一条记一条）

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
        # 关闭 qwen3 thinking/reasoning，缩短生成时间（unsloth/vLLM 兼容写法；
        # 服务器不识别该字段时会忽略，此时靠下方 </think> 剥离兜底）
        "chat_template_kwargs": {"enable_thinking": bool(cfg.get("enable_thinking", False))},
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
    target_set = set(targets)
    llm_used = mock_used = 0

    # 非目标行：
    #   enabled=true  → 保持脚本标签 y（LLM 只校准 frac 比例样本，其余不动——与文档口径一致；
    #                    2026-09-02 修复：此前误把全部非目标行改写成 mock 规则标签，
    #                    会导致训练目标≈规则函数、四方法对比失真）
    #   enabled=false → 全量 mock 规则演示（离线模式）
    for i, r in enumerate(rows):
        if i not in target_set:
            if cfg["enabled"]:
                r["y_aug"] = int(float(r["y"]))
                r["llm_reason"] = "保持脚本标签"
                r["llm_source"] = "script"
            else:
                churn, reason = mock_judge(r)
                r["y_aug"] = int(churn)
                r["llm_reason"] = reason
                r["llm_source"] = "mock"
            mock_used += 1

    if targets:
        # 断点缓存：上次已成功判定的样本直接复用（uid 校验防错位），重跑自动续传
        done = {}
        if os.path.exists(CACHE_PATH):
            with open(CACHE_PATH, encoding="utf-8") as cf:
                for line in cf:
                    try:
                        d = json.loads(line)
                        i = int(d["i"])
                        if 0 <= i < len(rows) and rows[i]["uid"] == str(d["uid"]):
                            done[i] = (int(d["churn"]), str(d["reason"]))
                    except Exception:
                        continue
        for i in targets:
            if i in done:
                churn, reason = done[i]
                rows[i]["y_aug"] = churn
                rows[i]["llm_reason"] = reason
                rows[i]["llm_source"] = "llm"
                llm_used += 1
        todo = [i for i in targets if rows[i].get("llm_source") != "llm"]
        print(f"LLM 判定: 目标 {len(targets)} 条 | 缓存命中 {len(targets) - len(todo)} | 待请求 {len(todo)}")

        def call_llm_strict(i):
            """单条 LLM 判定，失败重试 1 次；仍失败则抛出。
            enabled=true 时为 strict 模式：不做 mock 回退（保证输出全部来自真实 LLM），
            每条成功即追加缓存，中断后重跑续传。"""
            last_err = None
            for _ in range(2):
                try:
                    churn, reason = llm_judge(cfg, build_profile(rows[i]))
                    with open(CACHE_PATH, "a", encoding="utf-8") as cf:
                        cf.write(json.dumps({"i": i, "uid": rows[i]["uid"],
                                             "churn": churn, "reason": reason},
                                            ensure_ascii=False) + "\n")
                    return i, churn, reason
                except Exception as e:
                    last_err = e
                    time.sleep(2)
            raise last_err

        if todo:
            try:
                i0, c0, r0 = call_llm_strict(todo[0])   # 预检：端点不可用立刻中止，不写输出
            except Exception as e:
                raise SystemExit(f"LLM 预检失败（{type(e).__name__}: {e}）。本次增强中止、未写输出；"
                                 f"已缓存 {llm_used}/{len(targets)} 条，端点恢复后重跑自动续传。")
            rows[i0]["y_aug"] = c0
            rows[i0]["llm_reason"] = r0
            rows[i0]["llm_source"] = "llm"
            llm_used += 1

            workers = max(1, int(cfg.get("concurrency", 4)))
            with ThreadPoolExecutor(max_workers=workers) as pool:
                futs = {pool.submit(call_llm_strict, i): i for i in todo[1:]}
                ok = 0
                try:
                    for fut in as_completed(futs):
                        i, churn, reason = fut.result()
                        rows[i]["y_aug"] = churn
                        rows[i]["llm_reason"] = reason
                        rows[i]["llm_source"] = "llm"
                        llm_used += 1
                        ok += 1
                        if ok % 25 == 0:
                            print(f"  进度 {ok}/{len(todo) - 1}")
                except Exception as e:
                    for f in futs:
                        f.cancel()
                    raise SystemExit(f"LLM 判定中途失败（{type(e).__name__}: {e}）。本次增强中止、未写输出；"
                                     f"已缓存 {llm_used}/{len(targets)} 条，端点恢复后重跑自动续传。")

        # 纯度校验：目标样本必须全部来自真实 LLM 才允许写输出
        bad = [i for i in targets if rows[i].get("llm_source") != "llm"]
        if bad:
            raise SystemExit(f"存在 {len(bad)} 条非 LLM 判定的目标样本（异常状态），中止不写输出。")

    fieldnames = list(csv.DictReader(open(SRC, encoding="utf-8")).fieldnames) + \
                 ["y_aug", "llm_reason", "llm_source"]
    with open(DST, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for r in rows:
            w.writerow(r)

    print(f"LLM增强完成: {len(rows)} 样本 (frac={frac})")
    print(f"  写入: {DST}")
    from collections import Counter
    src_stat = Counter(r["llm_source"] for r in rows)
    print(f"  判定来源: LLM={src_stat.get('llm',0)}  脚本标签={src_stat.get('script',0)}  mock={src_stat.get('mock',0)}  (enabled={cfg['enabled']})")
    if cfg["enabled"]:
        agree = sum(1 for r in rows
                    if r["llm_source"] == "llm" and int(r["y_aug"]) == int(float(r["y"])))
        n_llm = src_stat.get("llm", 0)
        if n_llm:
            print(f"  LLM 与脚本标签一致率: {agree}/{n_llm} = {100*agree/n_llm:.1f}%（LLM 校准幅度参考）")
        print(f"  本地LLM端点: {cfg['base_url']}  model={cfg['model']}")


if __name__ == "__main__":
    main()
