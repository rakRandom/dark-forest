extends Node

signal fire(resource : ProjectileBaseResource, location: Vector2, direction: Vector2)

func emit_fire(resource : ProjectileBaseResource, location: Vector2, direction: Vector2):
	fire.emit(resource, location, direction)
