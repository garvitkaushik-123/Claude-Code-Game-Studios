# Story 002: Steering & trail

> **Epic**: territory-rush
> **Status**: Ready
> **Layer**: Core
> **Type**: Logic
> **Estimate**: coarse
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: Brief MVP feature 2

**ADR Governing Implementation**: N/A (minimal — no ADRs)
**ADR Decision Summary**: N/A (minimal — no ADRs)
**ADR Version**: N/A (minimal — no ADRs)

**Engine**: Godot 4.6 | **Risk**: HIGH (VERSION.md rates 4.6 HIGH)
**Engine Notes**: none (no ADR engine-compatibility analysis at minimal)

**Control Manifest Rules (this layer)**: N/A (minimal — no control manifest)

Swipe input steers a constant-speed head that leaves a trail when outside owned land.

---

## Acceptance Criteria

*From `design/game-brief.md` (Player goal & fail state + MVP feature 2), scoped to this story:*

- [ ] A swipe (and arrow keys for desktop testing) sets the head direction to one of 4 axes; reversing 180 degrees is ignored.
- [ ] The head moves at a constant speed (data-driven) and snaps to grid cells for ownership/trail logic.
- [ ] While the head is on a cell the player owns, no trail is drawn.
- [ ] On leaving owned land, each cell the head enters is added to the player's trail list and rendered in the trail color.
- [ ] The trail cells are unique and ordered; revisiting a trail cell is detected and reported (handled in story 004).
- [ ] Reaching the grid edge is reported as an out-of-bounds event (kill is handled in story 004).
- [ ] Swipe has a minimum distance threshold so taps/jitter do not turn the head.
- [ ] Launching the game and steering shows the head moving and a trail growing (retained screenshot).

---

## Implementation Notes

- Keep movement in a fixed tick so logic is deterministic; interpolate visually. Input handling in a small `SwipeInput` node emitting `direction_requested`. Mobile touch via `InputEventScreenDrag`/`InputEventScreenTouch`.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:* later/earlier stories in this epic.

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above.*

---

## Test Evidence

*Governed by `qa.level: minimal`: tests are waived (advisory); a retained screenshot for anything player-visible is not.*

**Story Type**: Logic
**Required evidence**: `tests/unit/territory-rush/steering-trail_test.gd` (advisory at minimal) + a launch-and-observe screenshot in `production/qa/evidence/` where player-visible

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 001
- Unlocks: Story 003
