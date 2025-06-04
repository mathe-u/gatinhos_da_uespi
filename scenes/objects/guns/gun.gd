extends Node2D

@export var projectile: PackedScene
@export var shoot_cooldown: float = 1.8
@export var gun_pellets: int = 3
@export var gun_spread_degree: float = 25.0

@onready var bullet_spawn: Marker2D = $GunSprite/BulletSpawn
@onready var gun_sprite: Sprite2D = $GunSprite
@onready var gun_blast: AudioStreamPlayer2D = $Shotgun_blast

var _shoot_cooldown_time: float = 0.2
var _spread_radians = deg_to_rad(gun_spread_degree)

func _ready() -> void:
	gun_sprite.flip_h = true

func _process(delta: float) -> void:
	if _shoot_cooldown_time > 0.0:
		_shoot_cooldown_time -= delta
	
	look_at(get_global_mouse_position())
	
	if get_global_mouse_position().x < global_position.x:
		gun_sprite.flip_v = true
		bullet_spawn.position = Vector2(40, 7)
	else:
		gun_sprite.flip_v = false
		bullet_spawn.position = Vector2(40, -7)
	
	if Input.is_action_pressed("hit") and _shoot_cooldown_time <= 0.0:
			_shoot_cooldown_time = shoot_cooldown
			shoot()


func shoot() -> void:
	#var spawn_transform: Transform2D = bullet_spawn.global_transform
	#var base_rotation: float = spawn_transform.get_rotation()
	#var spawn_position: Vector2 = spawn_transform.origin
	
	gun_blast.play(0.13)
	
	for i in range(gun_pellets):
		var bullet: Area2D = projectile.instantiate()
		var spread_offset: float = randf_range(-_spread_radians / 2.0, _spread_radians / 2.0)
		#var final_rotation: float = base_rotation + spread_offset
		
		#bullet.global_position = spawn_position
		#bullet.rotation = final_rotation
		bullet.rotation = bullet_spawn.rotation + spread_offset
		bullet_spawn.add_child(bullet)
