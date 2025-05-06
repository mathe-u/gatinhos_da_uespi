extends CharacterBody2D

const MOTION_SPEED: float = 90.0
const MAX_HEALTH: int = 100
const BULLET: PackedScene = preload("res://scenes/objects/Projectiles/projectile.tscn")
const SHOOT_COOLDOWN: float = 1.8
const SHOTGUN_PELLETS: int = 6
const SHOTGUN_SPREAD_DEGREES: float = 25.0

@export var synced_position: Vector2 = Vector2()
@export var stunned = false
@onready var shotgun_blast: AudioStreamPlayer2D = $Gun/Shotgun_blast

var player_direction: Vector2
var health = 100
var shoot_cooldown_time: float = 0.2
var _spread_radians = deg_to_rad(SHOTGUN_SPREAD_DEGREES)


func _enter_tree() -> void:
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	position = synced_position

func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		if shoot_cooldown_time > 0.0:
			shoot_cooldown_time -= _delta
		$Gun.look_at(get_global_mouse_position())
		
		if get_global_mouse_position().x < global_position.x:
			$Gun/Sprite2D.flip_v = true
			$Gun/Sprite2D/Marker2D.position = Vector2(34.0, 7.0)
		else:
			$Gun/Sprite2D.flip_v = false
			$Gun/Sprite2D/Marker2D.position = Vector2(34.0, -7.0)
		
		if Input.is_action_pressed("hit") and shoot_cooldown_time <= 0.0:
			shoot_cooldown_time = SHOOT_COOLDOWN
			shoot.rpc(multiplayer.get_unique_id())
		
		var m = Vector2()
		
		if Input.is_action_pressed("mv_left"):
			m += Vector2(-1, 0)
		if Input.is_action_pressed("mv_right"):
			m += Vector2(1, 0)
		if Input.is_action_pressed("mv_up"):
			m += Vector2(0, -1)
		if Input.is_action_pressed("mv_down"):
			m += Vector2(0, 1)
		velocity = m * MOTION_SPEED
		move_and_slide()

func on_tool_selected(tool: DataTypes.Tools) -> void:
	print("Tool: ", tool)

func set_player_name(player_name: String) -> void:
	get_node("PlayerNameLabel").text = player_name
	#player_name_label.text = ""


@rpc("call_local")
func shoot(shooter_id) -> void:
	var spawn_transform: Transform2D = $Gun/Sprite2D/Marker2D.global_transform
	var base_rotation: float = spawn_transform.get_rotation()
	var spawn_position: Vector2 = spawn_transform.origin
	
	
	#if !is_multiplayer_authority():
	shotgun_blast.play(0.13)
	
	for i in range(SHOTGUN_PELLETS):
		var bullet = BULLET.instantiate()
		bullet.set_multiplayer_authority(shooter_id)
		
		var spread_offset: float = randf_range(-_spread_radians / 2.0, _spread_radians / 2.0)
		var final_rotation: float = base_rotation + spread_offset
		
		bullet.global_position = spawn_position
		bullet.rotation = final_rotation
		get_parent().add_child(bullet)
		#bullet.transform = $Gun/Sprite2D/Marker2D.global_transform


@rpc("any_peer")
func take_damage(amount: int) -> void:
	health -= amount
	
	if health <= 0:
		#health = MAX_HEALTH
		queue_free()
		
	
	
