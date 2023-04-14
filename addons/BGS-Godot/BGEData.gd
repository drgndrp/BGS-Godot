@tool
extends Resource
class_name BGEData


@export_group("1. Import Data") 
## Set the the Path to the source File.
## [b]For now the data must be imported from a JSON-file.[/b]
@export_global_file("*.json") var Data_Path :
	set(data_path): 
		Data_Path = data_path 
		# TODO: Implement better ways to import data 
		# Parse json-file and safe in Data variable
		Data = JSON.parse_string(
					FileAccess.open(Data_Path,FileAccess.READ)
					.get_as_text()
					)
		# Prepopulate mapping with headers from source
		for key in Data[0]:
			if(!Data_Mappings.has(key)):
				Data_Mappings[key] = BGEField.new()
				# A signal needed to monitor changes in the field.
				(Data_Mappings[key] as BGEField).changed.connect(CardFieldChanged)
		
		notify_property_list_changed() 	# Don't know if this is needed lol

## This is the raw Imported Data. 
## [b]Only edit for debugging, changes will be overwritten once you import a new file.
@export var Data : Array :
	set(d):
		# Check if data has been imported
		if(Data_Path==null):
			push_error("Please import data from JSON-File first")
		else:
			Data = d


@export_group("2. Map Data")

## Here you will map the fields as defined in the source data to specific Godot Nodes.
@export var Data_Mappings: Dictionary : 
	set(dm):
		# Check if data has been imported
		if(Data_Path==null):
			push_error("Please import data from JSON-File first")
		else:
			Data_Mappings = dm

		notify_property_list_changed() # Don't know if this is needed lol
## Set a [Label] to display the size of this set of bg-elements (not required)
@export_node_path("Size Lable","Label") var Size_Label: NodePath
## Set a [Label] to display the ID of the Card (not required)
@export_node_path("ID Lable","Label") var ID_Label: NodePath

var ID : int

@export_group("Read Only Fields")

## Which field in the source data shows the amount of bg-elements that are
## contained in this set of bg-elements. [b] Set this in Mappings [/b]
## [br]If not set, every source dataset will be contained once.
@export var Amount_Field : String = "Not set" :
	set(_v): pass
	get:
		# Search for the first occurence of a "Amount"-Field in the mappings
		# ! Potentially heavy operation, can be optimized
		if Data_Mappings.size()>0:
			for m in Data_Mappings.values():
				if (m as BGEField).Type == "Amount":
					return Data_Mappings.find_key(m)
		return "Not set"

## An array containing all elements in this set, inflated according to the amount of each individual bg-element
@export var BGESet : Array :
	set(_v): pass

## The Size of the bg-elements set.
@export var Size: int:
	set(_v): pass
	get:
		var s
		BGESet.clear()
		if Amount_Field != "Not set":
			s = 0
			for C in Data:
				for i in range(0,C[Amount_Field]):
					BGESet.append(Data.find(C))
				s += C[Amount_Field]
		else:
			s = Data.size()
			BGESet.append_array(range(0,Data.size()))
		return s


## Monitor changes in BGEField objects
''' ! 
This feels scuffed and inconsistent with the rest of the code, 
but its the only way i got it working. Can be optimized
'''
func CardFieldChanged():
	# Populate the Symbol_Mappings
	for key in Data_Mappings:
		
		var field = Data_Mappings[key] as BGEField
		var SMap : Dictionary = field.Symbol_Mapping 
		
		match field.Type:
			"Symbol":
				# Add every unique occurence of a word in a "Symbol"-Type Collumn
				for d in Data:
					if(!SMap.has(d[key])): 
						SMap[str(d[key])] = CompressedTexture2D.new()
			"Rich Text":
				# Search for every Uniqe Occurence of a Word encased by "%" in text Rich-Text-Fields
				var regex = RegEx.create_from_string("%(.*?)%")
				for d in Data:
					for t in regex.search_all(d[key]):
						if(!SMap.has((t as RegExMatch).strings[1])): 
							SMap[(t as RegExMatch).strings[1]] = CompressedTexture2D.new()
						
## Returns a dataset from the Source data based on its ID
func getData(id) -> Dictionary:
	#CardFieldChanged()
	ID = id
	return Data[BGESet[id]]
