#!/usr/bin/env bash
# PostToolUse (Write|Edit): re-checks the file ON DISK after every write or
# edit, so Write and Edit are treated the same.
#   framing-vN.md / discovery-vN.md  -> question budget (+ must cap for discovery)
#   prototype-notes-vN.md            -> requirement coverage
#   prototype/site/**.html|js        -> no protocol text on the product surface
# The write has already happened; exit 2 feeds the reason back to the model so
# it fixes the file. Dormant without STATE.dp3.md; fails open on bad input.
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0
input="$(cat)"
path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
[ -n "$path" ] || exit 0

. "$(dirname "$0")/lib.sh"
dp3_active || exit 0

rel="$(dp3_rel "$path")"
[ -n "$rel" ] && [ -f "$rel" ] || exit 0

fail() {
  echo "discovery-protocol-v3 check failed for '$rel': $1 Fix the file now — this check re-runs on every write or edit." >&2
  exit 2
}

case "$rel" in
  artifacts/discovery/framing-v*.md)
    msg="$(dp3_check_questions "$rel")" || fail "$msg"
    ;;
  artifacts/discovery/discovery-v*.md)
    msg="$(dp3_check_questions "$rel")" || fail "$msg"
    msg="$(dp3_check_must_cap "$rel")" || fail "$msg"
    ;;
  artifacts/prototype/prototype-notes-v*.md)
    msg="$(dp3_check_coverage "$rel")" || fail "$msg"
    ;;
  artifacts/prototype/site/*.html|artifacts/prototype/site/*.htm|artifacts/prototype/site/*.js)
    msg="$(dp3_check_surface "$rel")" || fail "$msg"
    ;;
esac
exit 0
