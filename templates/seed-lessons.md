# Global lessons — discovery-protocol-v3

Distilled from ~15 runs of earlier versions of this protocol.
Each lesson names when to retire it. Keep this file short: it is injected into every
session of an active run, and only the first 80 lines load.

1. **Framing pays for itself — keep it small.** Checkpoint 0 surfaced the load-bearing facts
   (scope, equality semantics, N-way vs pairwise) before any expensive work, in every run.
   Retire when: never; resize only.
2. **Ask three things at framing:** what "match/same/done" means exactly (don't default to a
   softer version), what product surface this lives in (host product), and whether a likely
   answer implies persistent or shared state. Each one, discovered late, cost a revision cycle.
   Retire when: two runs in a row surface all three at framing without being told.
3. **Guess-with-default questions get answered in one line — keep each guess atomic.** A guess
   that bundles two claims gets a bundled "yes" that hides which half was confirmed.
   Retire when: never.
4. **Blind critic means the bar is in no file the critic reads.** Not in STATE, not in the
   retro, not in the brief. Use forced rank + kill + bet; no absolute threshold.
   Retire when: never.
5. **Unasked questions raised mid-build are parking-lot material, not the next checkpoint's
   headline.** Builders and critics will keep finding questions; only ones that block the
   primary journey reach the user now. Retire when: two runs end without question fatigue.
6. **A sketch's visual language gets lifted into the build.** Sketches stay greyscale wireframes
   and are never handed to the prototyper as input — the concept's journey and the design
   direction are. Retire when: two runs show prototypes that look nothing like their sketches.
7. **Requirement text on screen is the cheapest way to "prove" coverage — and it ruins the UI.**
   Coverage lives in prototype-notes; the surface check blocks IDs on screen. More [must]s make
   a worse prototype: the best-designed build so far carried 9.
   Retire when: never.
8. **A real render catches what logic checks miss.** Always screenshot before presenting.
   Retire when: never.
9. **Clean run by default.** Never import a prior run's answers as facts; at most, ask them as
   questions. Retire when: never.
