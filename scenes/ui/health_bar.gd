extends TextureProgressBar

@export var visible_duration_on_damage: float = 3.0

#var player_node: Player = SceneManager.get_player_node()
var _visibility_timer: Timer

func _ready() -> void:
	visible = true

	_visibility_timer = Timer.new()
	_visibility_timer.one_shot = true
	_visibility_timer.wait_time = visible_duration_on_damage
	_visibility_timer.timeout.connect(_on_visibility_timer_timeout)
	add_child(_visibility_timer)
	#.HealthComponent.health_changed.connect(update_health)
	#update_health()


func on_player_health_changed(health_component: HealthComponent) -> void:
	self.max_value = health_component.max_health
	self.value = health_component.health
	
	#if health_component.health < health_component.max_health and health_component.is_alive():
		#_show_briefly(health_component)


func _show_briefly(health_component: HealthComponent) -> void:
	if health_component and health_component.is_alive():
		visible = true
		_visibility_timer.start()

func _on_visibility_timer_timeout() -> void:
	visible = false
