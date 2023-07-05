extends Panel


@export var level_name = "默认测试"
@onready var toggle_audio = $"../../../../../Audio/ToggleButton"


func _ready():
	focus_entered.connect(Callable(self,"_on_focus_entered"))
	focus_exited.connect(Callable(self,"_on_focus_exited"))

func _on_focus_entered():
	material.set_shader_parameter("alpha",1.0)

func _on_focus_exited():
	material.set_shader_parameter("alpha",0.5)
	toggle_audio.play()
