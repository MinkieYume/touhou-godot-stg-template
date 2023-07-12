extends Node

signal load_finish

var bullet_sprite_frames = [
	preload("res://弹幕相关/子弹样式组.tres")
]

var bullet_spawner = {
#	"BulletSpawner": load("res://弹幕相关/发弹点.tscn"),
}

var bullet_collision_shapes = {
	"中玉":preload("res://弹幕相关/子弹碰撞/中玉.tres"),
	"小玉":preload("res://弹幕相关/子弹碰撞/小玉.tres"),
	"方玉":preload("res://弹幕相关/子弹碰撞/方玉.tres"),
	"米玉":preload("res://弹幕相关/子弹碰撞/米玉.tres"),
	"棱弹":preload("res://弹幕相关/子弹碰撞/棱弹.tres"),
	"激光":preload("res://弹幕相关/子弹碰撞/激光.tres"),
}

var bullet_pics = {}

var bullet_polygons = {}

var items = {
	"Point":preload("res://掉落物/Point.gd"),
	"Power":preload("res://掉落物/Power.gd"),
	"MegaPower":preload("res://掉落物/MegaPower.gd"),
	"BiggerPower":preload("res://掉落物/BiggerPower.gd")
}

var item_pics = {
	"Point":preload("res://Resource/texture/Point.png"),
	"Power":preload("res://Resource/texture/P_Point.png"),
	"MegaPower":preload("res://Resource/texture/P_Point.png"),
	"BiggerPower":preload("res://Resource/texture/P_Point.png")
}

var item_rects = {}

var levels = {
	"符卡测试":preload("res://关卡/符卡测试关卡.tscn"),
	"默认测试":preload("res://关卡/默认测试关卡.tscn"),
}

var self_flyers = {
	"默认自机":preload("res://机体/自机/默认自机.tscn"),
	"默认自机2":preload("res://机体/自机/默认自机2.tscn"),
	"默认自机3":preload("res://机体/自机/默认自机3.tscn"),
	"默认自机4":preload("res://机体/自机/默认自机4.tscn")
}

var self_flyer_menu = {
	"A机小方":{
		"标题效果":preload("res://UI/self_chose_panel_title1_squre.tres"),
		"图片":preload("res://机体/自机/A Square.png"),
		"称号效果":preload("res://UI/self_chose_panel_title2_squre.tres"),
		"称号":"非常可爱的方形",
		"介绍":\
"""不管怎么说，总之就是非常可爱的方形
容易被方块王国的怪物盯上
比较擅长追踪大范围攻击""",
		"介绍效果":preload("res://UI/self_chose_panel_discus_squre.tres"),
		"机体列表":{
			"买萌型":[preload("res://UI/spellcard_title.tres"),"一点都不萌的机型，还需要特地买萌",preload("res://UI/spell_card_discus.tres"),"默认自机"],
			"卖萌型":[preload("res://UI/spellcard_title.tres"),"除了卖萌之外没什么用的机型",preload("res://UI/spell_card_discus.tres"),"默认自机2"],
		},
	},
	"B机小圆":{
		"标题效果":preload("res://UI/self_chose_panel_title1_squre.tres"),
		"图片":preload("res://机体/自机/A Round.png"),
		"称号":"粉嫩少女小圆",
		"称号效果":preload("res://UI/self_chose_panel_title2_round.tres"),
		"介绍":\
"""小圆我啊，可是粉嫩的美少女哦！
粉粉的魔法少女，擅长格斗和狙击""",
		"介绍效果":preload("res://UI/self_chose_panel_discus_squre.tres"),
		"机体列表":{
			"狙击型":[preload("res://UI/spellcard_title.tres"),"适合远程小范围攻击的机型",preload("res://UI/spell_card_discus.tres"),"默认自机3"],
			"格斗型":[preload("res://UI/spellcard_title.tres"),"适合近战小范围攻击的机型",preload("res://UI/spell_card_discus.tres"),"默认自机4"],
		},
	}
}

var diff_levels = {
	"easy":["默认测试","默认测试","默认测试","默认测试","默认测试","默认测试"],
	"normal":["默认测试","默认测试","默认测试","默认测试","默认测试","默认测试"],
	"hard":["默认测试","默认测试","默认测试","默认测试","默认测试","默认测试"],
	"lunatic":["默认测试","默认测试","默认测试","默认测试","默认测试","默认测试"],
}

var enemys = {
#	"SqureBossEnemy":preload("res://机体/敌机/Squre_BOSS_EnemyFlyer.tscn"),
#	"EnemyFlyerFollowPath":preload("res://机体/敌机/EnemyFlyerFollowPath.tscn"),
	"EnemyFlyer":preload("res://机体/敌机/默认敌机.tscn"),
#	"Boss_01":preload("res://机体/Boss/Boss_01.tscn"),
}

var UI = {
	"HpBar": preload("res://UI/HpBar.tscn"),
	"HpBarRed": preload("res://UI/HpBarRed.tscn"),
}

func get_bullet_polygon(texture:AtlasTexture):
	#定义多边形的基础形状和UV
	var texture_size = texture.get_size()
	
	var region = texture.region
	var pic_size = texture.atlas.get_size()
	
	var polygon_base = [\
	Vector2(0,0),\
	Vector2(texture_size.x,0),\
	texture_size,\
	Vector2(0,texture_size.y)]
	
	var uv_num_x = texture_size.x/pic_size.x
	var uv_num_y = texture_size.y/pic_size.y
	
	var offset_num_x = region.position.x/texture_size.x
	var offset_num_y = region.position.y/texture_size.y
	
	var uvs = PackedVector2Array([
		Vector2(0 +uv_num_x*offset_num_x, 0 +uv_num_y*offset_num_y),\
		Vector2(uv_num_x +uv_num_x*offset_num_x, 0 +uv_num_y*offset_num_y),
		Vector2(uv_num_x +uv_num_x*offset_num_x, uv_num_y +uv_num_y*offset_num_y),\
		Vector2(0 +uv_num_x*offset_num_x , uv_num_y +uv_num_y*offset_num_y)
	])
	
	return([polygon_base,uvs])

func get_item_rect(texture):
	var rect = Rect2(Vector2(0,0),texture.get_size()/2)
	return rect

func get_item_collision_shape(texture):
	var collision = RectangleShape2D.new()
	collision.size = texture.get_size()/2
	return collision

func _ready():
	#遍历子弹样式组以获取所有子弹样式
	for sprite_frame in bullet_sprite_frames:
		var sprite_names = sprite_frame.get_animation_names()
		for sprite_name in sprite_names:
			var frame_count = sprite_frame.get_frame_count(sprite_name)
			var frame_pics = []
			for frame in range(frame_count):
				frame_pics.append(sprite_frame.get_frame_texture(sprite_name,frame))
			bullet_pics[sprite_name] = frame_pics
	
	#获取所有子弹对应的多边形参数
	for b_name in bullet_pics.keys():
		for btexture in bullet_pics[b_name]:
			bullet_polygons[btexture] = get_bullet_polygon(btexture)
	
	#获取所有道具的矩形参数
	for  i_name in item_pics.keys():
		item_rects[i_name] = get_item_rect(item_pics[i_name])
		
