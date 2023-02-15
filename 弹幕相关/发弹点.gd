class_name BulletSpawner
extends Marker2D

enum MANAGE_TYPE {COMMON,HIGHLIGHT}

#基本配置
@export_group("发弹点")
@export var enable = false #启用弹幕发射，必须开启这个才开始计时发射
@export var enable_shoot_bullet = true #启用发射弹幕，暂时消除发射出的弹幕时可以改为False
@export var cycle = false #循环运行的选项，即endtimer到时后再次开始startTimer计时
@export var start_sec = 0.1 #多少秒后开始发射
@export var end_sec = 20.0 #多少秒后自动结束发射
@export var never_end = false #不结束发射的选项
@export var bullet_manager_type: MANAGE_TYPE = MANAGE_TYPE.COMMON
var bullet_manager_name = "普通弹幕层"

#自运动配置
@export_group("发弹点运动")
@export var move_start = true #启用自移动
@export var self_move_start_sec = 0.1 #调用start_move_count方法几秒后开始移动
@export var out_screen_free = true #启用离开屏幕范围自动消失
@export var speed = 0.0 #自移动速度,仅用于ready前配置，ready后请改speed_vec属性
@export var aspeed = 0.0 #自移动加速度,仅用于ready前配置，ready后请改aspeed_vec属性
#注：这里的rotation单位是角度，而非弧度
@export var speed_rotation = 0.0 #子弹旋转度，仅用于ready前配置，ready后请改rotation属性
@export var aspeed_rotation = 0.0 #子弹加速旋转度
@onready var speed_vec = Vector2.DOWN*speed #移动向量
@onready var aspeed_vec = Vector2.DOWN*aspeed #加速度移动向量

#子弹信息配置
@export_group("子弹样式")
@export var bullet_life = 0 #子弹生命，设置子弹离开屏幕后多少帧后消失
@export var bullet_speed = 3.0 #子弹速度，决定子弹发射时的速度
@export var bullet_aspeed = 0.0 #子弹加速度，决定子弹发射时的加速度
var bullet_damage := 1.0 #子弹伤害，不可配置，根据技能自动计算伤害
#注：这里的rotation单位是角度，而非弧度
@export var bullet_aspeed_rotation = 0.0 #子弹加速度方向，决定子弹发射的加速度方向。
@export var spawn_bullet_type = "小玉" #子弹类型名称，需要在RSLOADER注册子弹场景
@export var spawn_bullet_color = 0
@export var spawn_bullet_owner = "none"
@export var bullet_scale = Vector2(1,1)
@export var bullet_moving_type = "linear"
@export var bullet_out_screen_remove = true
@export var bullet_sin_amplitude = 0.0 #当bullet_moving_type=sinx时生效，sin的振幅，数值越大，振幅越大
@export var bullet_sin_period = 0.0 #当bullet_moving_type=sinx时生效，sinx的周期公式B值(period=2pi/B)，数值越大，周期越短（快)
@export var bullet_tags = {}

#子弹发射配置
@export_group("子弹运动")
@export var way_num := 1 #Way数，决定单次发射子弹的数量。
@export var way_range := 360.0 #子弹范围，决定多Way子弹发射的范围，360是一个圆周的范围
@export var way_rotation := 0.0 #发射角度，决定子弹发射的方向
@export var spawner_radius := 0.0 #发射点半径，若为0则该组所有发弹点集中在一个点。
@export var spawner_radius_rotation := 0.0 #发弹点半径的方向
@export var spawn_bullet_frame = 2 #隔多少帧发射一次子弹
@export var rotate_bullet = false
@export var use_offset_position = false #发射子弹时偏移到子弹的头部发出

var tmp_skill #暂存当前技能实例
var skill_name := "" : set = add_skill_name #当前技能名
var bullet_groups = []

var change_frames = 1 #变化时间，一次变化多少帧的量
var shooting = false #是否正在射击

var first_run = true
var need_remove = false
var start_timer_counted = false #为true表示StartTimer已经运行过一次了

