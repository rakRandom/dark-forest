class_name Bullet
extends RigidBody2D

@onready var death_timer = $DeathTimer

var direction: Vector2
var speed: float
var damage: float

func _physics_process(delta):
	var collision = move_and_collide(speed * direction * delta)
	if collision:
		var container = NodesExtentions.get_projectile_container()
		var death_effect = preload("res://scenes/objects/explosion_particles.tscn").instantiate()

		death_effect.position = global_position
		death_effect.rotation = collision.get_normal().angle()
		if container:
			container.add_child(death_effect)
			death_effect.emitting = true
		
		queue_free()

func _on_death_timer_timeout():
	queue_free()

	
