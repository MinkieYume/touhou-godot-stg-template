extends Panel

@export var enable = false
@export var level_name = "默认测试"

@onready var main_menu = $"../MainMenu"

var loaded = false

func _ready():
	if enable:
		_load()

func _process(delta):
	if enable and not loaded:
		_load()

func _load():
	var level = RS.levels[level_name].instantiate()
	$SubViewportContainer/SubViewport.add_child(level)
	$NumberPanel.update_life()
	$NumberPanel.update_bomb()
	$NumberPanel.update_power()
	$NumberPanel.update_text()
	STGSYS.set_level(level)
	loaded = true
