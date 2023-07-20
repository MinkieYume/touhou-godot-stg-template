extends SpellCard

#提示：道中设定也可以考虑使用AnimationPlayer安排

func _before_card_run():
	pass

func _card_running_event():
	var left_time = floor(get_left_time())
	var running_time = floor(get_card_run_time())
	if running_time == 1:
		$"符卡发弹点/相对发弹点/全知之书发射".enable = true
		$"符卡发弹点/相对发弹点/全知之书绑定".enable = true
	$"符卡发弹点/相对发弹点/全知之书绑定".books = \
	$"符卡发弹点/相对发弹点/全知之书发射".all_bullets

func _after_card_run():
	for bull in $"符卡发弹点/相对发弹点/全知之书绑定".all_bullets:
		bull.queue_free()

