extends Node

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")
var players: Dictionary[int, Dictionary] = {}
var player_name: String = ""

var ship_events: int = 0

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("game_menu"):
		#show_game_menu_screen()


func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/loading_screen.tscn")
	
	#SceneManager.load_main_scene_container()
	#
	#var node: Node = get_tree().root.get_node("GameMenuScreen")
	#if node != null:
		#node.queue_free()
		#
	#await SceneManager.load_level("Level1")


func multiplayer_game() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/multiplayer_menu_screen.tscn")


func save_game() -> void:
	print("salvo")


func exit_game() -> void:
	get_tree().quit()


#func show_game_menu_screen() -> void:
	#var existing_menu = get_tree().root.find_child("GameMenuScreen", true)
	#if existing_menu:
		#return
	#
	#var game_menu_screen_instance = game_menu_screen.instantiate()
	#get_tree().root.add_child(game_menu_screen_instance)


func clear_player_data():
	players.clear()


func game_event(event: DataTypes.EventUnlock) -> void:
	if event == DataTypes.EventUnlock.BrokenBridge:
		var bridge_tilemap_layer: TileMapLayer = get_tree().root.get_node("MainScene/GameRoot/LevelRoot/Level1/GameTileMap/Grass")
		var tileset_source_id: int = 9
		var repaired_brigde_top_atlas_coord: Vector2i = Vector2i(1, 0)
		var repaired_brigde_down_atlas_coord: Vector2i = Vector2i(0, 0)
		var coords_top_broken_bridge_cells: Array[Vector2i] = [
			Vector2i(90, 35),
			Vector2i(91, 35),
			Vector2i(92, 35),
			Vector2i(93, 35),
		]
		var coords_down_broken_bridge_cells: Array[Vector2i] = [
			Vector2i(90, 36),
			Vector2i(91, 36),
			Vector2i(92, 36),
			Vector2i(93, 36),
		]
		#var tilemap_layer_index: int = 0
		
		for coord_cell: Vector2i in coords_top_broken_bridge_cells:
			bridge_tilemap_layer.set_cell(
				coord_cell,
				tileset_source_id,
				repaired_brigde_top_atlas_coord,
			)
	
		for coord_cell: Vector2i in coords_down_broken_bridge_cells:
			bridge_tilemap_layer.set_cell(
				coord_cell,
				tileset_source_id,
				repaired_brigde_down_atlas_coord,
			)

	
	if event == DataTypes.EventUnlock.ShipFloor:
		ship_events += 1
	
	if event == DataTypes.EventUnlock.ShipEngine:
		ship_events += 1
	
	if event == DataTypes.EventUnlock.ShipHull:
		ship_events += 1
	
	if ship_events == 3:
		var main_scene: Node = get_tree().root.get_node("MainScene")
		var credits_scene: PackedScene = load("res://scenes/credits/game_credits.tscn")
		var credits_instance: CanvasLayer = credits_scene.instantiate()
		
		get_tree().root.add_child(credits_instance)
		main_scene.queue_free()
