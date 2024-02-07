extends Node

const PROJECTILE_CONTAINER: String = "Projectile_Container"

func get_projectile_container():
	return get_tree().get_first_node_in_group(PROJECTILE_CONTAINER)
