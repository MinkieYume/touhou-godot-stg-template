extends SpellCard

var boss

var disabling = false

var fuu_stop_timer

#提示：道中设定也可以考虑使用AnimationPlayer安排
var two_fdd = []

func _on_boss_hited(hited_obj, damage := 1.0):
	if !disabling and hited_obj is Bullet:
		var variables = STGSYS.get_bullet_variables(hited_obj)
		for varia in variables:
			if varia == "水":
				disabling = true
				for fdd in two_fdd:
					fdd.enable_shoot_bullet = false
				fuu_stop_timer.start()
				await fuu_stop_timer.timeout
				disabling = false

func _before_card_run():
	boss = STGSYS.boss
	two_fdd = [$"符卡发弹点/扳手自机狙发弹点",$"符卡发弹点/雏翼自机狙发弹点"]
	fuu_stop_timer = $FuuStopTimer
	if is_instance_valid(boss):
		boss.hited.connect(self._on_boss_hited)

func _card_running_event():
	var left_time = floor(get_left_time())
	var running_time = floor(get_card_run_time())
	
	if is_instance_valid(boss):
		boss.position = $"符卡敌机/BossPos".position
	
	$"符卡发弹点/扳手自机狙发弹点".position = $"符卡敌机/BossPos".position
	$"符卡发弹点/雏翼自机狙发弹点".position = $"符卡敌机/BossPos".position
	
	if running_time == 1:
		$"符卡发弹点/扳手发弹点1".enable = true
		$"符卡发弹点/扳手发弹点2".enable = true
		$"符卡发弹点/雏翼发弹点1".enable = true
		$"符卡发弹点/雏翼发弹点2".enable = true
		for fdd in two_fdd:
			fdd.enable_shoot_bullet = false
			fdd.enable = true
		
	if int(running_time) % 5 == 0:
		if !disabling:
			if !this_second_runed:
				this_second_runed = true
				for fdd in two_fdd:
					fdd.enable_shoot_bullet = false
				$"符卡敌机/BossPos".position = Vector2(randf_range(10,1270),\
				randf_range(160,560))
				two_fdd[randi_range(0,1)].enable_shoot_bullet = true

func _after_card_run():
	pass

