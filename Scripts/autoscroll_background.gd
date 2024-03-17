extends ParallaxBackground

var angle := 0.0


func _process(delta):
	scroll_offset += Vector2.from_angle(angle) * 500 * delta
	angle += delta / 4
