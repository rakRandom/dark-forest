class_name GunComponent
extends Node2D

signal current_ammo_changed(current_ammo: int, max_ammo: int)

@export var projectile_resource: ProjectileBaseResource
@export var bullet_spawner: Node2D
@export_group("Appearance")
@export var shot_sound_stream: AudioStream
@export var reload_sound_stream: AudioStream
@export var fire_bullet_particles: PackedScene

var current_ammo: int
var max_ammo: int
var can_fire: bool = true
var reloading: bool = false

@onready var shot_timer = %ShotTimer
@onready var reload_timer = %ReloadTimer
@onready var shot_sound = %ShotSound
@onready var reload_sound = %ReloadSound


func _ready():
	shot_sound.stream = shot_sound_stream
	reload_sound.stream = reload_sound_stream
	
	max_ammo = projectile_resource.max_bullets
	current_ammo = max_ammo
	
	reload_timer.connect("timeout", reloaded)
	shot_timer.connect("timeout", set_can_fire)
	current_ammo_changed.emit(current_ammo, max_ammo)


func set_can_fire() -> void:
	can_fire = true


func gun_fire(target_pos: Vector2) -> bool:
	if current_ammo > 0 and can_fire == true and reloading == false:
		# Playing sound
		shot_sound.stop()
		shot_sound.play()
		
		can_fire = false
		current_ammo -= 1
		shot_timer.start(projectile_resource.shot_time)
		bullet_spawner.add_child(fire_bullet_particles.instantiate()) # Gun particles
		current_ammo_changed.emit(current_ammo, max_ammo)  # usage e.g.: UI Refresh
		SignalBus.emit_fire(projectile_resource, bullet_spawner.global_position, bullet_spawner.global_position.direction_to(target_pos))
		
		return true
	return false


func reload_gun() -> bool:
	if current_ammo != max_ammo and reloading == false:
		# Playing sound
		reload_sound.stop()
		reload_sound.play()
		
		reloading = true
		reload_timer.start(projectile_resource.reload_time)
		
		return true
	return false


func reloaded() -> void:
	reloading = false
	current_ammo = max_ammo
	current_ammo_changed.emit(current_ammo, max_ammo)
