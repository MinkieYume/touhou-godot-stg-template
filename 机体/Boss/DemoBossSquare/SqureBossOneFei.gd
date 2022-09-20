extends EnemyFlyerShooter

@export var enemy_num = 2

func bullet_spawn_logic():
	var enemy = get_bullet(spawn_bullet_type)
	enemy.physicMove = true
	enemy.selfMove = false
	enemy_spawn_logic(enemy)

func enemy_spawn_logic(enemy):
	var direction = get_global_position().direction_to(player.get_global_position())
	bullet_rotation = rad_to_deg(Vector2.DOWN.angle_to(direction))
	spawn_bullet(enemy)
