#!/usr/bin/env bash
# Screenshot a static HTML page (and any of its #routes) with headless Chrome.
# Copied into each run as ./.dp3/shoot.sh by scaffold.sh.
#
# Usage: bash .dp3/shoot.sh <page.html> <out-dir> [route ...]
#   route examples: "/"  "/compare"  "/compare?state=empty"
#   no routes -> one shot of the page as-is (out-dir/home.png)
# Env: DP3_SHOT_SIZE (default 1440,1000), DP3_SHOT_WAIT ms (default 1500),
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

abs="$(cd "$(dirname "$page")" && pwd)/$(basename "$page")"
size="${DP3_SHOT_SIZE:-1440,1000}"
wait="${DP3_SHOT_WAIT:-1500}"

shoot() {  # $1 = url, $2 = png
  "$chrome" --headless=new --disable-gpu --hide-scrollbars \
    --window-size="$size" --virtual-time-budget="$wait" \
    --screenshot="$2" "$1" >/dev/null 2>&1 || true
  if [ -s "$2" ]; then echo "shot: $2"; else echo "shoot: FAILED $1" >&2; fi
}

if [ "$#" -eq 0 ]; then
  shoot "file://$abs" "$out/home.png"
  exit 0
fi

for route in "$@"; do
  slug="$(printf '%s' "$route" | sed -E 's#^/+##; s#[^A-Za-z0-9]+#-#g; s#-+$##')"
  [ -n "$slug" ] || slug="home"
  shoot "file://$abs#$route" "$out/$slug.png"
done
