#!/usr/bin/env bash
# Invoked by the `start` skill (not a hook). Creates the artifact tree, copies
# the run tools (.dp3/shoot.sh) and the sketch stylesheet into the run, seeds
# the global v3 lessons file on first use, and writes STATE.dp3.md if absent.
# Safe to re-run.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p \
  ./artifacts/discovery \
  ./artifacts/concepts/sketches \
  ./artifacts/prototype/site \
  ./artifacts/prototype/screens \
  ./artifacts/validation \
  ./artifacts/briefs \
  ./.dp3

cp "$ROOT/scripts/shoot.sh" ./.dp3/shoot.sh
chmod +x ./.dp3/shoot.sh
# Lets subagents read this plugin's own skill files when a skill won't load,
# instead of finding a same-named skill from another plugin.
printf '%s\n' "$ROOT" > ./.dp3/plugin-root
cp "$ROOT/templates/sketch.css" ./artifacts/concepts/sketches/sketch.css

GLOBAL_DIR="${HOME}/.claude/discovery-protocol-v3"
mkdir -p "$GLOBAL_DIR"
if [ ! -f "$GLOBAL_DIR/RETRO.md" ]; then
  cp "$ROOT/templates/seed-lessons.md" "$GLOBAL_DIR/RETRO.md"
  echo "scaffold: seeded global lessons at $GLOBAL_DIR/RETRO.md"
fi

if [ ! -f ./STATE.dp3.md ]; then
  cat > ./STATE.dp3.md <<'EOF'
# Discovery Protocol v3 — STATE
- Stage: framing
- Gate framing: pending
- Gate discovery: pending
- Gate concepts: pending
- Gate prototype: pending
- Problem: <one-liner>
- Design reference: <design system / host product / screenshots / none>
- Approved artifacts:
- Selected concept:
- Open questions: <≤5, the ones on the table right now>
- Defaults taken: <unanswered questions → the default we are building on>
- Question cap: 5
- Must cap: 12
- Surface allow:
- Applied lessons:
EOF
  echo "scaffold: created STATE.dp3.md, artifacts/, .dp3/shoot.sh"
else
  echo "scaffold: artifact tree ensured; STATE.dp3.md already present"
fi
