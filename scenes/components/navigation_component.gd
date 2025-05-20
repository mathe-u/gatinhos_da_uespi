extends Node2D

@export var entity: CharacterBody2D

var direction: Vector2

func get_direction(target: Node2D) -> Vector2:
	return global_position.direction_to(target.global_position)
