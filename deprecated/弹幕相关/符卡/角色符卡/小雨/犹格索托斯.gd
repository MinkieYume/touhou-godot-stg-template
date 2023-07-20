extends SpellCard

#提示：道中设定也可以考虑使用AnimationPlayer安排

func _before_card_run():
	randomize()

func _card_running_event():
	var left_time = floor(get_left_time())
	var running_time = floor(get_card_run_time())
	if running_time == 1:
		STGSYS.boss.move(Vector2(600,120))
		await STGSYS.boss.move_out
		$"符卡发弹点/相对发弹点/犹格索托斯发弹点".enable = true
		$"符卡遮罩/犹格索托斯遮罩".enable = true
		$MoveTimer.start()

func _after_card_run():
	pass

func _on_move_timer_timeout():
	STGSYS.boss.move(Vector2(randf_range(100.0,1200.0),\
	randf_range(120.0,200.0)))
