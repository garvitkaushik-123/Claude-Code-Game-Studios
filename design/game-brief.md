# Game Brief: Territory Rush

**One-sentence pitch:** Swipe to steer a pen out of your safe zone, close the loop to claim land, and cut rivals' trails to take them out, all in a 2-minute arena run.

## Core loop
- Leave your territory and draw a trail by swiping to steer.
- Return to your own land and the loop closes, so everything enclosed becomes yours.
- Cross a rival's trail to eliminate them, and avoid your own trail and the rivals' heads.
- The run ends, the score shows, and you start another.

## Player goal & fail state — what "working" looks like
- Hold the largest territory share when the 2-minute timer ends (score = % of the grid owned).
- You fail if your head touches your own trail, a rival crosses your trail, or you leave the grid edge. A new run starts from the run-end screen.

## MVP — what must exist to be the game
1. Grid with territory ownership and a camera that follows the player.
2. Swipe steering with a trail that grows behind the head.
3. Loop closure that flood-fills and claims enclosed land.
4. Trail collision: self-kill and kills on rivals.
5. 4–6 bot rivals with simple behavior (wander, expand, hunt a weak trail).
6. Timer, territory-share HUD and a run-end screen with restart.
7. Original generated placeholder art and sound, with an `assets/` hook for later swaps.

## Out of scope — not building this
- No multiplayer, accounts or leaderboards.
- No shop, skins, power-ups, chests or progression.
- No ads, IAP or analytics.
- No multiple arenas or modes.

## Build order
1. Grid and ownership data, camera.
2. Steering and trail.
3. Loop closure and flood fill (the riskiest logic, so first).
4. Collision and kills.
5. Bots.
6. HUD, timer and run-end.
7. Placeholder art and audio pass.

---
**Who it's for / what they feel:** Casual mobile players who want a tense 2-minute greed-versus-safety hit ("just one more loop").

**Art & audio direction:** Flat, saturated colors on a clean grid, one color per player, with short synth blips. Placeholders are generated in-project; the user's own files drop into `assets/` later.

**Reference game:** Paper.io 2. The MVP keeps the trail, loop-capture and cut-the-trail mechanic on one arena, and drops skins, chests, modes and monetization.
