extends Panel

@onready var main_menu = $"../MainMenu"
@onready var save_replay = $VBoxContainer/SaveReplay
@onready var back_menu = $VBoxContainer/BackMenu
@onready var retry = $VBoxContainer/Continue
@onready var restart = $VBoxContainer/Restart
@onready var vbox = $VBoxContainer

@onready var no_focus = $"../MainMenu/No_Focus"

@onready var animation_player = $"../AnimationPlayer"

@export var can_save_replay = true
@export var can_retry = true

func _ready():
	visible = false
	STGSYS.connect("game_over",Callable(self,"_on_gameover"))

func _on_gameover():
	visible = true
	get_node("/root/东方弹幕绘/UI").show_boss_hp = false
	get_node("/root/东方弹幕绘/UI").remove_hp_bars()
	reset_focus()
	restart.grab_focus()

func reset_focus():
	var last_button = restart
	var first_button
	var index = 0
	
	if can_retry:
		retry.visible = true
	
	if can_save_replay:
		save_replay.visible = true
	
	if can_retry:
		first_button = retry
	elif can_save_replay:
		first_button = save_replay
	else:
		first_button = back_menu
	
	var buttons = vbox.get_children()
	
	for button in buttons:
		if button.visible:
			var next_button
			if index < buttons.size()-1:
				var i = 1
				next_button = buttons[index+i]
				while !next_button.visible:
					i+=1
					next_button = buttons[index+i]
			else:
				next_button = first_button
			button.focus_neighbor_bottom = next_button.get_path()
			button.focus_neighbor_left = last_button.get_path()
			button.focus_neighbor_right = next_button.get_path()
			button.focus_neighbor_top = last_button.get_path()
			button.focus_previous = last_button.get_path()
			button.focus_next = next_button.get_path()
			last_button = button
		index += 1



func _on_back_menu_pressed():
	visible = false
	main_menu.play_mainmenu_enter()


func _on_save_replay_pressed():
	pass # Replace with function body.


func _on_continue_pressed():
	pass # Replace with function body.


func _on_restart_pressed():
	pass # Replace with function body.
