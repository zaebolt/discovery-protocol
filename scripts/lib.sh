# lib.sh — shared helpers for discovery-protocol-v3 hooks. Source it; don't execute it.
#
# Contract: check functions take a file path (relative to the run dir), print a
# human-readable reason on stdout and return 1 on a real violation. Silence +
# return 0 = pass. Every check fails open on a missing prerequisite.
# Written for macOS bash 3.2 + BSD tools (no associative arrays, no mapfile).

DP3_STATE="./STATE.dp3.md"

dp3_active() { [ -f "$DP3_STATE" ]; }

# Absolute or relative path -> path relative to the run dir ('' if outside it).
dp3_rel() {
  case "$1" in
    "$PWD"/*) printf '%s' "${1#"$PWD"/}" ;;
    /*)       printf '' ;;
    *)        printf '%s' "${1#./}" ;;
  esac
}

# Value of a "- Key: value" line in STATE ('' if absent).
dp3_state_value() {
  [ -f "$DP3_STATE" ] || return 0
  grep -iE "^- *$1:" "$DP3_STATE" | head -1 | sed -E 's/^- *[^:]+: *//' || true
}

dp3_gate_approved() {  # $1 = framing | discovery | concepts | prototype
  grep -qiE "^- *Gate $1: *approved" "$DP3_STATE" 2>/dev/null
}

dp3_int_or() {  # $1 = value, $2 = default
  local n
  n="$(printf '%s' "$1" | grep -oE '^[0-9]+' || true)"
  printf '%s' "${n:-$2}"
}

# The discovery doc the prototype must cover: the version named on STATE's
# "Approved artifacts" line, else the highest version on disk.
dp3_discovery_doc() {
  local dir="artifacts/discovery" ver found=""
  ver="$(grep -iE '^- *Approved artifacts:' "$DP3_STATE" 2>/dev/null \
        | grep -oE 'discovery-v[0-9]+(\.[0-9]+)?' | sort -V | tail -1 || true)"
  if [ -n "$ver" ] && [ -f "$dir/$ver.md" ]; then found="$dir/$ver.md"; fi
  if [ -z "$found" ]; then
    found="$(ls -1 "$dir"/discovery-v*.md 2>/dev/null | sort -V | tail -1 || true)"
  fi
  printf '%s' "$found"
}

# ---------- question budget (framing + discovery docs) ----------
# Lines "- Q<n>: ..." under "## Questions for you". At most <Question cap>
# (default 5); each must carry "If unanswered:" (the default we take) and
# "Changes:" (what the answer would change). "## Later questions" is uncapped.
dp3_check_questions() {
  local cap section count bad
  cap="$(dp3_int_or "$(dp3_state_value 'Question cap')" 5)"
  section="$(awk '/^## /{s = (tolower($0) ~ /questions for you/) ? 1 : 0; next} s == 1 {print}' "$1")"
  count="$(printf '%s\n' "$section" | grep -cE '^[-*] *(\*\*)?Q[0-9]+' || true)"
  if [ "${count:-0}" -gt "$cap" ]; then
    echo "question budget exceeded: $count questions under '## Questions for you' (cap $cap). Keep only the questions whose answer changes the concept choice or the primary journey; move the rest to '## Later questions'."
    return 1
  fi
  bad="$(printf '%s\n' "$section" | grep -E '^[-*] *(\*\*)?Q[0-9]+' \
        | grep -viE 'if unanswered.*changes|changes.*if unanswered' \
        | grep -oE 'Q[0-9]+' | head -5 | paste -sd ',' - || true)"
  if [ -n "$bad" ]; then
    echo "question(s) $bad lack the guess-with-default form. Each line needs: '- Qn: <question> — If unanswered: <default we take> — Changes: <what the answer changes>'."
    return 1
  fi
  return 0
}

# ---------- must cap (discovery doc) ----------
dp3_check_must_cap() {
  local cap n
  cap="$(dp3_int_or "$(dp3_state_value 'Must cap')" 12)"
  n="$(grep -cE '^[-*] *R[0-9]+ *\[must\]' "$1" || true)"
  if [ "${n:-0}" -gt "$cap" ]; then
    echo "$n [must] requirements (cap $cap). A prototype cannot carry more than ~$cap musts and stay designed. Downgrade the rest to [should], or ask the user which ones are truly non-negotiable (the user may raise the cap via '- Must cap: N' in STATE)."
    return 1
  fi
  return 0
}

