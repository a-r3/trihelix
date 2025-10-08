#!/usr/bin/env python3
import json, glob, datetime, os, statistics as stats

# Simple forecast: if health is high and loops are stable, push for tests & coverage
# else focus on stabilization. Then write modules/atlas/plans/forecast.json and append to ROADMAP.md

def read_health():
    try:
        return json.load(open(".helix/health.json"))
    except:
        return {"score": 0}

def read_metrics():
    try:
        return json.load(open(".helix/metrics.json"))
    except:
        return {"total_loops": 0, "ok_count": 0}

def forecast(health, metrics):
    score = health.get("score", 0)
    ok_ratio = (metrics.get("ok_count",0) / max(1, metrics.get("total_loops",1)))
    action = "harden" if score >= 85 and ok_ratio >= 0.9 else "stabilize"
    if action == "harden":
        goals = ["extend module tests", "raise coverage threshold +5%", "tighten policy guard"]
    else:
        goals = ["reduce noise logs", "improve observability", "add retries where needed"]
    return {"action": action, "goals": goals}

def main():
    os.makedirs("modules/atlas/plans", exist_ok=True)
    health = read_health()
    metrics = read_metrics()
    fc = forecast(health, metrics)
    ts = datetime.datetime.now().isoformat()
    sprint = "S-" + datetime.datetime.now().strftime("%Y%m%d")
    payload = {"ts": ts, "sprint": sprint, **fc, "inputs": {"health": health, "metrics": metrics}}
    json.dump(payload, open("modules/atlas/plans/forecast.json","w"), indent=2)
    # Append to ROADMAP.md
    with open("docs/ROADMAP.md","a",encoding="utf-8") as f:
        f.write(f"\n## Forecast @ {ts} ({sprint})\n")
        f.write(f"- Action: {fc['action']}\n")
        for g in fc["goals"]:
            f.write(f"- Goal: {g}\n")
    print("✅ forecast → modules/atlas/plans/forecast.json & docs/ROADMAP.md")

if __name__ == "__main__":
    main()
