extends Node

var main_scene_path: String = "res://scenes/main_scene.tscn"
var main_scene_root_path: String = "/root/MainScene"
var main_scene_level_root_path: String = "/root/MainScene/GameRoot/LevelRoot"
var multiplayer_menu_screen: String = "res://scenes/ui/multiplayer_menu_screen.tscn"
var multiplayer_scene_root_path: String = "/root/GameMenuScreen"

var level_scenes: Dictionary = {
	"Level1": "res://scenes/levels/level_1.tscn",
}

var _next_scene_path: String
var _current_scene: Node

func load_main_scene_container() -> void:
	if get_tree().root.has_node(main_scene_root_path):
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


func get_player_node() -> Player:
	var player_node: Node2D = get_tree().root.get_tree().get_first_node_in_group("player")
	return player_node

func set_next_scene(scene_path: String) -> void:
	_next_scene_path = scene_path

func get_next_scene() -> String:
	return _next_scene_path


func set_current_scene(node: Node) -> void:
	_current_scene = node

func get_current_scene() -> Node:
	return _current_scene


func open_close_inventory_ui() -> void:
	var inventory_ui_scene: Control = get_tree().root.get_node("MainScene/GameScreen/MarginContainer/InventoryUI")
	show_hide_inventory_menu_button()
	inventory_ui_scene.visible = !inventory_ui_scene.visible


func open_close_settings_panel() -> void:
	var settings_panel_scene: PanelContainer = get_tree().root.get_node("MainScene/GameScreen/MarginContainer/SettingsPanel")
	show_hide_inventory_menu_button()
	settings_panel_scene.visible = !settings_panel_scene.visible
	


func show_hide_inventory_menu_button() -> void:
	var inventory_button: Button = get_tree().root.get_node("MainScene/GameScreen/MarginContainer/DayNightPanel/VBoxContainer/MarginContainer2/InventoryButton")
	var settings_button: Button = get_tree().root.get_node("MainScene/GameScreen/MarginContainer/DayNightPanel/VBoxContainer/MarginContainer/SettingsButton")
	
	inventory_button.visible = !inventory_button.visible
	settings_button.visible = !settings_button.visible
	
