extends CharacterBody2D

@onready var movement_component = %MovementComponent
@onready var gun_component = %GunComponent

func _process(_delta):
	velocity = movement_component.move(velocity, Vector2(1, 0))
	move_and_slide()
