class_name BulletOld
extends Object

const SPEED_MULTIPLYER = 100

#基础属性
var bullet_type = "":
	get:
		return bullet_type
	set(t):
		collision_shape = RS.bullet_collision_shapes[t]
		bullet_type = t
var color := 0
var position := Vector2.ZERO
var speed := 0.0
var rotation := 0.0 #角度
var aim_to_player := false
var rotation_velocity := 0.0 #每帧旋转速度
var unbreakable := false
var delay_time := 0 #延迟帧
var aspeed := 0 #加速度
var aspeed_rotation := 0 #旋转加速度
var max_speed := 0 #最大速度
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
		if collision_shape is ConvexPolygonShape2D:
			for point in collision_shape.points:
				point *= s
		if collision_shape is CapsuleShape2D:
			collision_shape.radius *= s.x
			collision_shape.height *= s.y
		scale = s  # TODOConverter40 Copy here content of _set_collision_scale
var collision_shape:Shape2D

func _init(args := {}):
	initialize(args)

#子弹的初始化方法，实例化子弹时必须记得调用此方法，可根据情况覆写
func initialize(args):
	#子弹类型
	if args.has("bullet_type"):
		bullet_type = args["bullet_type"]
		
	#子弹位置
	if args.has("position"):
		position = args["position"]
	
	#子弹速度
	if args.has("speed"):
		speed = args["speed"]
	
	#子弹朝向玩家
	if args.has("aim_to_player"):
		aim_to_player = args["aim_to_player"]

#object 本身并没有 _process() 方法，需要通过弹幕管理器每帧调用本方法
func process(delta):
	if delay_time > 0:
		delay_time -= 1
	else:
		move(delta)
	
func move(delta):
	speed += aspeed * delta
	if max_speed != 0 and speed > max_speed:
		speed = max_speed

	rotation_velocity += aspeed_rotation * delta

	rotation += rotation_velocity * delta

	var direction = Vector2.DOWN.rotated(deg_to_rad(rotation))
	
	if aim_to_player:
		# 如果子弹需要朝向玩家，那么需要获取玩家的位置并计算方向
		var player_position = get_player_position()
		direction = (player_position - position).normalized()

	var velocity = direction * speed * delta

	# 用前进方向和速度更新位置
	position += velocity

#待实现
func get_player_position():
	pass

