extends Button

@onready var cancel_audio = $"../../../../../Audio/CancelButton"
@onready var game_window = $"../../../../../GameWindow"

@export var level_index = 0

func _input(event):
	if has_focus():
		if Input.is_action_pressed("ui_cancel"):
			cancel_audio.play()


func _on_focus_entered():
	if level_index >= 0:
		var level_list = RS.diff_levels[game_window.difficult]
		game_window.level_name = level_list[level_index]
	else:
		match level_index:
			-1:
				game_window.difficult = "extra"
			-2:
				game_window.difficult = "phatom"
