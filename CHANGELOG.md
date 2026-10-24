# Changelog

## 0.2.1 — 2026-10-24

Fixes from the first full v3 run's retro.

- **Full-page screenshots:** `shoot.sh` now writes `<route>.full.png` next to each viewport shot, with inner scroll areas expanded so fixed app shells (header + scrolling main panel) are captured too. Before this, the critic never saw content below the fold.
- **Group legibility:** the design review gains a *Structure legibility* score, checked on the full shots: in long lists and tables, can you tell where each group starts and ends? prototype-craft gains the matching build guidance. A user had rejected an undivided grid that passed review twice.
- **Data at real scale:** the discovery doc gains a required **Scale & shape** section (counts, hierarchy depth, extremes), enforced by the post-write check. The prototyper builds mock data to it, and the critic compares against it. A prototype had modelled 22 flat settings where the real thing has ~100 in 9 categories.
- **No skill-name collisions:** agents and briefs use full skill names (`discovery-protocol-v3:concept-scoring`). `scaffold.sh` writes `.dp3/plugin-root` so a skill that fails to load is read from this plugin, never from a same-named skill elsewhere. An older `concept-scoring` with a passing score had nearly leaked into blind scoring.
- **No re-asked questions:** researcher briefs carry a *Settled* list of answered and defaulted questions. The researcher checks every question against the user's verbatim words, and the Lead drops any already-answered question before presenting.

## 0.2.0 — 2026-10-24

Restores research depth to the single discovery doc. In 0.1.0, consolidating discovery into one file also dropped most of the research: a real run shipped with one line per user, no stakeholders, and no competitive research.

- **Discovery doc sections:** new **Personas** (context, goals, pain points, jobs to be done, current journey with friction marked), **Stakeholders** (interest, what success means to them, influence), and **Competitive & adjacent landscape** (host-product features, alternatives, workarounds, each with a source, ending in *The gap*). These replace "Users & context" and "Current state".
- **Researcher:** does web research for the landscape before writing, and traces each need back to a persona's pain point.
- **Hook:** the post-write check blocks a discovery doc that is missing personas, stakeholders, the landscape, or pain points.
- **Critic:** the discovery-review rubric gains a *Research depth* dimension.
- **Concepts:** each concept names the persona it is for and the pain points it relieves.

## 0.1.0 — 2026-10-23

First public version. It's the successor to [design-centered-workflow](https://github.com/zaebolt/design-centered-workflow) and to several unpublished intermediate versions.

- **Stages:** framing → one discovery doc → concepts + wireframe sketches of the top 2 → design-directed static HTML prototype → optional validation kit.
- **Question budget:** at most 5 questions per checkpoint, written as a guess with a default and naming what the answer would change. Other questions go to an uncapped *Later questions* list. Hook-enforced.
- **Must cap:** at most 12 must-have requirements. Hook-enforced; adjustable in STATE.
- **Design reference:** asked at kickoff (design system, host product, or none). The prototyper writes a design direction before building.
- **Prototype review:** the critic screenshots every route with headless Chrome and reviews against a design rubric, with up to 2 fix rounds.
- **Surface check:** blocks requirement IDs and protocol words in the prototype's visible text.
- **Blind concept scoring:** forced ranking with a kill and a bet; no absolute threshold.
- **Lessons:** a global lessons file seeded with 9 lessons, each with a `Retire when:` condition. Only the first 80 lines load.
