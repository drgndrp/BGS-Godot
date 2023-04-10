@tool
extends VBoxContainer

@export var edited_scene_root : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Buttons/Export".get_popup().connect("id_pressed",_on_export_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visibility_changed():
	if visible:
		if edited_scene_root is BGENode:
			$"Scroll/Sheet".set("Data",edited_scene_root.Data)
			$"Scroll/Sheet".set("Template",edited_scene_root.get_path())

func _on_export_pressed(id):
	if edited_scene_root is BGENode:
		var node = (edited_scene_root.duplicate() as BGENode)

		var window = Window.new()
		window.title = "Render Window"
		window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
		add_child(window)

		match $"Buttons/Export".get_popup().get_item_text(id):

			"Sheet":
				var sheet = $"Scroll/Sheet".duplicate()
				window.size = Vector2(1000, 1000)
				window.add_child(sheet)
				await RenderingServer.frame_post_draw
				sheet.get_viewport().get_texture().get_image().save_png("test.png")

			"Seperate Files":
				window.size = (edited_scene_root as BGENode).size
				window.add_child(node)
				var vp = node.get_viewport().get_texture()
				for i in range(1,node.Data.Size+1):
					node.ID = i
					await RenderingServer.frame_post_draw
					vp.get_image().save_png("export/"+node.name+"_"+str(i)+".png")
				window.queue_free()
