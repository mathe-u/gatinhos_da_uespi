#tree
extends Sprite2D

@export var shake_intensity: float = 0.5
@export var drop_id: StringName
@export var drops: Array[StringName]

@onready var hurt_component_2: HurtComponent2 = $HurtComponent2
@onready var item_spawner_component: ItemSpawnerComponent = $ItemSpawnerComponent
@onready var health_component: HealthComponent = $HealthComponent

signal destroyed

func _ready() -> void:
	hurt_component_2.hurt.connect(on_hurt)

	health_component.died.connect(on_died)
	


func on_hurt(hit_damage: int) -> void:
	health_component.take_damage(hit_damage)
	
	material.set_shader_parameter("shake_intensity", shake_intensity)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity", 0.0)


#func on_max_damaged_reached() -> void:
	#call_deferred("drop_item")
	#destroyed.emit()
	#queue_free()


func on_died() -> void:
	call_deferred("drop_items")
	destroyed.emit()
	queue_free()


func drop_items() -> void:
	for item_id: StringName in drops:
		var item = ItemsDataBase.new().get_item_data(item_id)
		var item_scene: ItemComponent = item.item_scene.instantiate()
	
		#item_scene.global_position = global_position
		item_scene.set_item_data(item_id, 1)
		item_spawner_component.spawn_items2(item_scene, global_position)
