class_name BulletSpawner
extends Marker2D

# enum MANAGE_TYPE {COMMON,HIGHLIGHT}

#基本配置
@export_group("发弹点")
@export var enable = false #启用弹幕发射，必须开启这个才开始计时发射
@export var enable_shoot_bullet = true #启用发射弹幕，暂时消除发射出的弹幕时可以改为False
@export var cycle = false #循环运行的选项，即endtimer到时后再次开始startTimer计时
@export var start_frame = 0.0 #多少帧后开始发射
@export var end_frame = 0.0 #多少帧后自动结束发射
#@export var never_end = false #不结束发射的选项
# @export var bullet_manager_type: MANAGE_TYPE = MANAGE_TYPE.COMMON
# var bullet_manager_name = "普通弹幕层"

#自运动配置
# @export_group("发弹点运动")
# @export var move_start = true #启用自移动
# @export var self_move_start_sec = 0.0 #调用start_move_count方法几秒后开始移动
# @export var out_screen_free = true #启用离开屏幕范围自动消失
# @export var speed = 0.0 #自移动速度,仅用于ready前配置，ready后请改speed_vec属性
# @export var aspeed = 0.0 #自移动加速度,仅用于ready前配置，ready后请改aspeed_vec属性
# #注：这里的rotation单位是角度，而非弧度
# @export var speed_rotation = 0.0 #子弹旋转度，仅用于ready前配置，ready后请改rotation属性
# @export var aspeed_rotation = 0.0 #子弹加速旋转度
# @onready var speed_vec = Vector2.DOWN*speed #移动向量
# @onready var aspeed_vec = Vector2.DOWN*aspeed #加速度移动向量

#子弹信息配置
@export_group("子弹样式")
@export var bullet_type = "小玉" #子弹类型名称，需要在RSLOADER注册子弹场景
@export var spawn_bullet_owner = "enemy"
@export var bullet_speed = 0.0 #子弹速度，决定子弹发射时的速度
# @export var bullet_aim_to_player = false #子弹是否瞄准玩家
@export var bullet_rotation_velocity = 0.0 #子弹旋转速度，决定子弹的旋转速度
@export var bullet_unbreakable = false #子弹是否无敌
@export var bullet_aspeed = 0.0 #子弹加速度，决定子弹发射时的加速度
@export var bullet_aspeed_rotation = 0.0 #子弹加速度方向，决定子弹的旋转加速度
@export var bullet_max_speed = 0.0 #子弹最大速度，决定子弹的最大速度，若为0则不限制
@export var bullet_color = 0
@export var bullet_scale := Vector2(1, 1)
var bullet_position = position #子弹位置，决定子弹发射时的位置，默认为发弹点位置
var bullet_rotation = 0.0 #子弹旋转度，决定子弹发射时的旋转度，注：这里的rotation单位是角度，而非弧度

#子弹发射配置
@export_group("子弹运动")
@export var way_num := 1 #Way数，决定单次发射子弹的数量。
@export var way_range := 360.0 #子弹范围，决定多Way子弹发射的范围，360是一个圆周的范围
@export var way_rotation := 0.0 #发射角度，决定子弹发射的方向
@export var spawner_radius := 0.0 #发射点半径，若为0则该组所有发弹点集中在一个点。
# @export var spawner_radius_rotation := 0.0 #发弹点半径的方向
@export var spawn_interval_frame = 10 #隔多少帧发射一次子弹
@export var shooter_aim_to_player = false #发射器是否瞄准玩家
# @export var rotate_bullet = false
# @export var use_offset_position = false #发射子弹时偏移到子弹的头部发出

#内部属性
var run_frame = 0 #已运行帧数

#外部引用
@export var bullet_manager : BulletManager

func _ready():
	initialize({"bullet_manager": $"../../BulletManager"})

