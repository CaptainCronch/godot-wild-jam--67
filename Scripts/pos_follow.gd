extends Node2D

@export var target : Node2D
@export var offset := Vector2()
@export var use_starting_position_as_offset := true


func _ready():
	if not is_instance_valid(target):
		target = get_parent()

	if use_starting_position_as_offset:
		offset = position


func _process(_delta) -> void:
	global_position = target.global_position + offset
