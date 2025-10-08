# Autonomous Helix (80→100)

**Goals**
- Background agent keeps the loop running.
- Predictive planning updates roadmap automatically.
- Meta-learning snapshots preserve long-term memory.

**Commands**
```bash
# Start/stop/status background agent (default interval 120s)
bash scripts/agent-daemon.sh start
bash scripts/agent-daemon.sh status
bash scripts/agent-daemon.sh stop

# Predictive planning (one-off)
python3 scripts/predictive-planner.py

# Rotate meta-learning snapshot
bash scripts/meta-snapshot.sh
```

**CI Example**
- Add `ci/helix-gate.yml` to your CI provider (GitHub Actions example).
- Health Gate will fail if score < 75 (configurable with MIN_HEALTH).
