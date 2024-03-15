extends RigidBody2D

@export var right := true

var collision_pos : Vector2 = Vector2(0.0, 0.0)
var frozen := false
var lock_pos := Vector2()
var lock_rot := 0.0

@onready var foot : Sprite2D = $Foot
@onready var collider : Node2D = $StickCheck/CollisionShape2D
@onready var stick_check : Area2D = $StickCheck
@onready var player = $".."


func _integrate_forces(state : PhysicsDirectBodyState2D) -> void:
	if state.get_contact_count() > 0:
		collision_pos = state.get_contact_local_position(0)
	if frozen:
		state.linear_velocity = Vector2()
		state.angular_velocity = 0
		global_position = lock_pos
		global_rotation = lock_rot
		#foot.global_rotation = clampf(stick_check.global_position.angle_to_point(collision_pos) + deg_to_rad(180), deg_to_rad(150), deg_to_rad(210))
	#else:
		#foot.rotation = deg_to_rad(180)


func set_freeze(on : bool) -> bool :
	for area in stick_check.get_overlapping_areas():
		if area.get_collision_layer_value(6) and on:
			return false
	for body in stick_check.get_overlapping_bodies():
		if body.get_collision_layer_value(3) and on:
			body.linear_velocity = Vector2.from_angle(deg_to_rad(rotation_degrees - 180)) * player.PUSH_FORCE
			return false


	frozen = on
	lock_pos = global_position
	lock_rot = global_rotation
	custom_integrator = on
	return true
