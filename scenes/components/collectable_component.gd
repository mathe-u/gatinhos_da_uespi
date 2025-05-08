class_name CollectableComponent
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var item: Dictionary = get_parent().get_item_data()
		InventoryManager.add_item(item)
		get_parent().queue_free()
