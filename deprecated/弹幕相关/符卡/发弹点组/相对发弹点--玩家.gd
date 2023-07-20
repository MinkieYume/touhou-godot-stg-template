extends Node2D

@export var follow_player = true

func _ready():
	pass

func _process(delta):
	if STGSYS.player!=null and follow_player:
		position = STGSYS.player.position
