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


func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("hit"):
			interactable_label_component.hide()
			var crafting_station_ui: PanelContainer = crafting_station_menu_scene.instantiate()
			crafting_station_ui.setup_crafting_dependencies(item_spawner_component, global_position)
			get_tree().root.get_node("MainScene/GameScreen/MarginContainer").add_child(crafting_station_ui)
