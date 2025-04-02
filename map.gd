extends TileMapLayer

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var width = 64
var height = 64

# Reference to the player character
@export var player: Node2D
@export var speed = 400 # How fast the player will move (pixels/sec). 
var screen_size # Size of the game window.
var input_buffer = [0,0,0,0]
var loaded_chunks = []
var player_tile_pos: Vector2
var moved: bool
var tosnap: Vector2
var animation: AnimatedSprite2D

# Called every time there's an input.
func _input(event):
	bufferinit(event, "move_right", 0)
	bufferinit(event, "move_left", 1)
	bufferinit(event, "move_down", 2)
	bufferinit(event, "move_up", 3)
	
	var velocity = Vector2.ZERO # The player's movement vector.
	velocity.x += (input_buffer[0] - input_buffer[1])
	velocity.y += input_buffer[2] - input_buffer[3]
	velocity = map_to_local(velocity) - map_to_local(Vector2i(0,0))
	
	if velocity.length() > 0:
		tosnap = velocity
		print(tosnap)
	
func _ready():
	moved = false
	tosnap = Vector2(0,0)
	# Set random seeds for noise variation
	moisture.seed = randi()
	temperature.seed = randi()
	animation = get_node("Player/AnimatedSprite2D")
	screen_size = get_viewport_rect().size

func _process(_delta):
	# Convert the player's position to tile coordinates
	player_tile_pos = local_to_map(player.position)
	generate_chunk(player_tile_pos, false)

func _physics_process(_delta):
	if not moved:
		tosnap = tosnap / 2
		player.position += tosnap

func generate_chunk(pos, unload):
	for x in range(width):
		for y in range(height):
			var moist = moisture.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var temp = temperature.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var tile = Vector2(round(3 * (moist + 10) / 20), round(3 * (temp + 10) / 20))
			
			if unload:
				set_cell(Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 0, Vector2(-1,-1))
			else:
				set_cell(Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 0, tile)
			
			if Vector2i(pos.x, pos.y) not in loaded_chunks:
				loaded_chunks.append(Vector2i(pos.x, pos.y))
				unload_distant_chunks(pos)

func unload_distant_chunks(player_pos):
	var unload_distance_threshold = (width * 2) + 1

	for chunk in loaded_chunks:
		var displacement = Vector2(chunk) - player_pos
		var distance = sqrt(displacement.dot(displacement))

		if distance > unload_distance_threshold:
			generate_chunk(chunk, true)
			loaded_chunks.erase(chunk)

func bufferinit(event, action, key):
	if event.is_action_pressed(action):
		input_buffer[key] += 1
		animation.play()
		moved = true
	if event.is_action_released(action):
		input_buffer[key] -= 1
		animation.stop()
		moved = false
