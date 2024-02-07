extends CharacterBody2D

const RUN_SPEED_MULTIPLICATION: float = 1.5

var speed: float = 75
var acceleration: float = 0.075
var deceleration: float = 0.075

@onready var self_arm = %Arm
@onready var foot_step_sound = $FootStepSound

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	
	rotation = lerp_angle(rotation, rotation + get_angle_to(mouse_pos), 0.1)
	self_arm.look_at(mouse_pos)
	
	movement()

func movement():
	var dir = Input.get_vector("left", "right", "front", "back")
	
	if dir != Vector2.ZERO:
		if foot_step_sound.playing == false:
			foot_step_sound.play()
		velocity = lerp(velocity, dir * speed, acceleration)
	else:
		if foot_step_sound.playing == true:
			foot_step_sound.stop()
		velocity = lerp(velocity, Vector2.ZERO, deceleration)
	
	move_and_slide()


func _on_stamina_component_state_changed(is_running):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	
	if is_running == false:
		speed /= RUN_SPEED_MULTIPLICATION
		acceleration /= RUN_SPEED_MULTIPLICATION
		tween.tween_property(%Eyes, "zoom", Vector2(3.25, 3.25), 0.5)
		foot_step_sound.pitch_scale = 1
	else:
		speed *= RUN_SPEED_MULTIPLICATION
		acceleration *= RUN_SPEED_MULTIPLICATION
		tween.tween_property(%Eyes, "zoom", Vector2(2.75, 2.75), 0.75)
		foot_step_sound.pitch_scale = 1.1
