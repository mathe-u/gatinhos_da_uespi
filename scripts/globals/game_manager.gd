extends Node

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")
var players: Dictionary = {}
var player_name: String = ""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

func start_game() -> void:
	assert(multiplayer.is_server())
	ServerManager.load_game_scene.rpc()
	
	var main_scene: Node = get_tree().root.get_node("MainScene")
	var player_scene: PackedScene = load("res://scenes/characters/generic_player/generic_player.tscn")
	
	var spawn_points: Dictionary = {}
	spawn_points[1] = 0
	var spawn_point_index: int = 1
	for player in GameManager.players:
		spawn_points[player] = spawn_point_index
		spawn_point_index += 1
	
	for player_id: int in spawn_points:
		var spawn_point: Node = main_scene.get_node("GameRoot/SpawnPoint/" + str(spawn_points[player_id]))
		var spawn_position: Vector2 = spawn_point.position
		var player: Node = player_scene.instantiate()
		player.synced_position = spawn_position
		player.name = str(player_id)
		player.set_player_name(player_name if player_id == multiplayer.get_unique_id() else players[player_id])
		main_scene.get_node("GameRoot/Players").add_child(player)
		print(player_id)
	#ServerManager.register_host_player("PlayerHost_1", multiplayer.get_unique_id())
	#ServerManager.send_player_information("player1", multiplayer.get_unique_id())
	#SceneManager.switch_multiplayer_scene("res://scenes/test/test_scene_multiplayer.tscn")
	#SceneManager.load_main_scene_container()
	#await SceneManager.load_level("Level1")
	

func multiplayer_game() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/multiplayer_menu_screen.tscn")

func save_game() -> void:
	print("salvo")

func exit_game() -> void:
	get_tree().quit()

func show_game_menu_screen() -> void:
	var existing_menu = get_tree().root.find_child("GameMenuScreen", true)
	if existing_menu:
		return
	
	var game_menu_screen_instance = game_menu_screen.instantiate()
	get_tree().root.add_child(game_menu_screen_instance)

func clear_player_data():
	players.clear()
