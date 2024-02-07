class_name GunComponent
extends Node2D

signal current_ammo_changed(current_ammo: int, max_ammo: int)

@export var projectile_resource: ProjectileBaseResource
@export var gun_container: Polygon2D
@export var bullet_spawner: Node2D

var current_ammo: int
var max_ammo: int
var can_fire: bool = true
var reloading: bool = false

@onready var shot_timer = %ShotTimer
@onready var reload_timer = %ReloadTimer
@onready var shot_sound = %ShotSound
@onready var reload_sound = %ReloadSound

func _ready():
	shot_sound.stream = preload("res://assets/audios/gun-fire-sound.mp3")
	reload_sound.stream = preload("res://assets/audios/reload.mp3")
	
	max_ammo = projectile_resource.max_bullets
	current_ammo = max_ammo
	
	reload_timer.connect("timeout", reloaded)
	shot_timer.connect("timeout", set_can_fire)
	current_ammo_changed.emit(current_ammo, max_ammo)

func _process(_delta):
	player_fire()
	reload_gun()

func set_can_fire():
	can_fire = true

func spawn_fire_particles():
	var particles = preload("res://scenes/objects/fire_bullet_particles.tscn").instantiate()
	
	particles.position = Vector2(5, 0)
	gun_container.add_child(particles)

func player_fire():
	if Input.is_action_just_pressed("fire") and current_ammo > 0 and can_fire == true and reloading == false:
		# Gun Recoil
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(gun_container, "position", gun_container.position - Vector2(4, 4) * (get_local_mouse_position() - gun_container.position).normalized(), 0.025)
		tween.tween_property(gun_container, "position", Vector2(16, 20), 0.1)
		
		# Playing sound
		shot_sound.stop()
		shot_sound.play()
		
		can_fire = false
		current_ammo -= 1
		shot_timer.start(projectile_resource.shot_time)
		spawn_fire_particles()  # Gun particles
		current_ammo_changed.emit(current_ammo, max_ammo)  # UI Refresh
		SignalBus.emit_fire(projectile_resource, bullet_spawner.global_position, (get_global_mouse_position() - bullet_spawner.global_position).normalized())


func reload_gun():
	if Input.is_action_just_pressed("reload") and current_ammo != max_ammo and reloading == false:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(gun_container, "rotation_degrees", 180, 0.5)
		tween.tween_property(gun_container, "rotation_degrees", 180, projectile_resource.reload_time - 1)
		tween.tween_property(gun_container, "rotation_degrees", 0, 0.4)
		
		# Playing sound
		reload_sound.stop()
		reload_sound.play()
		
		reloading = true
		reload_timer.start(projectile_resource.reload_time)

func reloaded():
	reloading = false
	current_ammo = max_ammo
	current_ammo_changed.emit(current_ammo, max_ammo)
