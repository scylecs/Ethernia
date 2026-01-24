extends TileMapLayer

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var width = 64
var height = 64

# Reference to the player character
var screen_size # Size of the game window.
var loaded_chunks = []
var tosnap = []
var tile_pos: Vector2

@export var player: Node2D
@export var inputs: Camera2D

func _ready():
	player.moved = false
	
	# Set random seeds for noise variation
	moisture.seed = randi()
	temperature.seed = randi()
	screen_size = get_viewport_rect().size

	#spawn generation	
	tile_pos = local_to_map(player.position)
	generate_chunk(tile_pos, false)

func _process(_delta):
	var right = inputs.buffer[0] + inputs.buffer[4] - inputs.buffer[5] - inputs.buffer[1]
	var up = inputs.buffer[2] - inputs.buffer[3] - inputs.buffer[4] - inputs.buffer[5]

	if right != 0 or up != 0:
		tosnap.append(map_to_local(Vector2i(right, up)) - map_to_local(Vector2i(0, 0)))
		player.moved = true
		for i in range(inputs.buffer.size()):
			inputs.buffer[i] = max(inputs.buffer[i] - 1, 0)

	# Convert the player's position to tile coordinates
	if tosnap.size() > 0:
		tile_pos = local_to_map(player.position)
		generate_chunk(tile_pos, false)

func _physics_process(_delta):
	var tween = player.create_tween()
	if tosnap.size() > 0:
		tween.tween_property(player, "position", (map_to_local(local_to_map(player.position)) - Vector2(-5, 25)) + tosnap[0], 0.15)
		tosnap.pop_at(0)
		player.moved = false

func generate_chunk(pos, unload):
	for x in range(width):
		for y in range(height):
			var moist = moisture.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var temp = temperature.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var tile = Vector2(round(3 * (moist + 10) / 20), round(3 * (temp + 10) / 20))
			
			if unload:
				set_cell(Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), -1, Vector2(-1,-1))
			else:
				set_cell(Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 0, tile)
			
			if Vector2i(pos.x, pos.y) not in loaded_chunks:
				loaded_chunks.append(Vector2i(pos.x, pos.y))
				unload_distant_chunks(pos)

func unload_distant_chunks(player_pos):
	var unload_distance_threshold = (width * 2) + 1

	for chunk in loaded_chunks:
		var displacement: Vector2 = Vector2(chunk) - Vector2(player_pos)
		var distance = displacement.length()

		if distance > unload_distance_threshold:
			await generate_chunk(chunk, true)
			loaded_chunks.erase(chunk)
