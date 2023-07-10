extends Panel

@onready var toggle_audio = $"../../../../../Audio/ToggleButton"
@onready var pressed_audio = $"../../../../../Audio/PressedButton"
@onready var cancel_audio = $"../../../../../Audio/CancelButton"
@onready var game_window = $"../../../../../GameWindow"
@onready var main_menu = $"../../../.."
@onready var spell_card_chose = $".."
@export var flyer_type = "默认自机"

func _ready():
	focus_entered.connect(Callable(self,"_on_focus_entered"))
	focus_exited.connect(Callable(self,"_on_focus_exited"))

func _on_focus_entered():
	material.set_shader_parameter("alpha",1.0)
	game_window.self_flyer_name = flyer_type

func _on_focus_exited():
	material.set_shader_parameter("alpha",0.5)
	toggle_audio.play()

func _input(event):
	if has_focus():
		if event.is_action_pressed("ui_accept"):
			pressed_audio.play()
			#处理选中与淡出特效
			
			#切入游戏面板
			for panel in spell_card_chose.get_children():
				panel.visible = false
			main_menu.visible = false
			game_window.visible = true
			game_window.enable = true
		
		if event.is_action_pressed("ui_cancel"):
			cancel_audio.play()
