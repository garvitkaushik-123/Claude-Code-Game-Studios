# Story 003: Loop closure & territory claim

> **Epic**: territory-rush
> **Status**: In Progress
> **Layer**: Core
> **Type**: Logic
> **Estimate**: coarse
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: 2026-10-16

## Context

**GDD**: `design/game-brief.md`
**Requirement**: Brief MVP feature 3

**ADR Governing Implementation**: N/A (minimal — no ADRs)
**ADR Decision Summary**: N/A (minimal — no ADRs)
**ADR Version**: N/A (minimal — no ADRs)

**Engine**: Godot 4.6 | **Risk**: HIGH (VERSION.md rates 4.6 HIGH)
**Engine Notes**: none (no ADR engine-compatibility analysis at minimal)

**Control Manifest Rules (this layer)**: N/A (minimal — no control manifest)

Closing a loop back onto owned land claims all enclosed cells.

---

## Acceptance Criteria

*From `design/game-brief.md` (Player goal & fail state + MVP feature 3), scoped to this story:*

- [ ] When the head re-enters its own territory with a non-empty trail, the loop is considered closed.
- [ ] All cells enclosed by the trail plus owned land become owned by the player (flood fill from outside the bounding region; anything not reachable from the border is enclosed).
- [ ] The trail cells themselves become owned and the trail list is cleared.
- [ ] Enclosed cells that belonged to rivals are taken by the player (their territory shrinks accordingly).
- [ ] Concave and L-shaped loops are filled correctly; a trail that touches the grid edge still resolves correctly.
- [ ] A 'there and back' trail (no enclosed area) claims only the trail cells.
- [ ] Claim of a 60x60 grid completes within the 16.6 ms frame budget (measure and record).
- [ ] Closing a loop visibly claims land (retained screenshot).

---

## Implementation Notes

- This is the riskiest logic: write the fill as a pure function over `GridModel` and unit-test it with fixture grids. Prefer iterative BFS to avoid recursion limits.

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
**Required evidence**: `tests/unit/territory-rush/loop-closure-claim_test.gd` (advisory at minimal) + a launch-and-observe screenshot in `production/qa/evidence/` where player-visible

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 002
- Unlocks: Story 004
