# Story 006: Timer, HUD & run-end

> **Epic**: territory-rush
> **Status**: Ready
> **Layer**: Presentation
> **Type**: UI
> **Estimate**: coarse
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: Brief MVP feature 6

**ADR Governing Implementation**: N/A (minimal — no ADRs)
**ADR Decision Summary**: N/A (minimal — no ADRs)
**ADR Version**: N/A (minimal — no ADRs)

**Engine**: Godot 4.6 | **Risk**: HIGH (VERSION.md rates 4.6 HIGH)
**Engine Notes**: none (no ADR engine-compatibility analysis at minimal)

**Control Manifest Rules (this layer)**: N/A (minimal — no control manifest)

Two-minute timer, live territory share, and run-end screen with restart.

---

## Acceptance Criteria

*From `design/game-brief.md` (Player goal & fail state + MVP feature 6), scoped to this story:*

- [ ] A 2-minute countdown (data-driven) is shown on the HUD and starts at run start.
- [ ] The HUD shows the player's territory share as a percentage, updated as it changes.
- [ ] The run ends when the timer reaches 0 or the player is eliminated.
- [ ] The run-end screen shows final territory %, rank among players and the end reason.
- [ ] A Restart button begins a fresh run with state fully reset.
- [ ] HUD and run-end layout work in portrait and landscape and respect safe areas.
- [ ] All text uses scalable theme fonts, no hardcoded sizes.
- [ ] Retained screenshots of the HUD and the run-end screen.

---

## Implementation Notes

- UI in `CanvasLayer` Control nodes; reset by reloading the game scene. Use Godot Theme resources.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:* later/earlier stories in this epic.

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above.*

---

## Test Evidence

*Governed by `qa.level: minimal`: tests are waived (advisory); a retained screenshot for anything player-visible is not.*

**Story Type**: UI
**Required evidence**: Retained screenshot of each screen touched, in `production/qa/evidence/`

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 005
- Unlocks: Story 007