func initialize(shooter_attr := {}):
	var internal_vars = []
	for prop in get_script().get_script_property_list():
		if prop.usage & PROPERTY_USAGE_STORAGE or prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			internal_vars.append(prop.name)
			
	for attr in shooter_attr.keys():
		if attr in internal_vars:
			set(attr, shooter_attr[attr])
		else:
			print("BulletSpawner: %s is not a member of BulletSpawner" % attr)

func _process(delta):
	if enable:
		if enable_shoot_bullet:
			#发射间隔
			if run_frame % spawn_interval_frame == 0:
				spawn_bullet_group()
		run_frame += 1

	if run_frame >= end_frame and end_frame > 0:
		if cycle:
			run_frame = 0
		else:
			enable = false

func spawn_bullet_group():
	var radius_direction = Vector2.DOWN  # Default to down
	var bullet_position = position + radius_direction * spawner_radius
	bullet_position = bullet_position.rotated(deg_to_rad(way_rotation))
	
	var bullet_rotation = way_rotation
	var bullet_rotation_distance = way_range / float(way_num)
	var half_way_num = int(ceil(way_num / 2))

	for i in range(way_num):
		var bullet_attr = {
			"bullet_type": bullet_type,
			"color": bullet_color,
			"position": bullet_position,
			"speed": bullet_speed,
			"rotation": bullet_rotation,
			"aim_to_player": shooter_aim_to_player,
			"rotation_velocity": bullet_rotation_velocity,
			"unbreakable": bullet_unbreakable,
			"delay_time": spawn_interval_frame,
			"aspeed": bullet_aspeed,
			"aspeed_rotation": bullet_aspeed_rotation,
			"max_speed": bullet_max_speed,
			"scale": bullet_scale,
			"collision_shape": null   # Set a default value for collision_shape
		}
		
#		var bullet = Bullet.new(bullet_attr)  # Create a new bullet instance
		var bullet = bullet_manager.get_bullet()
		bullet.initialize(bullet_attr)
		bullet_manager.add_bullet(bullet, spawn_bullet_owner)

		bullet_rotation += bullet_rotation_distance
		bullet_position = bullet_position.rotated(deg_to_rad(bullet_rotation_distance))

#func spawn_bullet_group():
#	#根据当前子弹的Way数配置调整子弹旋转参数
#	#根据给出的半径和半径方向参数，设置发射每条子弹的位置
#
#	#发射位置变量赋值
#	# var radius_direction = Vector2.DOWN.rotated(deg_to_rad(spawner_radius_rotation))
#	var radius_direction = Vector2.DOWN #默认向下
#	var bullet_position = position + radius_direction * spawner_radius
#
#	#半径变量赋值
#	var bullet_rotation = way_rotation
#	var bullet_rotation_distance = way_range/float(way_num)
#	var half_way_num = int(ceil(way_num/2))
#
#	if way_num%2 == 0:
#		#若为偶数
#		#则初始半径方向和初始子弹发射反方向偏转间隔角度的一半
#		#加上半个way_num数少一的偏转间隔
#			bullet_rotation = way_rotation - bullet_rotation_distance/2 - \
#			bullet_rotation_distance*(half_way_num-1)
#			bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation_distance/2))
#			for r in range(half_way_num-1):
#				bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation_distance))
#	elif way_num > 1:
#		#若为奇数
#		#则初始半径和子弹发射方向直接反方向偏转间隔角度的一半的间隔
#		bullet_rotation = way_rotation - bullet_rotation_distance*half_way_num
#		for r in range(half_way_num):
#			bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation))
#
#	#批量设置每个弹幕具体的角度和位置
#	for bullet in bullets:
#		bullet.rotation = bullet_rotation
#		bullet.real_position = to_global(bullet_position)
#		if use_offset_position:
#			#设置子弹偏移
#			var off_dist = bullet.scale.y*16
#			bullet.real_position += \
#			Vector2(0,off_dist).rotated(deg_to_rad(bullet.rotation))
#		bullet_rotation += bullet_rotation_distance
#		bullet_position = bullet_position.rotated(deg_to_rad(bullet_rotation_distance))
