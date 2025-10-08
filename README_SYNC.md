# Synchronizer Phase (20→40) — Quick Start

```bash
# 0) Ensure executable
chmod +x scripts/*.sh modules/*/bin/*.sh

# 1) Run one synchronized loop (bus + modules + telemetry)
bash scripts/loop-run.sync.sh

# 2) Update metrics
bash scripts/metrics.sh

# 3) Optional: start scheduler (Ctrl+C to stop)
INTERVAL=60 MAX_RETRY=3 bash scripts/scheduler.sh
```

Artifacts:
- Bus stream: `.helix/bus/events.ndjson`
- Metrics: `.helix/metrics.json`, `docs/METRICS.md`
- Module outputs: `modules/*/out`, `modules/diagno/reports`, `code/HELLO.txt`
