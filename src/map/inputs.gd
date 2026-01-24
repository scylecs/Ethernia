extends Camera2D

var buffer = [0,0,0,0,0,0]
var release = [0,0,0,0,0,0]
var actions = []
var map = InputMap

func _ready() -> void:
	assign_key(KEY_KP_3, "move_right")
	assign_key(KEY_KP_1, "move_left")
	assign_key(KEY_KP_2, "move_down")
	assign_key(KEY_KP_5, "move_up")
	assign_key(KEY_KP_6, "move_rup")
	assign_key(KEY_KP_4, "move_lup")

func assign_key(key:Key, event:StringName):
	var keypress = InputEventKey.new()
	keypress.key_label = key
	map.add_action(event)
	actions.append(event)
	map.action_add_event(event, keypress)

func _input(event):
	for i in range(actions.size()):
		if event.is_action_pressed(actions[i]):
			release[i] = 1
		if event.is_action_released(actions[i]):
			buffer[i] += 1
			release[i] = 0
