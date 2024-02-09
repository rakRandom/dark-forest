extends CharacterBody2D

@onready var movement_component = %MovementComponent
@onready var gun_component = %GunComponent
@onready var health_component = %HealthComponent
@onready var enemy_component = %EnemyComponent


func _process(_delta):
	var player_pos: Vector2 = NodesExtentions.get_player_node().global_position
	
	if (player_pos - global_position).length() <= enemy_component.view_range:
		look_at(player_pos)
	
	if (player_pos - global_position).length() <= enemy_component.shot_range:
		gun_component.gun_fire(player_pos)
		if gun_component.current_ammo == 0:
			gun_component.reload_gun()
	
	move_and_slide()
