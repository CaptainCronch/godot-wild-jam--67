extends RigidBody2D

var collision_pos : Vector2 = Vector2(0.0, 0.0)
var frozen := false
var lock_pos := Vector2()
var lock_rot := 0.0


func _integrate_forces(state : PhysicsDirectBodyState2D) -> void:
	if state.get_contact_count() > 0:
		collision_pos = state.get_contact_local_position(0)
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
