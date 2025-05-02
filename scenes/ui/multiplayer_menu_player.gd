extends CanvasLayer

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test/test_scene_multiplayer_menu.tscn")


func _on_start_pressed() -> void:
	print("game_start")
	ServerManager.start_game_server()
