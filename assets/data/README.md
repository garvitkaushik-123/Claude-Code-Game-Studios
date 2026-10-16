# assets/data

## grid_config.json (Territory Rush, story 001)

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
| `placeholder_head_speed_px_per_sec` | Arrow-key speed of the throwaway story-001 head; removed by story 002. |
