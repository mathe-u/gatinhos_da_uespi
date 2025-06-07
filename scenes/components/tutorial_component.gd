extends Node2D

@export var text: String = ""

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var box_label: PanelContainer = $BoxLabel
@onready var label: Label = $BoxLabel/MarginContainer/Label

@onready var life_time: Timer = $LifeTime

var in_range: bool = true


func _ready() -> void:
	box_label.hide()
	label.text = text
	
	life_time.timeout.connect(_on_life_time_timeout)
	
	interactable_component.interactable_activated.connect(_on_interactable_activated)


func _on_interactable_activated() -> void:
	box_label.show()
	
	if in_range:
		life_time.start()
	
	in_range = false


func _on_life_time_timeout() -> void:
	queue_free()
