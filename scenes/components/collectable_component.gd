class_name CollectableComponent
extends Area2D

@export var collectable_name: String
@export var collectable_type: String
@export var collectable_texture: Texture2D
@export var collectable_effect: String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var item: Dictionary = {
			"name": collectable_name,
			"quantity": 1,
			"type": collectable_type,
			"texture": collectable_texture,
			"effect": collectable_effect,
		}
		InventoryManager.add_collectable(collectable_name)
		InventoryManager.add_item(item)
		get_parent().queue_free()
