extends TileMapLayer

var lasttile = []

@export var player:Node2D
@export var inputs: Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var temp = inputs.release
	var right = temp[0] + temp[4] - temp[5] - temp[1]
	var up = temp[2] - temp[3] - temp[4] - temp[5]
	
	if (right != 0 or up != 0):
		var tile = local_to_map(player.position + map_to_local(Vector2(right, up)) - map_to_local(Vector2(0,0)))
		lasttile.append(tile)
		set_cell(tile, 1, Vector2i(0,0))
	elif lasttile.size() > 0:
		for tile in lasttile:
			set_cell(tile, -1, Vector2i(-1,-1))
			lasttile.erase(tile)
