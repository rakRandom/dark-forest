extends Panel

func _on_gun_component_current_ammo_changed(current_ammo, max_ammo):
	%CurrentAmmoLabel.text = str(current_ammo)
	%MaxAmmoLabel.text = str(max_ammo)
