class_name TerritoryClaim
extends RefCounted
## Pure loop-closure territory claim over a [GridModel] (no scene dependencies).
## Implements: design/game-brief.md MVP feature 3 (story 003).
##
## Algorithm: trail cells count as the claimer's land (a wall). Every cell that
## is not a wall and is reachable from the grid border by an iterative 4-neighbour
## flood fill is "outside". Everything else (unowned AND rival-owned cells that
## are not reachable) is enclosed and becomes the claimer's. Trail cells become
## owned too. Whole-grid fill is used (<= a few thousand cells) so enclosed
## pockets of any shape are found without bounding-box edge cases.
##
## Usage:
##   var gained: int = TerritoryClaim.claim(grid, 1, state.get_trail())


## Claims land for [param owner_id] given its closed [param trail_cells].
## Returns the number of cells whose owner actually changed (trail + enclosed).
## An empty trail claims nothing. Ownership changes go through
## [method GridModel.set_owner], so [signal GridModel.cell_changed] fires per cell.
static func claim(grid: GridModel, owner_id: int, trail_cells: Array[Vector2i]) -> int:
	if trail_cells.is_empty() or owner_id == GridModel.UNOWNED:
		return 0
	var size: Vector2i = grid.get_size()
	var w: int = size.x
	var h: int = size.y
	# 1 = wall (claimer land or trail) or already visited; 0 = open and unvisited.
	var blocked := PackedByteArray()
	blocked.resize(w * h)
	for y in h:
		var row: int = y * w
		for x in w:
			if grid.get_owner(Vector2i(x, y)) == owner_id:
				blocked[row + x] = 1
	for cell: Vector2i in trail_cells:
		if grid.in_bounds(cell):
			blocked[cell.y * w + cell.x] = 1

	# Seed the queue with every open border cell, then flood iteratively.
	var queue := PackedInt32Array()
	queue.resize(w * h)
	var head: int = 0
	var tail: int = 0
	for x in w:
		for y: int in [0, h - 1]:
			var i: int = y * w + x
			if blocked[i] == 0:
				blocked[i] = 1
				queue[tail] = i
				tail += 1
	for y in range(1, h - 1):
		for x: int in [0, w - 1]:
			var i: int = y * w + x
			if blocked[i] == 0:
				blocked[i] = 1
				queue[tail] = i
				tail += 1
	while head < tail:
		var idx: int = queue[head]
		head += 1
		var cx: int = idx % w
		var cy: int = idx / w
		if cx > 0 and blocked[idx - 1] == 0:
			blocked[idx - 1] = 1
			queue[tail] = idx - 1
			tail += 1
		if cx < w - 1 and blocked[idx + 1] == 0:
			blocked[idx + 1] = 1
			queue[tail] = idx + 1
			tail += 1
		if cy > 0 and blocked[idx - w] == 0:
			blocked[idx - w] = 1
			queue[tail] = idx - w
			tail += 1
		if cy < h - 1 and blocked[idx + w] == 0:
			blocked[idx + w] = 1
			queue[tail] = idx + w
			tail += 1

	# `blocked` is now 0 only for enclosed open cells (outside cells were marked
	# visited). Claim those, then the trail cells.
	var changed: int = 0
	for y in h:
		var row: int = y * w
		for x in w:
			if blocked[row + x] == 0 and grid.set_owner(Vector2i(x, y), owner_id):
				changed += 1
	for cell: Vector2i in trail_cells:
		if grid.set_owner(cell, owner_id):
			changed += 1
	return changed
