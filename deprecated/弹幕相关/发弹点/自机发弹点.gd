extends BulletSpawner

func _on_ready():
	bullet_manager_name = "玩家子弹层"
	spawn_bullet_type = "小玉"
	spawn_bullet_owner = "self"
	way_rotation = -180

func bullet_spawn_logic():
	var bullets = get_bullet_group(way_num)
	set_way_bullet_spawn(bullets)
	spawn_group_of_bullet(bullets)
