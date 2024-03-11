extends Node2D

var desired_rotation := 60.0
var rotation_speed := 150.0

var gripped_r := false
var gripped_l := false

@export var body : RigidBody2D
@export var thigh_r : RigidBody2D
@export var thigh_l : RigidBody2D
@export var calf_r : RigidBody2D
@export var calf_l : RigidBody2D

@export var joint_thigh_r : PinSpringJoint2D
@export var joint_thigh_l : PinSpringJoint2D
@export var joint_calf_r : PinSpringJoint2D
@export var joint_calf_l : PinSpringJoint2D


func _process(delta):
	if Input.is_action_pressed("flex_up"):
		desired_rotation = clampf(desired_rotation - (rotation_speed * delta), -60, 60)
	elif Input.is_action_pressed("flex_down"):
		desired_rotation = clampf(desired_rotation + (rotation_speed * delta), -60, 60)

	if Input.is_action_pressed("lock_right"):
		if calf_r.get_contact_count() > 0:
			gripped_r = true
			calf_r.set_freeze(true)
	elif Input.is_action_just_released("lock_right"):
		gripped_r = false
		calf_r.set_freeze(false)


func _physics_process(_delta):
	set_force_all()


func set_force_all():
	joint_thigh_r.rest_angle_rads = deg_to_rad(desired_rotation)
	joint_thigh_l.rest_angle_rads = deg_to_rad(-desired_rotation - 180)
	joint_calf_r.rest_angle_rads = deg_to_rad(desired_rotation / 2)
	joint_calf_l.rest_angle_rads = deg_to_rad(-(desired_rotation / 2))


func normalize_ang(ang):
		while ang > PI:
			ang -= PI*2
		while ang < -PI:
			ang += PI*2
		return ang
