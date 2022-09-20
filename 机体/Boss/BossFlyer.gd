extends Node2D

var hp = 1

var bullet_group = "enemy_bullet"

var is_hp_zero = false
var is_new_round = false

var white = 0

var is_start_atk = false

var self_move = false

#var spawner_type = {
#	"BulletSpawner": preload("res://Bullets/BulletSpawner/BulletSpawner.tscn"),
#	"BulletAimSelfSpawner": preload("res://Bullets/BulletSpawner/BulletAimSelfSpawner.tscn"),
#}

var now_round = 0 #当前回合
var now_sub_round = 0 #当前子回合（回合内的第几个攻击模式）

@onready var atk_rounds = [
	[
		{"hp": 2400,"is_spell_card":false,"card":$"符卡/方块一非","drop":[0,0],"score":100},
		{"hp": 3200, "is_spell_card": true, "card": $"符卡/方符：摇曳方阵","drop":[10,0],"score":200},
	],
	[
		{"hp": 2000,"is_spell_card":false,"card":$"符卡/方块二非","drop":[0,0],"score":200},
		{"hp": 4000, "is_spell_card": true, "card": $"符卡/棱符：天棱地方","drop":[20,0],"score":400},
		{"hp": 4800, "is_spell_card": true, "card": $"符卡/方阵：完美立方体","drop":[0,0],"score":500},
	],
] #回合和子回合

@onready var UI = get_node("/root/东方弹幕绘/UI")
@onready var player = STGSYS.get_player()

signal before_atk
signal hited

func _ready():
	STGSYS.set_boss(self)
	connect("hited",Callable(self,"_on_HitArea_hit"))
	UI.init_ui()
	start_atk()

func _process(delta):
	#boss死亡处理
	if hp <= 0 and (now_round < atk_rounds.size() - 1 or now_sub_round < atk_rounds[-1].size() - 1) and !is_hp_zero:
		is_hp_zero = true
		boss_end_atk()
	elif hp <= 0 and now_round >= atk_rounds.size() - 1 and now_sub_round >= atk_rounds[-1].size() - 1 and !is_hp_zero:
		is_start_atk = false
		is_hp_zero = true
		boss_dead()
		
	#boss受到攻击变成白色后逐渐恢复颜色
	$AnimatedSprite2D.material.set_shader_parameter("flash_state", white)
	if white > 0:
		white -= 5 * delta
		
func start_atk():
	is_start_atk = true
	is_new_round = true
	process_atk()
	
func next_round():
	var level = STGSYS.get_level()
	level.get_node("普通弹幕层").clear = false
	level.get_node("高光弹幕层").clear = false
	if now_sub_round < atk_rounds[now_round].size() - 1:
		now_sub_round += 1
	else:
		now_sub_round = 0
		if now_round < atk_rounds.size() - 1:
			now_round += 1
			is_new_round = true
		else:
			boss_dead()
			
func process_atk():
	emit_signal("before_atk")
	
	hp = atk_rounds[now_round][now_sub_round]["hp"]
	is_hp_zero = false
	
	if is_new_round:
		UI.createBossHpBar(atk_rounds[now_round])
		is_new_round = false
	
	$AtkEndTimer.wait_time = atk_rounds[now_round][now_sub_round]["card"].keep_sec
	$AtkEndTimer.start()
	$BossMoveTimer.start()
	
	atk_rounds[now_round][now_sub_round]["card"].run_spell_card()
	
func boss_end_atk():
	#移除发弹点
	var left_time = STGSYS.time_left
	remove_bullet_spawner()
	$BossMoveTimer.stop()
	
	#本轮结算：
	var card = atk_rounds[now_round][now_sub_round]
	var level = STGSYS.get_level()
	var drops = card["drop"]
	
	emit_drop(drops)
	
	var card_score
	if card["is_spell_card"]:
		card_score = card["score"] + level.get_node("普通弹幕层").bullets.size()+\
	level.get_node("高光弹幕层").bullets.size()
	else:
		card_score = card["score"]
	
	card_score *= left_time
	
	STGSYS.change_value("score",STGSYS.score+card_score)
	
	if card["is_spell_card"]:
		level.get_node("普通弹幕层").clear = true
		level.get_node("高光弹幕层").clear = true
	
	#开始下一轮
	$AtkChangeTimer.start()
	
func boss_dead():
	is_hp_zero = true
	hp = 0
#	hide()
#	$HitArea/CollisionShape2D.call_deferred("set_disabled", true)
	remove_bullet_spawner()
	var level = STGSYS.get_level()
	level.get_node("普通弹幕层").clear = true
	level.get_node("高光弹幕层").clear = true
	UI.show_boss_hp = false
	STGSYS.remove_boss()
	queue_free()
	
func remove_bullet_spawner():
	atk_rounds[now_round][now_sub_round]["card"].stop_card()

func get_collision_shape():
	return $HitArea/CollisionShape2D.shape

func move(to_position, duration):
	var tween = create_tween()
	tween.tween_property(self,"position",to_position,duration)

func emit_drop(drops):
	#计算并发出物品掉落请求
	#先计算该敌机形状轮廓
	#然后计算要生成的点数物品种类和数量
	#然后用随机数获取敌机判定轮廓范围内的任意几个坐标
	#将信息打包成装有字典的数组形式
	#输出给STGSYS处理物品掉落生成
	var point = drops[0]
	var power = drops[1]
	var final_array = []
	var shape = $HitArea/CollisionShape2D.shape.extents
	var shape_pos = {"left":position.x-shape.x,"right":position.x+shape.x,\
	"up":position.y-shape.y,"down":position.y+shape.y}
	var bigger_power_num = int(power/25)
	var mega_power_num = int((power - bigger_power_num*25)/10)
	var power_num = power - bigger_power_num*25 - mega_power_num *10
	
	if bigger_power_num > 0:
		final_array.append(\
		spawn_random_pos_pack_dict("BiggerPower",bigger_power_num,shape_pos))
	
	if mega_power_num > 0:
		final_array.append(\
		spawn_random_pos_pack_dict("MegaPower",mega_power_num,shape_pos))
	
	if power_num > 0:
		final_array.append(\
		spawn_random_pos_pack_dict("Power",power_num,shape_pos))
	
	if point > 0:
		final_array.append(\
		spawn_random_pos_pack_dict("Point",point,shape_pos))
	
	STGSYS.hance_drop(final_array)

func spawn_random_pos_pack_dict(nam,num,pos_range):
	#生成一个带有随机坐标，名字和数量的字典
	var dic = {}
	dic["_name"] = nam
	dic["number"] = num
	dic["position"] = Vector2(randf_range(pos_range["left"],pos_range["right"]\
		),randf_range(pos_range["up"],pos_range["down"]))
	return dic

#boss攻击结束
func _on_AtkEndTimer_timeout():
	boss_end_atk()

#boss攻击方式转换
func _on_AtkChangeTimer_timeout():
	next_round()
	process_atk()

func _on_HitArea_hit():
	hp -= player.damage
	if hp < 0:
		hp = 0
	
	#受到攻击变成白色
	white = 1.0

func _on_BossMoveTimer_timeout():
	if is_instance_valid(self) and is_instance_valid(STGSYS.get_player()):
		if self_move:
			move(Vector2(STGSYS.get_player().position.x, self.position.y), 2)
