extends PanelContainer


func _on_close_button_pressed() -> void:
	queue_free()


func _on_check_button_toggled(toggled_on: bool) -> void:
	print("ligado ", toggled_on)
