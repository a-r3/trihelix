#!/usr/bin/env bash
set -euo pipefail

RED() { printf "\033[31m$*\033[0m\n"; }
GRN() { printf "\033[32m$*\033[0m\n"; }
YLW() { printf "\033[33m$*\033[0m\n"; }
BLU() { printf "\033[34m$*\033[0m\n"; }

ok=0; bad=0; warn=0
MARK_OK()   { ok=$((ok+1));   GRN "✅ $*"; }
MARK_BAD()  { bad=$((bad+1));  RED "❌ $*"; }
MARK_WARN() { warn=$((warn+1)); YLW "⚠️  $*"; }

have_jq=1
command -v jq >/dev/null 2>&1 || have_jq=0

# --- 0) Repo kökü?
[ -f CONTEXT.yaml ] || { MARK_BAD "CONTEXT.yaml tapılmadı (repo kökündə deyilsən?)"; exit 1; }

# --- 1) Context (phase) oxu
phase=$(awk '/^current_phase:/{f=1;next} f && /name:/{print $2; exit}' CONTEXT.yaml 2>/dev/null || echo "UNKNOWN")
range=$(awk '/^current_phase:/{f=1;next} f && /range:/{print $2; exit}' CONTEXT.yaml 2>/dev/null || echo "UNKNOWN")
[ -n "$phase" ] && MARK_OK "CONTEXT: phase=$phase, range=$range" || MARK_BAD "CONTEXT: phase oxunmadı"

# --- 2) State & loop sayğacı
if [ -f .helix/state.json ]; then
  if [ $have_jq -eq 1 ]; then
    iter=$(jq -r '.iteration // 0' .helix/state.json)
    lst=$(jq -r '.last_loop.status // "n/a"' .helix/state.json)
  else
    iter=$(python3 - <<'PY' .helix/state.json 2>/dev/null || echo 0
import json,sys;print(json.load(open(sys.argv[1])).get("iteration",0))
PY
)
    lst="n/a"
  fi
  MARK_OK "STATE: iteration=$iter, last_loop=$lst"
else
  MARK_BAD "STATE: .helix/state.json yoxdur"
fi

# --- 3) Loop log-ları
logs=$(ls -1 .helix/logs/loop-*.json 2>/dev/null | wc -l | tr -d ' ')
[ "$logs" -ge 1 ] && MARK_OK "LOGS: $logs loop log-u tapıldı" || MARK_WARN "LOGS: loop log-u tapılmadı"

# --- 4) Health score
if [ -f .helix/health.json ]; then
  if [ $have_jq -eq 1 ]; then
    hscore=$(jq -r '.score // 0' .helix/health.json)
  else
    hscore=$(python3 - <<'PY' .helix/health.json 2>/dev/null || echo 0
import json,sys;print(json.load(open(sys.argv[1])).get("score",0))
PY
)
  fi
  if [ "${hscore:-0}" -ge 75 ]; then
    MARK_OK "HEALTH: score=$hscore (>=75)"
  else
    MARK_WARN "HEALTH: score=$hscore (<75)"
  fi
else
  MARK_BAD "HEALTH: .helix/health.json yoxdur"
fi

# --- 5) Metrics
if [ -f .helix/metrics.json ]; then
  if [ $have_jq -eq 1 ]; then
    loops_total=$(jq -r '.total_loops // 0' .helix/metrics.json)
    last_fin=$(jq -r '.last_finished_at // "n/a"' .helix/metrics.json)
  else
    loops_total=$(grep -o '"total_loops":[^,]*' .helix/metrics.json | head -n1 | cut -d: -f2 | tr -d ' ' || echo 0)
    last_fin="n/a"
  fi
  MARK_OK "METRICS: total_loops=$loops_total, last_finished_at=$last_fin"
else
  MARK_WARN "METRICS: .helix/metrics.json yoxdur (bash scripts/metrics.sh)"
fi

# --- 6) Policy guard (yüngül yoxlama)
if [ -f scripts/policy-guard.sh ]; then
  if bash scripts/policy-guard.sh >/tmp/policy.out 2>&1; then
    MARK_OK "POLICY: PASS"
  else
    MARK_WARN "POLICY: FAIL — $(tail -n1 /tmp/policy.out)"
  fi
else
  MARK_WARN "POLICY: scripts/policy-guard.sh yoxdur"
fi

# --- 7) Modulların çıxışları
[ -f modules/atlas/plans/plan.json ] && MARK_OK "ATLAS: plan.json mövcud" || MARK_WARN "ATLAS: plan.json yoxdur"
[ -f modules/genom/out/diff.json ] && MARK_OK "GENOM: out/diff.json mövcud" || MARK_WARN "GENOM: diff.json yoxdur"
[ -f modules/diagno/out/insights.json ] && MARK_OK "DIAGNO: insights.json mövcud" || MARK_WARN "DIAGNO: insights.json yoxdur"

# --- 8) Cognitive artefaktlar
[ -f .helix/insights.json ] && MARK_OK "INSIGHTS: .helix/insights.json var" || MARK_WARN "INSIGHTS: çatışmır"
[ -f .helix/decision.json ] && MARK_OK "DECISION: .helix/decision.json var" || MARK_WARN "DECISION: çatışmır"
[ -s docs/TASKS.md ] && MARK_OK "TASKS: docs/TASKS.md doludur" || MARK_WARN "TASKS: docs/TASKS.md boş/görünmür"

# --- 9) Bus stream
[ -f .helix/bus/events.ndjson ] && tail -n 3 .helix/bus/events.ndjson >/tmp/bus.tail 2>/dev/null || true
if [ -s /tmp/bus.tail ]; then
  MARK_OK "BUS: events.ndjson aktiv (son 3 sətr aşağıda)"
  BLU "$(cat /tmp/bus.tail)"
else
  MARK_WARN "BUS: events.ndjson boş və ya yoxdur"
fi

# --- 10) CI & Release faylları
[ -f .github/workflows/trihelix-ci.yml ] && MARK_OK "CI: trihelix-ci.yml var" || MARK_WARN "CI: workflow yoxdur"
[ -f .github/workflows/release.yml ] && MARK_OK "RELEASE: release.yml var" || MARK_WARN "RELEASE: workflow yoxdur"

# --- 11) Git remote
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git remote -v | grep -q origin; then
    MARK_OK "GIT: origin təyin edilib ($(git remote get-url origin 2>/dev/null))"
  else
    MARK_WARN "GIT: origin təyin edilməyib"
  fi
else
  MARK_WARN "GIT: git repo deyil"
fi

# --- 12) Agent status
if [ -f .helix/agent.pid ]; then
  pid=$(cat .helix/agent.pid 2>/dev/null || echo "")
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    MARK_OK "AGENT: running (pid=$pid)"
  else
    MARK_WARN "AGENT: pid var, amma proses işləmir"
  fi
else
  MARK_WARN "AGENT: agent.pid yoxdur (opsional)"
fi

echo
echo "-----------------"
echo "Summary: $(GRN $ok OK), $(YLW $warn WARN), $(RED $bad BAD)"
[ $bad -eq 0 ] || exit 1
