---
description: Critic's screenshot-based design review of the discovery-protocol-v3 HTML prototype.
---

# Design review (critic)

You judge the prototype the way a design lead would in a crit, **from what renders, not from the code.**

## 1. Render

Take the route list from the design direction (and the notes, if they exist). Then run:

```bash
bash .dp3/shoot.sh artifacts/prototype/site/index.html artifacts/prototype/screens/review-vN /route1 /route2 …
```

Each route produces `<route>.png`, the viewport (what the user sees first), and, when there is more content, `<route>.full.png` (the whole page with scroll areas expanded). Open **every** PNG with Read, including the full shots. Most structural problems live below the fold. If a shot fails or comes out blank, that is a finding. Don't infer the screen from the source.

## 2. Score (1–10, one line each; there is no passing score)

- **5-second read**: the first screen makes its main point obvious immediately, as the design direction promised.
- **Journey**: you can walk the primary journey from entry to outcome through real navigation, and each step clearly leads to the next.
- **Hierarchy & density**: one primary focus per screen and progressive disclosure. It isn't a wall of tables, banners, and badges, and not every must is crammed onto one screen.
- **Structure legibility** *(check on the full shots)*: in long lists and tables, you can see at a glance where each group starts and ends, and a reader halfway down knows which group they're in (group headers, separation, repeated or sticky column headers). One long undivided grid scores low even when every row is correct. A user rejected exactly that after two passing reviews.
- **Visual craft**: type scale, spacing rhythm, alignment, colour restraint, and component consistency. It could pass as a shipped product.
- **Fit to reference**: it matches the stated design reference (design system or host product) as closely as the direction committed to.
- **Copy**: written in the product's voice. No explanations of design rationale on screen, no requirement-speak, no disclaimers beyond one small prototype badge.
- **Data realism**: the mock data is plausible and varied, and it **matches the discovery doc's *Scale & shape***: the stated counts, hierarchy depth and extremes, not a flattened sample. Compare the numbers explicitly; a design that only works at toy scale scores low. It shows the interesting cases (differences, failures, empty results), not lorem ipsum.
- **States**: the empty, error, and loading states that matter to the journey exist and can be reached by route.

## 3. Check claims

For each must marked `shown` or `partial` in the notes, go to its route and record whether you actually see it there.

## 4. Write `artifacts/prototype/design-review-vN.md`

Include: screens reviewed, the score table, the journey walk, must visibility, and **at most 5 top fixes, ordered by impact**. Each fix names the screen, what's wrong, and the concrete change ("Move the foundation picker into a compact header bar; the comparison grid should start above the fold"). Taste words alone ("make it cleaner") are not a fix.

End with a verdict: `ready` (show the user) or `one more round` (the fixes are worth another pass). The Lead allows at most 2 rounds.
