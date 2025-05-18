@tool # Permite que o script execute no editor (ex: para desenhar os raios)
class_name ItemSpawnerComponent
extends Node2D

@export var item_scene: PackedScene

## O raio máximo a partir do centro onde os itens podem aparecer.
@export var spawn_radius_max: float = 100.0 :
	set(value):
		spawn_radius_max = value
		if Engine.is_editor_hint():
			queue_redraw()

## O raio mínimo a partir do centro. Itens não aparecerão mais perto que isso.
@export var spawn_radius_min: float = 20.0 :
	set(value):
		spawn_radius_min = value
		if Engine.is_editor_hint():
			queue_redraw()

@export var placement_attempts: int = 10


@export var check_for_overlaps: bool = true
@export var overlap_collision_mask: int = 1 # Verifica contra a camada 1 por padrão
@export var items_parent_node_path: NodePath

var _items_parent: Node # Cache do nó pai dos itens


func _ready():
	if spawn_radius_min < 0:
		spawn_radius_min = 0.0
	if spawn_radius_max <= spawn_radius_min:
		spawn_radius_max = spawn_radius_min + 10.0

	if items_parent_node_path and not items_parent_node_path.is_empty():
		if has_node(items_parent_node_path):
			_items_parent = get_node(items_parent_node_path)
		else:
			printerr("ItemSpawner2D: Nó pai dos itens definido ('%s') não encontrado." % items_parent_node_path)
			_items_parent = get_parent() # Usa o pai do spawner como fallback
	else:
		_items_parent = get_parent()

	if Engine.is_editor_hint():
		queue_redraw()


func _draw():
	# Desenha os círculos de raio no editor para visualização
	if Engine.is_editor_hint():
		draw_arc(Vector2.ZERO, spawn_radius_max, 0, TAU, 64, Color.GREEN, 2.0, true)
		draw_arc(Vector2.ZERO, spawn_radius_min, 0, TAU, 32, Color.RED, 2.0, true)


## Gera uma quantidade específica de itens.
## @param quantity: O número de itens a gerar.
## @param item_to_spawn_override: Opcional. Uma PackedScene para substituir a item_scene padrão.
## @param target_global_position: Opcional. Se fornecido, o spawner usará esta posição como centro.
##                               Caso contrário, usa sua própria global_position.
## @return Um Array com as instâncias dos itens gerados.
func spawn_items(quantity: int, item_to_spawn_override: PackedScene = null, target_global_position: Variant = null) -> Array[Node2D]:
	var spawned_items: Array[Node2D] = []
	var item_definition = item_to_spawn_override if item_to_spawn_override else item_scene

	if not item_definition:
		printerr("ItemSpawner2D: Nenhuma 'item_scene' definida para instanciar.")
		return spawned_items
	
	
	var center_position = global_position
	# da pra remover essa verificacao de tipo
	if target_global_position != null and typeof(target_global_position) == TYPE_VECTOR2:
		center_position = target_global_position as Vector2
	
	#da pra remover
	var parent_for_items = _items_parent
	if not is_instance_valid(parent_for_items):
		parent_for_items = get_parent()
		if not is_instance_valid(parent_for_items):
			printerr("ItemSpawner2D: Spawner não tem pai e 'items_parent_node_path' não é válido. Não é possível instanciar itens.")
			return spawned_items

	for i in range(quantity):
		var new_item_instance: Node2D = null
		var spawn_pos_found = false
		var final_spawn_position_global: Vector2

		for attempt in range(placement_attempts):
			# 1. Calcular deslocamento aleatório
			var random_angle = randf_range(0, TAU) # TAU = 2 * PI
			var random_radius = randf_range(spawn_radius_min, spawn_radius_max)
			
			# Garante que o raio seja positivo se min_radius for 0 e max_radius for pequeno
			if spawn_radius_min == 0.0 and random_radius == 0.0 and spawn_radius_max > 0.0:
				random_radius = randf_range(0.001, spawn_radius_max) # Evita divisão por zero ou vetor zero se normalizar
			
			var offset = Vector2(random_radius, 0).rotated(random_angle)
			var proposed_spawn_position_global = center_position + offset

			# 2. (Opcional) Verificação de Colisão/Sobreposição
			if check_for_overlaps:
				# Esta é uma verificação simplificada no ponto central do spawn.
				# Para maior precisão, use PhysicsDirectSpaceState2D.intersect_shape
				# com a forma de colisão do item.
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsPointQueryParameters2D.new()
				query.position = proposed_spawn_position_global
				query.collide_with_areas = true # Ajuste conforme necessário
				query.collide_with_bodies = true
				query.collision_mask = overlap_collision_mask 
				# query.exclude = [self] # Se o spawner tiver um corpo/área de colisão

				var results = space_state.intersect_point(query)
				if results.is_empty():
					spawn_pos_found = true
					final_spawn_position_global = proposed_spawn_position_global
					break
				# else, tenta outra posição
			else:
				spawn_pos_found = true
				final_spawn_position_global = proposed_spawn_position_global
				break

		if spawn_pos_found:
			new_item_instance = item_definition.instantiate()
			
			if not is_instance_valid(new_item_instance):
				printerr("ItemSpawner2D: Falha ao instanciar item ou o item não é Node2D.")
				continue

			parent_for_items.add_child(new_item_instance)
			new_item_instance.global_position = final_spawn_position_global
			spawned_items.append(new_item_instance)
		else:
			printerr("ItemSpawner2D: Não foi possível encontrar um local livre para o item %s após %d tentativas." % [item_definition.resource_path, placement_attempts])
			
	return spawned_items


func spawn_items2(item_to_spawn: Node2D, target_position: Vector2) -> void:
	var main_scene: Node2D = get_tree().root.get_node("MainScene/GameRoot/LevelRoot/Level1")
	var drop_position: Vector2 = _calculate_drop_position(target_position)
	
	item_to_spawn.global_position = drop_position
	
	if main_scene:
		main_scene.add_child(item_to_spawn)


func _calculate_drop_position(target_position: Vector2) -> Vector2:
	var random_angle: float = randf_range(0, TAU)
	var random_distance: float = randf_range(spawn_radius_min, spawn_radius_max)
	var offset: Vector2 = Vector2(random_distance, 0).rotated(random_angle)
	return target_position + offset
