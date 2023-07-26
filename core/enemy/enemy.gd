class_name enemy
extends Area2D

@export var health = 100

@export var drop_score = 10
@export var drop_power = 0
@export var drop_point = 0

@export var protect_frames = 1

@export var clean_bullets = false
@export var out_screen_remove = true

@onready var atk1 = $AttackMode/AtkMode

var in_screen = false

var frame = 0
var second = 0

func _ready():
	pass

func _physics_process(delta):
	if in_screen:
		_enemy_event()
		frame +=1
		second = frame/60

func _enemy_event():
	if frame == 1:
		attack(atk1)

func attack(mode:AtkMode):
	mode.start_atk()

func kill():
	pass

func _on_dead():
	pass


func _on_visible_on_screen_enabler_2d_screen_entered():
	in_screen = true
