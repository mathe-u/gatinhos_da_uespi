extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if player.current_tool == DataTypes.Tools.Torch:
		if player.player_direction == Vector2.UP:
			animated_sprite_2d.play("idle_torch_back")
		elif player.player_direction == Vector2.DOWN:
			animated_sprite_2d.play("idle_torch_front")
		elif player.player_direction == Vector2.RIGHT:
			animated_sprite_2d.play("idle_torch_right")
		elif player.player_direction == Vector2.LEFT:
			animated_sprite_2d.play("idle_torch_left")
		else:
			animated_sprite_2d.play("idle_torch_front")
	else:
		if player.player_direction == Vector2.UP:
			animated_sprite_2d.play("idle_back")
		elif player.player_direction == Vector2.DOWN:
			animated_sprite_2d.play("idle_front")
		elif player.player_direction == Vector2.RIGHT:
			animated_sprite_2d.play("idle_right")
		elif player.player_direction == Vector2.LEFT:
			animated_sprite_2d.play("idle_left")
		else:
			animated_sprite_2d.play("idle_front")


func _on_next_transitions() -> void:
	GameInputEvents.movement_inut()
	
	if GameInputEvents.is_movement_input():
		transition.emit("Walk")
	
	if player.current_tool == DataTypes.Tools.AxeWood and player.use_tool:
		transition.emit("Chopping")
	
	#if player.current_tool == DataTypes.Tools.GunBlaster && GameInputEvents.use_tool():
		#transition.emit("Shooting")
	
	if player.current_tool == DataTypes.Tools.TillGround:
		transition.emit("Tilling")
	
	if player.current_tool == DataTypes.Tools.WaterCrops:
		transition.emit("Watering")

func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
