extends Area2D

var speed: float = 850.0

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if is_multiplayer_authority():
		if body is Player:
			body.take_damage.rpc_id(body.get_multiplayer_authority(), 40)
		
		body.take_damage.rpc_id(body.get_multiplayer_authority(), 40)
		remove_bullet.rpc()
	
	#print(body.name)


@rpc("call_local")
func remove_bullet():
	queue_free()
