#!/usr/bin/env bash
set -euo pipefail
H=.helix/health.json
M=.helix/metrics.json
ok=1

age_hours() {
  f="$1"
  if [ ! -f "$f" ]; then echo 999999; return; fi
  now=$(date +%s); mt=$(stat -c %Y "$f" 2>/dev/null || echo "$now")
  echo $(( (now-mt)/3600 ))
}

# 1) metrics presence + freshness
if [ ! -f "$M" ]; then
  echo "❌ policy: metrics missing ($M)"; ok=0
else
  ah=$(age_hours "$M")
  if [ "$ah" -gt 24 ]; then echo "❌ policy: metrics too old (${ah}h)"; ok=0; fi
fi

# 2) health score threshold (branch-aware)
branch="${GITHUB_REF_NAME:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo dev)}"
min=70; [ "$branch" = "main" ] && min=85
if [ -f "$H" ]; then
  hs=$(jq -r '.score|tonumber' "$H" 2>/dev/null || echo 0)
  if [ "$hs" -lt "$min" ]; then
    echo "❌ policy: health<$min (got $hs) on $branch"; ok=0
  fi
else
  echo "❌ policy: health missing ($H)"; ok=0
fi

# 3) evolution baseline
if ! bash scripts/evolution-guard.sh >/dev/null; then
  echo "❌ policy: evolution baseline check failed"; ok=0
fi

# 4) tasks non-empty when HARDEN
if jq -e '.decision.action=="harden"' ./.helix/decision.json >/dev/null 2>&1; then
  if ! grep -q '\[ \]' docs/TASKS.md; then
    echo "❌ policy: harden selected but no open tasks"; ok=0
  fi
fi

if [ $ok -eq 1 ]; then
  echo "✅ policy guard: PASS"
else
  echo "❌ policy guard: FAIL"; exit 3
fi