var spawner_event_groups = []
var bullet_event_groups = []

@onready var player = STGSYS.get_player()

var all_bullets = []

var spawner_tags = {}

var frame = 0

func set_remove_sec(s):
	$RemoveSec.wait_time = s

func start_remove_sec():
	$RemoveSec.start()

func start_move_count():
	$MoveStartTimer.start()

func start_shoot_count():
	start_timer_counted = true
	if start_sec == 0:
		shoot()
		$EndTimer.start()
	else:
		$StartTimer.start()

func _ready():
	randomize()
	if start_sec > 0:
		$StartTimer.wait_time = start_sec
	if !never_end:
		assert(end_sec > 0, "发弹点'%s'结束时间必须大于0" % get_path())
		$EndTimer.wait_time = end_sec
	$MoveStartTimer.wait_time = self_move_start_sec
	STGSYS.bullet_spawners.append(self)
	if has_node("SpawnerEventGroups"):
		for seg in $SpawnerEventGroups.get_children():
			seg.add_target(self)
			spawner_event_groups.append(seg)
	if has_node("BulletEventGroups"):
		for beg in $BulletEventGroups.get_children():
			bullet_event_groups.append(beg)
	_on_ready()
	if bullet_manager_type == MANAGE_TYPE.HIGHLIGHT:
		bullet_manager_name = "高光弹幕层"
	
	if enable:
		start_shoot_count()


func _on_ready():
	pass

func self_move(delta):
	if move_start:
		speed_vec += aspeed_vec.rotated(deg_to_rad(aspeed_rotation))
		position += speed_vec.rotated(deg_to_rad(speed_rotation))*delta

func self_free():
	STGSYS.bullet_spawners.erase(self)
	queue_free()

func _process(delta):
	frame += 1
	self_run_logic()
	self_move(delta)
	for bull in all_bullets:
		if is_instance_valid(bull):
			bullet_run_logic(bull,delta)
		else:
			all_bullets.erase(bull)
	if need_remove:
		if all_bullets.is_empty():
			self_free()
	if enable and first_run:
		bullet_spawn_logic()
		first_run = false
	if enable and !start_timer_counted:
		start_shoot_count()
	if enable and !out_screen_free:
		start_remove_sec()
	for event in spawner_event_groups:
		event.run_event_group()
	for event in bullet_event_groups:
		event.run_event_group()
	if enable_shoot_bullet and shooting:
		if frame % spawn_bullet_frame == 0:
			#生成子弹前运行
			bullet_spawn_logic()

func spawn_bullet(bullet):
#	if enable_shoot_bullet:
	#子弹的特殊参数处理
	
	bullet.position = bullet.position_trans*bullet.real_position
	
	bullet.out_screen_remove = bullet_out_screen_remove
	
	#子弹的生成处理
	if spawn_bullet_owner != "self" and \
	spawn_bullet_owner != "self_bomb":
		STGSYS.enemy_bullets.append(bullet)
	all_bullets.append(bullet)
	for bullet_event in bullet_event_groups:
		bullet_event.add_target(bullet)
	STGSYS.current_level.get_node(bullet_manager_name).create_bullet_bul(bullet)

