extends Area2D

@export var speed: float = 850.0
@export var damage: int = 5

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is GenericEnemy:
		body.health_component.take_damage(damage)
		remove_projectile()

func remove_projectile() -> void:
	queue_free()
