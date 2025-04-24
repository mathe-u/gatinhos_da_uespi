extends Node

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")
var players: Dictionary = {}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

func start_game() -> void:
	
	await SceneManager.switch_to_main_game_scene()
	await SceneManager.load_level("Level1")
	#SceneManager.load_main_scene_container()
	#SceneManager.load_level("Level1")
	SaveGameManager.allow_save_game = true

func multiplayer_game() -> void:
	#SceneManager.load_multiplayer_menu_scene()
	#print("laod scene multiplayer lobby from scenemanager")
	SceneManager.switch_to_multiplayer_menu_scene()
	print("Switched to Multiplayer Menu.")

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
