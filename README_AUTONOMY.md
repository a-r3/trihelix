# Quick Autonomy

```bash
# 1) Start background agent (every 2 minutes)
INTERVAL=120 bash scripts/agent-daemon.sh start

# 2) Generate predictive forecast
python3 scripts/predictive-planner.py

# 3) Rotate meta-learning snapshot (optional)
bash scripts/meta-snapshot.sh
```
Logs → `.helix/logs/agent-YYYYMMDD.log`, PID → `.helix/agent.pid`
