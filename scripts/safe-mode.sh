#!/usr/bin/env bash
# Safe Mode guard for TriHelix
set -euo pipefail

# Activation: env SAFE_MODE=1 OR presence of PROJECT_ROOT_MARKER file
if [ "${SAFE_MODE:-0}" = "1" ] || [ -f "PROJECT_ROOT_MARKER" ]; then
  export SAFE_MODE=1
else
  export SAFE_MODE=0
fi

# Allowed write prefixes in SAFE_MODE (meta-only)
# Everything else is treated as project code and will be blocked.
ALLOWED_PREFIXES=(
  ".helix/"
  "docs/"
  "modules/atlas/plans/"
  "modules/genom/out/"
  "modules/diagno/out/"
  "modules/diagno/reports/"
)

is_allowed_path() {
  local p="$1"
  # normalize
  p="${p#./}"
  for ap in "${ALLOWED_PREFIXES[@]}"; do
    if [[ "$p" == "$ap"* ]]; then
      return 0
    fi
  done
  return 1
}

safe_write_check() {
  # Usage: safe_write_check <target_path_or_dir>
  local p="$1"
  if [ "${SAFE_MODE}" != "1" ]; then
    return 0
  fi
  if is_allowed_path "$p"; then
    return 0
  fi
  echo "🛑 Safe Mode: write blocked → $p"
  return 1
}

safe_mode_banner() {
  if [ "${SAFE_MODE}" = "1" ]; then
    echo "🛡️  Safe Mode: ON (project code writes are blocked; meta-only writes allowed)"
  else
    echo "🟢 Safe Mode: OFF"
  fi
}

export -f is_allowed_path safe_write_check safe_mode_banner
export SAFE_MODE
