class_name SpawnerSetting
extends Resource

enum MANAGE_TYPE {COMMON,HIGHLIGHT}

#基本配置
@export var enable = false #启用弹幕发射，必须开启这个才开始计时发射
@export var enable_shoot_bullet = true #启用发射弹幕，暂时消除发射出的弹幕时可以改为False
@export var cycle = false #循环运行的选项，即endtimer到时后再次开始startTimer计时
@export var start_sec = 0.1 #多少秒后开始发射
@export var end_sec = 20.0 #多少秒后自动结束发射
@export var never_end = false #不结束发射的选项
@export var bullet_manager_type: MANAGE_TYPE = MANAGE_TYPE.COMMON

#自运动配置
@export var move_start = true #启用自移动
@export var self_move_start_sec = 0.1 #调用start_move_count方法几秒后开始移动
@export var out_screen_free = true #启用离开屏幕范围自动消失
@export var speed = 0.0 #自移动速度,仅用于ready前配置，ready后请改speed_vec属性
@export var aspeed = 0.0 #自移动加速度,仅用于ready前配置，ready后请改aspeed_vec属性
#注：这里的rotation单位是角度，而非弧度
@export var speed_rotation = 0.0 #移动速度的方向，仅用于ready前配置，ready后请改rotation属性
@export var aspeed_rotation = 0.0 #加速度的方向

#子弹信息配置
@export var bullet_life = 0 #子弹生命，设置子弹离开屏幕后多少帧后消失
@export var bullet_speed = 3.0 #子弹速度，决定子弹发射时的速度
@export var bullet_aspeed = 0.0 #子弹加速度，决定子弹发射时的加速度
#注：这里的rotation单位是角度，而非弧度
@export var bullet_aspeed_rotation = 0 #子弹加速度方向，决定子弹发射的加速度方向。
@export var spawn_bullet_type = "小玉" #子弹类型名称，需要在RSLOADER注册子弹场景
@export var spawn_bullet_color = 0
@export var spawn_bullet_owner = "none"
@export var bullet_scale = Vector2(1,1)
@export var bullet_moving_type = "linear"
@export var bullet_out_screen_remove = true

#子弹发射配置
@export var way_num := 1 #Way数，决定单次发射子弹的数量。
@export var way_range := 360.0 #子弹范围，决定多Way子弹发射的范围，360是一个圆周的范围
@export var way_rotation := 0.0 #发射角度，决定子弹发射的方向
@export var spawner_radius := 0.0 #发射点半径，若为0则该组所有发弹点集中在一个点。
@export var spawner_radius_rotation := 0.0 #发弹点半径的方向
@export var spawn_bullet_frame = 2 #隔多少帧发射一次子弹
