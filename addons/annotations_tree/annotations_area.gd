@tool
class_name AnnotationsArea
extends PanelContainer

signal open_script_selected(file_path, line_number)

var godot_theme : Theme

@onready
var annotation_filter_node := $VBoxContainer/AnnotationFilter as MenuButton

@onready
var annotation_tree  := $VBoxContainer/AnnotationTree as Tree

var _current_annotation_data : Dictionary
var filtered_annotations : Array[String] = []

## Fill [member annotation_filter_node] with all the annotations in [filtered_annotations]
func _ready() -> void:
	var popup_menu = annotation_filter_node.get_popup()
	popup_menu.clear()
	var item_id : int = 0
	for annotation_name in filtered_annotations:
		popup_menu.add_check_item(annotation_name, item_id)
		var item_idx = popup_menu.get_item_index(item_id)
		popup_menu.set_item_checked(item_idx, true)
		item_id += 1
	popup_menu.id_pressed.connect(_on_annotation_item_pressed)
	
	var menu_button_icon = godot_theme.get_icon("MenuButton", 'EditorIcons')
	annotation_filter_node.icon = menu_button_icon


## Add annotations to [member annotation_tree]
func add_annotations_to_annotation_tree(parent_item: TreeItem, annotation_data: Dictionary) -> bool:
	var added_meaningful_items = false
	for key_name in annotation_data:
		if annotation_data[key_name] is Dictionary:
			var key_item = annotation_tree.create_item(parent_item)
			key_item.set_text(0, key_name)
			if not add_annotations_to_annotation_tree(key_item, annotation_data[key_name]):
				key_item.get_parent().remove_child(key_item)
			else:
				added_meaningful_items = true
		else:
			if key_name in filtered_annotations:
				var key_item = annotation_tree.create_item(parent_item)
				var annotations_recaps = annotation_data[key_name]
				if annotations_recaps.size() > 0:
					key_item.set_text(0, key_name)
					for a_recap in annotations_recaps:
						var annotation_item = annotation_tree.create_item(key_item)
						annotation_item.set_text(0, a_recap)
				added_meaningful_items = true
	
	return added_meaningful_items


## Update [member annotation_tree] with the current [member _current_annotation_data]
func update_annotation_tree() -> void:
	annotation_tree.clear()
	var root = annotation_tree.create_item()
	root.set_text(0, "res://")
	annotation_tree.hide_root = true
	add_annotations_to_annotation_tree(root, _current_annotation_data)


## setter for [member _current_annotation_data]
func set_annotation_data(annotation_data) -> void:
	_current_annotation_data = annotation_data
	update_annotation_tree()


## setter for [member filtered_annotations]
func set_annotation_list(annotations: Array) -> void:
	filtered_annotations = annotations


func _on_annotation_item_pressed(item_id: int) -> void:
	var popup_menu = annotation_filter_node.get_popup()
	var item_idx = popup_menu.get_item_index(item_id)
	var is_checked = popup_menu.is_item_checked(item_idx)
	popup_menu.set_item_checked(item_idx, not is_checked)
	if is_checked:
		var item_name = popup_menu.get_item_text(item_idx)
		filtered_annotations.erase(item_name)
	else:
		var item_name = popup_menu.get_item_text(item_idx)
		filtered_annotations.push_back(item_name)
	update_annotation_tree()


func _on_tree_item_selected() -> void:
	var selected_item = annotation_tree.get_selected()
	var item_name = selected_item.get_text(0)
	if item_name in filtered_annotations:
		return # If clicked on an anotation line
	
	var line_number = -1
	var file_path = ""
	if selected_item.get_child_count() == 0:
		#If clicked on an annotation type
		var separator_index = item_name.find(":")
		line_number = item_name.substr(0, separator_index).to_int()
		selected_item = selected_item.get_parent().get_parent() #Go higher and skipping the annotation type item
		item_name = selected_item.get_text(0)

	if selected_item.get_child(0).get_text(0) in filtered_annotations:
		# If cliqued on a file
		file_path = item_name # initiate with file name
		selected_item = selected_item.get_parent()
		item_name = selected_item.get_text(0)
		
		while item_name != "res://": # Add the directories leading to the file
			file_path = item_name + "/" + file_path
			selected_item = selected_item.get_parent()
			item_name = selected_item.get_text(0)
			
		file_path = "res://" + file_path
		open_script_selected.emit(file_path, line_number)
	else:
		# Else : cliqued on a directory
		pass
