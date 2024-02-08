extends CharacterBody2D

const RUN_SPEED_MULTIPLICATION: float = 1.5

# Nodes
@onready var self_arm = %Arm
@onready var walk_particles = %WalkParticles
# Components
@onready var light_component = %LightComponent
@onready var gun_component = %GunComponent
@onready var stamina_component = %StaminaComponent
@onready var movement_component = %MovementComponent


func _process(_delta):
	movement()
	emit_components_signals()


func movement():
	var mouse_pos = get_global_mouse_position()
	rotation = lerp_angle(rotation, rotation + get_angle_to(mouse_pos), 0.1)
	self_arm.look_at(mouse_pos)
	
	var direction = Input.get_vector("left", "right", "front", "back")
	velocity = movement_component.move(velocity, direction)
	
	move_and_slide()


func emit_components_signals():
	# Shot
	if Input.is_action_just_pressed("fire") and gun_component.current_ammo > 0 and gun_component.can_fire == true and gun_component.reloading == false:
		# Gun Recoil
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self_arm, "position", self_arm.position - Vector2(4, 4) * (get_local_mouse_position() - self_arm.position).normalized(), 0.025)
		tween.tween_property(self_arm, "position", Vector2(16, 20), 0.1)
		
		# Gun Shot Logic
		gun_component.player_fire()
	
	# Reload
	if Input.is_action_just_pressed("reload") and gun_component.current_ammo != gun_component.max_ammo and gun_component.reloading == false:
		# Reload Animation
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self_arm, "rotation_degrees", 180, 0.5)
		tween.tween_property(self_arm, "rotation_degrees", 180, gun_component.projectile_resource.reload_time - 1)
		tween.tween_property(self_arm, "rotation_degrees", 0, 0.4)
		
		# Gun Reload Logic
		gun_component.reload_gun()
	
	# Toggle Light
	if Input.is_action_just_pressed("toggle_light"):
		light_component.toggle_light()
	
	# Toggle Run
	if Input.is_action_just_pressed("run"):
		stamina_component.toggle_run()


func _on_stamina_component_state_changed(is_running):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	
	if is_running == false:
		movement_component.walk_speed /= RUN_SPEED_MULTIPLICATION
		movement_component.acceleration /= RUN_SPEED_MULTIPLICATION
		tween.tween_property(%Eyes, "zoom", Vector2(3.25, 3.25), 0.5)
		movement_component.walk_sound.pitch_scale = 1
	else:
		movement_component.walk_speed *= RUN_SPEED_MULTIPLICATION
		movement_component.acceleration *= RUN_SPEED_MULTIPLICATION
		tween.tween_property(%Eyes, "zoom", Vector2(2.75, 2.75), 0.75)
		movement_component.walk_sound.pitch_scale = 1.1
