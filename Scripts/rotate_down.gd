extends Sprite2D

@export var damp := 5.0


func _process(delta):
	global_rotation = lerp_angle(global_rotation, 0.0, damp * delta)
