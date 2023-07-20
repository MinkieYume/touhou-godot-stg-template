extends Node2D

var drops = []
var updated_drops = []
var clear = false

func _ready():
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func _draw():
	for item in updated_drops:
		draw_texture_rect(item.texture,item.rect,false)

func _process(delta):
	if clear:
		for drop in drops:
			drop.wait_for_remove = true
	move_drops(delta)

func set_updated_item_rects():
	for item in updated_drops:
		var base_rect = item.rect
		base_rect.position = item.position
		item.rect = base_rect

func create_new_item(drop_name,pos):
	#获取一个新的掉落物
	var new_item = RS.items[drop_name].new()
	new_item.texture = RS.item_pics[drop_name]
	new_item.position = pos
	new_item._ready()
	drops.append(new_item)

func remove_drop(drop):
	drops.erase(drop)
	updated_drops.erase(drop)
	drop.free()

func move_drops(delta):
	updated_drops = []
	for drop in drops:
		#开始处理子弹的移动逻辑
		var before_position = drop.position
		drop.move(delta)
			
		updated_drops.append(drop)
		#如果子弹位置发生变化，则将运行判定逻辑
		if drop.position != before_position:
			drop.collision_detect()
			
		#判定子弹是否超出屏幕范围
		if drop.position.x > STGSYS.view_portsize.x + 40 or \
		drop.position.x < -40 or drop.position.y < -40 or \
		drop.position.y > STGSYS.view_portsize.y + 40:
			#超出屏幕后清理
				drop.wait_for_remove = true
	
	for drop in drops:
		if drop.wait_for_remove:
			remove_drop(drop)
	set_updated_item_rects()
	queue_redraw()
