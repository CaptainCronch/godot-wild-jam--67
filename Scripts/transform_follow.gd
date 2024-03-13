extends Node2D

@export var target : Node2D
@export var damp := 0.0
@export var player := false
@export var auto_enable := false


func _ready():
	if auto_enable:
		visible = true
	if player:
		target = target.get_node("Body")


func _process(delta):
	global_position = lerp(global_position, target.global_position, damp * delta) if damp > 0.0 else target.global_position
	global_rotation = lerp_angle(global_rotation, target.global_rotation, damp * delta) if damp > 0.0 else target.global_rotation