func bullet_draw_polygon(bullets,n=4,mode="all",aspeed=false):
	#n代表边数，mode有三个分别为rotation，position和all（position和rotation全开）
	#先计算该多边形的所有向量
	var rota = way_range/way_num #间隔角度数,必须为n的偶数倍
	var t_rota_crease = way_range/n#每个计算间隔的小三角形的旋转度增量
	var c_speed = 1 #垂直角度速度
	var bei = way_num/n #每份多边形的份数，同时也是倍数
	var b_off = -(floor(bei/2)) #计算多边形时b的取值范围的偏移
	var speed_vecs = []
	var t_rota = 0
	for a in range(n):
		for b in range(bei):
			var vec_x = tan(deg_to_rad((b+b_off)*rota))/c_speed
			var vec_y = c_speed
			var speed_vec = Vector2(vec_x,vec_y)
			speed_vec = speed_vec.rotated(deg_to_rad(t_rota))
			speed_vecs.append(speed_vec)
		t_rota += t_rota_crease
	
	#然后根据模式匹配该多边形是角度发射
	#还是位置放置
		if mode == "rotation" or mode == "all":
			var bullet_id = 0
			for vec in speed_vecs:
				#在单位多边形向量基础上赋予子弹速度和旋转度
				bullets[bullet_id].speed = \
				(vec*bullet_speed).rotated(deg_to_rad(way_rotation))
				
				if aspeed:
					bullets[bullet_id].aspeed = vec*bullet_aspeed
				bullet_id+=1
		if mode == "position" or mode == "all":
			var bullet_id = 0
			for vec in speed_vecs:
				var c_line = spawner_radius/sqrt(2) #用半径求中垂线
				bullets[bullet_id].real_position = \
				((vec*c_line)+position).rotated(deg_to_rad(spawner_radius_rotation))
				bullet_id+=1

func set_way_bullet_spawn(bullets:Array):
	#根据当前子弹的Way数配置调整子弹旋转参数
	#根据给出的半径和半径方向参数，设置发射每条子弹的位置
	
	#发射位置变量赋值
	var radius_direction = Vector2.DOWN.rotated(deg_to_rad(spawner_radius_rotation))
	var bullet_position = Vector2(0,0) + radius_direction*spawner_radius
	
	#半径变量赋值
	var bullet_rotation = way_rotation
	var bullet_rotation_distance = way_range/float(way_num)
	var half_way_num = int(ceil(way_num/2))
	
	if way_num%2 == 0:
		#若为偶数
		#则初始半径方向和初始子弹发射反方向偏转间隔角度的一半
		#加上半个way_num数少一的偏转间隔
			bullet_rotation = way_rotation - bullet_rotation_distance/2 - \
			bullet_rotation_distance*(half_way_num-1)
			bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation_distance/2))
			for r in range(half_way_num-1):
				bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation_distance))
	elif way_num > 1:
		#若为奇数
		#则初始半径和子弹发射方向直接反方向偏转间隔角度的一半的间隔
		bullet_rotation = way_rotation - bullet_rotation_distance*half_way_num
		for r in range(half_way_num):
			bullet_position = bullet_position.rotated(deg_to_rad(-bullet_rotation))
	
	#批量设置每个弹幕具体的角度和位置
	for bullet in bullets:
		bullet.rotation = bullet_rotation
		bullet.real_position = to_global(bullet_position)
		if use_offset_position:
			#设置子弹偏移
			var off_dist = bullet.scale.y*16
			bullet.real_position += \
			Vector2(0,off_dist).rotated(deg_to_rad(bullet.rotation))
		bullet_rotation += bullet_rotation_distance
		bullet_position = bullet_position.rotated(deg_to_rad(bullet_rotation_distance))
		

#创建一个子弹
func get_bullet(bullet_name):
	#获取单个子弹，给子弹赋值基础属性参数
	var attr = {
		#外观参数
		"life":bullet_life,
		"damage":bullet_damage,
		"bullet_type":bullet_name,
		"color":spawn_bullet_color,
		"b_owner":spawn_bullet_owner,
		"collision_shape":RS.bullet_collision_shapes[spawn_bullet_type],
		"scale":bullet_scale,
		"rotating":rotate_bullet,

		#运动参数
		"speed_value":bullet_speed,
		"aspeed_value":bullet_aspeed,
		"speed":bullet_speed * Vector2.DOWN,
		"aspeed":bullet_aspeed * Vector2.DOWN,
		"aspeed_rotation":bullet_aspeed_rotation,
		"moving_type":bullet_moving_type,
		"sin_amplitude":bullet_sin_amplitude,
		"sin_period":bullet_sin_period,

		#附加标签
		"bullet_tags":{
			"skill": skill_name,
		},
		
		"target_enemy": null,
	}
	
	for tags in bullet_tags.keys():
		attr.bullet_tags[tags] = bullet_tags[tags]
	
	if bullet_moving_type == "chaser":
		attr.target_enemy = get_chaser_target()

	var bullet = STGSYS.current_level.get_node(bullet_manager_name).get_new_bullet(attr)
	
	return bullet

