extends CharacterBody2D

@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var storage_deck: TileMapLayer = $StorageDeck
@onready var main_deck: TileMapLayer = $MainDeck

var in_range: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()


func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	#if is_chest_open:
		#animated_sprite_2d.play("chest_close")
	
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("hit"):
			interactable_component.hide()
			interactable_label_component.hide()
			storage_deck.hide()
			main_deck.hide()
			#animated_sprite_2d.play("chest_open")
			#is_chest_open = true
