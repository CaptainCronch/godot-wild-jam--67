extends Sprite2D

var og_pos : Vector2
var fly := Vector2(0, -50)
var time := 0.5
var spin_speed := 0.5

@onready var border = $Border
@onready var label = $Label


func _ready():
	border.rotation_degrees = randi_range(0, 360)

	var tween := get_tree().create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", og_pos + fly, time)

	var border_tween := get_tree().create_tween().bind_node(border)

	border_tween.set_ease(Tween.EASE_IN_OUT)
	border_tween.set_trans(Tween.TRANS_SINE)
	border_tween.set_loops()
	border_tween.tween_property(border, "scale", Vector2(0.9, 0.9), 2)
	border_tween.tween_property(border, "scale", Vector2(1.1, 1.1), 2)


func _process(delta):
	border.rotate(spin_speed * delta)
