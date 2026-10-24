---
description: Start or resume a discovery-protocol-v3 run — thin input to a designed HTML prototype.
---

# Start a discovery-protocol-v3 run

Take the **Lead** role. The `orchestrator` agent definition is the authoritative spec for how you route, brief, run checkpoints, and keep the question budget. If it isn't loaded, read `agents/orchestrator.md` under the plugin root. This skill covers only the entry sequence.

Problem statement (if provided): "$ARGUMENTS".

## 1. Scaffold

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh"
```

This creates `STATE.dp3.md`, `artifacts/`, `.dp3/shoot.sh` (the screenshot tool), and the sketch stylesheet, and seeds `~/.claude/discovery-protocol-v3/RETRO.md` on first use. Then read `./RETRO-draft.md` and `./RETRO.md` if they exist, and the global lessons file.

## 2. One kickoff message

> Building: **[problem from $ARGUMENTS, or ask for one]**
>
> 1. Confirm or correct the problem statement.
> 2. Paste any raw input you have, as-is: a PM ticket, notes, a Slack thread. Everything you give me becomes stated fact instead of my guess.
> 3. **Design reference:** what should the prototype look like it belongs to? A design system (name or link), a host product (screenshots welcome), a brand, or "none, use your judgment".
>
> This is a clean run: I won't import answers from earlier runs. [If local retro/draft exists: "I found notes from a previous run here. Apply them? (yes / no / show me)"]

Wait for the reply.

## 3. On reply

Record in STATE: `Problem`, `Design reference`, `Applied lessons`, and `Stage: framing`. Then dispatch the **researcher** to write only `artifacts/discovery/framing-v1.md`, with the user's raw input pasted verbatim into the brief.

## 4. Checkpoint 0 (framing)

Present the framing in the orchestrator's short checkpoint format: at most 5 guess-with-default questions, ending with *"Reply 'ok' to accept all defaults."* On approval, write `- Gate framing: approved (user: "<words>", <date>)` and `Stage: discovery`, record the answers and the defaults taken, and continue with the flow in the orchestrator spec.

## Resuming

If `STATE.dp3.md` already exists, the SessionStart hook has loaded it. Summarise the stage, the last gate approved, the open questions, and the next step in 3 lines, then ask where to pick up.
