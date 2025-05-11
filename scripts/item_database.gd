class_name ItemsDataBase

const ITEM_RESOURCE_PATH = "res://resources/item_resource/"

var items: Dictionary = {}
var crafting_station_items: Array[ItemData] = []

func _init() -> void:
	load_all_items()

func load_all_items() -> void:
	items.clear()
	crafting_station_items.clear()
	var dir = DirAccess.open(ITEM_RESOURCE_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"): # Certifique-se que é um resource ItemData
				var resource_path = ITEM_RESOURCE_PATH.path_join(file_name)
				var item_data: ItemData = load(resource_path)

				if item_data and item_data.id != "":
					if items.has(item_data.id):
						printerr("ItemDatabase: ID de item duplicado encontrado '", item_data.id, "' em ", resource_path)
					else:
						items[item_data.id] = item_data
						if item_data.is_craftable:
							#print(item_data.display_name)
							
							crafting_station_items.append(item_data)

				else:
					printerr("ItemDatabase: Falha ao carregar ItemData ou ID ausente em: ", resource_path)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		printerr("ItemDatabase: Não foi possível abrir o diretório de recursos de itens: ", ITEM_RESOURCE_PATH)


func get_item_data(item_id: StringName) -> ItemData:
	if items.has(item_id):
		return items[item_id]
	printerr("ItemDatabase: Item com ID '", item_id, "' não encontrado.")
	return items[item_id]


func get_all_item_data() -> Array[ItemData]:
	return items.values()

func get_all_crafting_station_items_data() -> Array[ItemData]:
	crafting_station_items.reverse()
	return crafting_station_items
