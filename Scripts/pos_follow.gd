extends Node2D

@export var target : Node2D
@export var offset := Vector2()
@export var use_starting_position_as_offset := true

var last_rotation := 0.0

var offset_bonus := 1.0
var max_velocity := 0.03

@onready var body : RigidBody2D = $"../../.."


func _ready():
	if not is_instance_valid(target):
		target = get_parent()

	if use_starting_position_as_offset:
		offset = target.position


func _process(_delta) -> void:
	offset_bonus = inverse_lerp(0.0, max_velocity, absf(target.global_rotation - last_rotation)) * 0.5 + 1
	target.position = offset * offset_bonus
	global_position = target.global_position

	last_rotation = target.global_rotation
