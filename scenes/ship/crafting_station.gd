class_name CraftingStation
extends StaticBody2D

@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var item_spawner_component: ItemSpawnerComponent = $ItemSpawnerComponent
@onready var craft_timer: Timer = $CraftTimer

var crafting_station_menu_scene: PackedScene = preload("res://scenes/ui/crafting_station_ui.tscn")
var in_range: bool = false

var _current_craft_item_data: ItemData = null
var _craft_units_remaining: int = 0
var _is_crafting: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	
	craft_timer.timeout.connect(_on_craft_timer_timeout)


func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true


func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false


func init_craft(item_to_craft: ItemData, units_of_recipe: int) -> void:
	if _is_crafting:
		# TODO: Implementar uma fila de espera ou rejeitar se já estiver fabricando.
		# Por simplicidade, vamos rejeitar novas fabricações se uma já estiver em progresso.
		print("CraftingStation: Já está fabricando. Aguarde a conclusão do lote atual.")
		# Aqui você poderia adicionar lógica para enfileirar pedidos de fabricação.
		return
	
	#print("crie:")
	#print("	item: %s" % item_to_craft.display_name)
	#print("	quantidade escolhida: %s" % units_of_recipe)
	#print("	quantidade por item: %s" % item_to_craft.items_produced)
	#print("	quantidade total na empilhavel: %s" % [item_to_craft.items_produced * units_of_recipe])
	#print("	tempo para criar: %f" % item_to_craft.time_to_craft)
	#print("	tempo total na fila: %f" % [item_to_craft.time_to_craft * units_of_recipe])
	
	_current_craft_item_data = item_to_craft
	_craft_units_remaining = units_of_recipe
	_is_crafting = true
	
	_start_next_craft_in_queue()
	# criar uma instacia do item ItemComponent
	# definir as propriedades do item
	
	# inicia um timer para criar o item item_to_craft.time_to_craft
	# para cada item 
	
	# quando o tempo acabar
	
	# iniciar item_spawner_component
	# spawn_items(quantity: int, item_to_spawn_override: PackedScene = null, target_global_position: Variant = null)


func _start_next_craft_in_queue() -> void:
	if _craft_units_remaining > 0:
		craft_timer.wait_time = _current_craft_item_data.time_to_craft
		craft_timer.start()
	else:
		_is_crafting = false
		_current_craft_item_data = null
		_craft_units_remaining = 0
		craft_timer.stop()
		# Opcional: Atualizar UI com progresso para esta unidade específica


func _on_craft_timer_timeout() -> void:
	var scene_to_spawn: PackedScene = _current_craft_item_data.item_scene
	var quantity_to_spawn_this_cycle: int = _current_craft_item_data.items_produced
	var item_to_spawn: ItemComponent = scene_to_spawn.instantiate()
	
	item_to_spawn.set_item_data(_current_craft_item_data.id, quantity_to_spawn_this_cycle)
	item_spawner_component.spawn_items2(item_to_spawn, global_position)
	_craft_units_remaining -= 1
	
	_start_next_craft_in_queue()


func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("interact"):
			if !_is_crafting:
				interactable_label_component.hide()
				var crafting_station_ui: PanelContainer = crafting_station_menu_scene.instantiate()
				crafting_station_ui.setup_crafting_station(self)
				get_tree().root.get_node("MainScene/GameScreen/MarginContainer").add_child(crafting_station_ui)
