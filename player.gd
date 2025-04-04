extends Area2D

var moved: bool
@export var animation: AnimatedSprite2D

func _process(delta: float) -> void:
	if moved:
		animation.play()
