class_name GridConfig
extends RefCounted
## Data-driven grid/camera settings loaded from assets/data/grid_config.json.
## Implements: design/game-brief.md MVP feature 1 (story 001); steering/trail keys added in story 002.
##
## Usage:
##   var config := GridConfig.load_from()
##   var model := GridModel.new(config.grid_size())

const DEFAULT_PATH: String = "res://assets/data/grid_config.json"

var grid_width: int = 60
var grid_height: int = 60
var cell_size_px: int = 48
var start_territory_size: int = 3
var camera_smoothing_speed: float = 5.0
var neutral_color: Color = Color("#e8ecef")
var grid_line_color: Color = Color("#d3d9de")
var player_color: Color = Color("#2e86de")
var rival_colors: Array[Color] = [Color("#e84a5f"), Color("#2ecc71"), Color("#f6b93b")]
## Fixed logical ticks (cells moved) per second; head speed = this * cell_size_px.
var ticks_per_second: float = 5.5
## Minimum drag distance (screen px) before a swipe turns the head.
var min_swipe_distance_px: float = 24.0
## Trail tint = owner colour lightened by this amount (0..1)...
var trail_lighten: float = 0.35
## ...and drawn with this alpha (0..1).
var trail_alpha: float = 0.55


## Loads the config from [param path]; returns defaults if the file is missing or invalid.
## Example: [code]var cfg := GridConfig.load_from("res://assets/data/grid_config.json")[/code]
static func load_from(path: String = DEFAULT_PATH) -> GridConfig:
	var config := GridConfig.new()
	if not FileAccess.file_exists(path):
		push_warning("GridConfig: %s missing, using defaults." % path)
		return config
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not parsed is Dictionary:
		push_warning("GridConfig: %s is not a valid JSON object, using defaults." % path)
		return config
	config._apply(parsed as Dictionary)
	return config


## Grid dimensions in cells.
func grid_size() -> Vector2i:
	return Vector2i(grid_width, grid_height)


## World-pixel size of the whole grid.
func world_size() -> Vector2:
	return Vector2(grid_width * cell_size_px, grid_height * cell_size_px)


## Colour for an owner id: 0 neutral, 1 player, 2+ rivals (cycled).
func color_for_owner(owner_id: int) -> Color:
	if owner_id <= 0:
		return neutral_color
	if owner_id == 1 or rival_colors.is_empty():
		return player_color
	return rival_colors[(owner_id - 2) % rival_colors.size()]


## Trail colour for an owner id: the owner colour, lightened and translucent.
func trail_color_for_owner(owner_id: int) -> Color:
	var c: Color = color_for_owner(owner_id).lightened(clampf(trail_lighten, 0.0, 1.0))
	c.a = clampf(trail_alpha, 0.0, 1.0)
	return c


func _apply(d: Dictionary) -> void:
	grid_width = maxi(1, int(d.get("grid_width", grid_width)))
	grid_height = maxi(1, int(d.get("grid_height", grid_height)))
	cell_size_px = maxi(1, int(d.get("cell_size_px", cell_size_px)))
	start_territory_size = maxi(1, int(d.get("start_territory_size", start_territory_size)))
	camera_smoothing_speed = float(d.get("camera_smoothing_speed", camera_smoothing_speed))
	ticks_per_second = maxf(0.1, float(d.get("ticks_per_second", ticks_per_second)))
	min_swipe_distance_px = maxf(0.0, float(d.get("min_swipe_distance_px", min_swipe_distance_px)))
	trail_lighten = float(d.get("trail_lighten", trail_lighten))
	trail_alpha = float(d.get("trail_alpha", trail_alpha))
	neutral_color = _color(d, "neutral_color", neutral_color)
	grid_line_color = _color(d, "grid_line_color", grid_line_color)
	player_color = _color(d, "player_color", player_color)
	var rivals: Variant = d.get("rival_colors", null)
	if rivals is Array and not (rivals as Array).is_empty():
		var parsed: Array[Color] = []
		for entry: Variant in rivals as Array:
			parsed.append(Color.from_string(str(entry), Color.MAGENTA))
		rival_colors = parsed


static func _color(d: Dictionary, key: String, fallback: Color) -> Color:
	if not d.has(key):
		return fallback
	return Color.from_string(str(d[key]), fallback)
