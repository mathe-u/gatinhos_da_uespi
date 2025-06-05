extends Sprite2D

@onready var damage_component: DamageComponent = $DamageComponent
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var hurt_component_2: HurtComponent2 = $HurtComponent2
@onready var item_spawner_component: ItemSpawnerComponent = $ItemSpawnerComponent

@export var drop_id: StringName

#var log_scene = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)


func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 1.5)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity", 0.0)


func on_max_damaged_reached() -> void:
	call_deferred("drop_item")
	queue_free()

func add_log_scene() -> void:
	var item = ItemsDataBase.new().get_item_data(drop_id)
	var item_scene: ItemComponent = item.item_scene.instantiate()
	
	item_scene.global_position = global_position
	item_scene.set_item_data(drop_id, 1)
	#item_scene.item_id = item.id
	#item_scene.quantity = randi_range(1, 4)
	get_parent().add_child(item_scene)
	#item_spawner_component.spawn_items2()
	#var log_instace = log_scene.instantiate() as Node2D
	#log_instace.global_position = global_position
	#get_parent().add_child(log_instace)
	pass


func drop_item() -> void:
	var item = ItemsDataBase.new().get_item_data(drop_id)
	var item_scene: ItemComponent = item.item_scene.instantiate()
	
	item_scene.global_position = global_position
	item_scene.set_item_data(drop_id, 1)
	item_spawner_component.spawn_items2(item_scene, global_position)
