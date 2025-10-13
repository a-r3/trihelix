#!/usr/bin/env bash
# TriHelix — Policy Guard
# Məqsəd: Layihənin sağlamlıq, siyasət və struktur qaydalarını yoxlamaq.
# Nəticə: PASS → 0, əks halda FAIL → 3

set -euo pipefail

echo "🔍 policy guard: starting…"

ok=1

# 1) Əsas fayllar yoxlanışı
for f in CONTEXT.yaml docs/TASKS.md modules/atlas/plans/plan.json modules/diagno/reports/report.json; do
  if [ ! -s "$f" ]; then
    echo "❌ policy: missing required file $f"
    ok=0
  fi
done

# 2) Safe Mode marker varsa xəbərdarlıq
if [ -f PROJECT_ROOT_MARKER ] || [ "${SAFE_MODE:-0}" = "1" ]; then
  echo "🛡️  Safe Mode aktivdir (kod yazılışları bloklanıb)"
fi

# 3) TASKS.md-də EP blokları olmalıdır
if ! grep -q "<!-- BEGIN:EP_IMPORT_META -->" docs/TASKS.md 2>/dev/null; then
  echo "❌ policy: META EP blok yoxdur (docs/TASKS.md)"
  ok=0
else
  # 3.1) META blok boş olmamalıdır
  if ! sed -n '/BEGIN:EP_IMPORT_META/,/END:EP_IMPORT_META/p' docs/TASKS.md | grep -q '\[ \]'; then
    echo "⚠️  policy: META blok boşdur və ya bütün tapşırıqlar tamamlanıb"
  fi
fi

# 3.2) PROJECT track aktivdirsə, PROJECT blokunda açıq item olmalıdır
if grep -q "project_track:" CONTEXT.yaml 2>/dev/null; then
  if grep -q "<!-- BEGIN:EP_IMPORT_PROJECT -->" docs/TASKS.md 2>/dev/null; then
    if ! sed -n '/BEGIN:EP_IMPORT_PROJECT/,/END:EP_IMPORT_PROJECT/p' docs/TASKS.md | grep -q '\[ \]'; then
      echo "⚠️  policy: PROJECT track aktiv, amma açıq tapşırıq yoxdur"
    fi
  fi
fi

# 4) Health metrikləri minimal həddə olmalıdır
if [ -s .helix/health.json ]; then
  score=$(jq -r '.score // 0' .helix/health.json 2>/dev/null || echo 0)
  if [ "$score" -lt 75 ]; then
    echo "❌ policy: Health score $score (<75)"
    ok=0
  fi
else
  echo "⚠️  policy: health.json tapılmadı"
fi

# 5) Phase coverage uyğun olmalıdır
if [ -s modules/diagno/reports/report.json ]; then
  open=$(jq '.phase_coverage.open' modules/diagno/reports/report.json 2>/dev/null || echo 0)
  done=$(jq '.phase_coverage.done' modules/diagno/reports/report.json 2>/dev/null || echo 0)
  echo "📊  coverage: open=$open, done=$done"
  if [ "$open" -lt 0 ]; then
    echo "❌ policy: phase coverage səhv göstərici"
    ok=0
  fi
fi

# 6) PLAN uyğunluq
if [ -s modules/atlas/plans/plan.json ]; then
  epcount=$(jq '.ep_tasks | length' modules/atlas/plans/plan.json 2>/dev/null || echo 0)
  if [ "$epcount" -eq 0 ]; then
    echo "⚠️  policy: plan.json-da ep_tasks yoxdur"
  fi
fi

# 7) Sonda nəticə
if [ "$ok" -eq 1 ]; then
  echo "✅ policy guard: PASS"
  exit 0
else
  echo "❌ policy guard: FAIL"
  exit 3
fi

