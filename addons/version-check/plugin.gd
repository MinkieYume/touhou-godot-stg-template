@tool
extends EditorPlugin

var version_check

func _enter_tree():
	version_check = preload("res://addons/version-check/views/version_check.tscn").instantiate()
	add_control_to_container(CONTAINER_TOOLBAR, version_check)

func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, version_check)
	version_check.free()



