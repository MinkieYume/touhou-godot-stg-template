extends Panel

@onready var game_start_button = $Buttons/GameStart
@onready var game_window = $"../GameWindow"

func _ready():
	game_start_button.grab_focus()

func _on_game_start_pressed():
	visible = false
	game_window.visible = true
	game_window.enable = true

func _on_quit_pressed():
	get_tree().quit()
