extends Node2D

@onready var save_game_button: Button = $GameMenuScreenForeground/MarginContainer/VBoxContainer/SaveGameButton
@onready var start_game_button: Button = $GameMenuScreenForeground/MarginContainer/VBoxContainer/StartGameButton


func _ready() -> void:
	save_game_button.disabled = false
	start_game_button.grab_focus()
	#save_game_button.focus_mode = Control.FOCUS_ALL if SaveGameManager.allow_save_game else Control.FOCUS_NONE


func _on_start_game_button_pressed() -> void:
	SceneManager.set_next_scene("res://scenes/main_scene.tscn")
	SceneManager.set_current_scene(self)
	GameManager.start_game()


func _on_multiplayer_button_pressed() -> void:
	GameManager.multiplayer_game()


func _on_save_game_button_pressed() -> void:
	GameManager.save_game()


func _on_exit_game_button_pressed() -> void:
	GameManager.exit_game()
