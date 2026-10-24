---
description: Conventions and quality bar for the discovery-protocol-v3 static HTML prototype.
---

# Prototype craft

The prototype answers one question for a PM, an engineer, or a user: *what would using this be like?* It succeeds if they react to the product, not to the prototype.

## Form

- **Static files in `artifacts/prototype/site/`**: `index.html`, `styles.css`, `app.js`, and `data.js` (split more if useful). It opens with `open index.html`. No npm, no bundler, no server, no fetch to localhost.
- Libraries are optional. If you use any, load them from a pinned CDN URL (for example a fixed version of Tailwind's CDN build, or a small icon set). Hand-written CSS built on custom-property tokens is usually better and always acceptable. Fonts from Google Fonts are fine.
- **Hash routing for everything that matters**: each journey step and each key state is addressable, as in `#/compare`, `#/compare?state=empty`, `#/item/prod-eu`. This lets the critic screenshot them, and you link them from the notes.
- Keep state in memory. `localStorage` is fine for "remembers my choice" behaviour, but every route must also render from a clean load.

## Design

- **Follow your design direction.** If there's a design reference (a design system or host product), match its look: colours, type, density, component shapes. If there isn't one, pick a clear stance and hold to it; the `frontend-design` skill helps you choose.
- **Build from the journey, not the requirement list.** Lay out the primary journey's screens first. Then place the remaining musts where a user would look for them, which is often a click away: a detail panel, a secondary tab, a row action, a settings view.
- **One primary focus per screen.** Create hierarchy with size, weight, and space before you reach for borders, boxes, and colour.
- **Avoid the default admin-panel look.** Don't box everything, don't stack full-width tables, don't use yellow warning banners as layout, and don't fill the page with badges. Earlier runs produced exactly this.
- **Sketches are not a reference.** Don't open them. Their look was meant to be thrown away.

## Content

- **Realistic mock data** shaped like the real domain, with real-sounding names, versions, and counts. Use enough volume to show the density problem the product solves, and seed the interesting cases: differences, outliers, failures, empty results.
- **Product copy only.** Use short labels and helpful empty states. Don't explain design choices on screen ("by design…", "this is not a severity…"). Never show requirement or assumption IDs, `[must]`, "provisional", or "PRD". A hook blocks these.
- At most one small, unobtrusive "Prototype" badge. No mock-data banners repeated across screens.

## Optional: open-assumptions overlay

If the prototype rests on defaults the user hasn't confirmed, you may add an overlay that is **off by default**, toggled by a small corner control or the `?` key. It pins plain-language notes to the relevant UI ("Assumes a match means byte-for-byte identical"). Use no IDs. It lets reviewers see what's assumed without cluttering the product.

## Done means

- Every route renders from a clean load, and you have looked at each one in a screenshot.
- The primary journey can be clicked through end to end.
- Every must has a coverage row with a `#route` (or a deferral reason).
- Nothing on screen would make a PM ask "why does it say that?"
