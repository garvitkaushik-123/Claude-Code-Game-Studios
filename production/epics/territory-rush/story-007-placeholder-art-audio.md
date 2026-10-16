# Story 007: Placeholder art/audio & asset hook

> **Epic**: territory-rush
> **Status**: Ready
> **Layer**: Presentation
> **Type**: Visual/Feel
> **Estimate**: coarse
> **Manifest Version**: N/A (minimal — no control manifest)
> **Last Updated**: —

## Context

**GDD**: `design/game-brief.md`
**Requirement**: Brief MVP feature 7

**ADR Governing Implementation**: N/A (minimal — no ADRs)
**ADR Decision Summary**: N/A (minimal — no ADRs)
**ADR Version**: N/A (minimal — no ADRs)

**Engine**: Godot 4.6 | **Risk**: HIGH (VERSION.md rates 4.6 HIGH)
**Engine Notes**: none (no ADR engine-compatibility analysis at minimal)

**Control Manifest Rules (this layer)**: N/A (minimal — no control manifest)

Original generated placeholder visuals and sounds, plus a drop-in override for user assets.

---

## Acceptance Criteria

*From `design/game-brief.md` (Player goal & fail state + MVP feature 7), scoped to this story:*

- [ ] All visuals use original generated placeholder art (flat colors, simple shapes); no third-party or extracted assets are used.
- [ ] Each player has a distinct color/skin palette defined in data.
- [ ] Short synthesized sound effects exist for claim, kill, death and run-end (original, generated in-project).
- [ ] An asset resolver loads `assets/art/<name>.png` and `assets/audio/<name>.ogg|wav` when present, otherwise falls back to the placeholder.
- [ ] Dropping a file named `skin_01_head.png` (naming convention documented) replaces the placeholder with no code change.
- [ ] Audio has a mute toggle and volume is data-driven.
- [ ] Placeholder generation scripts live under `tools/` and outputs under `assets/`.
- [ ] Retained screenshot of the final look and a note on the override convention.

---

## Implementation Notes

- Generate PNGs with a small script (Python/Pillow or Godot script) and sound blips via a script; commit outputs. Do not copy assets from any other game. Document the naming convention in `assets/README.md`.

---

## Out of Scope

*Handled by neighbouring stories — do not implement here:* later/earlier stories in this epic.

---

## QA Test Cases

*N/A — no qa-lead specs at this tier; implement against the Acceptance Criteria above.*

---

## Test Evidence

*Governed by `qa.level: minimal`: tests are waived (advisory); a retained screenshot for anything player-visible is not.*

**Story Type**: Visual/Feel
**Required evidence**: Retained screenshot in `production/qa/evidence/` + sign-off in `production/qa/evidence/placeholder-art-audio-evidence.md`

**Status**: [ ] Not yet created

---

## Dependencies

- Depends on: Story 006
- Unlocks: None
