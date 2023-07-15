class_name BulletObj
extends Object

const SPEED_MULTIPLYER = 60

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
	var internal_vars = []
	for prop in get_script().get_script_property_list():
		if prop.usage & PROPERTY_USAGE_STORAGE or prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			internal_vars.append(prop.name)
			
	for attr in args.keys():
		if attr in internal_vars:
			set(attr, args[attr])
		else:
			print("Bullet: %s is not a member of Bullet" % attr)

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

	var velocity = direction * speed * SPEED_MULTIPLYER * delta
	
	position += velocity
	
	#更新碰撞体积

#待实现
func get_player_position():
	pass
