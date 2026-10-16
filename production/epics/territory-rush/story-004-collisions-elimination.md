# Story 004: Collisions & elimination

> **Epic**: territory-rush
> **Status**: Ready
> **Layer**: Core
> **Type**: Integration
> **Estimate**: coarse
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: Brief MVP feature 4

**ADR Governing Implementation**: N/A (minimal — no ADRs)
**ADR Decision Summary**: N/A (minimal — no ADRs)
**ADR Version**: N/A (minimal — no ADRs)

**Engine**: Godot 4.6 | **Risk**: HIGH (VERSION.md rates 4.6 HIGH)
**Engine Notes**: none (no ADR engine-compatibility analysis at minimal)

**Control Manifest Rules (this layer)**: N/A (minimal — no control manifest)

Trail and head collisions eliminate players.

---

## Acceptance Criteria

*From `design/game-brief.md` (Player goal & fail state + MVP feature 4), scoped to this story:*

- [ ] A player whose head enters one of its own trail cells is eliminated.
- [ ] A head entering any rival's trail cell eliminates that rival (the owner of the trail), not the cutter.
- [ ] Head-on collision (two heads on the same cell) eliminates the player with the shorter trail; equal length eliminates both.
- [ ] Leaving the grid bounds eliminates the player.
- [ ] Elimination clears the player's trail and releases or removes their territory per a data-driven rule (default: territory removed).
- [ ] The player's elimination ends the run and raises a `run_ended` signal with the reason.
- [ ] Collision checks use the grid, not physics nodes.
- [ ] A kill is visibly resolved on screen (retained screenshot).

---

## Implementation Notes

- Use a single `CollisionResolver` run each tick after movement. Keep rules in data (`collision_rules.json`) where practical.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:* later/earlier stories in this epic.

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above.*

---

## Test Evidence

*Governed by `qa.level: minimal`: tests are waived (advisory); a retained screenshot for anything player-visible is not.*

**Story Type**: Integration
**Required evidence**: `tests/integration/territory-rush/collisions-elimination_test.gd` (advisory) + retained screenshot in `production/qa/evidence/`

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 003
- Unlocks: Story 005
