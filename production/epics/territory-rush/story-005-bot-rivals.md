# Story 005: Bot rivals

> **Epic**: territory-rush
> **Status**: Ready
> **Layer**: Feature
> **Type**: Logic
> **Estimate**: coarse
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: Brief MVP feature 5

**ADR Governing Implementation**: N/A (minimal — no ADRs)
**ADR Decision Summary**: N/A (minimal — no ADRs)
**ADR Version**: N/A (minimal — no ADRs)

**Engine**: Godot 4.6 | **Risk**: HIGH (VERSION.md rates 4.6 HIGH)
**Engine Notes**: none (no ADR engine-compatibility analysis at minimal)

**Control Manifest Rules (this layer)**: N/A (minimal — no control manifest)

4-6 AI rivals that expand, hunt weak trails and return home.

---

## Acceptance Criteria

*From `design/game-brief.md` (Player goal & fail state + MVP feature 5), scoped to this story:*

- [ ] 4-6 bots (count data-driven) spawn on separated start territories at run start.
- [ ] Each bot cycles wander -> expand (leave home, draw a loop, return) -> return-home when its trail is long.
- [ ] A bot hunts a rival trail it can reach before the rival closes it, with a bounded chance (difficulty knob).
- [ ] Bots use the same movement, trail, claim and collision rules as the player.
- [ ] A bot avoids stepping onto its own trail and avoids leaving the grid.
- [ ] Eliminated bots respawn after a data-driven delay, or not at all per a setting.
- [ ] Bot behavior parameters (aggression, loop size, reaction delay) are data-driven.
- [ ] A run with bots shows them competing for territory (retained screenshot).

---

## Implementation Notes

- Model bots as a small state machine in `BotController`; decisions at cell boundaries only. Seed the RNG for tests.

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
**Required evidence**: `tests/unit/territory-rush/bot-rivals_test.gd` (advisory at minimal) + a launch-and-observe screenshot in `production/qa/evidence/` where player-visible

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 004
- Unlocks: Story 006
