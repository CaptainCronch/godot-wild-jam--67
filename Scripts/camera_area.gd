extends Area2D

@onready var pcam : PhantomCamera2D = $PhantomCamera2D


func _on_body_entered(_body):
	pcam.set_priority(2)


func _on_body_exited(_body):
	pcam.set_priority(0)
