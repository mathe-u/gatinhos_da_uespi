extends Sprite2D

@onready var health_component: HealthComponent = $HealthComponent
#@onready var hurt_component: HurtComponent = $HurtComponent
@onready var hurt_component_2: HurtComponent2 = $HurtComponent2
@onready var entity_health_bar: TextureProgressBar = $EntityHealthBar

@export var hurted_by: DataTypes.Tools = DataTypes.Tools.None
@export var entity_max_health: int = 10
@export var entity_starting_health: int = 10
@export var drop_id: StringName
@export var squash_duration = 0.2
@export var max_squash_amount = 0.4

var item_drop_scene: PackedScene = preload("res://scenes/objects/itens/item_scene.tscn")

signal destroyed

func _ready() -> void:
	material.set_shader_parameter("squash_amount", 0.0)
	
	#hurt_component.tool = hurted_by
	hurt_component_2.hurt.connect(_on_hurt)
	
	entity_health_bar.health_component = health_component
	
	health_component.max_health = entity_max_health
	health_component.health = entity_starting_health
	health_component.health_changed.connect(_update_health_bar)
	health_component.died.connect(_on_unhealthy)
	
	_update_health_bar()


func _update_health_bar() -> void:
	entity_health_bar.on_entity_health_changed(health_component.health, health_component.max_health)


func _on_hurt(damage: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(material, "shader_parameter/squash_amount", max_squash_amount, squash_duration / 2.0).set_ease(Tween.EASE_OUT) # Achatamento rápido
	tween.tween_property(material, "shader_parameter/squash_amount", 0.0, squash_duration / 2.0).set_ease(Tween.EASE_IN) # Retorno mais suave
	health_component.take_damage(damage)


func _on_unhealthy() -> void:
	call_deferred("add_drop_scene")
	destroyed.emit()
	queue_free()


func heal(amount: int) -> void:
	health_component.apply_heal(amount)


func increase_max_health(amount: int) -> void:
	health_component.increase_health(health_component.max_health + amount)


func is_alive() -> bool:
	return health_component.is_alive()


func add_drop_scene() -> void:
	#var log_instace = drop_scene.instantiate() as Node2D
	#log_instace.global_position = global_position
	#get_parent().add_child(log_instace)
	var item = ItemsDataBase.new().get_item_data(drop_id)
	var item_scene: ItemComponent = item_drop_scene.instantiate()
	item_scene.global_position = global_position
	item_scene.set_item_data(item.id, randi_range(1, 3))
	#item_scene.item_id = item.id
	#item_scene.quantity = randi_range(1, 3)
	get_parent().add_child(item_scene)
