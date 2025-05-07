extends Node

@onready var inventory_slot_scene: PackedScene = preload("res://scenes/ui/inventory_slot.tscn")

var inventory: Dictionary = Dictionary()
var inventory2: Array = []
var slots: int = 20

signal inventory_changed
signal inventory_updated

func _ready() -> void:
	inventory2.resize(slots)


func add_item(item: Dictionary) -> bool:
	print("search slot for ", item["name"])
	for i in range(inventory2.size()):
		if inventory2[i] != null and inventory2[i]["type"] == item["type"] and inventory2[i]["effect"] == item["effect"]:
			inventory2[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory2[i] == null:
			print(item["name"], " added")
			inventory2[i] = item
			inventory_updated.emit()
			return true
	return false


func remove_item() -> void:
	pass


func increase_space() -> void:
	pass


func add_collectable(collectable_name: String) -> void:
	inventory.get_or_add(collectable_name)
	
	if (inventory[collectable_name] == null):
		inventory[collectable_name] = 1
	else:
		inventory[collectable_name] += 1
	
	inventory_changed.emit()

func remove_collectable(collectable_name: String) -> void:
	if (inventory[collectable_name] == null):
		inventory[collectable_name] = 0
	else:
		if inventory[collectable_name] > 0:
			inventory[collectable_name] -= 1
	
	inventory_changed.emit()
