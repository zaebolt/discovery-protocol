---
description: Render the current v3 run as a jargon-free brief for a PM, engineering lead, or exec.
---

# Brief: the team-facing summary

Audience (if given): "$ARGUMENTS". One of `pm` (default), `eng`, `exec`, or a free-text description of the reader.

Write `artifacts/briefs/brief-<audience>-<YYYY-MM-DD>.md`. Use no protocol jargon: no gates, stages, STATE, A/R/Q IDs (except for `eng`), and no file trees. Link the prototype (`artifacts/prototype/site/index.html`) and at most one other artifact.

1. **What we're solving**: 2–3 sentences.
2. **What we need from you**: the open questions in plain words. For each, say why it matters and what we'll assume if we don't hear back. This comes first so a skimming reader still sees it.
3. **What we know vs. what we're assuming**: confirmed facts (and who confirmed them), then the defaults we're building on.
4. **Where we are**: the concepts considered and the one chosen, with the reason. If a prototype exists, say what it shows, what's mocked, and any must-have that isn't fully there. Include 1–3 screenshots from `artifacts/prototype/screens/` if useful.
5. **Later questions**: the parking lot, briefly. These are not asks.
6. **Decisions needed**: each with the default we'll take and by when. Ask the user for the date if you don't know it.

Audience: **pm** emphasises sections 2 and 6. **eng** adds IDs, what's stubbed, and technical risks. **exec** gets one page: the problem, the direction, the single most important open question, and the ask.

Show the brief to the user and offer adjustments. Never send it anywhere yourself.
