extends Node
#全局控制中心

const DIRINPUTS = {"left":Vector2.LEFT,"right":Vector2.RIGHT,"down":Vector2.DOWN,\
	"up":Vector2.UP}

var pressed_direction = [Vector2(0,0)]

#当前屏幕中出现的各对象
var self_flyers = []
var enemys = []
var enemy_bullets = []
var bullet_spawners = []
var reflectors = []
var shades = []

var selfMoveVector = Vector2.ZERO #自机的移动偏移量
var lowSpeedMode = false #自机的低速移动开关
var current_level #当前关卡
var shooting = false #自机是否正在射击
var view_portsize = Vector2(0,0)

#符卡剩余时间
var time_left = 60.0 :
	get:
		return time_left # TODOConverter40 Non existent get function 
	set(mod_value):
		time_left = mod_value
		emit_signal("update_time_left")

#生命与炸弹
var life = 3
var bomb = 3

#历史得分和最大火力
var max_score = 0
var max_power = 120

#火力、分数、点数、擦弹
var power = 0
var score = 0
var point = 0
var graze = 0

var time_fps = 0
var fps_time = 0

var player = null #当前玩家操控的自机
var boss = null #当前boss
var level = null #当前level
var UI = null
var special = false
var bomb_use = false

signal update_life #生命数更新
signal update_bomb #炸弹数更新

signal update_power #火力值更新
signal update_text #分数，点数，擦弹统一处理

signal update_time_left

signal use_bomb
signal game_over

func _process(delta):
	time_fps = Performance.get_monitor(Performance.TIME_FPS)
	fps_time = Performance.get_monitor(Performance.TIME_PROCESS)
#	get_tree().get_root().\
#	get_node("东方弹幕绘").get_node("FPS").text = "FPS：%d"%time_fps

func frame_to_sec(frame):
	return frame*fps_time

func _ready():
	randomize()
	connect("game_over",Callable(self,"_on_game_over"))
#	view_portsize = get_node("/root/东方弹幕绘/GameWindow/SubViewportContainer/SubViewport").size

func get_player(): #获取当前玩家
	return player

func set_player(player_node):#设置当前玩家
	player = player_node
	
func get_boss(): #获取当前boss
	return boss

func set_boss(boss_node):#设置当前boss
	boss = boss_node
	enemys.append(boss_node)
	
func remove_boss():
	enemys.erase(boss)
	boss = null
	
func set_level(node,flyer_name):
	node.load_flyer(flyer_name)
	level = node
	RC.start = true
	
func get_level():
	return level

func hance_drop(item_list:Array):
	#处理物品掉落请求
	#将掉落物品放在需求位置
	#其实是以需求位置为中心50x50的随机位置
	for item in item_list:
		var _name = item["_name"]
		var num = item["number"]
		var pos = item["position"]
		
		for x in range(num):
			simple_add_drop(_name,pos)

func simple_add_drop(_name,pos):
	#将掉落物品随机添加在坐标的50x50范围内
	var vec = Vector2(randf_range(pos.x-25,pos.x+25),\
			randf_range(pos.y-25,pos.y+25))
	current_level.get_node("道具管理器").\
	create_new_item(_name,pos)

func change_value(type,val):
	#修改值，type为值类型
	#val为要修改为的值。
	#完成修改后发送一个更新对应值信号
	match type:
		"life":
			life = val
			emit_signal("update_life")
		"bomb":
			bomb = val
			emit_signal("update_bomb")
		"power":
			power = val
			if power >= max_power:
				power = max_power
			emit_signal("update_power")
		"score":
			score = val
			emit_signal("update_text")
		"point":
			point = val
			emit_signal("update_text")
		"graze":
			graze = val
			emit_signal("update_text")
		_:
			pass

#以下四个decrease和increase方法
#是为了方便快速增加和减少生命和炸弹数
#用于生命和炸弹数的-1或+1
func decrease_life():
	life -=1
	emit_signal("update_life")

func decrease_bomb():
	bomb -=1
	emit_signal("update_bomb")

func increase_life():
	life +=1
	emit_signal("update_life")

func increase_bomb():
	bomb+=1
	emit_signal("update_bomb")

func _unhandled_input(event):
	#统一处理案按键操作
	if Input.is_action_just_pressed("fire"):
		shooting = true
	if Input.is_action_just_released("fire"):
		shooting = false
	if Input.is_action_just_pressed("low_speed"):
		lowSpeedMode = true
	if Input.is_action_just_released("low_speed"):
		lowSpeedMode = false
	if Input.is_action_just_pressed("bomb"):
		if bomb > 0:
			emit_signal("use_bomb")
			bomb_use = true
			decrease_bomb()
	if Input.is_action_just_released("bomb"):
		bomb_use = false
	if Input.is_action_just_pressed("special"):
		special = true
	if Input.is_action_just_released("special"):
		special = false
	
	fxInput()

func _on_game_over():
	#游戏结束操作
	#player = null
	if is_instance_valid(UI):
		UI.visible = false

func fxInput(): #此函数用于处理方向的输入
	var vector = Vector2.ZERO
	
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()
	
	selfMoveVector = vector
#	for input in DIRINPUTS:
#		if Input.is_action_just_pressed("ui_"+input):
#			pressed_direction.append(DIRINPUTS[input])
#		if Input.is_action_just_released("ui_"+input):
#			pressed_direction.erase(DIRINPUTS[input])
#
#	if pressed_direction.has(Vector2.UP) and \
#	pressed_direction.has(Vector2.DOWN):
#		var up_ind = pressed_direction.find(Vector2.UP)
#		var down_ind = pressed_direction.find(Vector2.DOWN)
#		if up_ind < down_ind:
#			pressed_direction.remove_at(up_ind)
#		else:
#			pressed_direction.remove_at(down_ind)
#
#	if pressed_direction.has(Vector2.LEFT) and \
#	pressed_direction.has(Vector2.RIGHT):
#		var lf_ind = pressed_direction.find(Vector2.LEFT)
#		var rg_ind = pressed_direction.find(Vector2.RIGHT)
#		if lf_ind < rg_ind:
#			pressed_direction.remove_at(lf_ind)
#		else:
#			pressed_direction.remove_at(rg_ind)
#
#
#	for dire in pressed_direction:
#		var retype_num = 0
#		for ried in pressed_direction:
#			if dire == ried:
#				retype_num+=1
#		if retype_num > 1:
#			pressed_direction.erase(dire)
#
#	var finalvector = Vector2.ZERO
#	for direction in pressed_direction:
#		finalvector += direction
#
#	selfMoveVector = finalvector

