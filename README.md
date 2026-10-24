# Discovery Protocol

**Turn a thin product idea into a clickable HTML prototype ready for stakeholder and user validation**

A [Claude Code](https://claude.com/claude-code) plugin that runs design-centered product discovery as a small agent team: framing → discovery → concepts → prototype → (optional) validation, with a short human checkpoint between each stage.

It's built for the common situation where requirements are thin, the PM is stretched, and a mid-fidelity artifact the team can react to moves things faster than another requirements conversation.

## Evolved from design-centered-workflow

This is the successor to **[design-centered-workflow](https://github.com/zaebolt/design-centered-workflow)**, a conversational four-phase workflow (discovery, exploration, design, validation) built from role prompts in a repo's `.claude/` folder. The phases and the checkpoint rhythm carry over. Most other things changed, based on lessons from about 15 runs of intermediate versions (a hook-gated plugin, an elicitation-first v2, and a context-graph experiment, none published):

| | design-centered-workflow | discovery-protocol |
|---|---|---|
| **Packaging** | Prompt files in a cloned repo | Installable plugin: agents, skills, hooks |
| **Roles** | One conversation plays each role in turn | Separate agents; the critic reviews in its own context |
| **Starting point** | Generates a full PRD, personas, journeys and stakeholder map from the idea | A framing checkpoint first: restates the problem and asks at most 5 questions, each with a default |
| **Discovery output** | PRD, personas, journeys, JTBD, needs, stakeholders, landscape (several docs) | The same coverage (personas with pain points, JTBD and current journey; stakeholders; sourced competitive landscape; data scale and shape; needs; requirements) in **one document**, with every claim tagged *stated*, *retrieved*, *inferred* or *default* |
| **Picking a concept** | Iterate until ≥3 concepts score ≥7.5 | Critic scores blind, force-ranks, and names a kill and a bet; the top 2 get clickable wireframe sketches |
| **Prototype** | Next.js + Tailwind app (`npm install && npm run dev`) | Static HTML that opens from disk, built from a design direction and your design system or host product |
| **Prototype review** | You review the running app | Critic screenshots every screen and reviews it against a design rubric (up to 2 fix rounds) before you see it |
| **Guardrails** | Instructions in prompts | Hooks: stage gates, question budget, at most 12 must-haves, requirement coverage, no requirement text on screen |
| **Validation** | Stakeholder alignment summary + test scenarios | A kit for real sessions; no simulated stakeholder reactions |
| **Memory** | `DESIGN_PROCESS.md` per run | A running retro; lessons carry across runs, each with an expiry condition |

What previous versions taught, in short:
- **Generated research reads as fact.** Personas and PRDs written from a one-line idea look authoritative, so the team anchors on guesses. Now every claim shows where it came from.
- **Asking beats inventing, but only up to a point.** Unlimited elicitation turned into endless questions. Now there are at most 5 per checkpoint, each with a default you can accept by replying "ok".
- **More must-haves make a worse prototype.** Proving every requirement on screen produced dense admin panels. Must-haves are capped, and requirement text is kept out of the UI.
- **Sketches get copied.** When a quick spike was the only interface-shaped input, the final build re-skinned it. Sketches are now deliberately grey, and the prototyper never sees them.
- **Rules can crowd out the work.** Later, heavier versions spent their effort on following the rules instead of on the output. This version is less than half the size of the heaviest one.

## Install

```
/plugin marketplace add zaebolt/discovery-protocol
/plugin install discovery-protocol-v3@discovery-protocol
```

Then run `/reload-plugins` or start a new session. From a terminal, the equivalent is `claude plugin marketplace add zaebolt/discovery-protocol && claude plugin install discovery-protocol-v3@discovery-protocol`.

To update later: `/plugin marketplace update discovery-protocol`, then update the plugin from `/plugin`. See [CHANGELOG.md](CHANGELOG.md) for what changed.

**Recommended companion:** `/plugin install frontend-design@claude-plugins-official`. The prototyper uses it for visual direction when it's available.

### Requirements

- Claude Code
- `bash`, `jq`, `perl` (macOS ships bash and perl; `brew install jq`)
- Google Chrome, Chromium or Edge, used for screenshots in the design review. Set `CHROME=/path/to/binary` if it isn't in a standard location. Each screen gets a viewport shot and a full-page shot. Set `DP3_SHOT_FULL=0` to skip the full-page ones, or `DP3_SHOT_SIZE=1280,800` to change the window size.

Tested on macOS. Linux should work. Windows is untested.

## Quick start

In an empty folder for your project:

```
/discovery-protocol-v3:start Account managers can't see where each new customer is stuck during onboarding
```

The plugin creates its files in that folder and asks for three things:
1. Confirm or correct the problem.
2. Paste any raw input you have (a ticket, notes, a thread). Pasted text becomes stated fact instead of a guess.
3. **Design reference:** a design system, a host product (screenshots welcome), or "use your judgment".

From there, each checkpoint is short: what happened, the one thing to look at, at most 5 questions with defaults, and **Approve / Revise / End**. Reply `ok` to accept all defaults.

## How a run flows

```
 kickoff ─▶ FRAMING ─▶ DISCOVERY ─▶ CONCEPTS ─────────────▶ PROTOTYPE ─────────────────▶ [VALIDATION]
            restate +   one doc +   3–4 concepts, blind      design direction → HTML →    kit for real
            ≤5 Qs       critic      ranking, 2 wireframes    screenshot review (≤2 rounds) sessions
              C0          C1            C2: you pick               C3: you react              C4
```

| Agent | Does |
|---|---|
| **orchestrator** (lead) | Runs the flow, keeps the question budget, and is the only agent that talks to you |
| **researcher** | Writes the framing note and the discovery doc |
| **explorer** | Writes concepts and builds wireframe sketches |
| **critic** | Reviews discovery, ranks concepts blind, and design-reviews the prototype from screenshots |
| **prototyper** | Writes the design direction and builds the HTML prototype |
| **validator** | Writes the validation kit (optional) |

Other commands: `/discovery-protocol-v3:brief pm|eng|exec` renders a jargon-free summary to share with your team. `/discovery-protocol-v3:retro` closes a run and saves its lessons.

## What you get

```
your-project/
├── STATE.dp3.md                  run state (the plugin's hooks wake up only when this exists)
├── RETRO-draft.md                lessons captured during the run
└── artifacts/
    ├── discovery/   framing-v1.md · discovery-v1.md (personas, stakeholders, landscape,
    │                scale, needs, requirements) · discovery-review-v1.md
    ├── concepts/    concepts-v1.md · concept-scores-v1.md · sketches/<concept>/index.html
    ├── prototype/   design-direction-v1.md · site/index.html · screens/ (viewport + full-page)
    │                design-review-v1.md · prototype-notes-v1.md
    ├── validation/  validation-kit-v1.md
    └── briefs/      brief-pm-<date>.md
```

Open the prototype with `open artifacts/prototype/site/index.html`.

## Guardrails

Hooks enforce a few rules; the agents use judgment for everything else. The hooks only act inside a run, meaning a folder with `STATE.dp3.md`. If they can't read their input, they let the write through.

| Rule | When it's checked |
|---|---|
| Stages happen in order; a later stage needs your recorded approval of the one before | Before any write into `artifacts/` |
| At most 5 questions per checkpoint, each with *If unanswered* and *Changes* | After writing the framing or discovery doc |
| At most 12 must-have requirements; personas (with pain points), stakeholders, competitive landscape and scale & shape all present | After writing the discovery doc |
| Every must-have has a coverage row naming the screen (`#route`) where it lives | After writing the prototype notes |
| No requirement IDs, `[must]`, "PRD" or other protocol words in the prototype's visible text | After writing any prototype HTML/JS |

You can adjust these in `STATE.dp3.md`: `Question cap: 5`, `Must cap: 12`, and `Surface allow: A100` (for a real product term the surface check would otherwise block).

## Keep in mind

- **It uses a lot of tokens.** A full run is a multi-agent session.
- **The first checkpoint matters most.** Most expensive corrections in past runs came from things framing could have caught.

## Repository layout

```
.claude-plugin/   plugin.json · marketplace.json
agents/           orchestrator, researcher, explorer, critic, prototyper, validator
skills/           start, brief, retro, artifact-templates, discovery-review,
                  concept-scoring, design-review, prototype-craft
hooks/hooks.json  SessionStart · PreToolUse · PostToolUse
scripts/          lib.sh, gate.sh, post-write-check.sh, load-state.sh, scaffold.sh, shoot.sh
templates/        sketch.css (wireframe style), seed-lessons.md
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for local development and [CHANGELOG.md](CHANGELOG.md) for release notes.

## License

MIT. See [LICENSE](LICENSE).
