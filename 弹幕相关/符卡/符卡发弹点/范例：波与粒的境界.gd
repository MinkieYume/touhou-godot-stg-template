extends BulletSpawner

#能产生伪线的子弹角度是360/n
#伪线的倍数k = 某时刻子弹线数/发射口数
#发射口数量为n0时，产生伪线的角度为360/（n0*k）
#k < 根号288PI/n0pv 其中p代表发射间隔（帧），v代表子弹速度（像素每帧）
#利用伪线，可以设计出让玩家察觉不到子弹线的符卡

#way数为3时，生成2倍伪线所需的角度为60度
#如果角度超过二倍伪线，旋转方向会发生变化

#只有当函数在某一伪线区内停留数量超过3个循环
#才能看到子弹多个连成一条线
#停留在区间时间越长，连成一条线后越大

#若要创建每个子弹间隔运行一次的循环逻辑，请写在bullet_spawn_logic
#或在其它运行逻辑前面加上frame % spawn_bullet_frame ==0 的判定
#默认写在bullet_spawn_logic之外的运行逻辑方法都是每帧循环一次
#因此需要加上frame的判定

#给定一个角度增量x
#每循环x增加一定一定值
#而每循环角度也增加一定值
#就可以做出角度的加速度效果
#波与粒的境界符卡也用了该原理，
#所以做出了一会儿密集，一会儿离散的弹幕
#而且弹幕伪线的运动，时不时会出现优美的弧线
#旋转角度增量固定时，如果增量值在特定的区间则会产生伪线，而特定的区间又不会。
#所以当旋转角度增量递增的时候，就会产生时而离散，时而聚拢的效果。

#三角函数增量可以做出来回摆动的效果

#此外，取余子弹间隔角度可以防止函数运转过程中数值过大

#可以尝试给角度增量做各种函数处理，能做出很多特别的效果

var thelta = 0
var x = 0
var fx = 0
var r_range = 0

func bullet_spawn_logic():
	#重写该函数以自定义生成子弹初始设定
	#也可以重写生成子弹前运行的逻辑
	var bullets = get_bullet_group(way_num)
	set_way_bullet_spawn(bullets)
	#for bull in bullets:
	#	var bul_trans = Transform2D(deg_to_rad(bull.rotation),Vector2.ZERO)
	#	bull.position_trans = bul_trans
	spawn_group_of_bullet(bullets)

func _on_ready():
	r_range = int(way_range/way_num)

func _on_end():
	thelta+= 120
	way_rotation = way_rotation+thelta

func self_run_logic():
	#自己的运行逻辑
	if frame % spawn_bullet_frame == 0:
		x+=0.1
		#fx = int(10*sin(pow(x,1))) % r_range + x % r_range
		#fx = x % r_range
		fx = int(x) % r_range
		if frame > 1:
			way_rotation = way_rotation + fx

func bullet_run_logic(bull,delta):
	#子弹的运行逻辑
	#var bul_trans = Transform2D(deg_to_rad(bull.rotation),Vector2.ZERO)
	#bull.position_trans = bul_trans
	pass
