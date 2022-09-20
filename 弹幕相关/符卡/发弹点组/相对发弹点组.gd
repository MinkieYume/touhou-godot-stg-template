extends Node2D

@export var follow_boss = true

func _ready():
	pass

func _process(delta):
	if STGSYS.boss!=null and follow_boss:
		position = STGSYS.boss.position
