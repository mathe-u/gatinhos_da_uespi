extends CharacterBody2D

@onready var enter_interactable_label_component: Control = $EnterInteractableLabelComponent
@onready var enter_leather: InteractableComponent = $EnterLeather
@onready var exit_interactable_label_component: Control = $ExitInteractableLabelComponent
@onready var exit_leather: InteractableComponent = $ExitLeather
@onready var enter_spawn: Marker2D = $EnterSpawn
@onready var exit_spawn: Marker2D = $ExitSpawn

var in_range: bool
var is_inside: bool = true
var player_node: Player = SceneManager.get_player_node()

func _ready() -> void:
	enter_leather.interactable_activated.connect(on_enter_activated)
	enter_leather.interactable_deactivated.connect(on_enter_deactivated)
	enter_interactable_label_component.hide()
	
	exit_leather.interactable_activated.connect(on_exit_activated)
	exit_leather.interactable_deactivated.connect(on_exit_deactivated)
	exit_interactable_label_component.hide()


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
		if event.is_action_pressed("hit"):
			if is_inside:
				player_node.position = exit_spawn.global_position
				is_inside = false
				exit_interactable_label_component.hide()
			else:
				player_node.position = enter_spawn.global_position
				is_inside = true
				enter_interactable_label_component.hide()
	in_range = true
