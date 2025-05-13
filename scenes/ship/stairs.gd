extends Area2D

@export var layer_main_deck: TileMapLayer
@export var layer_storage_deck: TileMapLayer
@export var reverse_switch: bool = false

var enter_point: Vector2

const MINIMUM_DISTANCE: float = 4.0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		enter_point = global_position
		_switch_layer()
		


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		var leave_on_same_point: float = enter_point.distance_to(body.global_position) < MINIMUM_DISTANCE
		
		if leave_on_same_point and not reverse_switch:
			_switch_layer()


func _switch_layer() -> void:
	layer_main_deck.set_active(not layer_main_deck.enabled)
	layer_storage_deck.set_active(not layer_storage_deck.enabled)
