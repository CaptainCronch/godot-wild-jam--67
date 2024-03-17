extends Area2D

var ended = true
var given = false


func _on_body_entered(body):
	if body == Global.player.body and not ended:
		Deejay.race_time = false
		ended = true
		$"../Spawner".enabled = false
		$"../StartRace".activated = false
		$"../Racer".started = false
		$"../Racer".get_child(0).progress = 0
		Global.message.emit("You won!!!")
		await get_tree().create_timer(1).timeout
		Global.message.emit("")
		if not given: Global.collectible_get.emit("Race Zone")
		given = true
