extends Node

var main_scene_path: String = "res://scenes/main_scene.tscn"
var main_scene_root_path: String = "/root/MainScene"
var main_scene_level_root_path: String = "/root/MainScene/GameRoot/LevelRoot"
var multiplayer_menu_screen: String = "res://scenes/ui/multiplayer_menu_screen.tscn"
var multiplayer_scene_root_path: String = "/root/GameMenuScreen"

var level_scenes: Dictionary = {
	"Level1": "res://scenes/levels/level_1.tscn",
	"multiplayer_test": "res://scenes/test/test_scene_multiplayer.tscn",
}


func load_main_scene_container() -> void:
	if get_tree().root.has_node(main_scene_root_path):
		print("ja tem ", main_scene_root_path)
		return

	var node: Node = load(main_scene_path).instantiate()

	if node != null:
		get_tree().root.add_child(node)


func load_level(level: String) -> void:
	var scene_path: String = level_scenes.get(level)
	
	if scene_path == null:
		return
	
	var level_scene: Node = load(scene_path).instantiate()
	var level_root: Node = get_node(main_scene_level_root_path)
	
	if level_root != null:
		var nodes = level_root.get_children()
		
		if nodes != null:
			for node: Node in nodes:
				node.queue_free()
		
		await get_tree().process_frame
		level_root.add_child(level_scene)


func switch_to_main_game_scene() -> void:
	var current_scene = get_tree().root.get_node(main_scene_root_path)
	if current_scene:
		current_scene.queue_free()

	# Wait a frame for pending free operations to complete
	await get_tree().process_frame

	# Load and add the new main scene container
	var new_main_scene: Node = load(main_scene_path).instantiate()

	if new_main_scene != null:
		get_tree().root.add_child(new_main_scene)
		# Optional: Set the new scene as the current_scene if needed for input handling, etc.
		# get_tree().current_scene = new_main_scene
		# Wait another frame to ensure the newly added nodes (like GameRoot, LevelRoot)
		# are properly in the tree and accessible via get_node() calls later (e.g., in load_level).
		await get_tree().process_frame
	else:
		print("Error: Could not instantiate main scene from path ", main_scene_path)


func switch_to_multiplayer_main_game_scene() -> void:
	var main_scene: Node
	
	if !ServerManager.multiplayer.is_server():
		main_scene = get_tree().root.get_node("MultiplayerMenuScreen")
	else:
		main_scene = get_tree().root.get_node("GameMenuScreen")
	
	if main_scene:
		main_scene.queue_free()
	
	await get_tree().process_frame
	
	var multiplayer_test_scene = load("res://scenes/test/test_scene_multiplayer.tscn").instantiate()
	
	if multiplayer_test_scene:
		get_tree().root.add_child(multiplayer_test_scene)
		get_tree().current_scene = multiplayer_test_scene


func switch_to_multiplayer_menu_scene() -> void:
	get_tree().change_scene_to_file(multiplayer_menu_screen)


func switch_multiplayer_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
