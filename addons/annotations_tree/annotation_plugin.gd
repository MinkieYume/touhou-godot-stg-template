@tool
class_name AnnotationPlugin
extends EditorPlugin

## 
## A plugin that show comment annotations in the codebase in a tree
## Annotation must be surrounded by '#' and ':' to be considered found like this: #<AnnotationName>:
##
## Line that will be considered found 
## 	#TODO: do something
##
## Lines that will not.
## 	# TODO: do something
## 	# TODO do something
## 	#TODO do something
##

var annotations_area : AnnotationsArea
var timer : Timer

var folders_excluded : Array[String] = []

var annotations_list : Array[String] = []

var refresh_time : float = 10.0

var annotations_area_name : String = ""

var _is_processing : bool = false

func _enter_tree() -> void:
	# load configurations
	var config = ConfigFile.new()
	var err = config.load("res://addons/annotations_tree/plugin.cfg")
	# If the file didn't load, ignore it.
	if err == OK:
		annotations_list = config.get_value("parameters", "annotations_list", ["TODO", "FIXME", "BUG"])
		folders_excluded = config.get_value("parameters", "folders_excluded", [])
		annotations_area_name = config.get_value("parameters", "dock_name", "AnnotationsTree")
		refresh_time = config.get_value("parameters", "refresh_time", 10.0)
	
	# Add UI to the dock
	annotations_area = load("res://addons/annotations_tree/annotations_area.tscn").instantiate()
	annotations_area.godot_theme = get_editor_interface().get_base_control().theme as Theme
	annotations_area.open_script_selected.connect(open_script)
	annotations_area.set_annotation_list(annotations_list.duplicate(true))
	annotations_area.name = annotations_area_name
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, annotations_area)
	
	timer = Timer.new()
	timer.wait_time = refresh_time
	timer.one_shot = false
	timer.timeout.connect(update_annotations_tree)
	add_child(timer)
	timer.start()
	
	update_annotations_tree()


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	timer.stop()
	remove_control_from_docks(annotations_area)
	annotations_area.free()
	timer.free()


##
## Return a dictionary
## Creating sub dictionary on directory 
## The leaf contain the complete filepath as value
## example:
##{
##	"directory": {
##		"sub_directory": {
##			"file_name.gd": "file_path",
##			"file_name.gd": "file_path",
##		},
##		"file_name.gd": "file_path",
##		"file_name.gd": "file_path",
##	}
##}
##
func get_all_files(base_path: String) -> Dictionary:
	var files_found := {}
	var dir := Directory.new()
	if dir.open(base_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if ("%s%s" % [base_path, file_name]) not in folders_excluded:
					files_found[file_name] = get_all_files("%s%s/" % [base_path, file_name])
			else:
				if file_name.ends_with(".gd"):
					files_found[file_name] = "%s%s" % [base_path, file_name]
			file_name = dir.get_next()
	else:
		# Access to the path raise an error, no file will be processed
		pass
	return files_found


##
## Find all the annotation in the file
## Return a dictionary, example:
##{
##	"TODO": ["1:do something", "3:do something else"],
##	"FIXME": ["14: fix that part"]
##}
##
func get_annotations_from_file(file_path: String) -> Dictionary:
	var annotations_found := {}
	
	var target_file = File.new()
	if not target_file.file_exists(file_path):
		push_error("File not found: %s" % file_path)
		return {}
		
	target_file.open(file_path, File.READ)
	var line_number : int = 1
	while target_file.get_position() < target_file.get_length():
		var line_string := target_file.get_line()
		
		for annotation in annotations_list:
			var find_index = line_string.find("#%s:" % annotation)
			
			if find_index != -1:
				if annotation not in annotations_found:
					annotations_found[annotation] = []
				
				var annotation_recap = "%d:%s" % [line_number, line_string.substr(find_index + ("#%s:" % annotation).length())]
				annotations_found[annotation].push_back(annotation_recap)

		line_number += 1
	
	return annotations_found


## Return the full annotation tree
## Example
##{
##	"directory": {
##		"sub_directory": {
##			"file_name.gd": {
##				"TODO": [
##					["12: do something", "25: do something else"]
##				]
##			},
##		},
##		"file_name.gd": {
##				"TODO": [
##					["12: do something"]
##				],
##				"FIXME": [
##					["12: fix that part"]
##				]
##			},
##	}
##}
func get_annotations_for_all_files(files_tree: Dictionary) -> Dictionary:
	var files_annotations := {}
	for key_name in files_tree:
		if files_tree[key_name] is Dictionary:
			var sub_files_annotations := get_annotations_for_all_files(files_tree[key_name])
			
			if not sub_files_annotations.is_empty():
				files_annotations[key_name] = sub_files_annotations
		else:
			var file_annotation := get_annotations_from_file(files_tree[key_name])
			
			if not file_annotation.is_empty():
				files_annotations[key_name] = file_annotation
	
	return files_annotations

## Scan the whole projet for gdscript file (file.gd), retrieve the annotations then update the ui
func update_annotations_tree() -> void:
	if not _is_processing:
		_is_processing = true
		var all_files = get_all_files("res://")
		var annotations_data = get_annotations_for_all_files(all_files)
		annotations_area.set_annotation_data(annotations_data.duplicate(true))
		_is_processing = false

## Open the script file at the line_number
## If line_number is -1, the script is just opened
func open_script(file_path: String, line_number: int = -1) -> void:
	var script_editor := get_editor_interface().get_script_editor()
	var current_script := script_editor.get_current_script()
	
	if current_script == null or current_script.resource_path != file_path:
		var open_scripts := script_editor.get_open_scripts() as Array
		var script_to_open : Resource = null
		
		for script in open_scripts:
			if script.resource_path == file_path:
				script_to_open = script
		
		if script_to_open == null:
			script_to_open = ResourceLoader.load(file_path)
			
		get_editor_interface().edit_script(script_to_open, line_number)
		
	else:
		# goto_line() seem to count line from 0
		get_editor_interface().get_script_editor().goto_line(line_number - 1) 

