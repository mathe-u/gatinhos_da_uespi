extends CharacterBody2D

const MOTION_SPEED: float = 90.0
const MAX_HEALTH: int = 100
const BULLET: PackedScene = preload("res://scenes/objects/Projectiles/projectile.tscn")

@export var synced_position: Vector2 = Vector2()
@export var stunned = false
@onready var shotgun_blast: AudioStreamPlayer2D = $Gun/Shotgun_blast




var player_direction: Vector2
var health = 100

func _enter_tree() -> void:
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	position = synced_position
	
	#ToolManager.tool_selected.connect(on_tool_selected)



func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		$Gun.look_at(get_global_mouse_position())
		
		if get_global_mouse_position().x < global_position.x:
			$Gun/Sprite2D.flip_v = true
		else:
			$Gun/Sprite2D.flip_v = false
		
		if Input.is_action_just_pressed("hit"):
			shotgun_blast.play(0.13)
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
	var bullet = BULLET.instantiate()
	bullet.set_multiplayer_authority(shooter_id)
	get_parent().add_child(bullet)
	bullet.transform = $Gun/Sprite2D/Marker2D.global_transform


@rpc("any_peer")
func take_damage(amount: int) -> void:
	health -= amount
	
	if health <= 0:
		#health = MAX_HEALTH
		queue_free()
		
	
	
