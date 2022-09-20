extends BulletSpawner
class_name EnemyFlyerShooter

func _on_ready():
	bullet_manager_name = "敌人"

func bullet_spawn_logic():
	var enemys = get_bullet_group(way_num)
	set_way_bullet_spawn(enemys)
	enemy_spawn_logic(enemys)
	for enemy in enemys:
		enemy.enable_move = true

func spawn_bullet(bullet):
	if enable_shoot_bullet:
		#特殊参数处理
		bullet.position = bullet.position_trans*bullet.real_position
		bullet.out_screen_remove = bullet_out_screen_remove
		
		#子弹的生成处理
		all_bullets.append(bullet)
		STGSYS.current_level.get_node(bullet_manager_name).add_child(bullet)

func enemy_spawn_logic(enemys):
	spawn_group_of_bullet(enemys)

func get_bullet(bullet_name):
	#获取单个子弹，给子弹赋值基础属性参数
	#外观参数
	var bullet = RS.enemys[bullet_name].instantiate()
	
	#运动参数
	bullet.speed = bullet_speed*Vector2.DOWN
	bullet.aspeed = bullet_aspeed*Vector2.DOWN
	bullet.aspeed_rotation = bullet_aspeed_rotation
	return bullet
