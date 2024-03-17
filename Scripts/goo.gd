extends Area2D

@onready var sprite : Sprite2D = $Sprite2D


func _ready():
	sprite.region_rect.size = 7 * ($CollisionShape2D.shape.size)


func _on_body_entered(body):
	if body.name == "Body":
		body.get_parent().respawn()
