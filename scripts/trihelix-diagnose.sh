#!/usr/bin/env bash
set -euo pipefail

RED() { printf "%b\n" "\033[31m$*\033[0m"; }
GRN() { printf "%b\n" "\033[32m$*\033[0m"; }
YLW() { printf "%b\n" "\033[33m$*\033[0m"; }
BLU() { printf "%b\n" "\033[34m$*\033[0m"; }

ok=0; bad=0; warn=0
MARK_OK()   { ok=$((ok+1));   GRN "✅ $*"; }
MARK_BAD()  { bad=$((bad+1));  RED "❌ $*"; }
MARK_WARN() { warn=$((warn+1)); YLW "⚠️  $*"; }

have_jq=1
command -v jq >/dev/null 2>&1 || have_jq=0

[ -f CONTEXT.yaml ] || { MARK_BAD "CONTEXT.yaml tapılmadı (repo kök?)"; exit 1; }

phase=$(awk '/^current_phase:/{f=1;next} f && /name:/{print $2; exit}' CONTEXT.yaml 2>/dev/null || echo "UNKNOWN")
range=$(awk '/^current_phase:/{f=1;next} f && /range:/{print $2; exit}' CONTEXT.yaml 2>/dev/null || echo "UNKNOWN")
if [ -n "$phase" ]; then MARK_OK "CONTEXT: phase=$phase, range=$range"; else MARK_BAD "CONTEXT: phase oxunmadı"; fi

if [ -f .helix/state.json ]; then
  if [ $have_jq -eq 1 ]; then
    iter=$(jq -r '.iteration // 0' .helix/state.json)
    lst=$(jq -r '.last_loop.status // "n/a"' .helix/state.json)
  else
    iter=0; lst="n/a"
  fi
  MARK_OK "STATE: iteration=$iter, last_loop=$lst"
else
  MARK_BAD "STATE: .helix/state.json yoxdur"
fi

logs=$(find .helix/logs -maxdepth 1 -type f -name 'loop-*.json' 2>/dev/null | wc -l | tr -d ' ')
if [ "$logs" -ge 1 ]; then MARK_OK "LOGS: $logs loop log-u tapıldı"; else MARK_WARN "LOGS: loop log-u tapılmadı"; fi

if [ -f .helix/health.json ]; then
  hscore=$( [ $have_jq -eq 1 ] && jq -r '.score // 0' .helix/health.json || echo 0 )
  if [ "${hscore:-0}" -ge 75 ]; then MARK_OK "HEALTH: score=$hscore (>=75)"; else MARK_WARN "HEALTH: score=$hscore (<75)"; fi
else
  MARK_BAD "HEALTH: .helix/health.json yoxdur"
fi

if [ -f .helix/metrics.json ]; then
  loops_total=$( [ $have_jq -eq 1 ] && jq -r '.total_loops // 0' .helix/metrics.json || echo 0 )
  last_fin=$( [ $have_jq -eq 1 ] && jq -r '.last_finished_at // "n/a"' .helix/metrics.json || echo n/a )
  MARK_OK "METRICS: total_loops=$loops_total, last_finished_at=$last_fin"
else
  MARK_WARN "METRICS: .helix/metrics.json yoxdur (bash scripts/metrics.sh)"
fi

if bash scripts/policy-guard.sh >/tmp/policy.out 2>&1; then
  MARK_OK "POLICY: PASS"
else
  MARK_WARN "POLICY: FAIL — $(tail -n1 /tmp/policy.out)"
fi

[ -f modules/atlas/plans/plan.json ] && MARK_OK "ATLAS: plan.json mövcud" || MARK_WARN "ATLAS: plan.json yoxdur"
[ -f modules/genom/out/diff.json ] && MARK_OK "GENOM: out/diff.json mövcud" || MARK_WARN "GENOM: diff.json yoxdur"
[ -f modules/diagno/out/insights.json ] && MARK_OK "DIAGNO: insights.json mövcud" || MARK_WARN "DIAGNO: insights.json yoxdur"

[ -f .helix/insights.json ] && MARK_OK "INSIGHTS: .helix/insights.json var" || MARK_WARN "INSIGHTS: çatışmır"
[ -f .helix/decision.json ] && MARK_OK "DECISION: .helix/decision.json var" || MARK_WARN "DECISION: çatışmır"
[ -s docs/TASKS.md ] && MARK_OK "TASKS: docs/TASKS.md doludur" || MARK_WARN "TASKS: docs/TASKS.md boş/görünmür"

if [ -f .helix/bus/events.ndjson ]; then
  tail -n 3 .helix/bus/events.ndjson >/tmp/bus.tail 2>/dev/null || true
  if [ -s /tmp/bus.tail ]; then
    MARK_OK "BUS: events.ndjson aktiv (son 3 sətr aşağıda)"
    BLU "$(cat /tmp/bus.tail)"
  else
    MARK_WARN "BUS: events.ndjson boş"
  fi
else
  MARK_WARN "BUS: events.ndjson yoxdur"
fi

[ -f .github/workflows/trihelix-ci.yml ] && MARK_OK "CI: trihelix-ci.yml var" || MARK_WARN "CI: workflow yoxdur"
[ -f .github/workflows/release.yml ] && MARK_OK "RELEASE: release.yml var" || MARK_WARN "RELEASE: workflow yoxdur"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git remote -v | grep -q origin; then
    MARK_OK "GIT: origin təyin edilib ($(git remote get-url origin 2>/dev/null))"
  else
    MARK_WARN "GIT: origin təyin edilməyib"
  fi
else
  MARK_WARN "GIT: git repo deyil"
fi

if [ -f .helix/agent.pid ] && kill -0 "$(cat .helix/agent.pid)" 2>/dev/null; then
  MARK_OK "AGENT: running (pid=$(cat .helix/agent.pid))"
else
  MARK_WARN "AGENT: not running (opsional)"
fi

echo
echo "-----------------"
printf "Summary: %s OK, %s WARN, %s BAD\n" "$ok" "$warn" "$bad"
[ $bad -eq 0 ] || exit 1
