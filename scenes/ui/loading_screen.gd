extends CanvasLayer

@onready var loading_bar: TextureProgressBar = $PanelContainer/HBoxContainer/TextureProgressBar

var progress = []

func _ready() -> void:
	ResourceLoader.load_threaded_request(SceneManager.get_next_scene())


func _process(_delta: float) -> void:
	ResourceLoader.load_threaded_get_status(SceneManager.get_next_scene(), progress)
	loading_bar.value = progress[0] * 100
	
	if progress[0] == 1.0:
		var packed_next_scene: PackedScene = ResourceLoader.load_threaded_get(SceneManager.get_next_scene())
		var next_scene_instance: Node = packed_next_scene.instantiate()
		var current_scene: Node = SceneManager.get_current_scene()
		
		get_tree().root.add_child(next_scene_instance)
		
		if current_scene:
			current_scene.queue_free()
		
		queue_free()
	
