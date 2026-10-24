#!/usr/bin/env bash
# SessionStart: dormant unless ./STATE.dp3.md exists. When a run is active,
# injects STATE, the running retro draft, the local retro, and the global v3
# lessons. Global lessons are capped (first 80 lines) — lessons are scar
# tissue and must not grow into a standing tax on every session.
set -euo pipefail

STATE="./STATE.dp3.md"
DRAFT="./RETRO-draft.md"
LOCAL_RETRO="./RETRO.md"
GLOBAL_RETRO="${HOME}/.claude/discovery-protocol-v3/RETRO.md"

[ -f "$STATE" ] || exit 0

tmp="$(mktemp)"
{
  echo "## discovery-protocol-v3 — active run resumed"
  echo
  echo "### STATE.dp3.md"
  cat "$STATE"
  echo
  if [ -s "$DRAFT" ]; then
    echo "### Retro draft (this run)"
    cat "$DRAFT"
    echo
  fi
  if [ -s "$GLOBAL_RETRO" ]; then
    echo "### Global lessons (apply unless a local lesson overrides; capped at 80 lines)"
    head -n 80 "$GLOBAL_RETRO"
    echo
  fi
  if [ -s "$LOCAL_RETRO" ]; then
    echo "### Local retro (this project — overrides global)"
    cat "$LOCAL_RETRO"
    echo
  fi
} > "$tmp"

if command -v jq >/dev/null 2>&1; then
  jq -Rs '{hookSpecificOutput:{hookEventName:"SessionStart", additionalContext:.}}' "$tmp"
else
  cat "$tmp"
fi
rm -f "$tmp"
