extends Node2D

@export var ui_container: CanvasLayer
@export var player: Node2D
var screen_size = Vector2.ZERO
var bg: ColorRect
var prev: Button
var next: Button
var body: AnimatedSprite2D

var n = 0
var changed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	var corners = PackedVector2Array([Vector2(0,0), Vector2(0, screen_size.y), Vector2(screen_size.x, 0),screen_size])
	
	bg = ui_container.get_node("ColorRect")
	prev = ui_container.get_node("Prev")
	next = ui_container.get_node("Next")
	body = player.get_node("Body/AnimatedSprite2D")
	
	bg.size = screen_size
	player.position = Vector2(screen_size.x/1.2, screen_size.y/2)
	prev.position = player.position - Vector2(25, -80)
	next.position = prev.position + Vector2(25,0)
	player.get_node("Body/AnimatedSprite2D").scale = Vector2(1,1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if prev.button_pressed and not changed:
		print("hi")
		var body_shape_1 : SpriteFrames = load("res://player" + str(n) + ".tres")
		body.set_sprite_frames(body_shape_1)
		print(body.get_sprite_frames())
		print(body_shape_1)

		changed = true
	elif changed and not prev.button_pressed:
		changed = false