# ---------- research sections (discovery doc) ----------
# One doc, but not a thin one: personas (with pain points), stakeholders and
# the competitive/adjacent landscape must be present (0.1.0's thin template let
# a real run ship discovery without any of them).
dp3_check_discovery_sections() {
  local missing=""
  grep -qiE '^## +personas?' "$1" || missing="$missing '## Personas'"
  grep -qiE '^## +stakeholders?' "$1" || missing="$missing '## Stakeholders'"
  grep -qiE '^## +(competitive|landscape|alternatives)' "$1" || missing="$missing '## Competitive & adjacent landscape'"
  grep -qiE '^## +scale' "$1" || missing="$missing '## Scale & shape'"
  grep -qiE 'pain points?' "$1" || missing="$missing 'Pain points (per persona)'"
  if [ -n "$missing" ]; then
    echo "discovery doc is missing required research section(s):$missing. Personas need context, goals, pain points, jobs to be done and a current journey; stakeholders need interests and success criteria; the landscape needs sourced alternatives and the gap; scale & shape needs counts, hierarchy depth and extremes. Tag inferred content as inferred — see the artifact-templates skill."
    return 1
  fi
  return 0
}

# ---------- requirement coverage (prototype notes) ----------
# Every [must] in the approved discovery doc needs a coverage row:
#   | R3 | must | shown | #/compare | ... |
# shown/partial -> the Where column names a #route; deferred -> a reason.
dp3_check_coverage() {
  local doc musts missing="" bad="" r row status where
  doc="$(dp3_discovery_doc)"
  [ -n "$doc" ] || return 0
  musts="$(grep -oE '^[-*] *R[0-9]+ *\[must\]' "$doc" | grep -oE 'R[0-9]+' | sort -u || true)"
  [ -n "$musts" ] || return 0
  for r in $musts; do
    row="$(grep -E "^\| *$r *\|" "$1" | head -1 || true)"
    if [ -z "$row" ]; then missing="$missing $r"; continue; fi
    status="$(printf '%s' "$row" | awk -F'|' '{print tolower($4)}')"
    where="$(printf '%s' "$row" | awk -F'|' '{print $5}')"
    case "$status" in
      *shown*|*partial*) printf '%s' "$where" | grep -q '#' || bad="$bad $r(no #route in Where)" ;;
      *deferred*)        printf '%s' "$row" | grep -qi 'reason' || bad="$bad $r(deferred without a reason)" ;;
      *)                 bad="$bad $r(status must be shown/partial/deferred)" ;;
    esac
  done
  if [ -n "$missing$bad" ]; then
    echo "requirement coverage incomplete against $(basename "$doc"). Missing [must] rows:${missing:- none}. Invalid rows:${bad:- none}. Row format: | R3 | must | shown | #/route | note |"
    return 1
  fi
  return 0
}

# ---------- product surface (prototype site files) ----------
# The prototype is a product, not a defense of its requirements. Blocks
# requirement/assumption IDs, priority tags and protocol vocabulary in rendered
# text. Comments and tag attributes are stripped first. Tokens listed on
# STATE's "- Surface allow:" line (comma-separated) are ignored.
dp3_check_surface() {
  command -v perl >/dev/null 2>&1 || return 0
  local text hits allow tok filtered=""
  text="$(perl -0777 -pe 's/<!--.*?-->//gs; s{/\*.*?\*/}{}gs; s{\bhttps?://[^\s"'"'"'<>)]+}{}g; s{(?<![:\w"'"'"'])//[^\n]*}{}g; s/<[^>]*>/ /g' "$1" 2>/dev/null || true)"
  [ -n "$text" ] || return 0
  hits="$( { printf '%s' "$text" | grep -oE '\b[RA][0-9]{1,3}\b' || true
             printf '%s' "$text" | grep -oiE '\[(must|should|could)\]|\bprovisional\b|\bcheckpoint [0-9]\b|\bPRD\b' || true; } | sort -u)"
  [ -n "$hits" ] || return 0
  allow="$(dp3_state_value 'Surface allow' | tr ',' '\n' | sed -E 's/^ +| +$//g')"
  for tok in $hits; do
    printf '%s\n' "$allow" | grep -qxF "$tok" && continue
    filtered="$filtered $tok"
  done
  [ -n "$filtered" ] || return 0
  echo "protocol text on the product surface:$filtered. The prototype must read as a real product — no requirement/assumption IDs, priority tags, or protocol words in visible copy. Coverage lives in prototype-notes. (A genuine domain token, e.g. a GPU model 'A100', can be allowed via '- Surface allow: A100' in STATE.)"
  return 1
}
