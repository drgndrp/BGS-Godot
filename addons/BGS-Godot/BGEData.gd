@tool
extends Resource

class_name BGEData

@export_group("1. Import Data")
@export_global_file("*.json") var Data_Path :
	set(f): 
		Data_Path = f
		Data = JSON.parse_string(
					FileAccess.open(f,FileAccess.READ)
					.get_as_text()
					)
		for key in Data[0]:
			Mappings[key] = BGEField.new()
			(Mappings[key] as BGEField).changed.connect(CardFieldChanged)
		notify_property_list_changed()
@export var Data : Array
@export_group("2. Map Data")
@export var Mappings: Dictionary : 
	set(value):
		print(value)
		Mappings = value
		notify_property_list_changed()
@export_group("3. Set Card ID")
@export var ID : int

@export_group("Read Only Fields")
@export var deck : Array :
	set(_v): pass
@export var Amount_Field: String :
	set(_v): pass
	get:
		if Mappings.size()>0:
			for m in Mappings.values():
				if (m as BGEField).Type == "Amount":
					return Mappings.find_key(m)
			return ""
		else: return ""

@export var Size: int:
	set(_v): pass
	get:
		var s = 0
		deck.clear()
		if Amount_Field != "":
			for C in Data:
				for i in range(0,C[Amount_Field]):
					deck.append(Data.find(C))
				s += C[Amount_Field]
		return s

func CardFieldChanged():
	print("hey")
	for k in Mappings:
		var m = Mappings[k] as BGEField
		var SMap : Dictionary = m.Symbol_Mapping 
		match m.Type:
			"Symbol":
				for d in Data:
					print(d[k])
					print(SMap.find_key([d[k]]))
					if(!SMap.has(d[k])): 
						SMap[str(d[k])] = CompressedTexture2D.new()

func getData(id) -> Array:
	CardFieldChanged()
	ID = id
	var arr : Array
	var Card = Data[deck[id]]
	for k in Card:
		var cf = (Mappings[k] as BGEField)
		var CCard = Card[k]
		if cf.Type == "Symbol": CCard = (cf.Symbol_Mapping[Card[k]] as CompressedTexture2D).resource_path
		arr.append({"Type" : cf.Type, "Node_Path" : cf.Corresponding_Node, "Value" : str(CCard)})
		print(k + " (" + cf.Type + " @ $" + str(cf.Corresponding_Node) + ") = " + str(Card[k]))
	return arr
