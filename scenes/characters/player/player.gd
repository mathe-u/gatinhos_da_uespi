class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var health_component: HealthComponent = $HealthComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var max_health: int
@export var starting_health: int

var player_direction: Vector2
var health_bar_player_node: TextureProgressBar

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	
	#hurt_component.hurt.connect(_on_hurt)
	
	health_component.max_health = max_health
	health_component.health = starting_health
	health_component.health_changed.connect(_update_health_bar)


func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
	print("Tool: ", tool)

func set_player_name(player_name: String) -> void:
	get_node("PlayerNameLabel").text = player_name
	#player_name_label.text = "ada"

func apply_item_effect(item: ItemData) -> void:
	print("efeito de " + str(item.effect) + " aplicado")
	

func _on_hurt() -> void:
	pass

func _update_health_bar() -> void:
	health_bar_player_node = get_tree().root.get_node("MainScene/GameScreen/PlayersHealthBar")
	health_bar_player_node.on_player_health_changed(health_component)
	
	if !health_component.is_alive():
		died()


func died() -> void:
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	sprite.modulate = Color(0.5, 0.5, 0.5)
	
	var tween = create_tween()
	tween.tween_property(sprite, "rotation", PI, 0.5)
	
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")
