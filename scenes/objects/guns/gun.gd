@tool
extends Node2D

@export var gun_texture: Texture2D:
	set(value):
		gun_texture = value
		update_sprite()
@export var shoot_cooldown: float = 1.8
@export var gun_pellets: int = 3
@export var gun_spread_degree: float = 25.0
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 900
@export var projectile_damage: int = 5

@export var joystick_aim_sensitivity: float = 100.0

@onready var bullet_spawn: Marker2D = $GunSprite/BulletSpawn
@onready var gun_sprite: Sprite2D = $GunSprite
@onready var gun_blast: AudioStreamPlayer2D = $Shotgun_blast

var shoot_cooldown_time: float = 0.2
var _spread_radians: float = deg_to_rad(gun_spread_degree)
var aim_direction: Vector2 = Vector2.RIGHT
var aim_target_position: Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		update_sprite()
	
	if gun_spread_degree == 0.0:
		_spread_radians = 0.0
	
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	if shoot_cooldown_time > 0.0:
		shoot_cooldown_time -= delta
	
	var right_stick_input: Vector2 = Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down")
	if right_stick_input.length() > 0.1:
		aim_direction = right_stick_input.normalized()
		aim_target_position = global_position + right_stick_input.normalized() * joystick_aim_sensitivity
	else:
		aim_target_position = get_global_mouse_position()
	
	look_at(aim_target_position)
	
	if aim_target_position.x < global_position.x:
		gun_sprite.flip_v = true
		bullet_spawn.position = Vector2(28, 4)
	else:
		gun_sprite.flip_v = false
		bullet_spawn.position = Vector2(28, -4)
	
	if Input.is_action_pressed("hit") and shoot_cooldown_time <= 0.0:
			shoot_cooldown_time = shoot_cooldown
			shoot()


func shoot() -> void:
	var spawn_transform: Transform2D = bullet_spawn.global_transform
	var base_rotation: float = spawn_transform.get_rotation()
	var spawn_position: Vector2 = spawn_transform.origin
	
	gun_blast.play(0.13)
	
	for i in range(gun_pellets):
		var bullet: Projectile = projectile_scene.instantiate()
		var spread_offset: float = randf_range(-_spread_radians / 2.0, _spread_radians / 2.0)
		var final_rotation: float = base_rotation + spread_offset
		
		bullet.global_position = spawn_position
		bullet.rotation = final_rotation
		bullet.speed = projectile_speed
		bullet.hit_damage = projectile_damage
		get_parent().get_parent().add_child(bullet)


func update_sprite() -> void:
	if gun_sprite:
		gun_sprite.texture = gun_texture
