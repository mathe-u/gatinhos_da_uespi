extends CharacterBody2D

const MOTION_SPEED = 90.0

@export var synced_position: Vector2 = Vector2()
@export var stunned = false



var player_direction: Vector2

func _enter_tree() -> void:
	if str(name).is_valid_int():
		set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	position = synced_position
	
	#ToolManager.tool_selected.connect(on_tool_selected)



func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		
	
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
