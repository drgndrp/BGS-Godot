@tool
extends HFlowContainer


@export_group("Sheet Data")
@export var Data : BGEData

@export_node_path("BGENode") var Template : NodePath:
	set(templ):
		if(!is_inside_tree()): await(ready)

		for n in get_children():
			n.queue_free()

		if !templ.is_empty():
			for i in range(1,Data.Size+1):
				var card : BGENode = get_node(templ).duplicate()
				add_child(card)
				card.set("ID",i)
		Template = templ

