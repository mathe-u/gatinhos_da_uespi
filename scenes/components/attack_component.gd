class_name AttackComponent
extends Area2D

@export var curret_tool: DataTypes.Tools 
@export var damage: int = 1

signal damage_range

func _on_body_entered(_body: Node2D) -> void:
	damage_range.emit()
