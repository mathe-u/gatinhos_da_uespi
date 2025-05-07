extends Node

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")
var players: Dictionary[int, Dictionary] = {}
var player_name: String = ""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		open_close_inventory()

func open_close_inventory() -> void:
	var current_scene: Control = get_tree().root.get_node("MainScene/GameScreen/MarginContainer/InventoryUI")
	if current_scene:
		current_scene.visible = !current_scene.visible

func start_game() -> void:
	SceneManager.load_main_scene_container()
	
	var node: Node = get_tree().root.get_node("GameMenuScreen")
	if node != null:
		node.queue_free()
		
	await SceneManager.load_level("Level1")

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
