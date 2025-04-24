extends Node2D

@export var player_scene: PackedScene

func _ready() -> void:
	
	var index: int = 0
	for i in GameManager.players:
		var current_player: Node2D = player_scene.instantiate()
		current_player.name = str(GameManager.players[i].id)
		add_child(current_player)
		
		for spawn: Node2D in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				current_player.global_position = spawn.global_position
		
		index += 1
