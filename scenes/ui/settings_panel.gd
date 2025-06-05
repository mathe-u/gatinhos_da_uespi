extends PanelContainer

@onready var click_button: AudioStreamPlayer2D = $ClickButton


func _on_close_button_pressed() -> void:
	click_button.play(0.60)
	SceneManager.open_close_settings_panel()
	#queue_free()


func _on_check_button_toggled(toggled_on: bool) -> void:
	var game_music: AudioStreamPlayer2D = get_tree().root.get_node("MainScene/GameRoot/LevelRoot/Level1/OnTheFarmMusic")
	game_music.playing = toggled_on
	print("ligado ", toggled_on)


func _on_main_menu_button_pressed() -> void:
	SceneManager.load_main_menu()
