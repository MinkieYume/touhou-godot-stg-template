extends Panel

@onready var main_menu = $"../MainMenu"

func _ready():
	visible = false
	STGSYS.connect("game_over",Callable(self,"_on_gameover"))

func _on_gameover():
	visible = true
	get_node("/root/东方弹幕绘/UI").show_boss_hp = false
	get_node("/root/东方弹幕绘/UI").remove_hp_bars()
