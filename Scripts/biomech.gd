extends Node2D

signal spun(amount : float)

const MAX_FLEX := 80.0
const PUSH_FORCE := 350.0
const INACTIVITY_TIME := 3.0

var desired_rotation := 45.0
var rotation_speed := 200.0

var tracked_rotation := 0.0

var blocked_r := false
var blocked_l := false

var foot_collider_r : Array[Node2D] = []
var foot_collider_l : Array[Node2D] = []

var inactive_tween : Tween
var first_pressed = false

var respawn_pos := Vector2()
var respawn_time := 1.0
var paused := false

@export var body : RigidBody2D
@export var thigh_r : RigidBody2D
@export var thigh_l : RigidBody2D
@export var calf_r : RigidBody2D
@export var calf_l : RigidBody2D

var body_parts : Array[RigidBody2D]
var joints : Array[PinSpringJoint2D]

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

@onready var grab_audio : AudioStreamPlayer = $Grab
@onready var impact_audio : AudioStreamPlayer = $Impact
@onready var collectible_audio : AudioStreamPlayer = $CollectibleGet
@onready var collectible_particles : CPUParticles2D = $CollectibleParticles
@onready var respawn_audio : AudioStreamPlayer = $Respawn


func _enter_tree():
	Global.player = self


func _ready():
	respawn_pos = global_position
	inactive_tween = get_tree().create_tween()
	inactive_tween.kill()
	body_parts = [body, thigh_r, thigh_l, calf_r, calf_l]
	joints = [$Body/PinThighR, $Body/PinThighL, $ThighR/PinCalfR, $ThighL/PinCalfL]

	Global.collectible_get.connect(_on_collectible_get)
	for part in body_parts:
		part.gravity_scale = 0.25


func _process(delta):
	if Input.is_action_just_pressed("retry"): respawn()

	check_keys()
	check_spins(delta)

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
				grab_audio.play()
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
				grab_audio.play()
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
	var active := false
	if Input.is_action_just_pressed("flex_up"):
		flex_up.self_modulate = Color.WEB_GRAY
		active = true
	elif Input.is_action_just_released("flex_up"): flex_up.self_modulate = Color.WHITE

	if Input.is_action_just_pressed("flex_down"):
		flex_down.self_modulate = Color.WEB_GRAY
		active = true
	elif Input.is_action_just_released("flex_down"): flex_down.self_modulate = Color.WHITE

	if Input.is_action_just_pressed("lock_left"):
		left_leg.self_modulate = Color.WEB_GRAY
		active = true
	elif Input.is_action_just_released("lock_left"): left_leg.self_modulate = Color.WHITE

	if Input.is_action_just_pressed("lock_right"):
		right_leg.self_modulate = Color.WEB_GRAY
		active = true
	elif Input.is_action_just_released("lock_right"): right_leg.self_modulate = Color.WHITE

	if active:
		first_pressed = true
		for key in prompts.get_children():
			key.get_child(0).modulate = Color.WHITE
		inactive_tween.kill()
		return

	if inactive_tween.is_valid(): return
	if not first_pressed: return

	inactive_tween = get_tree().create_tween()
	inactive_tween.tween_interval(INACTIVITY_TIME)
	inactive_tween.tween_property(flex_up, "modulate", Color.TRANSPARENT, 2.0)
	inactive_tween.parallel().tween_property(flex_down, "modulate", Color.TRANSPARENT, 2.0)
	inactive_tween.parallel().tween_property(left_leg, "modulate", Color.TRANSPARENT, 2.0)
	inactive_tween.parallel().tween_property(right_leg, "modulate", Color.TRANSPARENT, 2.0)


func check_spins(delta : float) -> void :
	if paused: return
	tracked_rotation += body.angular_velocity * delta
	if absf(tracked_rotation) >= deg_to_rad(360):
		spun.emit(1)
		tracked_rotation -= deg_to_rad(360) * signf(tracked_rotation)


func respawn():
	respawn_audio.play()

	pause(true)

	var limb_positions : PackedVector2Array = []

	for limb in body_parts:
		if limb == body: continue
		limb_positions.append(limb.global_position - body.global_position)

	#await get_tree().create_timer(respawn_time).timeout

	body.global_position = respawn_pos
	var i := 0
	for limb in body_parts:
		if limb == body: continue
		limb.global_position = body.global_position + limb_positions[i]
		i += 1

	pause(false)

	for n in range(5):
		await get_tree().create_timer(0.1).timeout
		body.global_position = respawn_pos
		i = 0
		for limb in body_parts:
			if limb == body: continue
			limb.global_position = body.global_position + limb_positions[i]
			i += 1


func pause(on : bool) -> void :
	paused = on
	for joint in joints:
		joint.paused = on
	for part in body_parts:
		part.freeze = on


func _on_collectible_get(_title : String):
	collectible_audio.play()
	collectible_particles.global_position = body.global_position
	collectible_particles.global_rotation = 0
	collectible_particles.emitting = true
	pause(true)
	await get_tree().create_timer(3).timeout
	pause(false)


func _on_right_body_entered(_body):
	foot_collider_r.append(_body)


func _on_right_body_exited(_body):
	foot_collider_r.erase(_body)


func _on_left_body_entered(_body):
	foot_collider_l.append(_body)


func _on_left_body_exited(_body):
	foot_collider_l.erase(_body)


func _on_body_body_entered(body):
	impact_audio.play()
