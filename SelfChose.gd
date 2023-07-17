extends Control

@onready var focus = $focues/focus
@onready var character_list = RS.self_flyer_menu.keys()
@onready var toggle_audio = $"../../../Audio/ToggleButton"
@onready var pressed_audio = $"../../../Audio/PressedButton"
@onready var cancel_audio = $"../../../Audio/CancelButton"
@onready var self_chose_panel = $SelfChosePanel
@onready var switch_chose_panel = $SwitchChosePanel
@onready var animation_player = $"../../../AnimationPlayer"
@onready var spellcard_chose = $"../SpellCardChose/Spellcard Chose"
@onready var no_focus = $"../../No_Focus"

@onready var main_menu = $"../.."

var is_spellcard_practice_mode = false

var last_chosed_hard
var last_chosed_pos
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

func _input(event):
	if focus.has_focus():
		if event.is_action_pressed("ui_right"):
			no_focus.grab_focus()
			var index = character_list.find(current_character)
			var next_character
			if index == character_list.size()-1:
				next_character = character_list[0]
			else:
				next_character = character_list[index+1]
			reload_chose_panel(next_character,true)
			animation_player.play("自机选项切换_左")
			toggle_audio.play()
			await animation_player.animation_finished
			get_focus()
			reload_chose_panel(next_character)
		if event.is_action_pressed("ui_left"):
			no_focus.grab_focus()
			var index = character_list.find(current_character)
			var last_character = character_list[index-1]
			reload_chose_panel(last_character,true)
			animation_player.play("自机选项切换_右")
			toggle_audio.play()
			await animation_player.animation_finished
			get_focus()
			reload_chose_panel(last_character)
		if event.is_action_pressed("ui_accept"):
			no_focus.grab_focus()
			spellcard_chose.get_node("Spellcard1").visible = true
			var flyer_list = RS.self_flyer_menu[current_character]["机体列表"]
			var flyer_names = flyer_list.keys()
			var flyer_num = flyer_list.keys().size()
			var flyer_panel_list = []
			#批量设置每一个机型面板的属性
			for n in range(flyer_num):
				var panel_name = "Spellcard%d"%(n+1)
				var flyer_name = flyer_names[n]
				var flyer_data = flyer_list[flyer_name]
				var spellcard_panel = spellcard_chose.get_node(panel_name)
				var title_label = spellcard_panel.get_node("title")
				var discuss_label = spellcard_panel.get_node("Label")
				title_label.text = flyer_name
				title_label.label_settings = flyer_data[0]
				discuss_label.text = flyer_data[1]
				discuss_label.label_settings = flyer_data[2]
				spellcard_panel.flyer_type = flyer_data[3]
				spellcard_panel.visible = true
				flyer_panel_list.append(spellcard_panel)
			#设置机型面板的焦点
			var last_panel = flyer_panel_list[-1]
			var flyer_panel_index = 0
			for flyer_panel in flyer_panel_list:
				var next_panel
				if flyer_panel_index+1 >= flyer_panel_list.size():
					next_panel = flyer_panel_list[0]
				else:
					next_panel = flyer_panel_list[flyer_panel_index+1]
				print(last_panel.get_path())
				flyer_panel.focus_neighbor_left = last_panel.get_path()
				flyer_panel.focus_neighbor_bottom = next_panel.get_path()
				flyer_panel.focus_neighbor_right = next_panel.get_path()
				flyer_panel.focus_neighbor_top = last_panel.get_path()
				flyer_panel.focus_next = next_panel.get_path()
				flyer_panel.focus_previous = last_panel.get_path()
				last_panel = flyer_panel
				flyer_panel_index += 1
			pressed_audio.play()
			animation_player.play("自机选择切符卡选择")
			await  animation_player.animation_finished
			spellcard_chose.get_node("Spellcard1").grab_focus()
		if event.is_action_pressed("ui_cancel"):
			cancel_audio.play()
			no_focus.grab_focus()
			var ch = get_node("chosed_hard")
			if is_instance_valid(ch):
				var tween = get_tree().create_tween()
				tween.bind_node(ch)
				tween.set_trans(Tween.TRANS_LINEAR)
				tween.tween_property(ch,"position",last_chosed_pos,0.5)
			animation_player.play_backwards("难度选择切自机选择")
			await animation_player.animation_finished
			if is_instance_valid(ch):
				ch.queue_free()
			if is_spellcard_practice_mode:
				main_menu.play_mainmenu_enter()
			else:
				last_chosed_hard.grab_focus()

func delete_chosed_panel():
	var ch = get_node("chosed_hard")
	if is_instance_valid(ch):
		ch.queue_free()
