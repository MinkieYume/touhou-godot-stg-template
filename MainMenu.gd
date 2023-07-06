extends Panel

@onready var game_start_button = $Buttons/GameStart
@onready var easy_hard_penel = $LevelChose/HardChose/HardPanels/Easy

@onready var buttons = $Buttons
@onready var title = $"标题"
@onready var game_window = $"../GameWindow"
@onready var level_chose_panel = $LevelChose

@onready var animation_player = $"../AnimationPlayer"

var current_page = "main_menu"

func _ready():
	play_mainmenu_enter()

func play_mainmenu_enter():
	level_chose_panel.visible = false
	buttons.visible = true
	title.visible = true
	animation_player.play("菜单切入")
	await animation_player.animation_finished
	current_page = "main_menu"
	game_start_button.grab_focus()

func _on_game_start_pressed():
	animation_player.play("菜单切出")
	await animation_player.animation_finished
	level_chose_panel.visible = true
	animation_player.play("难度选择切入")
	await animation_player.animation_finished
	easy_hard_penel.grab_focus()
#	visible = false
#	game_window.visible = true
#	game_window.enable = true

func _on_quit_pressed():
	get_tree().quit()
