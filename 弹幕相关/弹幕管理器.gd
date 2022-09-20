class_name BulletManager
extends Node2D

var bullets = []
var updated_bullet_pic = {}
var in_screen_bullet = 0
var clear = false

func _ready():
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func _draw():
	for polygon in updated_bullet_pic.keys():
		draw_polygon(polygon[0],PackedColorArray(),polygon[1],updated_bullet_pic[polygon])

func get_bullet_polygon(bullet,texture:AtlasTexture):
	var polygon = RS.bullet_polygons[texture]
	#将定义好的多边形加上坐标得出解
	var pos_offset = texture.get_size()/2
	var polygon_array = []
	
	#先给多边形进行缩放操作
	var scaled_polygon = [polygon[0][0],\
	polygon[0][1]*bullet.scale.x,\
	polygon[0][2]*bullet.scale,\
	polygon[0][3]*bullet.scale.y]
	pos_offset*=bullet.scale
	
	#然后给多边形进行旋转和平移操作
	for polygon_pos in scaled_polygon:
		polygon_pos -= pos_offset
		polygon_pos = polygon_pos.rotated(deg_to_rad(bullet.rotation))
		polygon_pos += bullet.position
		polygon_array.append(polygon_pos)
		polygon_array = PackedVector2Array(polygon_array)
	return [polygon_array,polygon[1]]

func _process(delta):
	if clear:
		for bullet in bullets:
			remove_bullet(bullet)
	move_bullets(delta)

#将一个新的子弹添加进管理器
func create_bullet_bul(bullet):
	bullet._initlize()
	bullets.append(bullet)

func get_new_bullet():
	#获取一个没有任何配置的新的弹幕
	return Bullet.new()

func remove_bullet(bullet):
	STGSYS.enemy_bullets.erase(bullet)
	bullets.erase(bullet)
	bullet.free()

func add_bullet_to_update(bullet):
	var pic = RS.bullet_pics[bullet.bullet_type][bullet.color]
	var polygon = get_bullet_polygon(bullet,pic)
	updated_bullet_pic[polygon] = pic

func move_bullets(delta):
	updated_bullet_pic = {}
	in_screen_bullet = 0
	for bullet in bullets:
		#开始处理子弹的移动逻辑
		var before_position = bullet.position
		bullet.move(delta)
			
		add_bullet_to_update(bullet)
		#如果子弹位置发生变化，则将运行判定逻辑
		if bullet.position != before_position:
			bullet.collision_detect()
			
		#判定子弹是否超出屏幕范围
		if bullet.position.x > STGSYS.view_portsize.x + 40 or \
		bullet.position.x < -40 or bullet.position.y < -40 or \
		bullet.position.y > STGSYS.view_portsize.y + 40:
			#超出屏幕后清理子弹
			if bullet.out_screen_remove:
				bullet.wait_for_remove = true
			else:
				in_screen_bullet+=1
			
		#子弹的出屏即消关掉时计算多久删除子弹
		if !bullet.out_screen_remove:
			if bullet.life > 0:
				bullet.life -=1
			else:
				bullet.wait_for_remove = true
	
	for bullet in bullets:
		if bullet.wait_for_remove:
			remove_bullet(bullet)
	queue_redraw()
