@tool
extends Resource
class_name BGEField

## The Type of Field.
@export_enum("Amount","Text","Symbol","Image") var Type : String:
	set(v):
		Type = v
		emit_changed()

## The node to represent that field, the type of node is dependend on the type of field:
## [br] Amount: [Label],[RichTextLabel]
## [br] Text: [RichTextLabel]
## [br] Symbol: [TextureRect]
## [br] Image: (not yet implemented)
@export var Corresponding_Node : NodePath

@export_subgroup("Symbol Options")

## Map symbols in "Symbol"-fields or in "Rich Text"-Fields to [CCompressedTexture2D]
@export var Symbol_Mapping : Dictionary = {
	"unknown": CompressedTexture2D.new()
	} 
