extends TextureProgressBar

func on_player_energy_changed(energy_component: EnergyComponent) -> void:
	max_value = energy_component.max_energy
	value = energy_component.current_energy
