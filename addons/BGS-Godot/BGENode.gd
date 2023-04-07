@tool
extends Control
class_name BGENode

## A [BGEData] Resource to load Data
@export var Data : BGEData

## The ID of this Element within the BG-element-set
@export var ID : int :
	set(id):
		# wait for object to be instanced
		if(!is_inside_tree()): await(ready)

		# Get Element-Dataset from BGEData object
		id = clamp(id,1,Data.size)
		var data = Data.getData(id-1)
		
		#Fill nodes with Data
		for d in data:
			var field : BGEField = Data.Data_Mappings[d]
			print(d+" = "+ str(data[d]))
			if(has_node(field.Corresponding_Node)):
				var cn = get_node(field.Corresponding_Node)
				match field.Type:
					"Text":
						var fsize = (cn as RichTextLabel).get_theme_default_font().get_height()
						var text = data[d]
						for k in field.Symbol_Mapping:
							text = text.replace("%"+k+"%","[img height="+str(fsize)+"]"+field.Symbol_Mapping[k].resource_path+"[/img]")
						cn.text = text
					"Integer":
						cn.text = str(data[d])
					"Symbol":
						(cn as TextureRect).texture = load(field.Symbol_Mapping[data[d]].resource_path)
					"Image": # TODO: Implement
						pass
		if(has_node(Data.Size_Label)):(get_node(Data.Size_Label) as Label).text = str(Data.Size)
		if(has_node(Data.ID_Label)):(get_node(Data.ID_Label) as Label).text = str(id)
		print(str(id)+" done")
		ID = id
