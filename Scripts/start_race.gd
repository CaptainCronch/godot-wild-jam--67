extends Area2D


var activated = false


func _on_body_entered(body):
	if body == Global.player.body and not activated:
		Deejay.race_time = true
		$"../EndRace".ended = false
		activated = true
		Global.player.pause(true)
		Global.message.emit("3")
		await get_tree().create_timer(1).timeout
		Global.message.emit("2")
		await get_tree().create_timer(1).timeout
		Global.message.emit("1")
		await get_tree().create_timer(1).timeout
		Global.message.emit("GO!!!")
		Global.player.pause(false)
		$"../Racer".started = true
		$"../Spawner".enabled = true
		await get_tree().create_timer(1).timeout
		Global.message.emit("")
