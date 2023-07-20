extends Panel

enum PRACTICE_MODE{
	NOPE,
	LEVEL,
	SPELLCARD
}

@export var enable = false
@export var difficult = "easy"
@export var level_name = "默认测试"
@export var self_flyer_name = "默认自机"

var practice_mode = PRACTICE_MODE.NOPE

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
	STGSYS.set_level(level,self_flyer_name)
	loaded = true
