extends Control

@onready var item_icon: TextureRect = $MarginContainer/PanelContainer/ItemIcon
@onready var item_quantity: Label = $MarginContainer/PanelContainer/ItemQuantity
@onready var item_name: Label = $DetailsPanel/VBoxContainer/ItemName
@onready var item_type: Label = $DetailsPanel/VBoxContainer/ItemType
@onready var item_effect: Label = $DetailsPanel/VBoxContainer/ItemEffect
@onready var details_panel: PanelContainer = $DetailsPanel
@onready var actions_panel: PanelContainer = $ActionsPanel

var item: Dictionary


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
	item = new_item
	item_icon.texture = new_item["texture"]
	item_quantity.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = item["type"]
	item_effect.text = item["effect"]
	
	




func _on_drop_button_pressed() -> void:
	if item:
		InventoryManager.drop_item(item)
		InventoryManager.remove_item(item["id"])
		actions_panel.visible = false
