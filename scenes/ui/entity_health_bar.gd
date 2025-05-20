#entity_health_bar.gd
extends TextureProgressBar

@export var health_component: HealthComponent
@export var visible_duration_on_damage: float = 3.0

var _visibility_timer: Timer

func _ready() -> void:
	visible = false

	_visibility_timer = Timer.new()
	_visibility_timer.one_shot = true
	_visibility_timer.wait_time = visible_duration_on_damage
	_visibility_timer.timeout.connect(_on_visibility_timer_timeout)
	add_child(_visibility_timer)
	
	#health_component.health_changed.connect(_on_entity_health_changed)


func on_entity_health_changed(current_health: float, max_health: float) -> void:
	self.max_value = max_health
	self.value = current_health
	
	if current_health < max_health and health_component.is_alive():
		_show_briefly()

	#if not health_component.is_alive():
		#visible = false
	#print(get_parent().name, " HealthBar: ", current_health, "/", max_health)


func _show_briefly() -> void:
	if health_component and health_component.is_alive():
		visible = true
		_visibility_timer.start()


func _on_visibility_timer_timeout() -> void:
	visible = false
