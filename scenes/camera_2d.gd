extends Camera2D

@export var desired_offset: Vector2
@export var min_offset: int = -200
@export var max_offset: int = 200

func _process(_delta: float) -> void:
	#print("camera: %s, player: %s, mouse: %s" % [position, get_parent().position, get_global_mouse_position()])
	
	desired_offset = (get_global_mouse_position() - position) * 0.5
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y, min_offset/2.0, max_offset/2.0)
	
	global_position = get_parent().get_node("Player").global_position + desired_offset
