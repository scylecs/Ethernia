extends Node2D

@export var ui_container: CanvasLayer
@export var player: Node2D

var screen_size = Vector2.ZERO
var bg: ColorRect
var prev: Button
var next: Button
var save: Button
var body: AnimatedSprite2D

var n = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	var corners = PackedVector2Array([Vector2(0,0), Vector2(0, screen_size.y), Vector2(screen_size.x, 0),screen_size])
	
	bg = ui_container.get_node("ColorRect")
	prev = ui_container.get_node("Prev")
	next = ui_container.get_node("Next")
	save = ui_container.get_node("Save")
	body = player.get_node("Body/AnimatedSprite2D")
	
	bg.size = screen_size
	player.position = Vector2(screen_size.x/1.2, screen_size.y/2)
	prev.position = player.position - Vector2(25, -80)
	next.position = prev.position + Vector2(25,0)
	save.position = next.position + Vector2(-25,40)
	
	prev.pressed.connect(_button_handler.bind(-1))
	next.pressed.connect(_button_handler.bind(1))
	save.pressed.connect(_save_handler)
	
	player.get_node("Body/AnimatedSprite2D").scale = Vector2(1,1)
	print(player.player_load())

func _button_handler(add: int):
	print("hi")
	n = n + add
	if n < player.body_shapes and n >= 0:
		var body_shape_1: SpriteFrames = load("res://player" + str(n) + ".tres")
		body.set_sprite_frames(body_shape_1)
		print(body.get_sprite_frames())
		print(body_shape_1)
	elif n >= player.body_shapes:
		n = player.body_shapes-1
	else: n = 0

func _save_handler():
	var char_file = FileAccess.open("user://char.file", FileAccess.WRITE)
	char_file.store_line(JSON.stringify(player.player_save()))
	print("Saved!")
