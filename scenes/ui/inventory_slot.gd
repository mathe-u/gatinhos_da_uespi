extends Control

@onready var item_icon: TextureRect = $MarginContainer/PanelContainer/ItemIcon
@onready var item_quantity: Label = $MarginContainer/PanelContainer/ItemQuantity
@onready var item_name: Label = $DetailsPanel/VBoxContainer/ItemName
@onready var item_type: Label = $DetailsPanel/VBoxContainer/ItemType
@onready var item_effect: Label = $DetailsPanel/VBoxContainer/ItemEffect
@onready var details_panel: PanelContainer = $DetailsPanel
@onready var actions_panel: PanelContainer = $ActionsPanel
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer

var item: ItemData

signal drag_start(slot)
signal drag_end()

func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false


func _on_item_button_mouse_entered() -> void:
	if item:
		actions_panel.visible = false
		details_panel.visible = true


func _on_item_button_pressed() -> void:
	if item:
		actions_panel.visible = !actions_panel.visible


func set_empty() -> void:
	item_icon.texture = null
	item_quantity.text = ""


func set_item(new_item: Dictionary) -> void:
	item = new_item["item"]
	item_icon.texture = new_item["item"].icon
	item_quantity.text = str(new_item["units"])
	item_name.text = item.display_name
	item_type.text = str(item.type)
	item_effect.text = str(item.effect)


func _on_drop_button_pressed() -> void:
	if item:
		InventoryManager.drop_item(item)
		InventoryManager.remove_item(item.id)
		actions_panel.visible = false


func _on_use_button_pressed() -> void:
	actions_panel.visible = false
	
	if item and item["effect"]:
		var player_node: Player = SceneManager.get_player_node()
		if player_node:
			player_node.apply_item_effect(item)
			InventoryManager.remove_item(item["id"])
		else:
			print("player could not be found")


func _on_item_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				#panel_container.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				#panel_container.modulate = Color(1, 1, 1)
				drag_end.emit()
