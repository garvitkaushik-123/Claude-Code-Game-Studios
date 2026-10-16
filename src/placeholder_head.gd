class_name PlaceholderHead
extends Node2D
## THROWAWAY (story 001): arrow-key-driven circle so camera follow can be seen.
## Replaced by real steering in story 002; do not build on this.

var speed_px_per_sec: float = 400.0
var radius: float = 14.0
var color: Color = Color.WHITE
var bounds: Rect2 = Rect2()


func _process(delta: float) -> void:
	var dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position = (position + dir * speed_px_per_sec * delta).clamp(bounds.position, bounds.end)


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius + 3.0, Color.WHITE)
	draw_circle(Vector2.ZERO, radius, color)
