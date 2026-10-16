extends Node2D
## Story 001 bootstrap: builds model, view, placeholder head and camera.
## The head/arrow-key movement is throwaway until story 002.

const PLAYER_ID: int = 1


func _ready() -> void:
	var config := GridConfig.load_from()
	var model := GridModel.new(config.grid_size())
	var view := GridView.new()
	view.setup(model, config)
	add_child(view)

	var spawn := Vector2i(config.grid_width / 2, config.grid_height / 2)
	model.assign_start_territory(spawn, PLAYER_ID, config.start_territory_size)

	var head := PlaceholderHead.new()
	head.speed_px_per_sec = config.placeholder_head_speed_px_per_sec
	head.color = config.player_color.darkened(0.25)
	head.bounds = Rect2(Vector2.ZERO, config.world_size())
	head.position = (Vector2(spawn) + Vector2(0.5, 0.5)) * float(config.cell_size_px)
	add_child(head)

	var cam := FollowCamera.new()
	add_child(cam)
	cam.setup(head, config)
