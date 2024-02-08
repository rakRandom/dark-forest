class_name StaminaComponent
extends Node2D

signal current_stamina_changed(current_stamina: float, max_stamina: float)
signal state_changed(is_using_stamina: bool)

@export var max_stamina: float
@export var current_stamina: float
@export var stamina_consumption: float
@export var refresh_time: float

var is_using_stamina: bool = false
var can_refresh: bool = true

@onready var refresh_timer = $RefreshTimer


func _ready():
	current_stamina_changed.emit(current_stamina, max_stamina)


func _process(delta):
	if current_stamina <= 0 and is_using_stamina == true:
		update_state(false)
		
	if is_using_stamina == true:
		current_stamina -= stamina_consumption * delta
		current_stamina_changed.emit(current_stamina, max_stamina)
	elif current_stamina < max_stamina and can_refresh:
		current_stamina += stamina_consumption * delta
		current_stamina_changed.emit(current_stamina, max_stamina)


func toggle_run():
	if current_stamina > 0 and is_using_stamina == false:
		update_state(true)
	elif is_using_stamina == true:
		update_state(false)


func update_state(new_state: bool):
	is_using_stamina = new_state
	state_changed.emit(is_using_stamina)
	
	if new_state == false:
		can_refresh = false
		refresh_timer.start(refresh_time)


func _on_refresh_timer_timeout():
	can_refresh = true
