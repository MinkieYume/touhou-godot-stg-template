class_name AtkMode
extends Node

var position : Vector2

var attacker

var atk_start = false

@onready var spawn_point = $SpawnPoints/SpawnPoint

func _ready():
	var prt = get_parent()
	if prt is Node2D:
		attacker = prt.get_parent()

func _process(delta):
	if attacker != null:
		position = attacker.position
	if atk_start:
		_attack()

func _attack():
	spawn_point.position = position
	spawn_point.active = true
	print(spawn_point.active)

