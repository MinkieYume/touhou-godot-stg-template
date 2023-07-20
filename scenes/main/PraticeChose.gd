extends Control

@onready var main_menu = $"../.."
@onready var game_window = $"../../../GameWindow"
@onready var animation_player = $"../../../AnimationPlayer"
@onready var no_focus = $"../../No_Focus"

func _on_level_1_pressed():
	no_focus.grab_focus()
	animation_player.play("淡出画面")
	await animation_player.animation_finished
	game_window.practice_mode = game_window.PRACTICE_MODE.LEVEL
	main_menu.visible = false
	game_window.visible = true
	game_window.enable = true
	animation_player.play("淡入画面")

