class_name SwipeInput
extends Node
## Turns touch swipes (and mouse drags / arrow keys / WASD on desktop) into
## 4-axis direction requests. Holds no game rules; 180-degree rejection lives in
## PlayerState. Implements: design/game-brief.md MVP feature 2 (story 002).
##
## A swipe fires as soon as the drag travels [member min_distance_px]; the drag
## origin then resets so one continuous gesture can chain several turns.
## Note: with touch->mouse emulation both a touch and a mouse event may arrive for
## one gesture; the duplicate request is the same direction and is a no-op downstream.
##
## Usage:
##   var swipe := SwipeInput.new()
##   swipe.min_distance_px = config.min_swipe_distance_px
##   swipe.direction_requested.connect(state.request_direction)
##   add_child(swipe)

## Emitted with one of Vector2i.UP/DOWN/LEFT/RIGHT.
signal direction_requested(dir: Vector2i)

## Minimum drag distance in screen pixels before a swipe counts.
var min_distance_px: float = 24.0

const _MOUSE_ID: int = -1

var _origins: Dictionary = {} # pointer id (touch index or -1 for mouse) -> Vector2


## Dominant-axis direction of [param delta], or Vector2i.ZERO if shorter than
## [param min_distance]. Pure, for testing. Screen +y (down) maps to Vector2i.DOWN.
static func direction_from_delta(delta: Vector2, min_distance: float) -> Vector2i:
	if delta.length() < maxf(min_distance, 0.001):
		return Vector2i.ZERO
	if absf(delta.x) >= absf(delta.y):
		return Vector2i.RIGHT if delta.x > 0.0 else Vector2i.LEFT
	return Vector2i.DOWN if delta.y > 0.0 else Vector2i.UP


## Direction for a key event, or Vector2i.ZERO if the key is not a steering key.
static func direction_from_key(keycode: Key) -> Vector2i:
	match keycode:
		KEY_UP, KEY_W:
			return Vector2i.UP
		KEY_DOWN, KEY_S:
			return Vector2i.DOWN
		KEY_LEFT, KEY_A:
			return Vector2i.LEFT
		KEY_RIGHT, KEY_D:
			return Vector2i.RIGHT
	return Vector2i.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		_pointer_pressed(touch.index, touch.position, touch.pressed)
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		_pointer_moved(drag.index, drag.position)
	elif event is InputEventMouseButton:
		var button := event as InputEventMouseButton
		if button.button_index == MOUSE_BUTTON_LEFT:
			_pointer_pressed(_MOUSE_ID, button.position, button.pressed)
	elif event is InputEventMouseMotion:
		_pointer_moved(_MOUSE_ID, (event as InputEventMouseMotion).position)
	elif event is InputEventKey:
		var key := event as InputEventKey
		if key.pressed and not key.echo:
			var dir: Vector2i = direction_from_key(key.physical_keycode)
			if dir != Vector2i.ZERO:
				direction_requested.emit(dir)


func _pointer_pressed(id: int, pos: Vector2, pressed: bool) -> void:
	if pressed:
		_origins[id] = pos
	else:
		_origins.erase(id)


func _pointer_moved(id: int, pos: Vector2) -> void:
	if not _origins.has(id):
		return
	var dir: Vector2i = direction_from_delta(pos - (_origins[id] as Vector2), min_distance_px)
	if dir != Vector2i.ZERO:
		_origins[id] = pos
		direction_requested.emit(dir)
