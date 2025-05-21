class_name EnergyComponent
extends Node

@export var max_energy: float = 100.0
@export var current_energy: float = 100.0:
	set(value):
		var old_energy = current_energy
		current_energy = clamp(value, 0, max_energy)
		if old_energy != current_energy:
			energy_changed.emit()
		if current_energy == 0 and old_energy > 0:
			energy_empty.emit()
		if current_energy == max_energy and old_energy < max_energy:
			energy_full.emit()

@export var energy_drain_rate: float = 1.0 # Energia perdida por segundo
@export var damage_on_empty: int = 5 # Dano por tick quando a energia está vazia
@export var heal_on_full: int = 2 # Cura por tick quando a energia está cheia
@export var tick_rate: float = 1.0 # Frequência em segundos para aplicar efeitos de energia

signal energy_changed
signal energy_empty
signal energy_full

var energy_timer: Timer

func _ready() -> void:
	energy_timer = Timer.new()
	add_child(energy_timer)
	energy_timer.wait_time = tick_rate
	energy_timer.timeout.connect(_on_energy_timer_timeout)
	energy_timer.start()

func _process(delta: float) -> void:
	current_energy -= energy_drain_rate * delta

func add_energy(amount: float) -> void:
	current_energy += amount

func is_energy_full() -> bool:
	return current_energy >= max_energy

func is_energy_empty() -> bool:
	return current_energy <= 0

func _on_energy_timer_timeout() -> void:
	if is_energy_empty():
		energy_empty.emit()
	elif is_energy_full():
		energy_full.emit()
