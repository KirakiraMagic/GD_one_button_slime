extends RigidBody3D

var is_sticking = false
var jump_timer = 0.0
var hold_timer = 0.0
const JUMP_THRESHOLD = 0.3
const JUMP_FORCE = Vector3(0, 10, 0)
const STICK_BUTTON = "ui_accept"
var stick_point
var size = 0.5
var break_distance = 1.0

@onready var floorcast = $RayCast3D
var floor_pos = 0.0
var floor = false


func _physics_process(delta):

	if floorcast.is_colliding():
		if floorcast.get_collider().is_in_group("floor"):
			floor = true
			floor_pos = floorcast.get_collision_point().y
		else:
			floor = false
	else:
		floor = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):

	
	if Input.is_action_just_released(STICK_BUTTON):
		if hold_timer < JUMP_THRESHOLD:
			# Quick press, perform jump
			is_sticking = false
			apply_impulse(JUMP_FORCE)
			
	if Input.is_action_pressed(STICK_BUTTON):
		hold_timer += state.get_step()
		#if hold_timer > JUMP_THRESHOLD:
			# Get collision
		if !is_sticking:
			var sticky_collision
			var index = -1
			for i in range(state.get_contact_count()):
				var collision = state.get_contact_collider_object(i)
				if collision and collision.is_in_group("stickable"):
					sticky_collision = collision
					index = i
					break
			if sticky_collision != null:
				var joint = PinJoint3D.new()
				joint.exclude_nodes_from_collision = false
				sticky_collision.add_child(joint)
				joint.global_position = state.get_contact_local_position(index)
				joint.node_a = sticky_collision.get_path()
				joint.node_b = get_path()
				stick_point = joint
				is_sticking = true
	else:
		hold_timer = 0.0
		is_sticking = false
		if stick_point:
			stick_point.queue_free()
			stick_point = null

	if is_sticking:
		#linear_velocity = lerp(linear_velocity, Vector3(0, 0, 0), state.get_step() * 10)
		gravity_scale = 0
		if global_position.distance_to(stick_point.global_position) > break_distance:
			hold_timer = 0.0
			is_sticking = false
			if stick_point:
				stick_point.queue_free()
				stick_point = null

	else:
		gravity_scale = 1
		apply_central_force(Vector3(0, -ProjectSettings.get_setting("physics/3d/default_gravity") * mass, 0))
