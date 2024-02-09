extends Node

const PROJECTILE_CONTAINER: StringName = "Projectile_Container"
const PLAYER_CONTAINER: StringName = "PlayerNode"


func get_projectile_container():
	return get_tree().get_first_node_in_group(PROJECTILE_CONTAINER)


func get_player_node():
	return get_tree().get_first_node_in_group(PLAYER_CONTAINER)
