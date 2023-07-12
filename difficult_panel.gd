extends Panel


@export var level_name = "默认测试"
@export var hard = "easy"
@onready var toggle_audio = $"../../../../../Audio/ToggleButton"
@onready var pressed_audio = $"../../../../../Audio/PressedButton"
@onready var cancel_audio = $"../../../../../Audio/CancelButton"
@onready var game_window = $"../../../../../GameWindow"
@onready var self_chose_menu = $"../../../SelfChose"
@onready var animation_player = $"../../../../../AnimationPlayer"
@onready var main_menu = $"../../../.."
@onready var no_focus = $"../../../../No_Focus"

func _ready():
	focus_entered.connect(Callable(self,"_on_focus_entered"))
	focus_exited.connect(Callable(self,"_on_focus_exited"))

func _on_focus_entered():
	material.set_shader_parameter("alpha",1.0)
	game_window.difficult = hard
	game_window.level_name = level_name

func _input(event):
	if has_focus():
		if event.is_action_pressed("ui_accept"):
			pressed_audio.play()
			no_focus.grab_focus()
			
			#处理块平移到左下角的动画效果
			var new_panel = self.duplicate()
			new_panel.name = "chosed_hard"
			self_chose_menu.add_child(new_panel)
			self_chose_menu.last_chosed_hard = self
			self_chose_menu.last_chosed_pos = global_position
			new_panel.position = global_position
			new_panel.material = material.duplicate()
			new_panel.material.set_shader_parameter("alpha",0.5)
			var tween = get_tree().create_tween()
			tween.bind_node(new_panel)
			tween.set_trans(Tween.TRANS_LINEAR)
			material.set_shader_parameter("alpha",0.0)
			tween.tween_property(new_panel,"position",Vector2(39,444),0.5)
			animation_player.play("难度选择切自机选择")
			await animation_player.animation_finished
			self_chose_menu.get_focus()
			
		if event.is_action_pressed("ui_cancel"):
			cancel_audio.play()
			no_focus.grab_focus()
			animation_player.play("难度选择切出")
			await animation_player.animation_finished
			main_menu.play_mainmenu_enter()

func _on_focus_exited():
	material.set_shader_parameter("alpha",0.5)
	toggle_audio.play()
