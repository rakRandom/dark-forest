extends Camera2D


func _process(_delta):
	offset = lerp(offset, (get_global_mouse_position() - global_position) / 10, 0.05)
