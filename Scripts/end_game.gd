extends Area2D

var activated := false


func _on_body_entered(body):
	if body == Global.player.body and not activated:
		activated = true
		Deejay.shut_up(true)
		await get_tree().create_timer(10).timeout
		Deejay.shut_up(false)
		get_tree().change_scene_to_packed(preload("res://Scenes/end_game_screen.tscn"))
