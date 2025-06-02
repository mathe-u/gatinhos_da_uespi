class_name AttackComponent
extends Area2D

@export var curret_tool: DataTypes.Tools 
@export var damage: int = 1

signal in_range(body: Node2D)
signal out_range(body: Node2D)

func _on_body_entered(body: Node2D) -> void:
	in_range.emit(body)


func _on_body_exited(body: Node2D) -> void:
	out_range.emit(body)
