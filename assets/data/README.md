# assets/data

## grid_config.json (Territory Rush, stories 001-002)

Loaded by `src/grid/grid_config.gd` (`GridConfig.load_from`). Missing file or
missing keys fall back to the in-code defaults in `GridConfig`.

| Key | Meaning |
|-----|---------|
| `grid_width`, `grid_height` | Arena size in cells (default 60 x 60). |
| `cell_size_px` | Side of one cell in world pixels. |
| `start_territory_size` | Side (cells) of the square start territory given to a player; odd values centre on the spawn cell. |
| `camera_smoothing_speed` | Camera2D position smoothing speed; higher follows tighter. |
| `neutral_color` | Hex colour of unowned (owner 0) cells. |
| `grid_line_color` | Hex colour of the faint cell grid lines. |
| `player_color` | Hex colour of owner id 1 (the player). |
| `rival_colors` | Hex colours for owner ids 2, 3, ... in order (cycled if more rivals than colours). |
| `ticks_per_second` | Fixed logic ticks per second; the head moves one cell per tick (speed = this x `cell_size_px` px/s). Default 5.5. |
| `min_swipe_distance_px` | Screen pixels a drag must travel before it turns the head; smaller drags/taps are ignored. Default 24. |
| `trail_lighten` | 0..1; trail colour = owner colour lightened by this amount. Default 0.35. |
| `trail_alpha` | 0..1; opacity of trail cells drawn over the grid. Default 0.55. |
