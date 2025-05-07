extends Sprite2D

@export var item_name: String
@export var item_type: String
@export var item_id: String
@export var item_effect: String


var item: Dictionary = {}

func _ready() -> void:
	item = {
		"name": item_name,
		"quantity": 1,
		"type": item_type,
		"effect": item_effect,
		"id": item_id,
		"texture": texture,
		"scene_path": scene_file_path,
	}


func set_item_data(data: Dictionary) -> void:
	item_name = data["name"]
	item_type = data["type"]
	item_id = data["id"]
	texture = data["texture"]
	item_effect = data["effect"]


func get_item_data() -> Dictionary:
	return item
