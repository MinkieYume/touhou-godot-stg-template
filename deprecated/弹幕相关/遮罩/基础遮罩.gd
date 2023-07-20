@tool
class_name Shade
extends Area2D

#遮罩基础设置
@export var enable = true #是否启用遮罩
@export var start_sec = 0 #进入场景几秒后开始，为0代表立刻开始
@export var end_sec = 0 #进入场景几秒后停止，为0代表永不停止
@export var cycle = false
@export var out_screen_remove = true
var started = false
var start_time_runed = false

#运动设置
@export var speed = 0 :
	get:
		return speed # TODOConverter40 Non existent get function 
	set(s):
		speed_vec = Vector2.DOWN*s
		speed = s  # TODOConverter40 Copy here content of _set_speed_vec
@export var speed_rotation = 0 #单位为角度
@export var aspeed = 0 :
	get:
		return aspeed # TODOConverter40 Non existent get function 
	set(a):
		aspeed_vec = Vector2.DOWN*a
		aspeed = a  # TODOConverter40 Copy here content of _set_aspeed_vec
@export var aspeed_rotation = 0 #单位为角度

var speed_vec = Vector2.ZERO
var aspeed_vec = Vector2.ZERO

#遮罩设置
@export var owner_whitelist = false #是否只控制白名单中的弹幕，为false则为黑名单模式
@export var owner_list = ["self","self_bomb"]
@export var obj_mode = false
@export var shade_area = Vector2(100,100) :
	get:
		return shade_area # TODOConverter40 Non existent get function 
	set(vec):
		$CollisionShape2D.shape.extents = vec
		$VisibleOnScreenNotifier2D.rect = Rect2(-vec,2*vec)
		shade_area = vec  # TODOConverter40 Copy here content of _set_area

var in_area_obj = []
var vars = [] #该数组用于保存遮罩事件中可能会用到的所有全局变量

var frame = 0

func _ready():
	randomize()
	if not Engine.is_editor_hint():
		STGSYS.shades.append(self)
		$CollisionShape2D.shape.extents = shade_area
		if start_sec!=0:
			$StartTimer.wait_time = start_sec
		if end_sec!=0:
			$EndTimer.wait_time = end_sec
		_on_ready()
		if start_sec!=0 and enable:
			$StartTimer.start()
		elif start_sec == 0 and enable:
			started = true
			if end_sec != 0:
				$EndTimer.start()

func _on_ready():
	pass

func _process(delta):
	if not Engine.is_editor_hint():
		if started:
			shade_event()
			for obj in in_area_obj:
				other_obj_event(obj)
			frame+=1
		elif !start_time_runed:
			if start_sec!=0 and enable:
				$StartTimer.start()
			elif start_sec == 0 and enable:
				started = true
			if end_sec != 0:
				$EndTimer.start()
		else:
			frame = 0
		speed_vec += aspeed_vec.rotated(deg_to_rad(aspeed_rotation))
		position += speed_vec.rotated(deg_to_rad(speed_rotation))

func shade_event():
	#遮罩层事件
	pass

func shade_bullet_event(bullet):
	#遮罩层弹幕事件
	bullet.wait_for_remove = true

func other_obj_event(obj):
	#遮罩层其它obj事件
	pass

func run_shade_bullet_event(bullet):
	#仅用于判定bullet是否满足条件
	#若满足则运行bullet_event
	if !obj_mode and started:
		var owner_allow = false
		if owner_whitelist and owner_list.has(bullet.b_owner):
			owner_allow = true
		if !owner_whitelist and !owner_list.has(bullet.b_owner):
			owner_allow = true
		if owner_allow:
			shade_bullet_event(bullet)

func get_collision_shape():
	return $CollisionShape2D.shape

func self_free():
	if not Engine.is_editor_hint():
		STGSYS.shades.erase(self)
		queue_free()

func _on_StartTimer_timeout():
	start_time_runed = true
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

func is_obj_allow(obj):
	var owner_allow = false
	if obj_mode:
		if owner_whitelist:
			for o in owner_list:
				if obj.is_in_group(o):
					owner_allow = true
		else:
			for o in owner_list:
				if !obj.is_in_group(o):
					owner_allow = true
	return owner_allow

func _on__body_entered(body):
	if is_obj_allow(body):
		in_area_obj.append(body)

func _on__area_entered(area):
	if is_obj_allow(area):
		in_area_obj.append(area)

func _on__body_exited(body):
	if is_obj_allow(body):
		in_area_obj.erase(body)

func _on__area_exited(area):
	if is_obj_allow(area):
		in_area_obj.erase(area)


func _on_VisibilityNotifier2D_screen_exited():
	if out_screen_remove:
		self_free()
