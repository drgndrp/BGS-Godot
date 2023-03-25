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
			var field : BGEField = Data.Data_Mappings[d]
			print(d+" = "+ str(data[d]))
			if(has_node(field.Corresponding_Node)):
				var cn = get_node(field.Corresponding_Node)
				match field.Type:
					"Text":
						cn.text = data[d]
					"Integer":
						cn.text = str(data[d])
					"Rich Text":
						var fsize = (cn as RichTextLabel).get_theme_default_font().get_height()
						var text = data[d]
						for k in field.Symbol_Mapping:
							text = text.replace("%"+k+"%","[img height="+str(fsize)+"]"+field.Symbol_Mapping[k].resource_path+"[/img]")
						(cn as RichTextLabel).text = text
					"Symbol":
						(cn as TextureRect).texture = load(field.Symbol_Mapping[data[d]].resource_path)
					"Image": # TODO: Implement
						pass
		if(has_node(Data.Size_Label)): (get_node(Data.Size_Label) as Label).text = str(Data.Size)
		if(has_node(Data.ID_Label)):(get_node(Data.ID_Label) as Label).text = str(id)
		print(str(id)+" done")
		ID = id
