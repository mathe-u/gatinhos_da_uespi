class_name Projectile
extends Sprite2D

@export var speed: float = 850.0
@export var hit_damage: int = 5

@onready var life_time: Timer = $LifeTime
@onready var hit_component: HitComponent = $HitComponent

func _ready() -> void:
	life_time.timeout.connect(remove_projectile)
	hit_component.hit_damage = hit_damage


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func remove_projectile() -> void:
	queue_free()
