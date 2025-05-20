class_name GenericEnemy
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var entity_health_bar: TextureProgressBar = $EntityHealthBar
@onready var navigation_component: Node2D = $NavigationComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var attack_range: Area2D = $AttackRange

@export var hurted_by: DataTypes.Tools = DataTypes.Tools.None
@export var entity_max_health: int = 10
@export var entity_starting_health: int = 10
@export var damage: int = 3
@export var speed: float = 50.0
@export var drop_id: StringName

var player: Player

func _ready() -> void:
	hurt_component.tool = hurted_by
	hurt_component.hurt.connect(_on_hurt)
	
	entity_health_bar.health_component = health_component
	
	health_component.max_health = entity_max_health
	health_component.health = entity_starting_health
	health_component.health_changed.connect(_update_health_bar)
	health_component.died.connect(_on_unhealthy)
	
	#attack_component.damage_range.connect(_on_attack_range)
	
	player = SceneManager.get_player_node()
	
	_update_health_bar()


func _physics_process(_delta: float) -> void:
	var direction = navigation_component.get_direction(player)
	velocity = direction * speed
	move_and_slide()
	

func _update_health_bar() -> void:
	entity_health_bar.on_entity_health_changed(health_component.health, health_component.max_health)


func _on_hurt(hurt_damage: int) -> void:
	health_component.take_damage(hurt_damage)


func _on_unhealthy() -> void:
	call_deferred("add_drop_scene")
	queue_free()


func add_drop_scene() -> void:
	var item = ItemsDataBase.new().get_item_data(drop_id)
	var item_scene: ItemComponent = item.item_scene.instantiate()
	item_scene.global_position = global_position
	item_scene.item_id = item.id
	item_scene.quantity = randi_range(1, 3)
	get_parent().add_child(item_scene)


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		player.health_component.take_damage(damage)
		#print("body:. ", body.name)
