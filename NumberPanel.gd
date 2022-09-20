extends ReferenceRect
#属性面板：负责处理各个数值的显示

var max_show_life #最多显示的残机数量
var max_show_bomb #最多显示的炸弹数量

func _ready():
	max_show_life = $LifeGrid.get_child_count()
	max_show_bomb = $BombGrid.get_child_count()
	STGSYS.connect("update_life",Callable(self,"update_life"))
	STGSYS.connect("update_bomb",Callable(self,"update_bomb"))
	STGSYS.connect("update_power",Callable(self,"update_power"))
	STGSYS.connect("update_text",Callable(self,"update_text"))
	STGSYS.connect("update_time_left",Callable(self,"update_time_left"))

func update_time_left():
	$TimeLeft.text = "%d"%STGSYS.time_left

func update_life():
	for life in $LifeGrid.get_children():
		life.visible = false
	
	#显示的生命数量
	var life_num = STGSYS.life - 1
	
	if life_num > max_show_life:
		life_num = max_show_life

	if life_num == max_show_life:
		for life in $LifeGrid.get_children():
			life.visible = true
	else:
		for num in range(1,life_num+1):
			$LifeGrid.get_node("Life%d"%num).visible = true

func update_bomb():
	for bomb in $BombGrid.get_children():
		bomb.visible = false
	
	#显示的Bomb数量
	var bomb_num = STGSYS.bomb
	
	if bomb_num > max_show_bomb:
		bomb_num = max_show_bomb

	if bomb_num == max_show_bomb:
		for bomb in $BombGrid.get_children():
			bomb.visible = true
	else:
		for num in range(1,bomb_num+1):
			$BombGrid.get_node("Bomb%d"%num).visible = true

func update_power():
	#处理火力值的更新
	$FireBar.max_value = STGSYS.max_power
	$FireBar.value = STGSYS.power
	if STGSYS.power < STGSYS.max_power:
		$FireBar/Label.text = "%d"%STGSYS.power
	else:
		$FireBar/Label.text = "MAX"

func update_text():
	#分数、点数、擦弹统一处理
	$point_num_2.text = "%d"%STGSYS.max_score
	$point_num_1.text = "%d"%STGSYS.score
	$Point.text = "%d"%STGSYS.point
	$Graze.text = "%d"%STGSYS.graze
