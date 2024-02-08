class_name MovementComponent
extends Node2D

@export var walk_speed: float = 1
@export_group("Smooth Movement")
@export_range(0, 0.2, 0.001) var acceleration: float = 0.075
@export_range(0, 0.2, 0.001) var deceleration: float = 0.075
@export_group("Appearance")
@export var walk_sound_stream: AudioStream
@export var walk_particles: CPUParticles2D

@onready var walk_sound = %WalkSound

func _ready():
	walk_sound.stream = walk_sound_stream


func move(velocity: Vector2, direction: Vector2) -> Vector2:
	if direction != Vector2.ZERO:
		if walk_sound.playing == false:
			walk_sound.play()
		if walk_particles.emitting == false:
			walk_particles.emitting = true
		
		return lerp(velocity, direction * walk_speed, acceleration)
	
	else:
		if walk_sound.playing == true:
			walk_sound.stop()
		if walk_particles.emitting == true:
			walk_particles.emitting = false
		
		return lerp(velocity, Vector2.ZERO, deceleration)
