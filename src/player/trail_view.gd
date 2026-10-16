class_name TrailView
extends Node2D
## Draws a PlayerState's trail as a translucent overlay using ONE node: an
## RGBA Image with one pixel per cell, only dirty cells written (same approach
## as GridView). Does not touch cell ownership. Add it after GridView so it
## draws on top. Implements: design/game-brief.md MVP feature 2 (story 002).
##
## Usage:
##   var trail_view := TrailView.new()
##   trail_view.setup(state, grid.get_size(), config)
##   add_child(trail_view)

var _config: GridConfig
var _color: Color
var _image: Image
var _texture: ImageTexture
var _size: Vector2i
var _dirty: Dictionary = {} # Vector2i -> true
var _flush_queued: bool = false


## Binds to [param state]; [param grid_size] is the grid size in cells.
func setup(state: PlayerState, grid_size: Vector2i, config: GridConfig) -> void:
	_config = config
	_size = grid_size
	_color = config.trail_color_for_owner(state.get_owner_id())
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_image = Image.create_empty(grid_size.x, grid_size.y, false, Image.FORMAT_RGBA8)
	_texture = ImageTexture.create_from_image(_image)
	state.trail_cell_added.connect(_on_trail_cell_added)
	for cell: Vector2i in state.get_trail():
		_on_trail_cell_added(cell)


func _on_trail_cell_added(cell: Vector2i) -> void:
	_dirty[cell] = true
	if not _flush_queued:
		_flush_queued = true
		_flush.call_deferred()


func _flush() -> void:
	_flush_queued = false
	for cell: Vector2i in _dirty:
		_image.set_pixelv(cell, _color)
	_dirty.clear()
	_texture.update(_image)
	queue_redraw()


func _draw() -> void:
	if _texture != null:
		draw_texture_rect(_texture, Rect2(Vector2.ZERO, _config.world_size()), false)
