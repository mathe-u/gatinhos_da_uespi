extends Node



func _ready() -> void:
	pass
	

func play_click_sfx() -> void:
	var click_sfx_scene: PackedScene = load("res://scenes/components/click_button_audio.tscn")
	var click_sfx_instance: AudioStreamPlayer2D = click_sfx_scene.instantiate()
	
	click_sfx_instance.autoplay = true
	click_sfx_instance.finished.connect(_on_audio_finished.bind(click_sfx_instance))
	get_parent().add_child(click_sfx_instance)
	
	


func play_main_menu_music() -> void:
	pass

func _on_audio_finished(audio_stream_player: AudioStreamPlayer2D) -> void:
	
	audio_stream_player.queue_free()
	
