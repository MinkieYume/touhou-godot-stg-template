# meta-name: 符卡模板
# meta-description: 一个基础的符卡模板
# meta-default: true
# meta-space-indent: 4
extends SpellCard

#提示：道中设定也可以考虑使用AnimationPlayer安排

func _before_card_run():
	pass

func _card_running_event():
	var left_time = floor(get_left_time())
	var running_time = floor(get_card_run_time())
	print(frames)

func _after_card_run():
	pass
