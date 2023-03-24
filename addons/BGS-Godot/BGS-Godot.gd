@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("Board Game Element","Control",preload("res://addons/BGS-Godot/BGENode.gd"),null)
	add_custom_type("Board Game Element - Sheet","HFlowContainer",preload("res://addons/BGS-Godot/BGESheet.gd"),null)
	add_custom_type("Board Game Element - Data","Resource",preload("res://addons/BGS-Godot/BGEData.gd"),null)
	add_custom_type("Board Game Element - Field","Resource",preload("res://addons/BGS-Godot/BGEField.gd"),null)
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("Board Game Element")
	remove_custom_type("Board Game Element - Data")
	remove_custom_type("Board Game Element - Field")
	remove_custom_type("Board Game Element - Sheet")

	pass
