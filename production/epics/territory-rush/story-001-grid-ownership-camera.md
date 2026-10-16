# Story 001: Grid, ownership & camera

> **Epic**: territory-rush
> **Status**: Complete
> **Layer**: Foundation
> **Type**: Logic
> **Estimate**: coarse
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: 2026-10-16

## Context

**GDD**: `design/game-brief.md`
**Requirement**: Brief MVP feature 1

**ADR Governing Implementation**: N/A (minimal — no ADRs)
**ADR Decision Summary**: N/A (minimal — no ADRs)
**ADR Version**: N/A (minimal — no ADRs)

**Engine**: Godot 4.6 | **Risk**: HIGH (VERSION.md rates 4.6 HIGH)
**Engine Notes**: none (no ADR engine-compatibility analysis at minimal)

**Control Manifest Rules (this layer)**: N/A (minimal — no control manifest)

Grid data model with per-cell owner, a tile renderer, a follow-camera, and a starting territory for the player.

---

## Acceptance Criteria

*From `design/game-brief.md` (Player goal & fail state + MVP feature 1), scoped to this story:*

- [x] Grid is a fixed-size 2D array of cells (size read from a data file, default 60x60); each cell stores an owner id (0 = unowned).
- [x] Grid exposes `get_owner(cell)`, `set_owner(cell, id)`, `in_bounds(cell)` and a cell-changed signal.
- [x] A 3x3 starting territory is assigned to the player at run start, and `territory_share(id)` returns owned cells / total cells.
- [x] The grid renders each owner in a distinct flat color; unowned cells render as the neutral background.
- [x] A camera follows the player head smoothly and never shows beyond the grid edge.
- [x] Grid size, cell pixel size and start-territory size are data-driven, not hardcoded.
- [x] Launching the game shows the grid with the player's start territory (retained screenshot).

---

## Implementation Notes

- Use a typed `GridModel` (RefCounted) separate from rendering so it is unit-testable; render with one `TileMapLayer` or a single `_draw`/MultiMesh pass, not a Node per cell. Check `docs/engine-reference/godot/` for 4.6 TileMapLayer API before use.

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
**Required evidence**: `tests/unit/territory-rush/grid-ownership-camera_test.gd` (advisory at minimal) + a launch-and-observe screenshot in `production/qa/evidence/` where player-visible

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: None
- Unlocks: Story 002

---

## Completion Notes

**Completed**: 2026-10-16 — verdict COMPLETE WITH NOTES. 7/7 acceptance criteria pass.
**Evidence**: `production/qa/evidence/story-001-grid-ownership-camera/01-start-territory.png`; headless GridModel self-check (exit 0); camera follow/clamp check (exit 0); parse check on all 6 scripts (exit 0). Tests waived at `qa.level: minimal`.
**Deferred**: camera smoothing *feel* (needs a playtest — `/team-qa`).
**Advisory**:
- In-code fallback defaults (60x60, 48 px, colors) mirror `assets/data/grid_config.json`; real values come from the data file.
- `PLAYER_ID = 1` is a constant in `src/main.gd`; story 005 (bots) needs a proper player registry.
- Godot 4.6 Camera2D / Image / `draw_texture_rect` APIs are not covered by `docs/engine-reference/godot/`; they ran cleanly in 4.6 but are unchecked against the reference.
