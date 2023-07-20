extends Node2D

@export var keep_time = 10
@export var bomb_name = "默认炸弹发弹点"
signal bomb_out

func _ready():
	$Timer.wait_time = keep_time
	

func _process(delta):
	pass

func run_bomb():
	get_node(bomb_name).enable_shoot_bullet = true
	$Timer.start()


func _on_Timer_timeout():
	get_node(bomb_name).enable_shoot_bullet = false
	emit_signal("bomb_out")
