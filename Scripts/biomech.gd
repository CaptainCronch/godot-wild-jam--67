extends Node2D

const MAX_FLEX := 80.0
const PUSH_FORCE := 500.0

var desired_rotation := 45.0
var rotation_speed := 200.0

var blocked_r := false
var blocked_l := false

var foot_collider_r : Array[Node2D] = []
var foot_collider_l : Array[Node2D] = []

@export var body : RigidBody2D
@export var thigh_r : RigidBody2D
@export var thigh_l : RigidBody2D
@export var calf_r : RigidBody2D
@export var calf_l : RigidBody2D

var body_parts : Array[RigidBody2D]

@export var joint_thigh_r : PinSpringJoint2D
@export var joint_thigh_l : PinSpringJoint2D
@export var joint_calf_r : PinSpringJoint2D
@export var joint_calf_l : PinSpringJoint2D
@export var joint_foot_r : PinJoint2D
@export var joint_foot_l : PinJoint2D

@onready var prompts = $Body/Prompts
@onready var flex_up = $Body/Prompts/KeyHolder/FlexUp
@onready var flex_down = $Body/Prompts/KeyHolder2/FlexDown
@onready var left_leg = $Body/Prompts/KeyHolder3/LeftLeg
@onready var right_leg = $Body/Prompts/KeyHolder4/RightLeg

@onready var audio : AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	body_parts = [body, thigh_r, thigh_l, calf_r, calf_l]
	Global.player = self


func _process(delta):
	check_keys()

	var flex_dir := 0
	if Input.is_action_pressed("flex_up"): flex_dir -= 1
	if Input.is_action_pressed("flex_down"): flex_dir += 1

	desired_rotation = clampf(desired_rotation + ((rotation_speed * delta) * flex_dir), -MAX_FLEX, MAX_FLEX)

	if Input.is_action_pressed("lock_right") and not blocked_r:
		if foot_collider_r.size() > 0:
			if calf_r.set_freeze(true):
				blocked_r = true
				joint_foot_r.node_b = joint_foot_r.get_path_to(foot_collider_r[0])
				joint_foot_r.global_position = calf_r.collision_pos
				audio.play()
	elif Input.is_action_just_released("lock_right"):
		blocked_r = false
		joint_foot_r.node_b = ""
		calf_r.set_freeze(false)

	if Input.is_action_pressed("lock_left") and not blocked_l:
		if foot_collider_l.size() > 0:
			if calf_l.set_freeze(true):
				blocked_l = true
				joint_foot_l.node_b = joint_foot_l.get_path_to(foot_collider_l[0])
				joint_foot_l.global_position = calf_l.collision_pos
				audio.play()
	elif Input.is_action_just_released("lock_left"):
		blocked_l = false
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


func check_keys():
	if Input.is_action_pressed("flex_up"): flex_up.self_modulate = Color.WEB_GRAY
	else: flex_up.self_modulate = Color.WHITE

	if Input.is_action_pressed("flex_down"): flex_down.self_modulate = Color.WEB_GRAY
	else: flex_down.self_modulate = Color.WHITE

	if Input.is_action_pressed("lock_left"): left_leg.self_modulate = Color.WEB_GRAY
	else: left_leg.self_modulate = Color.WHITE

	if Input.is_action_pressed("lock_right"): right_leg.self_modulate = Color.WEB_GRAY
	else: right_leg.self_modulate = Color.WHITE


func _on_right_body_entered(_body):
	foot_collider_r.append(_body)


func _on_right_body_exited(_body):
	foot_collider_r.erase(_body)


func _on_left_body_entered(_body):
	foot_collider_l.append(_body)


func _on_left_body_exited(_body):
	foot_collider_l.erase(_body)