#const SPEED_MULTIPLYER = 100
#
#var color = 0
#var b_owner = "none"
#var moving_type = "linear"
#var bullet_type = "中玉" :
#	get:
#		return bullet_type
#	set(t):
#		collision_shape = RS.bullet_collision_shapes[t]
#		bullet_type = t
#
#var life = 0
#var damage := 1.0
#var unbreakable = false
#var in_graze_area = false
#var no_pic_rotation = false
#
#var bullet_tags = {
#	"skill":"",
#}
#
#var out_screen_remove = true #出屏即消，如果为false，则通过子弹生命计算子弹消除时间
#
#var speed_value = 0
#var aspeed_value = 0
#var speed = speed_value * Vector2.DOWN
#var aspeed = aspeed_value * Vector2.DOWN
#var aspeed_rotation = 0
#var sin_amplitude = 0 #sinx的振幅，数值越大，振幅越大
#var sin_period = 0 #sinx的周期公式B值(period=2pi/B)，数值越大，周期越短（快)
#var real_position = Vector2.ZERO
#var position = Vector2.ZERO
##注：这里的rotation单位是角度，而非弧度
#var rotation = 0 : set = _set_rotation
#var show_rotation = 0 :
#	get:
#		return show_rotation
#	set(r):
#		if collision_shape is ConvexPolygonShape2D:
#			if r != 0 and int(r)%360 != 0:
#				collision_shape = collision_shape.duplicate()
#			for point in collision_shape.points:
#				point.rotated(deg_to_rad(r))
#		show_rotation = r
#
#var rotating_speed = 1
#
#var run_frame = 0
#var scale = Vector2(1,1) :
#	get:
#		return scale # TODOConverter40 Non existent get function 
#	set(s):
#		if s != Vector2(1,1):
#			collision_shape = collision_shape.duplicate()
#		if collision_shape is RectangleShape2D:
#			collision_shape.extents *= s
#		if collision_shape is SegmentShape2D:
#			collision_shape.a *= s
#			collision_shape.b *= s
#		if collision_shape is ConvexPolygonShape2D:
#			for point in collision_shape.points:
#				point *= s
#		if collision_shape is CapsuleShape2D:
#			collision_shape.radius *= s.x
#			collision_shape.height *= s.y
#		scale = s  # TODOConverter40 Copy here content of _set_collision_scale
#
#var collision_shape:Shape2D
#var position_trans = Transform2D.IDENTITY
#
#var rotating = false
#var wait_for_remove = false
#
#var target_enemy #追踪弹的目标
#
##初始化子弹属性
#func _init(args := {}):
#	#子弹生命
#	if args.has("life"):
#		life = args["life"]
#
#	#子弹伤害
#	if args.has("damage"):
#		damage = args["damage"]
#
#	#子弹类型
#	if args.has("bullet_type"):
#		bullet_type = args["bullet_type"]
#
#	#子弹颜色
#	if args.has("color"):
#		color = args["color"]
#
#	#子弹拥有者
#	if args.has("b_owner"):
#		b_owner = args["b_owner"]
#
#	#子弹碰撞体
#	if args.has("collision_shape"):
#		collision_shape = args["collision_shape"]
#
#	#子弹自身是否不断旋转
#	if args.has("rotating"):
#		rotating = args["rotating"]
#
#	#子弹速度
#	if args.has("speed_value"):
#		speed_value = args["speed_value"]
#
#	#子弹加速度
#	if args.has("aspeed_value"):
#		aspeed_value = args["aspeed_value"]
#
#	#子弹速度向量
#	if args.has("speed"):
#		speed = args["speed"]
#
#	#子弹加速度向量
#	if args.has("aspeed"):
#		aspeed = args["aspeed"]
#
#	#子弹sin振幅
#	if args.has("sin_amplitude"):
#		sin_amplitude = args["sin_amplitude"]
#
#	#子弹sin周期
#	if args.has("sin_period"):
#		sin_period = args["sin_period"]
#
#	#子弹旋转角度
#	if args.has("rotation"):
#		rotation = args["rotation"]
#		show_rotation = rotation
#
#	#子弹加速度旋转角度
#	if args.has("aspeed_rotation"):
#		aspeed_rotation = args["aspeed_rotation"]
#
#	#子弹运动类型
#	if args.has("moving_type"):
#		moving_type = args["moving_type"]
#
#	#子弹 real_position
#	if args.has("real_position"):
#		real_position = args["real_position"]
#
#	#子弹 scale
#	if args.has("scale"):
#		scale = args["scale"]
#
#	#子弹 tag
#	if args.has("bullet_tags"):
#		for tag in args["bullet_tags"]:
#			set_tag(tag, args["bullet_tags"][tag])
#
#	#子弹追踪目标
#	if args.has("target_enemy"):
#		target_enemy = args["target_enemy"]
#
##	print("技能 %s 伤害 %s 输入伤害 %s" % [bullet_tags.skill,damage,args["damage"]])
#
#func move(delta):
#	match moving_type:
#		"linear": #直线飞行逻辑
#			if rotating:
#				if show_rotation >= 360:
#					show_rotation = 0
#				show_rotation += rotating_speed
#			else:
#				show_rotation = rotation
#			speed_value += aspeed_value
#			speed += aspeed.rotated(deg_to_rad(aspeed_rotation))
#			real_position += speed
##			var new_aspeed_rotation = aspeed_rotation - rotation
##			speed += aspeed.rotated(deg_to_rad(new_aspeed_rotation))
##			real_position += speed.rotated(deg_to_rad(rotation))
#		"parabola": #抛物线飞行逻辑 y=ax^{2}+bx+c
#			pass
#		"sinx": #y = sinx
#			var tri = Vector2.ZERO
#			# tri.y = 10*sin(tri.x/8)
#			# real_position += speed.rotated(deg_to_rad(rotation))
#			speed_value += aspeed_value
#			speed += aspeed.rotated(deg_to_rad(aspeed_rotation))
#			tri.x = real_position.x + speed.x - bullet_tags["init_pos"].x
#			tri.y = sin_amplitude * sin(sin_period * tri.x)
#			real_position.x += speed.x
#			real_position.y += tri.y
#		"cosx": #y = cosx
#			pass
#		"speed_liner": #仅计算speed的直线飞行逻辑
#			speed_value += aspeed_value
#			speed += aspeed
#			real_position += speed
#		"chaser":
#			if target_enemy:
#				var angle_to_enemy = rad_to_deg(Vector2.DOWN.angle_to(position.direction_to(target_enemy.position)))
#				self.rotation = angle_to_enemy
#			speed_value += aspeed_value
#			speed += aspeed.rotated(deg_to_rad(aspeed_rotation))
#			real_position += speed
#	position = position_trans * real_position
#	run_frame += 1
#
#func get_collision_shape():
#	return collision_shape
#
#func _initlize():
#	pass
#
#func detect_collsion_with(bul_trans,obj):
#	if is_instance_valid(obj):
#		var obj_trans = Transform2D(obj.rotation,obj.position)
#		var obj_shape = obj.get_collision_shape()
#		return collision_shape.collide(bul_trans,obj_shape,obj_trans)
#
#func collision_detect():
#	var bul_trans = Transform2D(rotation,position)
#	#只要改变了移动状态就会运行的形状判定检测
#	match b_owner:
#		"self":
#			#自机子弹
#			for enemy in STGSYS.enemys:
#				if detect_collsion_with(bul_trans,enemy):
#					#在此处写自机子弹撞到敌机的效果
#					enemy.emit_signal("hited",self,damage)
#					if !unbreakable:
#						wait_for_remove = true
#
#			for reflect in STGSYS.reflectors:
#				if reflect.enable:
#					if detect_collsion_with(bul_trans,reflect):
#						#在此写自机子弹撞到反射板的结果
#						reflect.reflect_logic(self)
#
#			for shade in STGSYS.shades:
#				if shade.enable:
#					if detect_collsion_with(bul_trans,shade):
#						#自机弹幕撞到遮罩的结果
#						shade.run_shade_bullet_event(self)
#		"self_bomb":
#			#自机炸弹
#			for enemy_bull in STGSYS.enemy_bullets:
#				#在此处写自机炸弹撞到敌机子弹的结果
#				if detect_collsion_with(bul_trans,enemy_bull):
#					if !unbreakable:
#						enemy_bull.wait_for_remove = true
#
#			for reflect in STGSYS.reflectors:
#				if reflect.enable:
#					if detect_collsion_with(bul_trans,reflect):
#						#在此写自机炸弹撞到反射板的结果
#						reflect.reflect_logic(self)
#
#			for shade in STGSYS.shades:
#				if shade.enable:
#					if detect_collsion_with(bul_trans,shade):
#						#自机炸弹撞到遮罩的结果
#						shade.run_shade_bullet_event(self)
#
#			for enemy in STGSYS.enemys:
#				if detect_collsion_with(bul_trans,enemy):
#					#在此处写自机炸弹撞到敌机的效果
#					enemy.emit_signal("hited",self,damage)
#					if !unbreakable:
#						wait_for_remove = true
#		"raser_line":
#			#激光判定线
#			for shade in STGSYS.shades:
#				if shade.enable:
#					if detect_collsion_with(bul_trans,shade):
#						#判定线碰到遮罩的结果
#						shade.run_shade_bullet_event(self)
#		_:
#			#其它子弹
#			for reflect in STGSYS.reflectors:
#				if reflect.enable:
#					if detect_collsion_with(bul_trans,reflect):
#						#在此写敌机子弹撞到反射板的结果
#						reflect.reflect_logic(self)
#
#			for shade in STGSYS.shades:
#				if shade.enable:
#					if detect_collsion_with(bul_trans,shade):
#						#敌机弹幕撞到遮罩的结果
#						shade.run_shade_bullet_event(self)
#
#			for self_flyer in STGSYS.self_flyers:
#				var self_graze = self_flyer.get_node("GrazeArea")
#				var self_graze_trans = Transform2D(self_flyer.rotation,\
#				self_flyer.to_global(self_graze.position))
#				var self_graze_shape = self_graze.get_collision_shape()
#				if collision_shape.collide(bul_trans,self_graze_shape,self_graze_trans):
#					#在此写敌机子弹撞到自机擦弹范围的结果
#					if speed != Vector2(0,0):
#						self_graze.emit_signal("graze")
#
#				var self_dead_point = self_flyer.get_dead_point()
#				var self_dead_trans = Transform2D(self_flyer.rotation,\
#				self_flyer.to_global(self_dead_point.position))
#				var self_dead_shape = self_dead_point.get_collision_shape()
##				print("自机判定点位置："+ str(self_dead_point.global_position))
##				print("子弹位置："+ str(position))
##				print(collision_shape.collide(bul_trans,self_dead_shape,self_dead_trans))
##				print("------")
#				if collision_shape.collide(bul_trans,self_dead_shape,self_dead_trans):
#					#在此处写敌机子弹撞到自机判定点的结果
#					self_dead_point.emit_signal("hit",self)
#
#func set_tag(tag_name, value):
#	#添加标签
#	bullet_tags[tag_name] = value	
#
##设置子弹旋转
#func _set_rotation(r):
#	self.show_rotation = r
#	self.speed = speed.rotated(deg_to_rad(r - rotation)) #将速度修正为旋转后的方向
#	rotation = r
