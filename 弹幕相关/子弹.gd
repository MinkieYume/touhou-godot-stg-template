class_name Bullet
extends Object

var color = 0
var b_owner = "none"
var moving_type = "linear"
var bullet_type = "中玉"

var life = 0
var unbreakable = false
var in_graze_area = false

var out_screen_remove = true #出屏即消，如果为false，则通过子弹生命计算子弹消除时间

var speed = 1*Vector2.DOWN
var aspeed = 0*Vector2.DOWN
var aspeed_rotation = 0
var real_position = Vector2.ZERO
var position = Vector2.ZERO
#注：这里的rotation单位是角度，而非弧度
var rotation = 0
var run_frame = 0
var scale = Vector2(1,1) :
	get:
		return scale # TODOConverter40 Non existent get function 
	set(s):
		if s != Vector2(1,1):
			collision_shape = collision_shape.duplicate()
		if collision_shape is RectangleShape2D:
			collision_shape.extents *= s
		if collision_shape is SegmentShape2D:
			collision_shape.a *= s
			collision_shape.b *= s
		scale = s  # TODOConverter40 Copy here content of _set_collision_scale

var collision_shape:Shape2D
var position_trans = Transform2D.IDENTITY

var wait_for_remove = false

func move(delta):
	match moving_type:
		"linear": #直线飞行逻辑
			speed += aspeed.rotated(deg_to_rad(aspeed_rotation))
			real_position += speed.rotated(deg_to_rad(rotation))
		"parabola": #抛物线飞行逻辑 y=ax^{2}+bx+c
			pass
		"speed_liner": #仅计算speed的直线飞行逻辑
			speed += aspeed
			real_position += speed
	position = position_trans * real_position
	run_frame += 1

func get_collision_shape():
	return collision_shape

func _initlize():
	pass

func detect_collsion_with(bul_trans,obj):
	var obj_trans = Transform2D(obj.rotation,obj.position)
	var obj_shape = obj.get_collision_shape()
	return collision_shape.collide(bul_trans,obj_shape,obj_trans)

func collision_detect():
	var bul_trans = Transform2D(rotation,position)
	#只要改变了移动状态就会运行的形状判定检测
	match b_owner:
		"self":
			for enemy in STGSYS.enemys:
				if detect_collsion_with(bul_trans,enemy):
					#在此处写自机子弹撞到敌机的效果
					enemy.emit_signal("hited")
					if !unbreakable:
						wait_for_remove = true
			
			for reflect in STGSYS.reflectors:
				if reflect.enable:
					if detect_collsion_with(bul_trans,reflect):
						#在此写自机子弹撞到反射板的结果
						reflect.reflect_logic(self)
			
			for shade in STGSYS.shades:
				if shade.enable:
					if detect_collsion_with(bul_trans,shade):
						#自机弹幕撞到遮罩的结果
						shade.run_shade_bullet_event(self)
		"self_bomb":
			for enemy_bull in STGSYS.enemy_bullets:
				#在此处写自机炸弹撞到敌机子弹的结果
				if detect_collsion_with(bul_trans,enemy_bull):
					if !unbreakable:
						enemy_bull.wait_for_remove = true
			
			for reflect in STGSYS.reflectors:
				if reflect.enable:
					if detect_collsion_with(bul_trans,reflect):
						#在此写自机炸弹撞到反射板的结果
						reflect.reflect_logic(self)
			
			for shade in STGSYS.shades:
				if shade.enable:
					if detect_collsion_with(bul_trans,shade):
						#自机炸弹撞到遮罩的结果
						shade.run_shade_bullet_event(self)
			
			for enemy in STGSYS.enemys:
				if detect_collsion_with(bul_trans,enemy):
					#在此处写自机炸弹撞到敌机的效果
					enemy.emit_signal("hited")
					if !unbreakable:
						wait_for_remove = true
		_:
			for reflect in STGSYS.reflectors:
				if reflect.enable:
					if detect_collsion_with(bul_trans,reflect):
						#在此写敌机子弹撞到反射板的结果
						reflect.reflect_logic(self)
			
			for shade in STGSYS.shades:
				if shade.enable:
					if detect_collsion_with(bul_trans,shade):
						#敌机弹幕撞到遮罩的结果
						shade.run_shade_bullet_event(self)
			
			for self_flyer in STGSYS.self_flyers:
				var self_graze = self_flyer.get_node("GrazeArea")
				var self_graze_trans = Transform2D(self_flyer.rotation,\
				self_flyer.to_global(self_graze.position))
				var self_graze_shape = self_graze.get_collision_shape()
				if collision_shape.collide(bul_trans,self_graze_shape,self_graze_trans):
					#在此写敌机子弹撞到自机擦弹范围的结果
					if speed != Vector2(0,0):
						self_graze.emit_signal("graze")
				
				var self_dead_point = self_flyer.get_dead_point()
				var self_dead_trans = Transform2D(self_flyer.rotation,\
				self_flyer.to_global(self_dead_point.position))
				var self_dead_shape = self_dead_point.get_collision_shape()
				if collision_shape.collide(bul_trans,self_dead_shape,self_dead_trans):
					#在此处写敌机子弹撞到自机判定点的结果
					self_dead_point.emit_signal("hit",self)
	
