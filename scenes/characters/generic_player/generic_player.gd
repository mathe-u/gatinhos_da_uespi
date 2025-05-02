extends CharacterBody2D

const MOTION_SPEED = 90.0

@export var synced_position: Vector2 = Vector2()
@export var stunned = false
@onready var inputs: Node = $Inputs


@onready var hit_component: HitComponent = $HitComponent
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None


var player_direction: Vector2

func _ready() -> void:
	position = synced_position
	
	if str(name).is_valid_int():
		get_node("Inputs/InputsSync").set_multiplayer_authority(str(name).to_int())
	
	ToolManager.tool_selected.connect(on_tool_selected)


func _physics_process(delta: float) -> void:
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		# The client which this player represent will update the controls state, and notify it to everyone.
		inputs.update()
	
	if multiplayer.multiplayer_peer == null or is_multiplayer_authority():
		# The server updates the position that will be notified to the clients.
		synced_position = position
		# And increase the bomb cooldown spawning one if the client wants to.
		
	else:
		# The client simply updates the position to the last known one.
		position = synced_position
	
	if not stunned:
		# Everybody runs physics. I.e. clients tries to predict where they will be during the next frame.
		velocity = inputs.motion * MOTION_SPEED
		move_and_slide()


func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
	print("Tool: ", tool)

func set_player_name(player_name: String) -> void:
	get_node("PlayerNameLabel").text = player_name
	#player_name_label.text = "ada"
