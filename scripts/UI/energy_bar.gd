extends ProgressBar


func _on_light_component_current_energy_changed(current_energy: float, max_energy: float):
	if max_energy == 0:
		return
	value = current_energy / max_energy * 100
