extends Node2D

func _process(delta):
	#print(get_tree().get_nodes_in_group("bullet").size())
	pass

func _enter_tree():
	STGSYS.current_level = self

func _ready():
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	#get_node("符卡/范例：波与粒的境界").run_spell_card()
	#get_node("符卡/方符：摇曳方阵").run_spell_card()
	#get_node("符卡/棱符：天棱地方").run_spell_card()
	#get_node("符卡/方阵：完美立方体").run_spell_card()
	#get_node("符卡/方块一非").run_spell_card()
	#get_node("符卡/方块二非").run_spell_card()
