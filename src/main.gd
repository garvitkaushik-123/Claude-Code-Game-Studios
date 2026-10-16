extends Node2D
## Bootstrap: builds grid model/view, the player (state, trail view, head, input)
## and the follow camera. Implements stories 001-002 of the territory-rush epic.

const PLAYER_ID: int = 1
## Debug-only user arg (after "--") that replaces player input with a scripted path.
const DEMO_ARG: String = "--demo-path"


func _ready() -> void:
	var config := GridConfig.load_from()
	var model := GridModel.new(config.grid_size())
	var view := GridView.new()
	view.setup(model, config)
	add_child(view)

	var spawn := Vector2i(config.grid_width / 2, config.grid_height / 2)
	model.assign_start_territory(spawn, PLAYER_ID, config.start_territory_size)

	var state := PlayerState.new(model, PLAYER_ID, spawn)

	var trail_view := TrailView.new()
	trail_view.setup(state, model.get_size(), config)
	add_child(trail_view)

	var head := PlayerHead.new()
	head.setup(state, config)
	add_child(head)

	if OS.get_cmdline_user_args().has(DEMO_ARG):
		var demo := DemoDriver.new()
		add_child(demo)
		demo.direction_requested.connect(state.request_direction)
		demo.setup(state)
	else:
		var swipe := SwipeInput.new()
		swipe.min_distance_px = config.min_swipe_distance_px
		swipe.direction_requested.connect(state.request_direction)
		add_child(swipe)

	var cam := FollowCamera.new()
	add_child(cam)
	cam.setup(head, config)
