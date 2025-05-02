extends Node

@export var motion = Vector2():
	set(value):
		# This will be sent by players, make sure values are within limits.
		motion = clamp(value, Vector2(-1, -1), Vector2(1, 1))

func update():
	var m = Vector2()
	if Input.is_action_pressed("mv_left"):
		m += Vector2(-1, 0)
	if Input.is_action_pressed("mv_right"):
		m += Vector2(1, 0)
	if Input.is_action_pressed("mv_up"):
		m += Vector2(0, -1)
	if Input.is_action_pressed("mv_down"):
		m += Vector2(0, 1)

	motion = m
