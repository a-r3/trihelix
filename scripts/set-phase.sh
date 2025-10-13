#!/usr/bin/env bash
set -euo pipefail
PHASE="${1:-Genesis}"
RANGE="${2:-0-20}"
FOCUS="${3:-Scaffold, context, memory, first loop prototype}"
tmp="$(mktemp)"
awk -v ph="$PHASE" -v rg="$RANGE" -v fc="$FOCUS" '
  BEGIN{inblk=0}
  /^current_phase:/ {print; inblk=1; getline; print "  name: " ph; getline; print "  range: " rg; getline; print "  focus: \"" fc "\""; 
                     while(getline>0){ if($0~/^ai_operating_rules:/){print; inblk=0; break} }
                     next}
  { if(!inblk) print }
' CONTEXT.yaml > "$tmp" && mv "$tmp" CONTEXT.yaml
echo "✅ Phase set → $PHASE ($RANGE)"
