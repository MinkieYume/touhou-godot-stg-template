class_name BulletPool
extends Object
#子弹对象池，专门用于大量处理子弹对象

const DEFAULT_BULLET_NUM = 4000 #初始创建多少子弹
const EXPAND_DISTANCE = 500 #单次扩容多少子弹

var in_pool_bullets = [] #在池中的子弹
var used_bullets = [] #在池外的子弹
var total_bullet_count = 0 #总共的子弹数

var default_meta = {}

func initalize():
	#初始化方法，使用子弹池前必须运行该方法
	
	#获取最初的子弹配置
	var default_bullet = Bullet.new()
	var metalist = default_bullet.get_meta_list()
	for meta in metalist:
		default_meta[meta] = default_bullet.get_meta(meta)
	
	#创造最初池中的储备子弹
	expand_pool(DEFAULT_BULLET_NUM)

func expand_pool(bullet_num):
	#扩张池子，往池子里添加给定数目的子弹
	for r in range(bullet_num):
		in_pool_bullets.append(Bullet.new())
		total_bullet_count+=1

func intend_pool(bullet_num):
	#缩小池子，释放掉给定数目的子弹
	if in_pool_bullets.size() >= bullet_num:
		for num in range(bullet_num):
			var bullet = in_pool_bullets[in_pool_bullets.size() - num - 1]
			in_pool_bullets.erase(bullet)
			bullet.free()

func get_bullet():
	#返回一个子弹
	#仅用于内部方法，外部请使用take_bullet
	var bullet = in_pool_bullets[0]
	used_bullets.append(bullet)
	in_pool_bullets.remove_at(0)
	return bullet

func take_bullet():
	#从池子中拿出一个子弹
	if used_bullets.size() < total_bullet_count:
		return get_bullet()
	else:
		expand_pool(EXPAND_DISTANCE)
		return get_bullet()

func put_back(bullet):
	#放回池子，将给定子弹放回子弹池
	used_bullets.erase(bullet)
	clean_bullet(bullet)
	in_pool_bullets.append(bullet)

func clean_bullet(bullet):
	#回收将放回子弹池的子弹，重置为初始状态
	for meta in default_meta.keys():
		bullet.set_meta(meta,default_meta[meta])

