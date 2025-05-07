class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None


@export var synced_position: Vector2 

var player_direction: Vector2

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)


func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
	print("Tool: ", tool)

func set_player_name(player_name: String) -> void:
	get_node("PlayerNameLabel").text = player_name
	#player_name_label.text = "ada"

func apply_item_effect(item: Dictionary) -> void:
	print("efeito de ", item["effect"], " aplicado")
	
