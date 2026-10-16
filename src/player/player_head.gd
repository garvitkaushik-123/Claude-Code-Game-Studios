class_name PlayerHead
extends Node2D
## Thin visual for a [PlayerState]: drives the fixed logical tick from frame time
## and interpolates the drawn position between cell centers. Holds no game rules.
## The visual lags the logical head by at most one tick (it arrives at a cell
## centre as the next tick fires), which keeps interpolation correct on turns.
## Implements: design/game-brief.md MVP feature 2 (story 002).
##
## Usage:
##   var head := PlayerHead.new()
##   head.setup(state, config)
##   add_child(head)

## Safety cap on ticks simulated in one frame (avoids a spiral after a long stall).
const MAX_TICKS_PER_FRAME: int = 4

var _state: PlayerState
var _step_seconds: float = 0.2
var _cell_px: float = 48.0
var _accumulator: float = 0.0
var _from: Vector2 = Vector2.ZERO
var _to: Vector2 = Vector2.ZERO
var _color: Color = Color.WHITE


## Binds to [param state] and places the head on its current cell.
func setup(state: PlayerState, config: GridConfig) -> void:
	_state = state
	_step_seconds = 1.0 / config.ticks_per_second
	_cell_px = float(config.cell_size_px)
	_color = config.player_color.darkened(0.25)
	_to = _cell_center(state.get_head_cell())
	_from = _to
	position = _to
	_state.head_moved.connect(_on_head_moved)
	queue_redraw()


## Accumulates [param delta], runs whole logical ticks, and updates the drawn
## position. Called from [method _process]; public so it can be driven in tests.
func advance(delta: float) -> void:
	if _state == null:
		return
	_accumulator += delta
	var ran: int = 0
	while _accumulator >= _step_seconds and ran < MAX_TICKS_PER_FRAME:
		_accumulator -= _step_seconds
		_from = _to # stays put unless the tick moves the head
		_state.tick()
		ran += 1
	if ran == MAX_TICKS_PER_FRAME:
		_accumulator = fposmod(_accumulator, _step_seconds)
	position = _from.lerp(_to, clampf(_accumulator / _step_seconds, 0.0, 1.0))


func _process(delta: float) -> void:
	advance(delta)


func _on_head_moved(_from_cell: Vector2i, to_cell: Vector2i) -> void:
	_to = _cell_center(to_cell)


func _cell_center(cell: Vector2i) -> Vector2:
	return (Vector2(cell) + Vector2(0.5, 0.5)) * _cell_px


func _draw() -> void:
	var radius: float = _cell_px * 0.3
	draw_circle(Vector2.ZERO, radius + 3.0, Color.WHITE)
	draw_circle(Vector2.ZERO, radius, _color)
