class_name PlayerState
extends RefCounted
## Pure, deterministic head movement + trail model (no scene dependencies).
## Logic advances only via [method tick]; callers decide how often.
## Implements: design/game-brief.md MVP feature 2 (story 002).
##
## Rules per tick: (1) a pending turn is applied (cell boundary), (2) the head
## moves one cell in its direction, (3) outside own land the entered cell is
## appended to the ordered unique trail. Cell ownership is never changed here.
## Not handled yet: loop closure/claim (story 003), kills (story 004) - this
## class only reports [signal trail_self_hit] and [signal out_of_bounds].
##
## Usage:
##   var state := PlayerState.new(grid, 1, Vector2i(30, 30))
##   state.request_direction(Vector2i.RIGHT)
##   state.tick()

## Emitted at the end of every [method tick] with the new tick count.
signal ticked(tick_count: int)
## Emitted when the head enters a new cell.
signal head_moved(from_cell: Vector2i, to_cell: Vector2i)
## Emitted when a pending turn is applied to the current direction.
signal direction_changed(direction: Vector2i)
## Emitted when a cell is appended to the trail (unique, in order).
signal trail_cell_added(cell: Vector2i)
## Emitted when the head enters a cell that is already in its own trail.
signal trail_self_hit(cell: Vector2i)
## Emitted instead of moving when the next cell is outside the grid.
## Fires on every blocked tick until the owner of this model reacts (story 004).
signal out_of_bounds(cell: Vector2i)
## Emitted when the head enters player-owned land (from non-owned) with a non-empty trail.
signal returned_home

var _grid: GridModel
var _owner_id: int
var _head_cell: Vector2i
var _direction: Vector2i = Vector2i.ZERO # ZERO = idle until the first request
var _pending: Vector2i = Vector2i.ZERO
var _trail: Array[Vector2i] = []
var _trail_set: Dictionary = {} # Vector2i -> true
var _tick_count: int = 0
var _on_home: bool


func _init(grid: GridModel, owner_id: int, start_cell: Vector2i) -> void:
	_grid = grid
	_owner_id = owner_id
	_head_cell = start_cell
	_on_home = grid.get_owner(start_cell) == owner_id


## True if [param dir] is one of the 4 unit axes.
static func is_axis_direction(dir: Vector2i) -> bool:
	return absi(dir.x) + absi(dir.y) == 1


## Requests a new heading, applied at the next [method tick] (next cell boundary).
## Ignored if not a unit axis, equal to the current heading, or a 180-degree
## reversal of it. The latest valid request before a tick wins.
## Returns true if the request was accepted.
func request_direction(dir: Vector2i) -> bool:
	if not is_axis_direction(dir):
		return false
	if dir == _direction or dir == -_direction:
		return false
	_pending = dir
	return true


## Advances the simulation by exactly one logical tick.
func tick() -> void:
	_tick_count += 1
	if _pending != Vector2i.ZERO:
		_direction = _pending
		_pending = Vector2i.ZERO
		direction_changed.emit(_direction)
	if _direction != Vector2i.ZERO:
		_step()
	ticked.emit(_tick_count)


## Cell the head currently occupies.
func get_head_cell() -> Vector2i:
	return _head_cell


## Current heading (Vector2i.ZERO before the first accepted request).
func get_direction() -> Vector2i:
	return _direction


## Heading queued for the next tick (Vector2i.ZERO if none).
func get_pending_direction() -> Vector2i:
	return _pending


## Owner id this state plays for.
func get_owner_id() -> int:
	return _owner_id


## Number of ticks simulated so far.
func get_tick_count() -> int:
	return _tick_count


## Copy of the ordered, unique trail cells (oldest first).
func get_trail() -> Array[Vector2i]:
	return _trail.duplicate()


## Number of cells in the trail.
func get_trail_size() -> int:
	return _trail.size()


## True if [param cell] is part of the trail.
func has_trail_cell(cell: Vector2i) -> bool:
	return _trail_set.has(cell)


func _step() -> void:
	var target: Vector2i = _head_cell + _direction
	if not _grid.in_bounds(target):
		out_of_bounds.emit(target)
		return
	var from_cell: Vector2i = _head_cell
	_head_cell = target
	head_moved.emit(from_cell, target)
	if _grid.get_owner(target) == _owner_id:
		var arrived: bool = not _on_home
		_on_home = true
		if arrived and not _trail.is_empty():
			returned_home.emit()
		return
	_on_home = false
	if _trail_set.has(target):
		trail_self_hit.emit(target)
		return
	_trail.append(target)
	_trail_set[target] = true
	trail_cell_added.emit(target)
