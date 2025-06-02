class_name HealthComponent
extends Node

@export var max_health: int = 10
@export var health: int = 10
@export var invincibility_time: float = 1.0

var is_invincible: bool = false

signal died
signal health_changed
signal damaged(damage: int)
signal healed(heal: int)

func _ready() -> void:
	health = clamp(health, 0, max_health)
	health_changed.emit()


func take_damage(damage: int) -> void:
	health = clamp(health-damage, 0, max_health)
	health_changed.emit()
	damaged.emit(damage)
	if health == 0:
		died.emit()
	
	start_invincibility()


func start_invincibility() -> void:
	if invincibility_time > 0.0:
		is_invincible = true
	
		await get_tree().create_timer(invincibility_time).timeout
		is_invincible = false


func apply_heal(heal: int) -> void:
	health = clamp(health+heal, 0, max_health)
	health_changed.emit()
	healed.emit(heal)


func increase_health(new_health: int) -> void:
	max_health = max(max_health, new_health)
	health_changed.emit()


func is_alive() -> bool:
	return health > 0
