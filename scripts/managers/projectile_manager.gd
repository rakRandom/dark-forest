class_name ProjectileManager
extends Node2D


func _ready():
	SignalBus.connect("fire", build_projectile)


func build_projectile(resource : ProjectileBaseResource, location: Vector2, direction: Vector2):
	var new_bullet := resource.base_bullet_scene.instantiate() as Bullet
	
	new_bullet.direction = direction
	new_bullet.rotation = new_bullet.direction.angle()
	new_bullet.damage = resource.damage
	new_bullet.speed = resource.speed
	new_bullet.position = location
	
	spawn_projectile(new_bullet)


func spawn_projectile(bullet: Bullet):
	var projectile_container: Node2D = NodesExtentions.get_projectile_container()
	
	if projectile_container == null:
		return
	
	projectile_container.add_child(bullet)
