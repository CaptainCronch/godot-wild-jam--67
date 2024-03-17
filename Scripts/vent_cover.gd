extends RigidBody2D


func _on_body_entered(body):
	var check := false
	for part in Global.player.body_parts:
		if body == part:
			check = true
	if check:
		for part in Global.player.body_parts:
			part.gravity_scale = 1.0
		gravity_scale = 1.0
		await get_tree().create_timer(5.0).timeout
		Deejay.start_music()
		queue_free()
