extends TileMapLayer

var highlighted = []
var lasttile = []

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
