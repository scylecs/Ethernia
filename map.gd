extends TileMapLayer

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var width = 64
var height = 64

# Reference to the player character
@export var player: Node2D
@export var location_marker: TileMapLayer
@export var inputs: Camera2D
var screen_size # Size of the game window.
var loaded_chunks = []
var player_tile_pos: Vector2
var tosnap: Vector2

func _ready():
	player.moved = false
	tosnap = Vector2(0,0)
	# Set random seeds for noise variation
	moisture.seed = randi()
	temperature.seed = randi()
	screen_size = get_viewport_rect().size
	
	#spawn generation	
	player_tile_pos = local_to_map(player.position)
	generate_chunk(player_tile_pos, false)

func _process(_delta):
	# Convert the player's position to tile coordinates
	player_tile_pos = local_to_map(player.position)
	if player.moved:
		generate_chunk(player_tile_pos, false)

func _physics_process(_delta):
	if not player.moved and tosnap.length() > 0:
		var tween = player.create_tween()
		tween.tween_property(player, "position", player.position + tosnap, 0.15)
		tosnap = Vector2.ZERO;

# Called every time there's an input.
func _input(event):
	bufferinit(event, "move_right", 0)
	bufferinit(event, "move_left", 1)
	bufferinit(event, "move_down", 2)
	bufferinit(event, "move_up", 3)
	bufferinit(event, "move_rup", 4)
	bufferinit(event, "move_lup", 5)
	
	var velocity = Vector2.ZERO # The player's movement vector.
	velocity.x += (inputs.buffer[0] + inputs.buffer[4] - inputs.buffer[1] - inputs.buffer[5])
	velocity.y += (inputs.buffer[2] - inputs.buffer[3] - inputs.buffer[4] - inputs.buffer[5])
	velocity = map_to_local(velocity) - map_to_local(Vector2i(0,0))
	
	if velocity.length() > 0:
		location_marker.highlighted = [local_to_map(player.position + velocity + Vector2(5,25))]
		tosnap = velocity
	
func bufferinit(event, action, key):
	if event.is_action_pressed(action):
		inputs.buffer[key] += 1
		player.moved = true
		
	if event.is_action_released(action):
		player.position = map_to_local(player_tile_pos) + Vector2(5,-25)
		print(player_tile_pos)
		inputs.buffer[key] -= 1
		player.moved = false
		location_marker.highlighted = []

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
		var displacement: Vector2 = Vector2(chunk) - player_pos
		var distance = displacement.length()

		if distance > unload_distance_threshold:
			await generate_chunk(chunk, true)
			loaded_chunks.erase(chunk)
