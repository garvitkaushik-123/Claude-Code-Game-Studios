class_name DemoDriver
extends Node
## DEBUG ONLY: scripted steering for launch-and-observe screenshots without
## manual input. Created by main.gd only when the user arg [code]--demo-path[/code]
## is passed (e.g. [code]godot --path . res://src/main.tscn -- --demo-path[/code]).
## Never part of the normal run path. Same signal contract as SwipeInput.

signal direction_requested(dir: Vector2i)

## [tick, direction] pairs. Includes a 180-degree reversal at tick 3 (must be ignored).
## Path: right 6, (ignored left), down 4, left 7, up -> re-enters the 3x3 start
## territory at tick 20 (loop closes, enclosed land is claimed, trail cleared),
## then keeps heading up and leaves land again at tick 23 (fresh trail), proving
## story 002 behaviour survives a claim.
const STEPS: Array = [
	[0, Vector2i.RIGHT],
	[3, Vector2i.LEFT],
	[6, Vector2i.DOWN],
	[10, Vector2i.LEFT],
	[17, Vector2i.UP],
]

var _state: PlayerState


## Starts the script against [param state]; fires tick-0 steps immediately.
func setup(state: PlayerState) -> void:
	_state = state
	state.ticked.connect(_on_ticked)
	_fire(0)


func _on_ticked(tick_count: int) -> void:
	_fire(tick_count)


func _fire(tick_count: int) -> void:
	for step: Array in STEPS:
		if int(step[0]) == tick_count:
			direction_requested.emit(step[1] as Vector2i)
