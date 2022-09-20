extends BulletSpawner

#一个基础的符卡，继承BulletSpawner
#当然继承对象也可以改为别的BulletSpawner

func bullet_spawn_logic():
	#重写该函数以自定义生成子弹初始设定
	#也可以重写生成子弹前运行的逻辑
	#每次发射子弹的时候运行
	bullet_moving_type = "speed_liner"
	var bullets = get_bullet_group(way_num)
	set_way_bullet_spawn(bullets)
	bullet_draw_polygon(bullets,4)
	spawn_group_of_bullet(bullets)
	if spawn_bullet_color < 14:
		spawn_bullet_color +=1
	else:
		spawn_bullet_color = 0

func draw_Shuai_bullet(bullets):
	#本来打算画个方，结果无意间摸出做甩弹的方法了
	#因此这个方法可作为一个研究甩弹如何制作的范例
	var speed_crease = 0
	var rotation_decrease = 0
	for bullet in bullets:
		bullet.speed += Vector2.DOWN*speed_crease
		bullet.rotation = way_rotation+rotation_decrease
		speed_crease += 0.1
		rotation_decrease += 1

func _on_ready():
	#该发弹点加载好的时候运行
	pass

func _on_end():
	#发射结束时候运行一次
	#如果neverend为true则永远不会运行该方法
	#如果cycle为true则代表每次循环结束时运行一次
	bullet_speed+=0.5
	spawn_bullet_frame-=20

func self_run_logic():
	#自己的运行逻辑
	#每帧运行一次
	way_rotation+=1
	if frame % spawn_bullet_frame == 0:
		pass

func bullet_run_logic(bull,delta):
	#子弹的运行逻辑
	#如果屏幕总子弹数为n的话，则每帧运行n次
	#在self_run_logic之后运行
	pass



func old_draw_squre(bullets):
	#获取正方形边长
	var SQURE_SCALE = 1
	var squre_length = (way_num/4)*SQURE_SCALE
	
	#先获取以0,0为中心的正方形顶点坐标
	var raw_squre = PackedVector2Array([\
	Vector2(-squre_length/2,squre_length/2),#左下
	Vector2(squre_length/2,squre_length/2),#右下
	Vector2(squre_length/2,-squre_length/2),#右上
	Vector2(-squre_length/2,-squre_length/2)])#左上
	
	var s_trans = Transform2D(Vector2(1,0),Vector2(0,1),position) 
	
	#对基础的正方形坐标进行变换
	var squre = []
	for s in raw_squre:
		squre.append(s_trans * s.rotated(deg_to_rad(way_rotation)))
	
	var squre_line = []
	var squre_point_num = 0
	#根据正方形的所有点坐标获取所有连成的线的整数坐标
	for sq in squre:
		if squre_point_num < 3:
			var sl = Util.get_line_points(squre[squre_point_num],\
			squre[squre_point_num+1])
			squre_point_num += 1
			squre_line.append(sl)
		else:
			var sl = Util.get_line_points(squre[squre_point_num],squre[0])
			squre_line.append(sl)
		
	
	var line_id = 0
	var point_num = 0
	var bullet_id = 0
	var squre_bullet_rotation = 45
	#遍历所有弹幕，设置方形
	print(squre_line)
	for line in squre_line:
		for l in line:
			var bullet = bullets[bullet_id]
			bullet.real_position = l
			bullet.rotation = squre_bullet_rotation
			bullet.speed = Vector2(0,0)
			bullet_id+=1
	for bullet in bullets:
		if line_id <= 3:
			if point_num*SQURE_SCALE < squre_line[line_id].size():
				bullet.real_position = squre_line[line_id][point_num*SQURE_SCALE]
				bullet.rotation = squre_bullet_rotation
				bullet.speed = Vector2(0,0)
				point_num += 1
			else:
				point_num = 0
				line_id += 1
