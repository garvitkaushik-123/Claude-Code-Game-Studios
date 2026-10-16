# Epic: Territory Rush

**Goal:** Swipe to steer a pen out of your safe zone, close the loop to claim land, and cut rivals' trails to take them out, all in a 2-minute arena run.

**Source:** `design/game-brief.md` (minimal tier — no GDD/ADR/TR registry).

**Scope (MVP):** grid + camera, steering + trail, loop closure, collisions, bot rivals, timer/HUD/run-end, original placeholder art/audio with an `assets/` override hook.

**Ordering (brief build order):** 001 -> 002 -> 003 -> 004 -> 005 -> 006 -> 007. Loop closure (003) is the riskiest logic and is built before bots and polish.

## Stories

| # | Story | Type | Status | ADR |
|---|-------|------|--------|-----|
| 001 | Grid, ownership & camera | Logic | Complete | N/A |
| 002 | Steering & trail | Logic | Complete | N/A |
| 003 | Loop closure & territory claim | Logic | Ready | N/A |
| 004 | Collisions & elimination | Integration | Ready | N/A |
| 005 | Bot rivals | Logic | Ready | N/A |
| 006 | Timer, HUD & run-end | UI | Ready | N/A |
| 007 | Placeholder art/audio & asset hook | Visual/Feel | Ready | N/A |
