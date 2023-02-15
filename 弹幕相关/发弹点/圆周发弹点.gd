extends BulletSpawner

@export var r = 50
@export var bullet_number = 1
var angle_offset = 0

func bullet_spawn_logic():
	spawn_bullet(get_bullet(spawn_bullet_type))

func bullet_run_logic(bull,delta):
	angle_offset += PI*delta
	angle_offset = wrapf(angle_offset,-PI,PI)
	#计算子弹的下一位置
	var next_position = bullet_speed*\
	Vector2(r*cos(angle_offset),r*sin(angle_offset))
	next_position += position
	bull.position = next_position
	

