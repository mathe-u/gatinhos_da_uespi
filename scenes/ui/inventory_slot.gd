extends Control

@onready var item_icon: TextureRect = $MarginContainer/PanelContainer/ItemIcon
@onready var item_quantity: Label = $MarginContainer/PanelContainer/ItemQuantity
@onready var item_name: Label = $DetailsPanel/ItemName
@onready var details_panel: PanelContainer = $DetailsPanel
@onready var actions_panel: PanelContainer = $ActionsPanel


var item


func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false


func _on_item_button_mouse_entered() -> void:
	if item:
		actions_panel.visible = false
		details_panel.visible = false


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
