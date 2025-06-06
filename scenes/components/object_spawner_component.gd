# object_spawner.gd (Versão 2 - Gerenciador de População)
class_name ObjectSpawner
extends Node2D

## As cenas dos objetos que você quer spawnar (inimigos, árvores, pedras, etc.).
@export var objects_to_spawn: Array[PackedScene]
@export var tilemap_layer: TileMapLayer
@export var population_target: int = 50
@export var respawn_delay: float = 5.0
@export var spawnable_custom_data_layer: String = "can_spawn"

@onready var respawn_timer: Timer = $RespawnTimer


var _valid_spawn_cells: Array[Vector2i] = []
var _occupied_cells: Array[Vector2i] = []


func _ready() -> void:
	# Validação inicial
	if not tilemap_layer:
		push_error("ObjectSpawner: A variável 'tilemap_layer' não foi definida!")
		return
	if objects_to_spawn.is_empty():
		push_warning("ObjectSpawner: O array 'objects_to_spawn' está vazio.")
		return
	if not respawn_timer:
		push_error("ObjectSpawner: Nó Timer não encontrado! Adicione um nó Timer como filho e nomeie-o 'RespawnTimer'.")
		return
	
	respawn_timer.wait_time = respawn_delay
	respawn_timer.one_shot = true
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)
	
	initial_spawn()


func initial_spawn() -> void:
	_valid_spawn_cells = get_valid_spawn_cells()
	
	if _valid_spawn_cells.is_empty():
		push_warning("ObjectSpawner: Nenhuma célula válida para spawn foi encontrada.")
		return
	
	_valid_spawn_cells.shuffle()
	
	var amount_to_spawn = min(population_target, _valid_spawn_cells.size())
	
	for i in range(amount_to_spawn):
		var cell = _valid_spawn_cells[i]
		spawn_single_object(cell)


func spawn_single_object(cell: Vector2i) -> void:
	var random_scene: PackedScene = objects_to_spawn.pick_random()
	if not random_scene:
		return

	var new_instance = random_scene.instantiate()
	
	# Conecta o sinal 'destroyed' do objeto à nossa função de reposição.
	# Isso é CRUCIAL para o sistema de reposição funcionar.
	new_instance.destroyed.connect(_on_object_destroyed.bind(cell))
	
	var spawn_position = tilemap_layer.map_to_local(cell)
	new_instance.global_position = spawn_position
	
	get_parent().call_deferred("add_child", new_instance)
	
	# Adiciona a célula à lista de ocupadas
	_occupied_cells.append(cell)


# Chamado quando um objeto emite o sinal "destroyed"
func _on_object_destroyed(cell: Vector2i) -> void:
	# Libera a célula que estava ocupada
	var index = _occupied_cells.find(cell)
	if index != -1:
		_occupied_cells.remove_at(index)
	
	# Se o timer não estiver rodando, inicia a contagem para reposição
	if respawn_timer.is_stopped():
		respawn_timer.start()

# Chamado quando o timer de reposição termina
func _on_respawn_timer_timeout() -> void:
	# Verifica se a população atual é menor que o alvo
	if _occupied_cells.size() >= population_target:
		return # Já temos objetos suficientes, não faz nada

	# Encontra uma célula vazia
	var available_cells = []
	for cell in _valid_spawn_cells:
		if not cell in _occupied_cells:
			available_cells.append(cell)
	
	if available_cells.is_empty():
		# Não há mais lugares para spawnar, então não faz nada.
		return

	# Spawna um novo objeto em uma das células disponíveis
	available_cells.shuffle()
	spawn_single_object(available_cells[0])
	
	# Se ainda houver espaço, reinicia o timer para o próximo respawn
	if _occupied_cells.size() < population_target:
		respawn_timer.start()


## Retorna um array com todas as coordenadas de células que podem receber um objeto.
func get_valid_spawn_cells() -> Array[Vector2i]:
	var valid_cells: Array[Vector2i] = []
	var used_cells = tilemap_layer.get_used_cells()
	
	for cell in used_cells:
		var tile_data: TileData = tilemap_layer.get_cell_tile_data(cell)
		if not tile_data:
			continue
		
		var can_spawn_here = tile_data.get_custom_data(spawnable_custom_data_layer)
		if can_spawn_here == true:
			valid_cells.append(cell)
			
	return valid_cells
