extends CanvasLayer


func _on_button_pressed() -> void:
	ServerManager.disconnect_peer()
	get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")
