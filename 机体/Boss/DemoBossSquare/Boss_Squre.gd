extends Node2D

#DEMO BOSS 方块
#该BOSS是一个巨大的方块
#该BOSS具有操纵方块的寰宇之力
#BOSS的能力是把世间一切物体全部变成方形
#符卡有3个，非符有2个
#一非：发射方形小怪偶数狙，方形小怪会对你发射间隔很长的单个方块的弹幕自机狙。
#同时BOSS还会按照方形范围在屏幕上发射激光
#方符-摇曳方阵：站在屏幕中间一波一波对外发射方形固定弹，每一波发射角度都会旋转。
#二非：发射大量棱形弹幕，棱形弹幕会向着自机方向按组成一个个棱形的轨迹发射。
#棱符-天棱地方：对着周围发射棱形弹幕，棱形弹幕会定时在运动轨迹生成垂直方向运行的方形弹幕（最基础的绑定）
#方阵-完美立方体：大量生成固定在屏幕上的方形弹幕，组成的方形逐渐变小，直到最小之后弹幕会从随机方向离开屏幕。

var hp = 999999

var shooter_details = [
	{
		"spawner_mode": "BulletSpawner",
		"rotate_speed": 0,
		"spawn_bullet_sec": 0,
		"bullet_spawner_count": 0,
		"radius": 40,
	},
	{
		"spawner_mode": "BulletSpawner",
		"rotate_speed": 0,
		"spawn_bullet_sec": 0,
		"bullet_spawner_count": 0,
		"radius": 40,
	},
]

var bullet_group = "enemy_bullet"

var atk_mode = 0

var attacked = false
var atk_mode_changed = false
var is_hp_zero = false

var white = 0

var start_atk = false

var spawner_type = {
	"BulletSpawner": preload("res://Bullets/BulletSpawner.tscn"),
	"BulletAimSelfSpawner": preload("res://Bullets/BulletSpawner/BulletAimSelfSpawner.tscn"),
}

var atk_rounds = [
	[
		{"atk_mode": 0, "time": 0, "hp": 0, "is_spell_card": false}
	],
	[
		{"atk_mode": 1, "time": 60, "hp": 600, "is_spell_card": false},
		{"atk_mode": 2, "time": 60, "hp": 600, "is_spell_card": true},
	],
	[
		{"atk_mode": 3, "time": 60, "hp": 600, "is_spell_card": false},
		{"atk_mode": 4, "time": 60, "hp": 600, "is_spell_card": true},
	],
] #回合和子回合
var now_round = 0 #当前回合
var now_sub_round = 0 #当前子回合（回合内的第几个攻击模式）

@onready var shooters = [
	$Shooter, $Shooter2
]

func _ready():
	start_atk = true

func _process(delta):
#	print("round:" + String(now_round))
#	print("sub round:" + String(now_sub_round))
	#旋转发弹组中心，使发弹点顺着圆周旋转
	var index = 0
	for shooter in shooters:
		var rotate = shooter.rotation_degrees + shooter_details[index]["rotate_speed"] * delta
		shooter.rotation_degrees = fmod(rotate, 360)
		index += 1
	
	if start_atk:
		#boss停止攻击并准备下一波攻击
		if atk_mode == 0 and !atk_mode_changed:
			$AtkChangeTimer.start()
			atk_mode_changed = true
			for shooter in shooters:
				for node in shooter.get_children():
					node.stop_shoot()
			
#		if atk_mode != 0 and !attacked:
#			boss_atk()
#			hp = atk_rounds[now_round][now_sub_round]["hp"]
#			$AtkEndTimer.wait_time = atk_rounds[now_round][now_sub_round]["time"]
#			$AtkEndTimer.start()
#			attacked = true
	
	#boss死亡处理		
	if hp <= 0 and !is_hp_zero:
		start_atk = false
		is_hp_zero = true
		hp = 0
		hide()
		$HitArea/CollisionShape2D.call_deferred("set_disabled", true)
#		$AtkIntervalTimer.stop()
		
	#boss受到攻击变成白色后逐渐恢复颜色
	$AnimatedSprite2D.material.set_shader_parameter("flash_state", white)
	if white > 0:
		white -= 5 * delta

