@tool
extends Control
class_name BGENode

@export var Data : BGEData

@export var ID : int :
	set(id):
		if(!is_inside_tree()): await(ready)
		if id<1: id=1
		if id>Data.Size: id=Data.Size
		var data = Data.getData(id-1)
		for d in data:
			match d.Type:
				"Text":
					(get_node(d.Node_Path) as Label).text = d.Value
				"Integer":
					(get_node(d.Node_Path) as Label).text = d.Value
				"Richt Text":
					(get_node(d.Node_Path) as RichTextLabel).text = d.Value
				"Symbol":
					(get_node(d.Node_Path) as TextureRect).texture = load(d.Value)
				"Image": # TODO: Implement
					pass
		(get_node(Data.Size_Label) as Label).text = str(Data.Size)
		(get_node(Data.ID_Label) as Label).text = str(id)
		print(str(id)+" done")
		ID = id

