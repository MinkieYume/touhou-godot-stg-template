extends BulletSpawnerBomb

func bullet_spawn_logic():
	var bullets = get_bullet_group(way_num)
	set_way_bullet_spawn(bullets)
	spawn_group_of_bullet(bullets)
	if spawn_bullet_color < 15:
		spawn_bullet_color+=1
	else:
		spawn_bullet_color = 0