#func get_bullet(bullet_name):
#	#获取单个子弹，给子弹赋值基础属性参数
#	#外观参数
#	var bullet = STGSYS.current_level.get_node(bullet_manager_name).get_new_bullet()
#	bullet.life = bullet_life
#	bullet.bullet_type = bullet_name
#	bullet.color = spawn_bullet_color
#	bullet.b_owner = spawn_bullet_owner
#	bullet.collision_shape = RS.bullet_collision_shapes[spawn_bullet_type]
#	bullet.scale = bullet_scale
#	bullet.rotating = rotate_bullet
#
#	#运动参数
#	bullet.speed = bullet_speed*Vector2.DOWN
#	bullet.aspeed = bullet_aspeed*Vector2.DOWN
#	bullet.aspeed_rotation = bullet_aspeed_rotation
#	bullet.moving_type = bullet_moving_type
#
#	if bullet_moving_type == "chaser":
#		bullet.target_enemy = get_chaser_target()
#
#	return bullet

func get_bullet_group(num):
	#获取一组子弹
	var bullets = []
	for b in range(num):
		var bullet = get_bullet(spawn_bullet_type)
		bullets.append(bullet)
	return bullets

func spawn_group_of_bullet(bullets:Array):
	#生成一组子弹
	for bul in bullets:
		spawn_bullet(bul)

func bullet_spawn_logic():
	var bullets = get_bullet_group(way_num)
	set_way_bullet_spawn(bullets)
	spawn_group_of_bullet(bullets)

func shoot():
	shooting = true
	#$BulletSpawnTimer.wait_time = spawn_bullet_sec
	#$BulletSpawnTimer.start()
	
func stop_shoot():
	shooting = false
	#$BulletSpawnTimer.stop()
	
#当弹幕全部消失后自动移除发弹点
func remove_spawner():
	need_remove = true
	STGSYS.bullet_spawners.erase(self)
	
#检测诱导弹目标
func get_chaser_target():
	var nearest_enemy = find_closest_or_furthest(self, "enemy_flyer")
	return nearest_enemy
	
#获取最靠近或者最远的节点
func find_closest_or_furthest(node: Object, group_name: String, get_closest:= true) -> Object:
	var target_group = get_tree().get_nodes_in_group(group_name)
	
	if target_group.is_empty():
		return null
	
	var distance_away = node.global_transform.origin.distance_to(target_group[0].global_transform.origin)
	var return_node = target_group[0]
	for index in target_group.size():
		var distance = node.global_transform.origin.distance_to(target_group[index].global_transform.origin)
		if get_closest == true && distance < distance_away:
			distance_away = distance
			return_node = target_group[index]
		elif get_closest == false && distance > distance_away:
			distance_away = distance
			return_node = target_group[index]
	return return_node

func self_run_logic():
	pass

func bullet_run_logic(bull,delta):
	pass

func add_bullet_group(group):
	bullet_groups.append(group)

func add_skill_name(sname):
	skill_name = sname
	tmp_skill = RS.fight_skills[skill_name].instantiate()

func _on_StartTimer_timeout():
	shoot()
	$EndTimer.start()

func _on_end():
	pass

func _on_EndTimer_timeout():
	if !never_end:
		frame = 0
		_on_end()
		if cycle:
			if start_sec == 0:
				$EndTimer.start()
			else:
				stop_shoot()
				$StartTimer.start()

func _on_MoveStartTimer_timeout():
	move_start = true

func _on_VisibilityNotifier2D_screen_exited():
	if out_screen_free:
		self_free()

func _on_RemoveSec_timeout():
	self_free()
