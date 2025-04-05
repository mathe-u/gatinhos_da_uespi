extends CharacterBody2D

var speed: float = 180.0

func _physics_process(_delta) -> void:
	# Pegar entrada do jogador
	var direction = Input.get_vector("mv_left", "mv_right", "mv_up", "mv_down")
	velocity = direction * speed
	
	# Mover o personagem
	move_and_slide()
