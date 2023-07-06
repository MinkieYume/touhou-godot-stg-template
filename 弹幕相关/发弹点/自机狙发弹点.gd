extends BulletSpawner

#自机狙相关配置
@export var lock_aim_direction = false #锁定自机狙的方向，即只在发射时获取一次玩家方向
@export var bullet_aim = true #是否是子弹瞄准玩家的自机狙

func bullet_spawn_logic():
	var player = STGSYS.player
	var direction = get_global_position().direction_to(player.get_global_position())
	var bullets = get_bullet_group(way_num)
	if !lock_aim_direction and bullet_aim:
		#若未锁定自机狙方向，则每个子弹都会获取一次玩家方向
		way_rotation = rad_to_deg(Vector2.DOWN.angle_to(direction))
	set_way_bullet_spawn(bullets)
	spawn_group_of_bullet(bullets)

func _on_StartTimer_timeout():
	if lock_aim_direction and bullet_aim:
		#若锁定自机狙方向，则只在发射时获取一次玩家方向
		var player = STGSYS.player
		var direction = get_global_position().direction_to(player.get_global_position())
		way_rotation = rad_to_deg(Vector2.DOWN.angle_to(direction))
	shoot()
	$EndTimer.start()
