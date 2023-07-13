extends Node2D

#@onready var self_spawner = $"自机出生点"
#
#func _process(delta):
#	pass
#
#func _enter_tree():
#	STGSYS.current_level = self
#
#func load_flyer(flyer_name:String):
#	var self_flyer = RS.self_flyers[flyer_name].instantiate()
#	add_child(self_flyer)
#	self_flyer.position = self_spawner.position
#
#func _ready():
#	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
#	#get_node("符卡/范例：波与粒的境界").run_spell_card()
#	#get_node("符卡/方符：摇曳方阵").run_spell_card()
#	#get_node("符卡/棱符：天棱地方").run_spell_card()
#	#get_node("符卡/方阵：完美立方体").run_spell_card()
#	#get_node("符卡/方块一非").run_spell_card()
#	#get_node("符卡/方块二非").run_spell_card()
