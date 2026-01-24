extends Button

@export var Root: TileMapLayer
var screen_size = Vector2.ZERO
var player_creation =  preload("res://src/player_creation/player_creation.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	print(screen_size)
	self.position = Vector2(screen_size.x / 1.2, screen_size.y / 1.1)
	
	self.pressed.connect(_scene_switcher)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _scene_switcher():
	print("hi!")
	get_tree().root.add_child(player_creation)
	Root.free()

func _process(delta: float) -> void:
	pass
