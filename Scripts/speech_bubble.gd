extends Node2D

var og_pos : Vector2
var offset := Vector2(0, -50)
var time := 0.5


func _ready():
	var tween = get_tree().create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", og_pos + offset, time)
