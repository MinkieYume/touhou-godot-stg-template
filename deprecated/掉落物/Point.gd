class_name Point
extends Object
#一个基础的加点物品场景

@export var point_var = 1 #单个该物品对象的得点数

#以下是移动的各个量，如果没有特殊操作不需要修改
@export var direction = Vector2(0,-1)
@export var aspeed = -1
@export var speed = 100
@export var position = Vector2(0,0)
@export var scale = Vector2(1,1):
	get:
		return scale # TODOConverter40 Non existent get function 
	set(s):
		if s != Vector2(1,1):
			rect.size *= s
			collision_shape = collision_shape.duplicate()
		if collision_shape is RectangleShape2D:
			collision_shape.extents *= s
		if collision_shape is SegmentShape2D:
			collision_shape.a *= s
			collision_shape.b *= s
		scale = s 

var texture
var rect:Rect2
var collision_shape:Shape2D
var wait_for_remove = false

func _ready():
	rect = RS.item_rects["Point"]
	collision_shape = RS.get_item_collision_shape(texture)

func _on_reach_player_area(player):
	change_var()

func change_var():
	#更改值，可覆写该场景以更改对应值
	STGSYS.change_value("point",STGSYS.point+point_var)
	STGSYS.change_value("score",STGSYS.score+point_var*10)
	wait_for_remove = true

func detect_collsion_with(bul_trans,obj):
	var obj_trans = Transform2D(obj.rotation,obj.position)
	var obj_shape = obj.get_collision_shape()
	return collision_shape.collide(bul_trans,obj_shape,obj_trans)

func collision_detect():
	#只要改变了移动状态就会运行的形状判定检测
	var bul_trans = Transform2D(Vector2(1,0),Vector2(0,1),position+rect.size)
	for self_flyer in STGSYS.self_flyers:
		if detect_collsion_with(bul_trans,self_flyer):
			#在此写撞到自机擦弹范围的结果
			_on_reach_player_area(self_flyer)
				
		var self_dead_point = self_flyer.get_dead_point()
		var self_dead_trans = Transform2D(self_flyer.rotation,\
		self_flyer.to_global(self_dead_point.position))
		var self_dead_shape = self_dead_point.get_collision_shape()
		if collision_shape.collide(bul_trans,self_dead_shape,self_dead_trans):
			#在此处写撞到自机判定点的结果
			pass

func move(delta):
	speed += aspeed
	position += direction * speed * delta
