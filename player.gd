extends Area2D

const body_shapes = 3

var moved: bool
var played: bool = false
@export var animation: AnimatedSprite2D
var player_data

func _process(delta: float) -> void:
	if moved and not played:
		animation.play()
		played = true
	if not moved and played:
		if animation.frame_progress < 1:
			animation.play()
		else:
			animation.play_backwards()
			played = false

func player_save():
	var player_props = {
		"body_shape" : get_node("Body/AnimatedSprite2D").get_sprite_frames(),
		"body_color" : get_node("Body/AnimatedSprite2D").get_animation(),
		"eyes_shape" : get_node("Eyes/AnimatedSprite2D").get_sprite_frames(),
		"eyes_color" : get_node("Eyes/AnimatedSprite2D").get_animation(),
		"hair_shape" : get_node("Hair/AnimatedSprite2D").get_sprite_frames(),
		"hair_color" : get_node("Hair/AnimatedSprite2D").get_animation(),
		}
	print(player_props["body_shape"])
	return player_props

func player_load():
	var char_file = FileAccess.open("user://char.file", FileAccess.READ)
	var json_string = char_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null
	var player_data = json.data	
	var n = 0
	while n < body_shapes:
		var body_shape = load("res://player" + str(n) + ".tres")
		var body_name = body_shape.to_string()
		print(body_name)
		print(player_data["body_shape"])
		if body_name == player_data["body_shape"]:
			get_node("Body/AnimatedSprite2D").set_sprite_frames(body_shape)
			break
		n += 1
	get_node("Body/AnimatedSprite2D").set_animation(player_data["body_color"])
	return"loaded"
