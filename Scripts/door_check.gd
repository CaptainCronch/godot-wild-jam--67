extends Area2D

var activated := false


func _on_body_entered(body):
	if body == Global.player.body and not activated and Global.goops >= 4:
		activated = true
		$"../Door".get_node("AnimationPlayer").play("open")
