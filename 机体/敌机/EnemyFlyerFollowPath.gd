extends PathFollow2D

@export var unbreakable = false
@export var speed = 100

@export var score = 100 #击杀该敌机获取的分数
@export var power = 10 #击杀该敌机获得的火力
@export var point = 10 #击杀该敌机获得的点数

var health = 50
var bullet_group = "enemy_bullet"

signal hited

func _process(delta):
	#move(delta)
	pass
	
func _ready():
	for node in $Shooter.get_children():
		node.add_bullet_group(bullet_group)

#func move(delta):
	#set_offset(get_offset() + speed * delta)

func emit_drop():
	#计算并发出物品掉落请求
	#先计算该敌机形状轮廓
	#然后计算要生成的点数物品种类和数量
	#然后用随机数获取敌机判定轮廓范围内的任意几个坐标
	#将信息打包成装有字典的数组形式
	#输出给STGSYS处理物品掉落生成
	var final_array = []
	var shape = $Area2D/CollisionShape2D.shape.extents
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

func _on_hit():
	if health > 0:
		health -= 1
	else:
		death()
		
func death():
	visible = false
	emit_drop()
	STGSYS.change_value("score",STGSYS.score+score)
	queue_free()
	
func _on_EnemyFlyer_area_entered(area):
	if area.is_in_group("self_bullet"):
		area.queue_free()
		emit_signal("hited")
	if area.is_in_group("self_dead_point"):
		var player = area.get_parent()
		player.emit_signal("hit",self)

func _on_VisibilityNotifier2D_screen_exited():
	if !unbreakable:
		queue_free()
