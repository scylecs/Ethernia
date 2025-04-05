extends Camera2D

var buffer = [0,0,0,0,0,0]
var map = InputMap

func _ready() -> void:
	assign_key(KEY_KP_3, "move_right")
	assign_key(KEY_KP_1, "move_left")
	assign_key(KEY_KP_5, "move_up")
	assign_key(KEY_KP_2, "move_down")
	assign_key(KEY_KP_4, "move_lup")
	assign_key(KEY_KP_6, "move_rup")


func assign_key(key:Key, event:StringName):
	var keypress = InputEventKey.new()
	keypress.key_label = key
	map.add_action(event)
	map.action_add_event(event, keypress)
