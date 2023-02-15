extends SpellCard

#提示：道中设定也可以考虑使用AnimationPlayer安排
var boss

func _before_card_run():
	boss = STGSYS.boss

func _card_running_event():
	var left_time = floori(get_left_time())
	var running_time = floori(get_card_run_time())
	
	if is_instance_valid(boss):
		boss.position = $"符卡敌机/BossPos".position
	
	$"符卡发弹点/扳手发弹点".position = $"符卡敌机/BossPos".position
	$"符卡发弹点/雏翼发弹点".position = $"符卡敌机/BossPos".position
	
	if running_time == 0:
		var tween = create_tween()
		tween.tween_property($"符卡敌机/BossPos","position",Vector2(1120,360),1)
	if running_time == 1:
		$"符卡发弹点/扳手发弹点".enable = true
		$"符卡发弹点/雏翼发弹点".enable = true
		$"符卡发弹点/雏翼发弹点".enable_shoot_bullet = false
	if running_time % 10 == 0 and running_time!=0:
		$"符卡发弹点/雏翼发弹点".enable_shoot_bullet = false
		$"符卡发弹点/扳手发弹点".enable_shoot_bullet = true
	if running_time % 20 == 0 and running_time!=0:
		$"符卡发弹点/扳手发弹点".enable_shoot_bullet = false
		$"符卡发弹点/雏翼发弹点".enable_shoot_bullet = false
		if !this_second_runed:
			this_second_runed = true
			var tween = create_tween()
			tween.tween_property($"符卡敌机/BossPos","position",\
			Vector2(randf_range(1000,1220),randf_range(120,620)),1)
			await tween.finished
			if is_instance_valid($"符卡发弹点/雏翼发弹点"):
				$"符卡发弹点/雏翼发弹点".enable_shoot_bullet = true

func _after_card_run():
	pass

