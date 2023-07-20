class_name RaserSpawner
extends BulletSpawner

#激光刷弹点
@export var await_sec = 0.0 #激光等待几秒才开始出现预判线或发射
@export var keep_sec = 5.0 #激光扩展到满的时候到消失持续的秒数
@export var max_sec = 2.0 #激光从开始发射到发射满的秒数
@export var before_sec = 2.0 #激光从预判线出现到发射激光的秒数
@export var start_collide_sec = 1.0 #激光开始发射后几秒开启碰撞
@export var max_width = 5.0 #激光的最大宽度倍数
@export var min_width = 1.0 #激光的最小宽度倍数
@export var length = 50.0: #激光延伸的长度倍数
	set(len):
		bullet_scale.y = len
		length = len
@export var aim_self_flyer = false #发射是否瞄准自机
@export var use_raser_line = true #是否使用判定线

var raser_shooting = false

var raser_collides = []

var now_width = 1.0:
	set(n):
		bullet_scale.x = n
		now_width = n

var max_laser_tween

func bullet_spawn_logic():
	#重写该函数以自定义生成子弹初始设定
	#也可以重写生成子弹前运行的逻辑
	#每次发射子弹的时候运行
	$KeepRaserTimer.wait_time = keep_sec
	$BeforeRaserTimer.wait_time = before_sec
	$StartCollideTimer.wait_time = start_collide_sec
	if enable_shoot_bullet:
		var b_id = 0
		for bullet in all_bullets:
			if bullet.b_owner != "raser_line":
				bullet.scale = bullet_scale
				var collide = raser_collides[b_id]
				collide.scale = bullet_scale
				collide.rotation = deg_to_rad(bullet.rotation)
				b_id += 1
		if !raser_shooting:
			raser_shooting = true
			if await_sec != 0.0:
				await get_tree().create_timer(await_sec).timeout
			
			if aim_self_flyer:
				if is_instance_valid(STGSYS.player):
					var direction = get_global_position().direction_to(STGSYS.player.get_global_position())
					way_rotation = rad_to_deg(Vector2.DOWN.angle_to(direction))
			
			if use_raser_line:
				spawn_group_raser_beforeline()
				$BeforeRaserTimer.start()
			else:
				spawn_raser()

func spawn_raser():
	
	$CollideArea.monitoring = false
	
	#移除判定线
	for bullet in all_bullets:
		bullet.wait_for_remove = true
	all_bullets.clear()
	
	#重置激光大小
	now_width = min_width
	
	#激光生成
	var bullets = get_bullet_group(way_num)
	set_way_bullet_spawn(bullets)
	
	for bullet in bullets:
		bullet.scale = bullet_scale
		
		#激光碰撞生成
		var raser_collide = $RaserCollideTemp.duplicate()
		raser_collide.scale = bullet.scale
		raser_collide.rotation = deg_to_rad(bullet.rotation)
		$CollideArea.add_child(raser_collide)
		raser_collide.position = to_local(bullet.real_position)
		raser_collides.append(raser_collide)
	
	spawn_group_of_bullet(bullets)
	
	#激光逐渐变大效果
	max_laser_tween = create_tween()
	max_laser_tween.connect("finished",Callable(self,"_on_raser_max"))
	max_laser_tween.tween_property(self,"now_width",max_width,max_sec)
	$StartCollideTimer.start()

func spawn_group_raser_beforeline():
	bullet_manager_name = "玩家子弹层"
	var bullets = []
	for w in range(way_num):
		var raser_line = get_bullet("判定线")
		raser_line.b_owner = "raser_line"
		bullets.append(raser_line)
	set_way_bullet_spawn(bullets)
	spawn_group_of_bullet(bullets)
	bullet_manager_name = "高光弹幕层"

func _on_ready():
	#该发弹点加载好的时候运行
	$KeepRaserTimer.wait_time = keep_sec
	$BeforeRaserTimer.wait_time = before_sec
	$StartCollideTimer.wait_time = start_collide_sec
	bullet_scale.x = now_width
	bullet_scale.y = length

func _on_raser_max():
	$KeepRaserTimer.start()

func _on_end():
	#发射结束时候运行一次
	#如果neverend为true则永远不会运行该方法
	#如果cycle为true则代表每次循环结束时运行一次
	pass

func self_run_logic():
	#自己的运行逻辑
	#每帧运行一次
	if frame % spawn_bullet_frame == 0:
		#该条件判断代表的是：
		#判定每次发射子弹前运行
		#注意：way数代表的是一次同时发射的子弹数
		pass

func bullet_run_logic(bull,delta):
	#子弹的运行逻辑
	#如果屏幕总子弹数为n的话，则每帧运行n次
	#在self_run_logic之后运行
	pass

func _on_keep_raser_timer_timeout():
	for bullet in all_bullets:
		bullet.wait_for_remove = true
	for raser_collide in raser_collides:
		raser_collide.queue_free()
	raser_collides.clear()
	all_bullets.clear()
	raser_shooting = false


func _on_before_raser_timer_timeout():
	spawn_raser()

func _on_collide_area_area_entered(area):
	if area.is_in_group("self_dead_point"):
		area.emit_signal("hit",null)

func _on_start_collide_timer_timeout():
	$CollideArea.monitoring = true
