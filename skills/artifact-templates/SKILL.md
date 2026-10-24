---
description: Canonical filenames and required sections for every discovery-protocol-v3 artifact.
---

# Artifact templates (v3)

Every markdown artifact starts with a three-line header:

```
Owner: <role> · Version: vN[.M] · Inputs: <path@version>, …
Changes since last version: <one line, or "first version">
```

Versions: a minor bump (`v1.1`) for corrections, critic follow-ups, or folded-in answers; a major bump (`v2`) for a user-driven change of scope. Never edit an older version; write the next one. The prototype site (`artifacts/prototype/site/`) is a working artifact and is edited in place.

## Canonical paths

| Path | Owner | Stage |
|---|---|---|
| `artifacts/discovery/framing-vN.md` | researcher | framing |
| `artifacts/discovery/discovery-vN.md` | researcher | discovery |
| `artifacts/discovery/discovery-review-vN.md` | critic | discovery |
| `artifacts/concepts/concepts-vN.md` | explorer | concepts |
| `artifacts/concepts/concept-scores-vN.md` | critic | concepts |
| `artifacts/concepts/owner-response-vN.md` | explorer | concepts |
| `artifacts/concepts/sketches/<slug>/index.html` | explorer | concepts |
| `artifacts/prototype/design-direction-vN.md` | prototyper | prototype |
| `artifacts/prototype/site/index.html` (+ css/js/data) | prototyper | prototype |
| `artifacts/prototype/design-review-vN.md` | critic | prototype |
| `artifacts/prototype/screens/<self\|review-vN>/*.png` | prototyper / critic | prototype |
| `artifacts/prototype/prototype-notes-vN.md` | prototyper | prototype |
| `artifacts/validation/validation-kit-vN.md` | validator | validation |
| `artifacts/briefs/brief-<audience>-<YYYY-MM-DD>.md` | Lead | any |

IDs: `A` (assumptions), `R` (requirements), `Q` (questions, numbered per document). A and R IDs are permanent integers and are never reused. A split or added requirement takes the next free integer; `R6a` is invalid.

## Question format (hook-checked in framing and discovery docs)

```
## Questions for you
- Q1: <one atomic question>? — If unanswered: <default we take> — Changes: <concept choice / primary journey / scope>
```
At most 5 (or STATE's `Question cap`). `## Later questions` is the uncapped parking lot. It is never asked at a checkpoint and is shown in briefs.

## framing-vN.md
Header · **Problem as I understand it** (3–5 sentences in your own words) · **What you've told us** (A-IDs, user-stated) · **Questions for you** (≤5) · **Defaults I'll take** (what happens if nothing is answered) · **Later questions**

It should be forwardable to a PM unedited.

## discovery-vN.md
Header · **Problem** · **Users & context** (who, situation, jobs; a few lines per user type) · **Current state** (how it's done today; naming tools and UI is fine here) · **Needs** (prioritised, citing A-IDs) · **Requirements** · **Success criteria** · **Non-goals** · **Assumption register** · **Questions for you** (≤5) · **Later questions**

```
- R1 [must]: <user-facing capability> (basis: A1, A4)
- R2 [must] [provisional]: <capability> (basis: A6)
- R3 [should]: <capability> (basis: A2)
- R4 [retired]: <capability> (why: user dropped it at C1)

- A1 (user-stated, confirmed: kickoff): <claim>
- A2 (retrieved: <url>, unconfirmed): <claim>
- A6 (inferred, unconfirmed): <claim>
- A7 (default: framing Q3 unanswered): <claim>
```
At most 12 `[must]` (or STATE's `Must cap`), hook-checked. Requirements say *what*, never screens, layout, or technology.

## discovery-review-vN.md (critic)
Header · Score table (discovery-review rubric) · Provenance findings · Question-budget findings · Top fixes (≤5)

## concepts-vN.md (explorer)
Header · then per concept:
```
## Concept 2 — <Name>
- The bet: <one sentence>
- Puts first / gives up: <…> / <…>
- Primary journey: 1. <entry> → 2. … → 6. <outcome>
- Screens: <names>
- Must coverage: R1 — <how> · R2 — <how> · … (every must, one line each)
- Breaks if: A6, A9 turn out false
- Risks: <…>
```

## concept-scores-vN.md (critic)
Header · Score table · Forced ranking (no ties) · Kill + Bet · Per-concept note (deciding strength/weakness + what it breaks without) · Recommendation of which 2 to sketch

## Sketch (`sketches/<slug>/index.html`)
Greyscale, linking `../sketch.css` only. Primary-journey steps as hash routes with a `.steps` strip. Small `SKETCH — <concept>` banner. `.note` annotations allowed. No other styling beyond layout.

## design-direction-vN.md (prototyper)
Header · **Design reference & stance** (what we match, and how closely) · **The 5-second read** (what the first screen must make obvious) · **Route map** (`#/route` → purpose; primary journey marked) · **Hierarchy per screen** (primary / secondary / on demand) · **Visual system** (type scale, colour tokens with semantic roles, spacing scale, density, radius, iconography) · **Components** · **Data & copy** (mock-data shape and volume; voice) · **Where the other musts live** (musts not on primary screens → their route)

## design-review-vN.md (critic)
Header · Screens reviewed (route → png path) · Score table (design-review rubric) · Journey walk (step → route → what you saw) · Must visibility (R-ID → claimed route → seen? yes/no) · **Top fixes (≤5)**: screen, problem, concrete change · Verdict: `ready` / `one more round`

## prototype-notes-vN.md (prototyper)
Header · **How to open** (`open artifacts/prototype/site/index.html`) · **Routes** · **Coverage** · **Defaults built on** · **Later questions** · Known gaps

```
## Coverage
| Req | Priority | Status | Where | Note |
|-----|----------|--------|-------|------|
| R1  | must     | shown   | #/compare | main grid |
| R2  | must     | partial | #/compare?state=skipped | read failure stubbed |
| R7  | must     | deferred | — | reason: needs real auth; user agreed at C2 |
```
Every `[must]` from the approved discovery doc has a row. `shown` and `partial` need a `#route`; `deferred` needs `reason:`. Hook-checked.

## validation-kit-vN.md (validator)
Header · Assumptions to test (question · who answers · confirms vs refutes · consequence) · Task scenarios (task · `#route` · observable pass/fail, stated beforehand; ≥1 designed to fail informatively) · Session guide · Results template (blank tables). No simulated content.

## Briefs
Exempt from the header. See the `brief` skill.
