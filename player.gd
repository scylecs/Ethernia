extends Area2D

var moved: bool
var played: bool = false
var char_file = FileAccess.open("user://char.file", FileAccess.WRITE)
@export var animation: AnimatedSprite2D

func _ready() -> void:
	while char_file.get_position() < char_file.get_length():
		var json_string = char_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var player_data = json.data

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
