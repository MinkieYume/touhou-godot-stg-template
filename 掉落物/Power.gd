class_name Power
extends Point
#一个基础的加点物品场景

@export var become_to = "Point" #配置火力满时会变成的物品

func _ready():
	rect = RS.item_rects["Power"]
	collision_shape = RS.get_item_collision_shape(texture)
	if STGSYS.power == STGSYS.max_power:
		for x in range(point_var):
			STGSYS.simple_add_drop(become_to,position)

func change_var():
	#更改值，可覆写该场景以更改对应值
	STGSYS.change_value("power",STGSYS.power+point_var)
	wait_for_remove = true
