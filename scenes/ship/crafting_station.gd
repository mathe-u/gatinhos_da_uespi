class_name CraftigStation
extends StaticBody2D

var crafting_station_menu_scene: PackedScene = preload("res://scenes/ui/crafting_station_ui.tscn")

@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var item_spawner_component: ItemSpawnerComponent = $ItemSpawnerComponent

var in_range: bool = false


func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()


func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true


func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false


func init_craft(item_to_craft: ItemData, units: int) -> void:
	print("crie:")
	print("	item: %s" % item_to_craft.display_name)
	print("	quantidade escolhida: %s" % units)
	print("	quantidade por item: %s" % item_to_craft.items_produced)
	print("	quantidade total na empilhavel: %s" % [item_to_craft.items_produced * units])
	print("	tempo para criar: %f" % item_to_craft.time_to_craft)
	print("	tempo total na fila: %f" % [item_to_craft.time_to_craft * units])


func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("hit"):
			interactable_label_component.hide()
			var crafting_station_ui: PanelContainer = crafting_station_menu_scene.instantiate()
			crafting_station_ui.setup_crafting_station(self)
			get_tree().root.get_node("MainScene/GameScreen/MarginContainer").add_child(crafting_station_ui)
