class_name GridView
extends Node2D
## Renders a GridModel with ONE node: an Image/ImageTexture holds one pixel per
## cell; only dirty cells are written via set_pixel, then the texture is updated
## once per frame. Drawn scaled with nearest filtering. No node per cell.
## Implements: design/game-brief.md MVP feature 1 (story 001).
##
## Usage:
##   var view := GridView.new()
##   view.setup(model, config)
##   add_child(view)

var _model: GridModel
var _config: GridConfig
var _image: Image
var _texture: ImageTexture
var _dirty: Dictionary = {} # Vector2i -> true
var _flush_queued: bool = false


## Binds the view to [param model] and paints every cell once.
func setup(model: GridModel, config: GridConfig) -> void:
	_model = model
	_config = config
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var size: Vector2i = model.get_size()
	_image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	for y in size.y:
		for x in size.x:
			_image.set_pixel(x, y, config.color_for_owner(model.get_owner(Vector2i(x, y))))
	_texture = ImageTexture.create_from_image(_image)
	model.cell_changed.connect(_on_cell_changed)
	queue_redraw()


func _on_cell_changed(cell: Vector2i, _old_owner: int, _new_owner: int) -> void:
	_dirty[cell] = true
	if not _flush_queued:
		_flush_queued = true
		_flush.call_deferred()


func _flush() -> void:
	_flush_queued = false
	for cell: Vector2i in _dirty:
		_image.set_pixelv(cell, _config.color_for_owner(_model.get_owner(cell)))
	_dirty.clear()
	_texture.update(_image)
	queue_redraw()


func _draw() -> void:
	if _texture == null:
		return
	var cs: float = float(_config.cell_size_px)
	var world: Vector2 = _config.world_size()
	draw_texture_rect(_texture, Rect2(Vector2.ZERO, world), false)
	for x in range(_model.get_size().x + 1):
		draw_line(Vector2(x * cs, 0), Vector2(x * cs, world.y), _config.grid_line_color, 1.0)
	for y in range(_model.get_size().y + 1):
		draw_line(Vector2(0, y * cs), Vector2(world.x, y * cs), _config.grid_line_color, 1.0)
