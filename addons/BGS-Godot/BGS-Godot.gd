@tool
extends EditorPlugin

const SheetViewer = preload("res://addons/BGS-Godot/BGESheetViewer.tscn")
var sheetviewer

func _enter_tree():
	# Initialization of the plugin goes here.

	sheetviewer = SheetViewer.instantiate()

	get_editor_interface().get_editor_main_screen().add_child(sheetviewer)

	add_custom_type("Board Game Element",			"Control",			preload("res://addons/BGS-Godot/BGENode.gd"),	null)
	add_custom_type("Board Game Element - Sheet",	"HFlowContainer",	preload("res://addons/BGS-Godot/BGESheet.gd"),	null)
	add_custom_type("Board Game Element - Data",	"Resource",			preload("res://addons/BGS-Godot/BGEData.gd"),	null)
	add_custom_type("Board Game Element - Field",	"Resource",			preload("res://addons/BGS-Godot/BGEField.gd"),	null)
	_make_visible(false)

func _exit_tree():
	# Clean-up of the plugin goes here.

	if sheetviewer:
		sheetviewer.queue_free()

	remove_custom_type("Board Game Element")
	remove_custom_type("Board Game Element - Data")
	remove_custom_type("Board Game Element - Field")
	remove_custom_type("Board Game Element - Sheet")

func _has_main_screen():
	return true

func _make_visible(visible):
	if sheetviewer:
		sheetviewer.edited_scene_root = get_editor_interface().get_edited_scene_root()
		sheetviewer.visible = visible

func _get_plugin_name():
	return "BGS - Sheet Viewer"

func _get_plugin_icon():
	var t = load("res://addons/BGS-Godot/icons/card.svg") as Texture2D
	return t