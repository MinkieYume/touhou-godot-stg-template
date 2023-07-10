extends Panel

@onready var game_start_button = $Buttons/GameStart
@onready var easy_hard_penel = $LevelChose/HardChose/HardPanels/Easy

@onready var buttons = $Buttons
@onready var title = $"标题"
@onready var game_window = $"../GameWindow"
@onready var level_chose_panel = $LevelChose

@onready var animation_player = $"../AnimationPlayer"

@onready var easy_hard_panel = $LevelChose/HardChose/HardPanels/Easy
@onready var normal_hard_panel = $LevelChose/HardChose/HardPanels/Normal
@onready var hard_hard_panel = $LevelChose/HardChose/HardPanels/Hard
@onready var lunatic_hard_panel = $LevelChose/HardChose/HardPanels/Lunatic
@onready var extra_hard_panel = $LevelChose/HardChose/HardPanels/Extra
@onready var phatom_hard_panel = $LevelChose/HardChose/HardPanels/Phatom

@export var quick_test_mode = false

var current_page = "main_menu"

func _ready():
	if quick_test_mode:
		visible = false
		game_window.visible = true
		game_window.enable = true
	else:
		play_mainmenu_enter()
	

func play_mainmenu_enter():
	level_chose_panel.visible = false
	buttons.visible = true
	title.visible = true
	easy_hard_panel.visible = false
	normal_hard_panel.visible = false
	hard_hard_panel.visible = false
	lunatic_hard_panel.visible = false
	extra_hard_panel.visible = false
	phatom_hard_panel.visible = false
	animation_player.play("菜单切入")
	await animation_player.animation_finished
	current_page = "main_menu"
	game_start_button.grab_focus()

func _on_game_start_pressed():
	animation_player.play("菜单切出")
	await animation_player.animation_finished
	level_chose_panel.visible = true
	easy_hard_panel.visible = true
	normal_hard_panel.visible = true
	hard_hard_panel.visible = true
	lunatic_hard_panel.visible = true
	animation_player.play("难度选择切入")
	await animation_player.animation_finished
	easy_hard_penel.grab_focus()

func _on_quit_pressed():
	get_tree().quit()
