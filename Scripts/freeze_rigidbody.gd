extends RigidBody2D

var frozen := false
var lock_pos := Vector2()
var lock_rot := 0.0


func _integrate_forces(state):
	if frozen:
		state.linear_velocity = Vector2()
		state.angular_velocity = 0
		global_position = lock_pos
		global_rotation = lock_rot


func set_freeze(on : bool):
	frozen = on
	lock_pos = global_position
	lock_rot = global_rotation
	custom_integrator = on
