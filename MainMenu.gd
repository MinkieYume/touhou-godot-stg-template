extends Panel

@onready var game_start_button = $Buttons/GameStart
@onready var game_window = $"../GameWindow"
@onready var hardpanel_container = $LevelChose/HardChose/HardPanels

func _ready():
	game_start_button.grab_focus()
#	hardpanel_container.get_child(0).grab_focus()

func _on_game_start_pressed():
	visible = false
	game_window.visible = true
	game_window.enable = true

func _on_quit_pressed():
	get_tree().quit()
