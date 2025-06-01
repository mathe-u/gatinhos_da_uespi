extends CharacterBody2D

@onready var enter_interactable_label_component: Control = $EnterInteractableLabelComponent
@onready var enter_leather: InteractableComponent = $EnterLeather
@onready var exit_interactable_label_component: Control = $ExitInteractableLabelComponent
@onready var exit_leather: InteractableComponent = $ExitLeather
@onready var enter_spawn: Marker2D = $EnterSpawn
@onready var exit_spawn: Marker2D = $ExitSpawn
@onready var point_light_2d: PointLight2D = $PointLight2D


var in_range: bool
var is_inside: bool = true
#var player_node: Player = SceneManager.get_player_node()
var player_node: Player

func _ready() -> void:
	enter_leather.interactable_activated.connect(on_enter_activated)
	enter_leather.interactable_deactivated.connect(on_enter_deactivated)
	enter_interactable_label_component.hide()
	
	exit_leather.interactable_activated.connect(on_exit_activated)
	exit_leather.interactable_deactivated.connect(on_exit_deactivated)
	exit_interactable_label_component.hide()
	
	point_light_2d.enabled = false
	DayNightCycleManager.time_tick.connect(on_nightfall)
	
	player_node = SceneManager.get_player_node()
	
	print("player: ", player_node)


func on_enter_activated() -> void:
	enter_interactable_label_component.show()
	in_range = true


func on_enter_deactivated() -> void:
	enter_interactable_label_component.hide()
	in_range = false


func on_exit_activated() -> void:
	exit_interactable_label_component.show()
	in_range = true


func on_exit_deactivated() -> void:
	exit_interactable_label_component.hide()
	in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("interact"):
			if is_inside:
				player_node.position = exit_spawn.global_position
				is_inside = false
				exit_interactable_label_component.hide()
			else:
				player_node.position = enter_spawn.global_position
				is_inside = true
				enter_interactable_label_component.hide()
		in_range = true


func on_nightfall(_day: int, hour: int, _minute: int) -> void:
	if hour >= 19 or hour <= 4:
		point_light_2d.enabled = true
	else:
		point_light_2d.enabled = false
