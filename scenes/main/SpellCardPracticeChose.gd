extends Control

@onready var spellcard_vbox = $ScrollContainer/VBoxContainer

@onready var spell_card1 = $ScrollContainer/VBoxContainer/SpellCard1

@onready var game_window = $"../../../GameWindow"

@onready var no_focus = $"../../No_Focus"

@onready var animation_player = $"../../../AnimationPlayer"

@onready var main_menu = $"../.."

var spell_card_temp

var last_focus_button

func _ready():
	spell_card_temp = spell_card1.duplicate()
	last_focus_button = spell_card1
	load_spellcard_buttons()

func load_spellcard_buttons():
	var sp = RS.spellcard_practices
	var card_button_list = spellcard_vbox.get_children()
	var index = 0
	for card_button in card_button_list:
		card_button.disabled = true
		card_button.level = ""
		card_button.text = "？？？？？？"
	for spellcard in sp:
		if spellcard["unlocked"]:
			var current_card_button
			if index >= card_button_list.size():
				current_card_button = spell_card_temp.duplicate()
				spellcard_vbox.add_child(current_card_button)
			else:
				current_card_button = card_button_list[index]
			
			current_card_button.disabled = false
			current_card_button.level = spellcard["level"]
			current_card_button.text = spellcard["name"]
		index += 1
	
	index = 0

	for card_button in card_button_list:
		#设置聚焦节点
		card_button.focus_neighbor_left = card_button_list[index-1].get_path()
		card_button.focus_neighbor_top = card_button_list[index-1].get_path()
		card_button.focus_previous = card_button_list[index-1].get_path()
		
		if index >= card_button_list.size()-1:
			card_button.focus_neighbor_bottom = card_button_list[0].get_path()
			card_button.focus_neighbor_right = card_button_list[0].get_path()
			card_button.focus_next = card_button_list[0].get_path()
		else:
			card_button.focus_neighbor_bottom = card_button_list[index+1].get_path()
			card_button.focus_neighbor_right = card_button_list[index+1].get_path()
			card_button.focus_next = card_button_list[index+1].get_path()
		card_button.connect("pressed",Callable(self,"_on_cardbutton_pressed").bind(card_button))
		card_button.connect("focus_entered",Callable(self,"_on_cardbutton_focus_on").bind(card_button))
		index += 1

func _on_cardbutton_focus_on(card_button):
	if card_button.disabled:
		last_focus_button.grab_focus()
	else:
		last_focus_button = card_button

func _on_cardbutton_pressed(card_button):
	game_window.level_name = card_button.level
	no_focus.grab_focus()
	animation_player.play("淡出画面")
	await animation_player.animation_finished
	game_window.practice_mode = game_window.PRACTICE_MODE.SPELLCARD
	main_menu.visible = false
	game_window.visible = true
	game_window.enable = true
	animation_player.play("淡入画面")
