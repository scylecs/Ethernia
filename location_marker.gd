extends TileMapLayer

var highlighted = []
var lasttile = []

@export var map: TileMapLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if highlighted.size() > 0:
		for tile in highlighted:
			set_cell(tile, 1, Vector2i(0,0))
			lasttile.append(tile)
	elif lasttile.size() > 0:
		for tile in lasttile:
			set_cell(tile, -1, Vector2i(-1,-1))
			lasttile.erase(tile)

	if map.tosnap.size() > 0:
		highlighted.append(local_to_map(map.tile_pos + map_to_local(map.tosnap[0])))
		print(map.tile_pos + map_to_local(map.tosnap[0]))
