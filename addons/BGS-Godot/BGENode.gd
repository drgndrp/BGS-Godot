@tool
extends Control

@export var Data : BGEData

@export var ID : int :
	set(v):
		if v<1: v=1
		if v>Data.Size: v=Data.Size
		ID = v
		print("test")
		var data = Data.getData(ID-1)
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
		(get_node(Data.Size_Label) as Label).text = str(Data.Size)
		(get_node(Data.ID_Label) as Label).text = str(ID)

