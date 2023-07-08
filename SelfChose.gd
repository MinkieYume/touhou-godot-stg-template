extends Control

@onready var focus = $focues/focus
@onready var character_list = RS.self_flyer_menu.keys()
@onready var toggle_audio = $"../../../Audio/ToggleButton"
@onready var pressed_audio = $"../../../Audio/PressedButton"
@onready var cancel_audio = $"../../../Audio/CancelButton"
@onready var self_chose_panel = $SelfChosePanel
@onready var switch_chose_panel = $SwitchChosePanel
@onready var animation_player = $"../../../AnimationPlayer"

var current_character

func _ready():
	character_list = RS.self_flyer_menu.keys()
	reload_chose_panel(character_list[0])
	self_chose_panel.position = Vector2(803,0)

func reload_chose_panel(character_name,is_switch_panel=false):
	var title = character_name
	var tittle_ef = RS.self_flyer_menu[character_name]["标题效果"]
	var pic = RS.self_flyer_menu[character_name]["图片"]
	var chenghao = RS.self_flyer_menu[character_name]["称号"]
	var chenghao_ef = RS.self_flyer_menu[character_name]["称号效果"]
	var discuss = RS.self_flyer_menu[character_name]["介绍"]
	var discuss_ef = RS.self_flyer_menu[character_name]["介绍效果"]
	var panel
	if is_switch_panel:
		panel = switch_chose_panel.get_child(0).get_child(0)
		switch_chose_panel.visible = true
	else:
		panel = self_chose_panel.get_child(0).get_child(0)
		current_character = title
		self_chose_panel.position = Vector2(317,0)
		self_chose_panel.size = Vector2(419,600)
		switch_chose_panel.visible = false
	panel.texture = pic
	panel.get_node("Title2").text = chenghao
	panel.get_node("Title2").label_settings = chenghao_ef
	panel.get_node("Title1").text = title
	panel.get_node("Title1").label_settings = tittle_ef
	panel.get_node("Discus").text = discuss
	panel.get_node("Discus").label_settings = discuss_ef

func get_focus():
	focus.grab_focus()

func _unhandled_input(event):
	if focus.has_focus():
		if event.is_action_pressed("right"):
			toggle_audio.play()
			var index = character_list.find(current_character)
			var next_character
			if index == character_list.size()-1:
				next_character = character_list[0]
			else:
				next_character = character_list[index+1]
			reload_chose_panel(next_character,true)
			animation_player.play("自机选项切换_左")
			await animation_player.animation_finished
			reload_chose_panel(next_character)
		if event.is_action_pressed("left"):
			toggle_audio.play()
			var index = character_list.find(current_character)
			var last_character = character_list[index-1]
			reload_chose_panel(last_character,true)
			animation_player.play("自机选项切换_右")
			await animation_player.animation_finished
			reload_chose_panel(last_character)
		if event.is_action_pressed("ui_accept"):
			pass
		if event.is_action_pressed("ui_cancel"):
			pass
