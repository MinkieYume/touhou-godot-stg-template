extends Panel


@export var level_name = "默认测试"
@onready var toggle_audio = $"../../../../../Audio/ToggleButton"
@onready var game_window = $"../../../../../GameWindow"

func _ready():
	focus_entered.connect(Callable(self,"_on_focus_entered"))
	focus_exited.connect(Callable(self,"_on_focus_exited"))

func _on_focus_entered():
	material.set_shader_parameter("alpha",1.0)
	game_window.level_name = level_name

func _unhandled_input(event):
	if has_focus():
		if event.is_action_pressed("ui_accept"):
			pass
		if event.is_action_pressed("ui_cancel"):
			pass

func switch_to_flayer_chose():
	pass

func _on_focus_exited():
	material.set_shader_parameter("alpha",0.5)
	toggle_audio.play()
