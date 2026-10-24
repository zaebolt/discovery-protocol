#!/usr/bin/env bash
# PreToolUse (Write|Edit): stage gate. A write into a later stage's directory
# needs the literal "- Gate <prior>: approved" marker in STATE.dp3.md, which
# the Lead records only after the user approves that checkpoint.
#   artifacts/discovery/framing-*  always allowed (checkpoint 0 itself)
#   artifacts/discovery/*          needs Gate framing
#   artifacts/concepts/*           needs Gate discovery
#   artifacts/prototype/*          needs Gate concepts
#   artifacts/validation/*         needs Gate prototype
#   anything else (briefs, files outside artifacts/) is never gated
# Dormant without STATE.dp3.md; fails open on unparseable input.
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0
input="$(cat)"
path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
[ -n "$path" ] || exit 0

. "$(dirname "$0")/lib.sh"
dp3_active || exit 0

rel="$(dp3_rel "$path")"
case "$rel" in
  artifacts/discovery/framing-*) exit 0 ;;
  artifacts/discovery/*)         need="framing" ;;
  artifacts/concepts/*)          need="discovery" ;;
  artifacts/prototype/*)         need="concepts" ;;
  artifacts/validation/*)        need="prototype" ;;
  *) exit 0 ;;
esac

dp3_gate_approved "$need" && exit 0

echo "BLOCKED by discovery-protocol-v3: '$rel' belongs to a later stage. It needs '- Gate $need: approved (user: \"...\", date)' in STATE.dp3.md, which the Lead writes only after the user approves the $need checkpoint. If you are a specialist, report back to the Lead instead of working around this." >&2
exit 2
