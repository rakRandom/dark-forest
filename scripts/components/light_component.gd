class_name LightComponent
extends Node2D

signal current_energy_changed(current_energy: float, max_energy: float)

@export var light_source: PointLight2D = null
@export var refresh_time: float = 0.1
@export var current_energy: float = 1
@export var max_energy: float = 1
@export var energy_consumption: float = 1

var can_refresh = true

@onready var refresh_timer = $RefreshTimer


func _ready():
	current_energy_changed.emit(current_energy, max_energy)


func _process(delta):
	if current_energy <= 0 and light_source.enabled == true:
		light_source.enabled = false
		can_refresh = false
		refresh_timer.start(refresh_time)
		
	if light_source.enabled == true:
		current_energy -= energy_consumption * delta
		current_energy_changed.emit(current_energy, max_energy)
	elif current_energy < max_energy and can_refresh:
		current_energy += energy_consumption * delta
		current_energy_changed.emit(current_energy, max_energy)


func toggle_light():
	if current_energy > 0 and light_source.enabled == false:
		light_source.enabled = true
	elif light_source.enabled == true:
		light_source.enabled = false
		can_refresh = false
		refresh_timer.start(refresh_time)


func _on_timer_timeout():
	can_refresh = true
