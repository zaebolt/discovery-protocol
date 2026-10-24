#!/usr/bin/env bash
# Screenshot a static HTML page (and any of its #routes) with headless Chrome.
# Copied into each run as ./.dp3/shoot.sh by scaffold.sh.
#
# Usage: bash .dp3/shoot.sh <page.html> <out-dir> [route ...]
#   route examples: "/"  "/compare"  "/compare?state=empty"
#   no routes -> the page as-is (out-dir/home.png)
#
# Per route it writes:
#   <slug>.png       the viewport — what the user sees first (above the fold)
#   <slug>.full.png  everything on the page, with inner scroll areas expanded
#                    (fixed app shells included), written only when the
#                    content is taller than the viewport. Review both: content
#                    below the fold is invisible in the viewport shot.
#
# Env: DP3_SHOT_SIZE (default 1440,1000), DP3_SHOT_WAIT ms (default 1500),
#      DP3_SHOT_FULL=0 to skip full-page shots, DP3_SHOT_MAXH (default 12000),
#      CHROME (path to a Chrome/Chromium binary, optional)
set -euo pipefail

page="${1:?usage: shoot.sh <page.html> <out-dir> [route ...]}"
out="${2:?usage: shoot.sh <page.html> <out-dir> [route ...]}"
shift 2

[ -f "$page" ] || { echo "shoot: no such file: $page" >&2; exit 1; }
mkdir -p "$out"

chrome="${CHROME:-}"
if [ -z "$chrome" ]; then
  for c in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"; do
    [ -x "$c" ] && { chrome="$c"; break; }
  done
fi
if [ -z "$chrome" ]; then
  for c in google-chrome google-chrome-stable chromium chromium-browser; do
    command -v "$c" >/dev/null 2>&1 && { chrome="$(command -v "$c")"; break; }
  done
fi
[ -n "$chrome" ] || { echo "shoot: no Chrome/Chromium found (set CHROME=/path/to/binary)" >&2; exit 3; }

dir="$(cd "$(dirname "$page")" && pwd)"
abs="$dir/$(basename "$page")"
size="${DP3_SHOT_SIZE:-1440,1000}"
width="${size%,*}"
height="${size#*,}"
wait="${DP3_SHOT_WAIT:-1500}"
full="${DP3_SHOT_FULL:-1}"
maxh="${DP3_SHOT_MAXH:-12000}"

# A capture copy of the page, next to the original so relative assets resolve.
# After the page renders it expands every inner scroll area (app shells with a
# fixed header and a scrolling main panel), then records the document height on
# <html data-dp3h="…">. It is used both to measure and to take the full shot.
measure="$dir/.dp3-measure-$$.html"
cleanup() { rm -f "$measure"; }
trap cleanup EXIT
if [ "$full" != "0" ]; then
  cp "$abs" "$measure"
  cat >> "$measure" <<EOF

<script>setTimeout(function(){
  var all=document.querySelectorAll('*'), open=[];
  for (var i=0;i<all.length;i++){var e=all[i],s=getComputedStyle(e);
    if(/(auto|scroll)/.test(s.overflowY) && e.scrollHeight>e.clientHeight+1) open.push(e);}
  open.forEach(function(e){
    for(var p=e;p&&p.style;p=p.parentElement){p.style.overflowY='visible';p.style.height='auto';p.style.maxHeight='none';}
  });
  var d=document.documentElement,b=document.body;
  d.setAttribute('data-dp3h',Math.max(d.scrollHeight,b?b.scrollHeight:0));
},$(( wait * 2 / 3 )));</script>
EOF
fi

cap() {  # $1 = url, $2 = png, $3 = window size
  "$chrome" --headless=new --disable-gpu --hide-scrollbars \
    --window-size="$3" --virtual-time-budget="$wait" \
    --screenshot="$2" "$1" >/dev/null 2>&1 || true
  if [ -s "$2" ]; then echo "shot: $2"; else echo "shoot: FAILED $1" >&2; fi
}

page_height() {  # $1 = hash ('' or '#/route') -> integer or ''
  "$chrome" --headless=new --disable-gpu --window-size="$size" \
    --virtual-time-budget="$wait" --dump-dom "file://$measure$1" 2>/dev/null \
    | grep -oE 'data-dp3h="[0-9]+"' | head -1 | sed -E 's/.*="([0-9]+)"/\1/' || true
}

shoot() {  # $1 = hash, $2 = slug
  cap "file://$abs$1" "$out/$2.png" "$size"
  [ "$full" != "0" ] || return 0
  local h
  h="$(page_height "$1")"
  [ -n "$h" ] || return 0
  if [ "$h" -gt "$height" ]; then
    h=$(( h + 120 ))   # room for the headless window frame
    [ "$h" -le "$maxh" ] || { echo "shoot: $2 is ${h}px tall; full shot capped at ${maxh}px" >&2; h="$maxh"; }
    cap "file://$measure$1" "$out/$2.full.png" "$width,$h"
  fi
}

if [ "$#" -eq 0 ]; then
  shoot "" "home"
  exit 0
fi

for route in "$@"; do
  slug="$(printf '%s' "$route" | sed -E 's#^/+##; s#[^A-Za-z0-9]+#-#g; s#-+$##')"
  [ -n "$slug" ] || slug="home"
  shoot "#$route" "$slug"
done
