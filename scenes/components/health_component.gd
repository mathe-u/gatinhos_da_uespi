class_name HealthComponent
extends Node

@export var max_health: int = 10
@export var health: int = 10

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


func apply_heal(heal: int) -> void:
	health = clamp(health+heal, 0, max_health)
	health_changed.emit()
	healed.emit(heal)


func increase_health(new_health: int) -> void:
	max_health = max(max_health, new_health)
	health_changed.emit()


func is_alive() -> bool:
	return health > 0
