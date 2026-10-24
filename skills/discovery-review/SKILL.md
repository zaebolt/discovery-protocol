---
description: Critic rubric for the discovery-protocol-v3 discovery doc (provenance, scope, question budget).
---

# Discovery review (critic)

Score each dimension 1–10 with a one-line justification. 5 means adequate. There is no passing score.

- **Provenance** *(weight heaviest)*: requirements rest on register entries with honest source tags. No confident prose rests on inferred, unconfirmed claims. Each A-ID holds one claim. Every must with a weak basis is `[provisional]`.
- **Question quality**: each of the ≤5 questions would change the concept choice or the primary journey if answered differently. Each is atomic, and its default is a reasonable bet. Penalise questions that are curiosity, homework, or already answered. A great doc asks fewer questions.
- **Must discipline**: the musts are the few things without which the product fails its users. Penalise padding, near-duplicates, and musts that are really implementation detail.
- **Scope clarity**: in scope and out of scope are explicit and defensible. The key term (what "match", "done" or "same" means) is pinned down.
- **Consistency**: needs, requirements, and the register agree. Nothing contradicts a user-stated fact.
- **What vs how**: no screens, layout, or technology in the requirements. Describing how things work today under *Current state* is fine.

Write `artifacts/discovery/discovery-review-vN.md`: score table, overall mean (one decimal), provenance findings (claim → section → A-ID), question-budget findings (which question to cut, sharpen, or move to Later), and **at most 5 top fixes**, each addressed to the researcher.
