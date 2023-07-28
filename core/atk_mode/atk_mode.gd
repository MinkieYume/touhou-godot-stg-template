class_name AtkMode
extends Node

var position : Vector2

var attacker
var target

var atk_start = false

@onready var spawn_point = $SpawnPoints/SpawnPoint

func _ready():
	var prt = get_parent()
	if prt is Node2D:
		attacker = prt.get_parent()
	spawn_point.active = false

func start_atk(target_=null):
	atk_start = true
	target = target_

func _physics_process(delta):
	if attacker != null:
		position = attacker.position
	if atk_start:
		_attack()

func _attack():
	spawn_point.position = position
	spawn_point.active = true

