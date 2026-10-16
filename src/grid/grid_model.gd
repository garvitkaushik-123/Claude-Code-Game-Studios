class_name GridModel
extends RefCounted
## Pure grid ownership data (no scene dependencies). Owner 0 = unowned.
## Implements: design/game-brief.md MVP feature 1 (story 001).
##
## Usage:
##   var grid := GridModel.new(Vector2i(60, 60))
##   grid.assign_start_territory(Vector2i(30, 30), 1, 3)
##   var share: float = grid.territory_share(1)  # 9 / 3600

## Emitted whenever a cell's owner actually changes.
signal cell_changed(cell: Vector2i, old_owner: int, new_owner: int)

const UNOWNED: int = 0

var _size: Vector2i
var _owners: PackedInt32Array = PackedInt32Array()
var _counts: Dictionary = {} # owner id -> owned cell count (excludes UNOWNED)


func _init(size: Vector2i = Vector2i(60, 60)) -> void:
	_size = Vector2i(maxi(1, size.x), maxi(1, size.y))
	_owners.resize(_size.x * _size.y) # zero-filled == unowned


## Grid dimensions in cells.
func get_size() -> Vector2i:
	return _size


## True if [param cell] lies inside the grid.
func in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < _size.x and cell.y < _size.y


## Owner id of [param cell]; UNOWNED (0) if out of bounds.
func get_owner(cell: Vector2i) -> int:
	if not in_bounds(cell):
		return UNOWNED
	return _owners[cell.y * _size.x + cell.x]


## Sets the owner of [param cell]. Out-of-bounds is ignored (returns false).
## Emits [signal cell_changed] only if the owner differs. Returns true if changed.
func set_owner(cell: Vector2i, id: int) -> bool:
	if not in_bounds(cell):
		return false
	var index: int = cell.y * _size.x + cell.x
	var old_owner: int = _owners[index]
	if old_owner == id:
		return false
	_owners[index] = id
	if old_owner != UNOWNED:
		_counts[old_owner] = int(_counts.get(old_owner, 0)) - 1
	if id != UNOWNED:
		_counts[id] = int(_counts.get(id, 0)) + 1
	cell_changed.emit(cell, old_owner, id)
	return true


## Owned cells / total cells for [param id], in 0..1.
func territory_share(id: int) -> float:
	return float(owned_count(id)) / float(_size.x * _size.y)


## Number of cells owned by [param id].
func owned_count(id: int) -> int:
	if id == UNOWNED:
		return _size.x * _size.y - _total_owned()
	return int(_counts.get(id, 0))


## Gives [param id] a square start territory of side [param side] centred on
## [param center] (3 = 3x3 around the cell), shifted to fit inside the grid.
## Returns the number of cells that changed owner.
func assign_start_territory(center: Vector2i, id: int, side: int = 3) -> int:
	var half: int = side / 2
	var origin := Vector2i(
		clampi(center.x - half, 0, maxi(0, _size.x - side)),
		clampi(center.y - half, 0, maxi(0, _size.y - side)))
	var changed: int = 0
	for y in range(origin.y, mini(origin.y + side, _size.y)):
		for x in range(origin.x, mini(origin.x + side, _size.x)):
			if set_owner(Vector2i(x, y), id):
				changed += 1
	return changed


func _total_owned() -> int:
	var total: int = 0
	for count: Variant in _counts.values():
		total += int(count)
	return total
