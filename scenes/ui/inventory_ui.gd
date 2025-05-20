extends Control

@onready var grid_container: GridContainer = $PanelContainer/GridContainer
@onready var click_button: AudioStreamPlayer2D = $ClickButton


var dragged_slot: Control

func _ready() -> void:
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()


func _on_inventory_updated() -> void:
	clear_grid_container()
	
	for item in InventoryManager.inventory:
		var slot: Control = InventoryManager.inventory_slot_scene.instantiate()
		
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
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
	click_button.play(0.60)
	GameManager.open_close_inventory()


func _on_drag_start(slot_control: Control) -> void:
	dragged_slot = slot_control


func _on_drag_end() -> void:
	var target_slot: Control = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null


func get_slot_under_mouse() -> Control:
	var mouse_position: Vector2 = get_global_mouse_position()
	
	for slot in grid_container.get_children():
		var slot_rect: Rect2 = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
			
	return null


func get_slot_index(slot: Control) -> int:
	for i in range(grid_container.get_child_count()):
		if grid_container.get_child(i) == slot:
			return i
	return -1

func drop_slot(slot1: Control, slot2: Control) -> void:
	var slot1_index: int = get_slot_index(slot1)
	var slot2_index: int = get_slot_index(slot2)
	
	if slot1_index == -1 or slot2_index == -1:
		print("invalid slot found")
		return
	else:
		if InventoryManager.swap_inventory_itens(slot1_index, slot2_index):
			_on_inventory_updated()
