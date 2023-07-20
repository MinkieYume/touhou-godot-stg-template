class_name SpawnerSpawner
extends BulletSpawner

@export var spawner_set: Resource
@export var spawner_type = "BulletSpawner"

func _on_ready():
	pass

func bullet_spawn_logic():
	var bullets = get_bullet_group(way_num)
	set_way_bullet_spawn(bullets)
	spawn_group_of_bullet(bullets)

func set_way_bullet_spawn(bullets:Array):
	#根据当前子弹的Way数配置调整子弹旋转参数
	#根据给出的半径和半径方向参数，设置发射每条子弹的位置
	
	#发射位置变量赋值
	var radius_direction = Vector2.DOWN.rotated(deg_to_rad(spawner_radius_rotation))
	var bullet_position = Vector2(0,0) + radius_direction*spawner_radius
	
	#半径变量赋值
	var bullet_rotation = way_rotation
	var bullet_rotation_distance = way_range/float(way_num)
	var half_way_num = int(ceil(way_num/2))
	
	if way_num%2 == 0:
		#若为偶数
		#则初始半径方向和初始子弹发射反方向偏转间隔角度的一半
		#加上半个way_num数少一的偏转间隔
			bullet_rotation = way_rotation - bullet_rotation_distance/2 - \
			bullet_rotation_distance*(half_way_num-1)
			bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation_distance/2))
			for r in range(half_way_num-1):
				bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation_distance))
	elif way_num > 1:
		#若为奇数
		#则初始半径和子弹发射方向直接反方向偏转间隔角度的一半的间隔
		bullet_rotation = way_rotation - bullet_rotation_distance*half_way_num
		for r in range(half_way_num):
			bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation))
	
	#批量设置每个弹幕具体的角度和位置
	for bullet in bullets:
		bullet.speed_rotation = bullet_rotation
		bullet.position = to_global(bullet_position)
		bullet_rotation += bullet_rotation_distance
		bullet_position = bullet_position.rotated(deg_to_rad(bullet_rotation_distance))

func spawn_bullet(bullet):
	if enable_shoot_bullet:
		#子弹的特殊参数处理
		
		bullet.out_screen_free = bullet_out_screen_remove
		if !bullet_out_screen_remove:
			bullet.set_remove_sec(bullet_life)
		
		#子弹的生成处理
		all_bullets.append(bullet)
		STGSYS.current_level.get_node(bullet_manager_name).add_child(bullet)

func get_bullet(bullet_name):
	#获取单个子弹，给子弹赋值基础属性参数
	#外观参数
	var bullet = RS.bullet_spawner[spawner_type].instantiate()
	var is_bullet_property= false
	for set in spawner_set.get_property_list():
		var p_name = set["name"]
		if p_name == "enable":
			is_bullet_property = true
		if is_bullet_property:
			bullet.set(p_name,spawner_set.get(p_name))
	bullet.speed = bullet_speed
	bullet.aspeed = bullet_aspeed
	bullet.aspeed_rotation = bullet_aspeed_rotation
	return bullet
