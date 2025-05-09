class_name ItemComponent
extends Sprite2D

@export var item_id: int
@export var item_name: String
@export var quantity: int = 1
@export var item_type: DataTypes.ItemType
@export var ingredients: Array[Ingredient]
@export var item_effect: DataTypes.Effect

var item: Dictionary = {}

func _ready() -> void:
	item = {
		"id": item_id,
		"name": item_name,
		"quantity": quantity,
		"type": item_type,
		"ingredients": ingredients,
		"effect": item_effect,
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
