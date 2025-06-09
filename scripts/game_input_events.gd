class_name GameInputEvents

static var direction: Vector2

static func movement_inut() -> Vector2:
	if Input.is_action_pressed("mv_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("mv_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("mv_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("mv_right"):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO
	
	return direction
	
static func is_movement_input() -> bool:
	return direction != Vector2.ZERO

#static func use_tool() -> bool:
	#var use_tool_value = Input.is_action_just_pressed("hit")
	#return use_tool_value
