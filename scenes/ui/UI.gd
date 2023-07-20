#待更新：根据代码动态显示血量条
extends CanvasLayer

var show_boss_hp = false
var hp_bar_nodes = []
var normal_bar_ratio = 3
var spell_bar_ratio = 1

var boss = null
#onready var viewport = get_node("/root/东方弹幕绘/GameWindow/SubViewportContainer/SubViewport")

func _ready():
	STGSYS.UI = self
	visible = true
	$"测试背景".visible = false

func play_SCN_anim():
	$AnimationPlayer.play("立绘移动与字幕淡入")

func set_boss_lh(texture:Texture):
	$"Boss立绘".texture = texture

func setSpellCardName(_name):
	if _name != "":
		$SpellCardShow/SpellCardName.visible = true
		$"Boss立绘".visible = true
		$SpellCardShow/SpellCardName.text = _name
	else:
		$SpellCardShow/SpellCardName.visible = false
		$"Boss立绘".visible = false

func _process(delta):
	if show_boss_hp and !hp_bar_nodes.is_empty():
		hp_bar_nodes[-1].value = boss.hp
		
func init_ui():
	boss = STGSYS.get_boss()
		
func createBossHpBar(bar_info_ori := []):
	#[{"hp": 100, "is_spell_card": false},{"hp": 100, "is_spell_card": true}]
	boss.connect("before_atk",Callable(self,"_on_boss_before_atk"))
	
	var bar_info = bar_info_ori.duplicate()
	
	#移除旧生命条
	remove_hp_bars()
	
	var viewport = get_node("/root/东方弹幕绘/GameWindow/SubViewportContainer/SubViewport")
	var bar_max_length = float(round(viewport.size.x - $HpContainer.offset_left - $HpContainer.offset_right)) - 10
	var total_ratio = 0
	for info in bar_info:
		if info.is_spell_card:
			total_ratio += spell_bar_ratio
		else:
			total_ratio += normal_bar_ratio
	
	bar_info.reverse()
	var last_offset = 0
	for info in bar_info:
		var hp_bar = null
		var ratio = 0
		if info.is_spell_card:
			hp_bar = RS.UI.HpBarRed.instantiate()
			ratio = spell_bar_ratio
		else:
			hp_bar = RS.UI.HpBar.instantiate()
			ratio = normal_bar_ratio
		var rect_offset = round(bar_max_length * (float(ratio) / float(total_ratio)))
		hp_bar.scale.x = rect_offset / hp_bar.size.x
		hp_bar.max_value = info["hp"]
		hp_bar.value = info["hp"]
		hp_bar.offset_left = last_offset
		last_offset += rect_offset + 1
		$HpContainer.add_child(hp_bar)
		hp_bar_nodes.append(hp_bar)
	show_boss_hp = true
	
func remove_hp_bars():
	for child in $HpContainer.get_children():
		child.queue_free()

func _on_boss_before_atk():
	hp_bar_nodes.pop_back().queue_free()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "立绘移动与字幕淡入":
		$AnimationPlayer.play("立绘淡出与字幕移动")
	if anim_name == "立绘淡出与字幕移动":
		$"Boss立绘".visible = false
