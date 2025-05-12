class_name CollectableComponent
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var item: ItemData = get_parent().get_item_data()
		var units: int = get_parent().quantity
		InventoryManager.add_item(item, units)
		get_parent().queue_free()
