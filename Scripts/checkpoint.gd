extends Area2D


func _on_body_entered(body):
	if body == Global.player.body:
		Global.player.respawn_pos = global_position + Vector2(0, -200)
