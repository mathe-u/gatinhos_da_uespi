extends Control

@onready var grid_container: GridContainer = $PanelContainer/GridContainer


func _ready() -> void:
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()


func _on_inventory_updated() -> void:
	clear_grid_container()
	
	for item in InventoryManager.inventory2:
		var slot: Control = InventoryManager.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		if item:
			slot.set_item(item)
		else:
			slot.set_empty()


func clear_grid_container() -> void:
	while grid_container.get_child_count() > 0:
		var child: Node = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()


func _on_close_inventory_pressed() -> void:
	GameManager.open_close_inventory()
