extends TextureProgressBar

var player_node: Player = SceneManager.get_player_node()

func _ready() -> void:
	print("barra de vida pronta ", player_node.current_tool)
	#.HealthComponent.health_changed.connect(update_health)
	update_health()

func update_health() -> void:
	pass
	#value = entity.HealthComponent.health
