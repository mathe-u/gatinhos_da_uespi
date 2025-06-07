
extends Node2D

@export var event_unlock: DataTypes.EventUnlock = DataTypes.EventUnlock.None
@export var item_id: StringName
@export var required_items: int = 1
@export var icon: Texture2D


@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var panel_container: PanelContainer = $PanelContainer
@onready var texture_rect: TextureRect = $PanelContainer/VBoxContainer/TextureRect
@onready var label: Label = $PanelContainer/VBoxContainer/Label
@onready var alert_icon: TextureRect = $AlertIcon
@onready var interactable_label: TextureRect = $InteractableLabel



var in_range: bool = false
var collected_items: int = 0

func _ready() -> void:
	alert_icon.show()
	label.text = "%s/%s" % [collected_items ,required_items]
	texture_rect.texture = icon
	panel_container.hide()
	interactable_label.hide()
	
	interactable_component.interactable_activated.connect(_on_interactable_activated)
	interactable_component.interactable_deactivated.connect(_on_interactable_deactivated)


func _on_interactable_activated() -> void:
	alert_icon.hide()
	panel_container.show()
	interactable_label.show()
	in_range = true


func _on_interactable_deactivated() -> void:
	alert_icon.show()
	panel_container.hide()
	interactable_label.hide()
	in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("interact"):
			if InventoryManager.get_item_quantity(item_id) > 0 and collected_items < required_items:
				InventoryManager.remove_item(item_id)
				collected_items += 1
				label.text = "%s/%s" % [collected_items ,required_items]
				
				if collected_items == required_items:
					GameManager.game_event(event_unlock)
					queue_free()
			
