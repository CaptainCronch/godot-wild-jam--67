extends Area2D


func _on_body_entered(body):
	for child in get_children():
		if child is Sprite2D: child.enabled = true


func _on_body_exited(body):
	for child in get_children():
		if child is Sprite2D: child.enabled = false
