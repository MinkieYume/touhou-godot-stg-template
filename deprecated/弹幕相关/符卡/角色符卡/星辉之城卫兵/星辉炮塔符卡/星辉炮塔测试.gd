extends SpellCard

#提示：道中设定也可以考虑使用AnimationPlayer安排

func _before_card_run():
	pass

func _card_running_event():
	var left_time = floor(get_left_time())
	var running_time = floor(get_card_run_time())
	if running_time == 1:
		$"符卡发弹点/星辉炮塔激光".enable = true
		$"符卡发弹点/星辉炮塔自机狙".enable = true
		$"符卡发弹点/星辉炮塔固定弹".enable = true
		$"符卡发弹点/星辉炮塔随机弹".enable = true

func _after_card_run():
	pass