func boss_atk():
	atk_mode = atk_rounds[now_round][now_sub_round]["atk_mode"]
		
	if atk_mode == 0:
		for shooter in shooters:
			for node in shooter.get_children():
				node.stop_shoot()
		
	if atk_mode == 1:
		shooter_details[0] = {
			"spawner_mode": "BulletSpawner",
			"rotate_speed": 100,
			"spawn_bullet_sec": 0.1,
			"bullet_spawner_count": 6,
			"radius": 40,
		}
		for shooter in shooters:
			shooter.rotation_degrees = 0
			for node in shooter.get_children():
				if !node.need_remove:
					node.shoot()
		add_bullet_spawner([0])

	if atk_mode == 2:
		shooter_details[0] = {
			"spawner_mode": "BulletAimSelfSpawner",
			"rotate_speed": 0,
			"spawn_bullet_sec": 0.2,
			"bullet_spawner_count": 4,
			"radius": 40,
		}
		for shooter in shooters:
			shooter.rotation_degrees = 0
			for node in shooter.get_children():
				if !node.need_remove:
					node.shoot()
		add_bullet_spawner([0])
		
	if atk_mode == 3:
		shooter_details[0] = {
			"spawner_mode": "BulletSpawner",
			"rotate_speed": -100,
			"spawn_bullet_sec": 0.1,
			"bullet_spawner_count": 3,
			"radius": 40,
		}
		shooter_details[1] = {
			"spawner_mode": "BulletSpawner",
			"rotate_speed": 200,
			"spawn_bullet_sec": 0.2,
			"bullet_spawner_count": 6,
			"radius": 80,
		}
		for shooter in shooters:
			shooter.rotation_degrees = 0
			for node in shooter.get_children():
				if !node.need_remove:
					node.shoot()
		add_bullet_spawner([0,1])
		
	if atk_mode == 4:
		shooter_details[0] = {
			"spawner_mode": "BulletSpawner",
			"rotate_speed": 0,
			"spawn_bullet_sec": 0.5,
			"bullet_spawner_count": 12,
			"radius": 40,
		}
		shooter_details[1] = {
			"spawner_mode": "BulletAimSelfSpawner",
			"rotate_speed": 0,
			"spawn_bullet_sec": 0.5,
			"bullet_spawner_count": 3,
			"radius": 40,
		}
		for shooter in shooters:
			shooter.rotation_degrees = 0
			for node in shooter.get_children():
				if !node.need_remove:
					node.shoot()
		add_bullet_spawner([0,1])
		
	if atk_mode == 5:
		shooter_details[0] = {
			"spawner_mode": "BulletAimSelfSpawner",
			"rotate_speed": 0,
			"spawn_bullet_sec": 0.3,
			"bullet_spawner_count": 6,
			"radius": 90,
		}
		shooter_details[1] = {
			"spawner_mode": "BulletAimSelfSpawner",
			"rotate_speed": 0,
			"spawn_bullet_sec": 0.6,
			"bullet_spawner_count": 6,
			"radius": 240,
		}
		for shooter in shooters:
			shooter.rotation_degrees = 0
			for node in shooter.get_children():
				if !node.need_remove:
					node.shoot()
		add_bullet_spawner([0,1])

func add_bullet_spawner(shooter_indexes):
	#生成圆周发弹组
	for shooter_index in shooter_indexes:
		var step = 2 * PI / shooter_details[shooter_index]["bullet_spawner_count"] #计算每个发弹点间隔
		for i in range(shooter_details[shooter_index]["bullet_spawner_count"]):
			var spawner = spawner_type[shooter_details[shooter_index]["spawner_mode"]].instantiate()
			var pos = Vector2(shooter_details[shooter_index]["radius"], 0).rotated(step * i) #顺着圆周根据间隔确定发弹点生成位置
			spawner.position = pos
			spawner.bullet_rotation = rad_to_deg(pos.angle())
			spawner.spawn_bullet_sec = shooter_details[shooter_index]["spawn_bullet_sec"]
			spawner.add_bullet_group(bullet_group)
			shooters[shooter_index].add_child(spawner)

#boss攻击结束
func _on_AtkEndTimer_timeout():
	atk_mode = 0
	atk_mode_changed = false
	for shooter in shooters:
		for node in shooter.get_children():
			node.remove_spawner()

#boss攻击方式转换
func _on_AtkChangeTimer_timeout():
	if now_sub_round < atk_rounds[now_round].size() - 1:
		now_sub_round += 1
	else:
		now_sub_round = 0
		if now_round < atk_rounds.size() - 1:
			now_round += 1
		else:
			pass #boss 时间到死亡
			
	hp = atk_rounds[now_round][now_sub_round]["hp"]
	$AtkEndTimer.wait_time = atk_rounds[now_round][now_sub_round]["time"]
	$AtkEndTimer.start()
	boss_atk()

func _on_HitArea_area_entered(area):
	if area.is_in_group("player_bullet"):
		hp -= 1
		#受到攻击变成白色
		white = 1.0
		area.queue_free()
