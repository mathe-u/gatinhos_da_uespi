extends Node

@onready var inventory_slot_scene: PackedScene = preload("res://scenes/ui/inventory_slot.tscn")

var inventory: Array[Dictionary] = []
var slots: int = 20

signal inventory_updated

const MIN_DROP_AWAY_RADIUS: float = 35.0
const MAX_DROP_SCATTER_RADIUS: float = 70.0

func _ready() -> void:
	inventory.resize(slots)


func add_item(item_to_add: ItemData, item_units: int) -> bool:
	for i: int in range(inventory.size()):
		if !inventory[i].is_empty():
			if inventory[i]["item"].id == item_to_add.id:
				if inventory[i]["units"] < 999:
					inventory[i]["item"] = item_to_add.duplicate()
					inventory[i]["units"] += item_units
					inventory_updated.emit()
					return true
				elif inventory[i]["units"] >= 999:
					for j: int in range(inventory.size()):
						if inventory[i] == null:
							inventory[i]["item"] = item_to_add.duplicate()
							inventory[i]["units"] += 1
							inventory_updated.emit()
							return true
	#
	for i: int in range(inventory.size()):
		if inventory[i].is_empty():
			inventory[i]["item"] = item_to_add.duplicate()
			inventory[i]["units"] = 1
			inventory_updated.emit()
			return true
	return false
	#return true


func remove_item(item_id) -> void:
	for i in range(inventory.size()):
		if inventory[i]["item"] != null and inventory[i]["item"].id == item_id:
			inventory[i]["units"] -= 1
			if inventory[i]["units"] <= 0:
				inventory[i] = {}
			inventory_updated.emit()
			break


func increase_space(extra_slots: int) -> void:
	inventory.resize(inventory.size() + extra_slots)
	inventory_updated.emit()


func _calculate_drop_position(player_global_position: Vector2) -> Vector2:
	var random_angle: float = randf() * TAU
	var random_distance: float = randf_range(MIN_DROP_AWAY_RADIUS, MAX_DROP_SCATTER_RADIUS)
	var offset: Vector2 = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	return player_global_position + offset


func drop_item(item_data: ItemData) -> void:
	var player_node: Node2D = SceneManager.get_player_node()
	if not player_node:
		return
	
	var player_position: Vector2 = player_node.global_position
	var item_scene: PackedScene = item_data.item_scene
	var item_instance: Node = item_scene.instantiate()
	
	item_instance.set_item_data(item_data.id)
	
	var calculated_drop_position: Vector2 = _calculate_drop_position(player_position)
	item_instance.global_position = calculated_drop_position
	var main_scene: Node = get_tree().root.get_node("MainScene/GameRoot/LevelRoot/Level1")
	if main_scene:
		main_scene.add_child(item_instance)


func swap_inventory_itens(index1: int, index2: int) -> bool:
	if index1 < 0 or index1 > inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
	
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	
	inventory_updated.emit()
	return true
