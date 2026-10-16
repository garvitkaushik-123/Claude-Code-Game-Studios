class_name FollowCamera
extends Camera2D
## Smoothly follows a target node and never shows beyond the grid edge.
## Implements: design/game-brief.md MVP feature 1 (story 001).
##
## Usage:
##   var cam := FollowCamera.new()
##   add_child(cam)
##   cam.setup(head_node, config)

var _target: Node2D


## Sets the node to follow and applies smoothing + grid-edge limits from [param config].
func setup(target: Node2D, config: GridConfig) -> void:
	_target = target
	var world: Vector2 = config.world_size()
	limit_left = 0
	limit_top = 0
	limit_right = int(world.x)
	limit_bottom = int(world.y)
	limit_smoothed = true
	position_smoothing_enabled = true
	position_smoothing_speed = config.camera_smoothing_speed
	global_position = target.global_position
	make_current()
	reset_smoothing()


func _process(_delta: float) -> void:
	if is_instance_valid(_target):
		global_position = _target.global_position
