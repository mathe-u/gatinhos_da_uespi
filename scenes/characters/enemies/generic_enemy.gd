class_name GenericEnemy
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var entity_health_bar: TextureProgressBar = $EntityHealthBar
@onready var navigation_component: Node2D = $NavigationComponent
@onready var attack_component: AttackComponent = $AttackComponent

@onready var attack_timer: Timer = $AttackTimer

@export var hurted_by: DataTypes.Tools = DataTypes.Tools.None
@export var entity_max_health: int = 10
@export var entity_starting_health: int = 10
@export var damage: int = 3
@export var speed: float = 50.0
@export var drop_id: StringName
@export var attack_cooldown: float = 1.8

var player: Player

func _ready() -> void:
	hurt_component.tool = hurted_by
	hurt_component.hurt.connect(_on_hurt)
	
	entity_health_bar.health_component = health_component
	
	health_component.max_health = entity_max_health
	health_component.health = entity_starting_health
	health_component.health_changed.connect(_update_health_bar)
	health_component.died.connect(_on_unhealthy)
	
	attack_component.in_range.connect(_on_attack_in_range)
	
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = false
	attack_timer.timeout.connect(_apply_damage)
	
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
	item_scene.quantity = randi_range(1, 4)
	get_parent().add_child(item_scene)


func _on_attack_in_range(body: Node2D) -> void:
	if body is Player:
		_apply_damage()
		attack_timer.start()


func _on_attack_out_range(body: Node2D) -> void:
	if body is Player:
		attack_timer.stop()


func _apply_damage() -> void:
	player.health_component.take_damage(damage)
