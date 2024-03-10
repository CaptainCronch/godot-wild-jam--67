extends Node2D

var flex_force := 120.0
var desired_rotation := 0.0
var rotation_speed := 1.0

var speed := 0.0

var gripped_r := false
var gripped_l := false

@export var body : RigidBody2D
@export var thigh_r : RigidBody2D
@export var thigh_l : RigidBody2D

@export var joint_thigh_r : PinJoint2D
@export var joint_thigh_l : PinJoint2D


func _process(delta):
	if Input.is_action_pressed("flex_up"):
		desired_rotation -= rotation_speed * delta
	elif Input.is_action_pressed("flex_down"):
		desired_rotation += rotation_speed * delta


func _physics_process(_delta):
	pass


func set_force_all(force : float):
	joint_thigh_r.motor_target_velocity = force
	joint_thigh_l.motor_target_velocity = -force
