extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var gun_componente: Node2D
@export var direction: Vector2
@export var speed: int = 100

func _ready() -> void:
	#hit_component_collision_shape.position = Vector2(0, 0)
	pass


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	#direction = GameInputEvents.movement_inut()
	
	#if direction == Vector2.UP:
		#animated_sprite_2d.play("walk_back")
	#elif direction == Vector2.DOWN:
		#animated_sprite_2d.play("walk_front")
	#elif direction == Vector2.RIGHT:
		#animated_sprite_2d.play("walk_right")
	#elif direction == Vector2.LEFT:
		#animated_sprite_2d.play("walk_left")
		
	#if direction != Vector2.ZERO:
		#player.player_direction = direction
		
	#player.velocity = direction * speed
	#player.move_and_slide()
	pass


func _on_next_transitions() -> void:
	#if player.current_tool != DataTypes.Tools.GunBlaster or !Input.is_action_pressed("hit"):
		#transition.emit("Idle")
		#return
	
	#if !animated_sprite_2d.is_playing():
		#transition.emit("Idle")
	
	#if  !Input.is_action_pressed("hit"):
		#transition.emit("Idle")
	
	pass


func _on_enter() -> void:
	#gun_componente.visible = true
	#gun_componente.process_mode = Node.PROCESS_MODE_INHERIT
	#
	#if player.player_direction == Vector2.UP:
		#animated_sprite_2d.play("shooting_back")
		#print("shoot")
	#elif player.player_direction == Vector2.DOWN:
		#animated_sprite_2d.play("shooting_front")
		#print("shoot")
	#elif player.player_direction == Vector2.LEFT:
		#animated_sprite_2d.play("shooting_left")
		#print("shoot")
	#elif player.player_direction == Vector2.RIGHT:
		#animated_sprite_2d.play("shooting_right")
		#print("shoot")
	#else:
		#animated_sprite_2d.play("shooting_front")
		#print("shoot")
	pass


func _on_exit() -> void:
	#gun_componente.visible = false
	#gun_componente.process_mode = Node.PROCESS_MODE_DISABLED
	#animated_sprite_2d.stop()
	pass
