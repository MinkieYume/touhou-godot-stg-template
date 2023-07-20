@tool
class_name Reflecter
extends Area2D
#一个基础的反射板

@export var enable = true #是否启用反射板
@export var start_sec = 0 #进入场景几秒后开始，为0代表立刻开始
@export var end_sec = 0 #进入场景几秒后停止反弹，为0代表永不停止
@export var cycle = false
@export var out_screen_remove = true

#运动设置
@export var speed = 0
@export var speed_rotation = 0 #单位为角度
@export var aspeed = 0
@export var aspeed_rotation = 0 #单位为角度

@onready var speed_vec = Vector2.DOWN*speed
@onready var aspeed_vec = Vector2.DOWN*aspeed

#反射设置
@export var owner_whitelist = false #是否只反射白名单中的弹幕，为false则为黑名单模式
@export var length = 75 :
	get:
		return length # TODOConverter40 Non existent get function 
	set(leng):
		length = leng
		$ReflectShape.shape.b = Vector2.RIGHT*leng  # TODOConverter40 Copy here content of _set_length
@export var roatate = 0 :
	get:
		return roatate # TODOConverter40 Non existent get function 
	set(rotate):
		roatate = rotate
		rotation = deg_to_rad(rotate)  # TODOConverter40 Copy here content of _set_rotation
@export var twice = 0 #总共能反弹的子弹次数
@export var never_end = false
@export var owner_list = ["self","self_bomb"]

var started = false
var frame = 0

func _ready():
	if not Engine.editor_hint:
		STGSYS.reflectors.append(self)
		$StartTimer.wait_time = start_sec
		$EndTimer.wait_time = end_sec
		if start_sec!=0 and enable:
			$StartTimer.start()
		elif start_sec == 0 and enable:
			started = true
			if end_sec != 0:
				$EndTimer.start()

func _process(delta):
	if not Engine.editor_hint:
		if started:
			frame+=1
		else:
			frame = 0
		speed_vec += aspeed_vec.rotated(deg_to_rad(aspeed_rotation))
		position += speed_vec.rotated(deg_to_rad(speed_rotation))

func reflect_before_event(bullet):
	#继承用函数
	#在子弹反弹前运行的反弹事件函数
	pass

func reflect_after_event(bullet):
	#继承用函数
	#在子弹反弹后运行的反弹事件函数
	pass

func reflect_logic(bullet):
	#运行反射逻辑本身
	if not Engine.editor_hint:
		var owner_allow = false
		if owner_whitelist and owner_list.has(bullet.b_owner):
			owner_allow = true
		if !owner_whitelist and !owner_list.has(bullet.b_owner):
			owner_allow = true
		if twice > 0 or never_end and started and owner_allow:
			reflect_before_event(bullet)
			var n = Vector2.UP
			var t = Transform2D(rotation,Vector2(0,0))
			n = t * n
			var v1 = bullet.speed.rotated(deg_to_rad(bullet.rotation)).normalized()
			var v2 = v1-2*n*(v1*n)
			bullet.rotation += rad_to_deg(v1.angle_to(v2))
			if twice > 0:
				twice -= 1
			reflect_after_event(bullet)
		elif twice <= 0 and !never_end:
			self_free()

func get_collision_shape():
	return $ReflectShape.shape

func self_free():
	if not Engine.editor_hint:
		STGSYS.reflectors.erase(self)
		queue_free()

func _on_StartTimer_timeout():
	if end_sec != 0:
		$EndTimer.wait_time = end_sec
		started = true
		$EndTimer.start()


func _on_EndTimer_timeout():
	if !cycle:
		self_free()
	elif start_sec > 0:
		started = false
		$StartTimer.start()
	else:
		started = true
		$EndTimer.start()


func _on_VisibilityNotifier2D_screen_exited():
	if out_screen_remove:
		self_free()
