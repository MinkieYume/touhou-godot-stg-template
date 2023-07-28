extends Node

func _unhandled_input(event):
	#统一处理案按键操作
#	if Input.is_action_just_pressed("fire"):
#		shooting = true
#	if Input.is_action_just_released("fire"):
#		shooting = false
#	if Input.is_action_just_pressed("low_speed"):
#		lowSpeedMode = true
#	if Input.is_action_just_released("low_speed"):
#		lowSpeedMode = false
#	if Input.is_action_just_pressed("bomb"):
#		if bomb > 0:
#			emit_signal("use_bomb")
#			bomb_use = true
#			decrease_bomb()
#	if Input.is_action_just_released("bomb"):
#		bomb_use = false
#	if Input.is_action_just_pressed("special"):
#		special = true
#	if Input.is_action_just_released("special"):
#		special = false
	
	fxInput()

func fxInput(): #此函数用于处理方向的输入
	var vector = Vector2.ZERO
	
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()
	
	STGSYS.selfMoveVector = vector
#	for input in DIRINPUTS:
#		if Input.is_action_just_pressed("ui_"+input):
#			pressed_direction.append(DIRINPUTS[input])
#		if Input.is_action_just_released("ui_"+input):
#			pressed_direction.erase(DIRINPUTS[input])
#
#	if pressed_direction.has(Vector2.UP) and \
#	pressed_direction.has(Vector2.DOWN):
#		var up_ind = pressed_direction.find(Vector2.UP)
#		var down_ind = pressed_direction.find(Vector2.DOWN)
#		if up_ind < down_ind:
#			pressed_direction.remove_at(up_ind)
#		else:
#			pressed_direction.remove_at(down_ind)
#
#	if pressed_direction.has(Vector2.LEFT) and \
#	pressed_direction.has(Vector2.RIGHT):
#		var lf_ind = pressed_direction.find(Vector2.LEFT)
#		var rg_ind = pressed_direction.find(Vector2.RIGHT)
#		if lf_ind < rg_ind:
#			pressed_direction.remove_at(lf_ind)
#		else:
#			pressed_direction.remove_at(rg_ind)
#
#
#	for dire in pressed_direction:
#		var retype_num = 0
#		for ried in pressed_direction:
#			if dire == ried:
#				retype_num+=1
#		if retype_num > 1:
#			pressed_direction.erase(dire)
#
#	var finalvector = Vector2.ZERO
#	for direction in pressed_direction:
#		finalvector += direction
#
#	selfMoveVector = finalvector
