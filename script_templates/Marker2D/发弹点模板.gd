# meta-name: 发弹点
# meta-description: 用于发弹点的模板
# meta-default: true
# meta-space-indent: 4
extends BulletSpawner

#一个基础的发弹点，继承BulletSpawner
#当然继承对象也可以改为别的BulletSpawner

#子弹的position分为real_position和position
#real_position代表应用子弹的position矩阵变换前的position
#position代表应用矩阵变换后的position
#如果有考虑要让子弹支持矩阵变换
#最好只更改real_position

func bullet_spawn_logic():
	#重写该函数以自定义生成子弹初始设定
	#也可以重写生成子弹前运行的逻辑
	#每次发射子弹的时候运行
	var bullets = get_bullet_group(way_num)
	set_way_bullet_spawn(bullets)
	spawn_group_of_bullet(bullets)

func _on_ready():
	#该发弹点加载好的时候运行
	pass

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
