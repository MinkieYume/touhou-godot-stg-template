extends Panel

@onready var toggle_audio = $"../../../../../Audio/ToggleButton"
@onready var pressed_audio = $"../../../../../Audio/PressedButton"
@onready var cancel_audio = $"../../../../../Audio/CancelButton"
@onready var game_window = $"../../../../../GameWindow"
@onready var main_menu = $"../../../.."
@onready var spell_card_chose = $".."
@onready var animation_player = $"../../../../../AnimationPlayer"
@onready var self_chose = $"../../../SelfChose"
@onready var no_focus = $"../../../../No_Focus"
@onready var black_screen = $"../../../../../BlackScreen"
@onready var pratice_chose = $"../../../PraticeChose"
@onready var pratice_level1 = $"../../../PraticeChose/Levels/Level1"

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
			no_focus.grab_focus()
			#处理淡出特效
			animation_player.play("淡出画面")
			await animation_player.animation_finished
			#切入游戏面板
			for panel in spell_card_chose.get_children():
				panel.visible = false
			match main_menu.character_chose_mode:
				0:
					main_menu.visible = false
					game_window.visible = true
					game_window.enable = true
					animation_player.play("淡入画面")
				1:
					pratice_chose.visible = true
					animation_player.play("RESET")
					await animation_player.animation_finished
					self_chose.delete_chosed_panel()
					animation_player.play_backwards("淡入淡出练习关卡选择")
					await animation_player.animation_finished
					pratice_level1.grab_focus()
					black_screen.visible = false
				2:
					pass
		
		if event.is_action_pressed("ui_cancel"):
			cancel_audio.play()
			no_focus.grab_focus()
			animation_player.play_backwards("自机选择切符卡选择")
			await animation_player.animation_finished
			self_chose.get_focus()
			for panel in spell_card_chose.get_children():
				panel.visible = false
