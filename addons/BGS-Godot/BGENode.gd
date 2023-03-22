extends Node2D

@export var Data : BGEData

@export var ID : int :
	set(v):
		ID = v
		var data = Data.getData(ID)
		for d in data:
			match d.Type:
				"Text":
					print("Text")
					(get_node(d.Node_Path) as Label).text = d.Value
				"Integer":
					print("int")
					(get_node(d.Node_Path) as Label).text = d.Value
				"Richt Text":
					(get_node(d.Node_Path) as RichTextLabel).text = d.Value
				"Symbol":
					(get_node(d.Node_Path) as TextureRect).texture = load(d.Value)
				"Image": # TODO: Implement
					pass
