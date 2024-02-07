extends ProgressBar

func _on_stamina_component_current_stamina_changed(current_stamina: float, max_stamina:float):
	if max_stamina == 0:
		return
	value = current_stamina / max_stamina * 100
