extends Node

var start = false

var input = []

func _process(delta):
	if start and STGSYS.player!=null:
		var dict = {}
		dict["vector"] = STGSYS.selfMoveVector
		if STGSYS.lowSpeedMode:
			dict["speed"] = STGSYS.player.low_speed_speed
		else:
			dict["speed"]= STGSYS.player.move_speed
		dict["attack"] = STGSYS.shooting
		dict["bomb"] = STGSYS.bomb_use
		dict["special"] = STGSYS.special
		input.append(dict)
