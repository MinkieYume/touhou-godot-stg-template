extends SpellCard

#提示：道中设定也可以考虑使用AnimationPlayer安排
@export var shoot_bullet = true

func _before_card_run():
	pass

func _card_running_event():
	if frames == 1:
		$"符卡发弹点/相对发弹点/扳手风暴--自机".enable = true
	
	$"符卡发弹点/相对发弹点/扳手风暴--自机".enable_shoot_bullet = shoot_bullet

func _after_card_run():
	pass

