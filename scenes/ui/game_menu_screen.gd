extends CanvasLayer

@onready var save_game_button: Button = $MarginContainer/VBoxContainer/SaveGameButton

func _ready() -> void:
	save_game_button.disabled = !SaveGameManager.allow_save_game
	save_game_button.focus_mode = Control.FOCUS_ALL if SaveGameManager.allow_save_game else Control.FOCUS_NONE


func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	queue_free()


func _on_save_game_button_pressed() -> void:
	GameManager.save_game()
	#SaveGameManager.save_game()


func _on_exit_game_button_pressed() -> void:
	GameManager.exit_game()


func _on_multiplayer_button_pressed() -> void:
	GameManager.multiplayer_game()
