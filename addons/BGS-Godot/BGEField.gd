@tool
extends Resource
class_name BGEField

@export_group("Field Options")
@export_enum("Amount","Integer","Text","Rich Text","Symbol","Image") var Type : String:
	set(v):
		Type = v
		emit_changed()
@export var Corresponding_Node : NodePath
@export_subgroup("Symbol Options")
@export var Symbol_Mapping : Dictionary = {
	"unknown": CompressedTexture2D.new()
	} 
