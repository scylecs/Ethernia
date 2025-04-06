extends Node2D

@export var ui_container: CanvasLayer
var screen_size = Vector2.ZERO
var bg: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	var corners = PackedVector2Array([Vector2(0,0), Vector2(0, screen_size.y), Vector2(screen_size.x, 0),screen_size])
	print(corners)
	bg = ui_container.get_node("ColorRect")
	bg.size = screen_size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
