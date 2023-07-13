class_name BulletManager
extends Node2D

var bullets = [] #所有子弹
var player_bullets = [] # 存储自机的子弹
var enemy_bullets = [] # 存储敌人的子弹
var updated_bullet_pic = {}
var in_screen_bullet = 0

var players = []
var enemies = []
var collision_objects = []

func _ready():
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func _draw():
	for polygon in updated_bullet_pic.keys():
		draw_polygon(polygon[0],PackedColorArray(),polygon[1],updated_bullet_pic[polygon])

func _process(delta):
	move_bullets(delta)

func add_player(player):
	players.append(player)

func add_enemy(enemy):
	enemies.append(enemy)

func add_collision_object(collision_object):
	collision_objects.append(collision_object)

func remove_player(player):
	players.erase(player)

func remove_enemy(enemy):
	enemies.erase(enemy)

func remove_collision_object(collision_object):
	collision_objects.erase(collision_object)

#注册子弹，bullet_owner = player/enemy，bullet_mode = normal/highlight
func add_bullet(bullet:Bullet, bullet_owner := "enemy", bullet_mode := "normal"):
	bullets.append(bullet)
	
	if bullet_owner == "player":
		player_bullets.append(bullet)
	elif bullet_owner == "enemy":
		enemy_bullets.append(bullet)

#清屏弹幕
func clear_bullets():
	for bullet in bullets:
		bullets.erase(bullet)
		player_bullets.erase(bullet)
		enemy_bullets.erase(bullet)
		bullet.free()

func move_bullets(delta):
	updated_bullet_pic = {}
	for bullet in bullets:
		#开始处理子弹的移动逻辑
		bullet.process(delta)

		#更新子弹的碰撞位置
		var pic = RS.bullet_pics[bullet.bullet_type][bullet.color]
		# var polygon = get_bullet_polygon(bullet,pic)
		var tmp_polygon = RS.bullet_polygons[pic]
		#将定义好的多边形加上坐标得出解
		var pos_offset = pic.get_size()/2
		var polygon_array = []

		#先给多边形进行缩放操作
		var scaled_polygon = [tmp_polygon[0][0],\
		tmp_polygon[0][1]*bullet.scale.x,\
		tmp_polygon[0][2]*bullet.scale,\
		tmp_polygon[0][3]*bullet.scale.y]
		pos_offset*=bullet.scale

		#然后给多边形进行旋转和平移操作
		for polygon_pos in scaled_polygon:
			polygon_pos -= pos_offset
#			if !bullet.no_pic_rotation:
#				polygon_pos = polygon_pos.rotated(deg_to_rad(bullet.show_rotation))
			polygon_pos = polygon_pos.rotated(deg_to_rad(bullet.rotation))
			polygon_pos += bullet.position
			polygon_array.append(polygon_pos)
			polygon_array = PackedVector2Array(polygon_array)
		var polygon = [polygon_array,tmp_polygon[1]]
		updated_bullet_pic[polygon] = pic
	queue_redraw()
