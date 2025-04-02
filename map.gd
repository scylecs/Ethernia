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
var moved = false
var animation: AnimatedSprite2D

# Called every time there's an input.
func _input(event):
	bufferinit(event, "move_right", 0)
	bufferinit(event, "move_left", 1)
	bufferinit(event, "move_down", 2)
	bufferinit(event, "move_up", 3)

func _ready():
	# Set random seeds for noise variation
	moisture.seed = randi()
	temperature.seed = randi()
	animation = get_node("Player/AnimatedSprite2D")
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	velocity.x += (input_buffer[0] - input_buffer[1])
	velocity.y += input_buffer[2] - input_buffer[3]
	velocity = map_to_local(velocity) - map_to_local(Vector2i(0,0))
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animation.play()
	else:
		animation.stop()
		
	player.position += Vector2(velocity.x * delta, velocity.y * delta)
	
		# Convert the player's position to tile coordinates
	player_tile_pos = local_to_map(player.position)
	generate_chunk(player_tile_pos)

func _physics_process(delta):
	if input_buffer.max()==0 && moved:
		print(player_tile_pos)
		print(player.position)
		var tosnap = map_to_local(player_tile_pos) - player.position
		player.position += tosnap / 5
		if player.position == map_to_local(player_tile_pos):
			moved = false

func generate_chunk(pos):
	for x in range(width):
		for y in range(height):
			# Generate noise values for moisture, temperature, and altitude
			var moist = moisture.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10 # Values between -10 and 10
			var temp = temperature.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10

			set_cell(Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 0, Vector2(round(3 * (moist + 10) / 20), round(3 * (temp + 10) / 20)))
			
			if Vector2i(pos.x, pos.y) not in loaded_chunks:
				loaded_chunks.append(Vector2i(pos.x, pos.y))

func bufferinit(event, action, key):
	if event.is_action_pressed(action):
		input_buffer[key] += 1
		moved = true
	if event.is_action_released(action):
		input_buffer[key] -= 1
