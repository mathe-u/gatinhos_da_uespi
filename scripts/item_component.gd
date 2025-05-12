class_name ItemComponent
extends Sprite2D

@export var item_id: StringName
@export var quantity: int = 1

var item_database: ItemsDataBase = ItemsDataBase.new()
var item: ItemData

func _ready() -> void:
	item = item_database.get_item_data(item_id)
	texture = item.icon

func set_item_data(id: StringName, item_quantity: int = 1) -> void:
	self.item_id = id
	self.quantity = item_quantity



func get_item_data() -> ItemData:
	return item
