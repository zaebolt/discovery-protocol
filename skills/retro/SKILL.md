---
description: Close a discovery-protocol-v3 run — promote RETRO-draft lessons to local and global memory.
---

# Retro (draft-first, lessons expire)

Trigger: End at any checkpoint, "stop and retro", or a failure-mode exit.

Capture has already happened in `./RETRO-draft.md`. This step only promotes lessons. If the user declines, the draft stays on disk for the next run.

## 1. Assemble (short)

Include: the date, the problem in one line, the stages reached, the exit reason, the selected concept, the prototype path, and how the questions went (how many asked, answered, and left as defaults, and whether the user showed fatigue). Then list what worked, what didn't, and the lessons, seeded from the draft. Note the user's verdict on the prototype in their own words if they gave one.

## 2. Classify

- **Local** (`./RETRO.md`): facts about this product or domain. Misleading anywhere else.
- **Global** (`~/.claude/discovery-protocol-v3/RETRO.md`): how the protocol works, independent of product. Promote a lesson only if it recurred, or if the user marks it as general.

Every global lesson gets a **`Retire when:`** line, meaning the evidence that would show it's no longer needed. A lesson without an expiry turns into a permanent rule nobody remembers the reason for.

## 3. Present, then write on confirm

Show the local entry and the proposed global changes separately: Confirm / Edit / Decline. On confirm:
- Prepend the local entry to `./RETRO.md`.
- Update the global file: add new lessons, sharpen existing ones, and **delete any lesson whose `Retire when` condition has been met.** Keep the file under 80 lines, because only that much is loaded. Merge or drop lessons to stay under.
- Delete `./RETRO-draft.md`.

Then end the run.
