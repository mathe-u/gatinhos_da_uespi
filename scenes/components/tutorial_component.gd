extends Node2D

@export var text: String

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var box_label: PanelContainer = $BoxLabel
@onready var interactable_label: TextureRect = $InteractableLabel
@onready var label: Label = $BoxLabel/Label
@onready var life_time: Timer = $LifeTime

var in_range: bool = false

func _ready() -> void:
	box_label.hide()
	label.text = text
	
	life_time.timeout.connect(_on_life_time_timeout)
	
	interactable_component.interactable_activated.connect(_on_interactable_activated)
	interactable_component.interactable_deactivated.connect(_on_interactable_deactivated)


func _on_interactable_activated() -> void:
	box_label.show()
	life_time.start()
	in_range = true


func _on_interactable_deactivated() -> void:
	in_range = false


func _on_life_time_timeout() -> void:
	queue_free()
