class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var energy_component: EnergyComponent = $EnergyComponent

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
	
	energy_component.energy_changed.connect(_update_energy_bar)
	energy_component.energy_empty.connect(_on_energy_empty)
	energy_component.energy_full.connect(_on_energy_full)


func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool


func set_player_name(player_name: String) -> void:
	get_node("PlayerNameLabel").text = player_name
	#player_name_label.text = "ada"ee


func apply_item_effect(item: ItemData) -> void:
	if item.effect == DataTypes.Effect.RestoreEnergy:
		energy_component.add_energy(item.effect_amount)
	if item.effect == DataTypes.Effect.Healing:
		health_component.apply_heal(item.effect_amount)
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
	
	var main_scene: Node = get_tree().root.get_node("MainScene")
	var main_menu_screen_scene: PackedScene = load("res://scenes/ui/game_menu_screen.tscn")
	var main_menu_screen_instance: CanvasLayer = main_menu_screen_scene.instantiate()
	
	get_tree().root.add_child(main_menu_screen_instance)
	
	main_scene.queue_free()


func _update_energy_bar() -> void:
	var energy_bar_player_node: TextureProgressBar = get_tree().root.get_node("MainScene/GameScreen/PlayerEnergyBar")
	energy_bar_player_node.on_player_energy_changed(energy_component)


func _on_energy_empty() -> void:
	health_component.take_damage(energy_component.damage_on_empty)


func _on_energy_full() -> void:
	health_component.heal(energy_component.heal_on_full)
