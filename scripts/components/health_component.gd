class_name HealthComponent
extends Node2D

signal current_health_changed(current_health: float, max_health: float)
signal current_shield_changed(current_shield: float, max_shield: float)

@export var max_health: float = 1
@export var current_health: float = 1
@export var max_shield: float = 0
@export var current_shield: float = 0
