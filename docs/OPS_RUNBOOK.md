# Ops Runbook — TriHelix

## Daily
- Check **trihelix-ci** workflow status
- Review new PRs from bot/helix-update
- Scan **docs/METRICS.md** and **.helix/health.json**

## When failures happen
1. Open workflow logs → identify failing step (health gate / policy)
2. Inspect **.helix/logs/** and **modules/diagno/reports/**
3. Apply quick wins (from **.helix/insights.json**)
4. Re-run `scripts/loop-run.sync.sh` locally and push

## Notifications
- Use **NOTIFY_WEBHOOK** secret to receive JSON events
- Or rely on GitHub PR notifications (assign, label, review)
