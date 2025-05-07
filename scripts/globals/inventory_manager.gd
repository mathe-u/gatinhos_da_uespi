extends Node

@onready var inventory_slot_scene: PackedScene = preload("res://scenes/ui/inventory_slot.tscn")

var inventory: Dictionary = Dictionary()
var inventory2: Array = []
var slots: int = 20

signal inventory_changed
signal inventory_updated

const MIN_DROP_AWAY_RADIUS: float = 35.0
const MAX_DROP_SCATTER_RADIUS: float = 70.0

func _ready() -> void:
	inventory2.resize(slots)


func add_item(item: Dictionary) -> bool:
	for i in range(inventory2.size()):
		if inventory2[i] != null and inventory2[i]["id"] == item["id"]:
			inventory2[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory2[i] == null:
			inventory2[i] = item
			inventory_updated.emit()
			return true
	return false


func remove_item(item_id) -> void:
	for i in range(inventory2.size()):
		if inventory2[i] != null and inventory2[i]["id"] == item_id:
			inventory2[i]["quantity"] -= 1
			if inventory2[i]["quantity"] <= 0:
				inventory2[i] = null
			inventory_updated.emit()
			break


func increase_space() -> void:
	pass


func _calculate_drop_position(player_global_position: Vector2) -> Vector2:
	var random_angle: float = randf() * TAU
	var random_distance: float = randf_range(MIN_DROP_AWAY_RADIUS, MAX_DROP_SCATTER_RADIUS)
	var offset: Vector2 = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	return player_global_position + offset


func drop_item(item_data: Dictionary) -> void:
	var player_node: Node2D = get_tree().root.get_node_or_null("MainScene/GameRoot/Player")
	if not player_node:
		return
	
	var player_position: Vector2 = player_node.global_position
	var item_scene: PackedScene = load(item_data["scene_path"])
	var item_instance: Node = item_scene.instantiate()
	
	item_instance.set_item_data(item_data)
	
	var calculated_drop_position: Vector2 = _calculate_drop_position(player_position)
	item_instance.global_position = calculated_drop_position
	#drop_position = _calculate_drop_position(drop_position)
	#item_instance.global_position = drop_position
	var main_scene: Node = get_tree().root.get_node("MainScene/GameRoot/LevelRoot/Level1")
	if main_scene:
		main_scene.add_child(item_instance)


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
