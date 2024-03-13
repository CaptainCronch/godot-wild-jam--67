extends Node2D

const MAX_FLEX = 80.0

var desired_rotation := 45.0
var rotation_speed := 200.0

var gripped_r := false
var gripped_l := false

var foot_collider_r : Array[Node2D] = []
var foot_collider_l : Array[Node2D] = []

@export var body : RigidBody2D
@export var thigh_r : RigidBody2D
@export var thigh_l : RigidBody2D
@export var calf_r : RigidBody2D
@export var calf_l : RigidBody2D

@export var joint_thigh_r : PinSpringJoint2D
@export var joint_thigh_l : PinSpringJoint2D
@export var joint_calf_r : PinSpringJoint2D
@export var joint_calf_l : PinSpringJoint2D
@export var joint_foot_r : PinJoint2D
@export var joint_foot_l : PinJoint2D

@export var debug_label : Label


func _process(delta):
	if Input.is_action_pressed("flex_up"):
		desired_rotation = clampf(desired_rotation - (rotation_speed * delta), -MAX_FLEX, MAX_FLEX)
	elif Input.is_action_pressed("flex_down"):
		desired_rotation = clampf(desired_rotation + (rotation_speed * delta), -MAX_FLEX, MAX_FLEX)

	if Input.is_action_pressed("lock_right") and not gripped_r:
		if foot_collider_r.size() > 0:
			gripped_r = true
			joint_foot_r.node_b = joint_foot_r.get_path_to(foot_collider_r[0])
			joint_foot_r.global_position = calf_r.collision_pos
			calf_r.set_freeze(true)
	elif Input.is_action_just_released("lock_right"):
		gripped_r = false
		joint_foot_r.node_b = ""
		calf_r.set_freeze(false)

	if Input.is_action_pressed("lock_left") and not gripped_l:
		if foot_collider_l.size() > 0:
			gripped_l = true
			joint_foot_l.node_b = joint_foot_l.get_path_to(foot_collider_l[0])
			joint_foot_l.global_position = calf_l.collision_pos
			calf_l.set_freeze(true)
	elif Input.is_action_just_released("lock_left"):
		gripped_l = false
		joint_foot_l.node_b = ""
		calf_l.set_freeze(false)


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


func _on_right_body_entered(body):
	foot_collider_r.append(body)


func _on_right_body_exited(body):
	foot_collider_r.erase(body)


func _on_left_body_entered(body):
	foot_collider_l.append(body)


func _on_left_body_exited(body):
	foot_collider_l.erase(body)
