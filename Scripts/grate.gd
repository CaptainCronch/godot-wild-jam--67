extends StaticBody2D

@onready var sprite : Sprite2D = $Sprite2D


func _ready():
	sprite.region_rect.size = 7 * ($CollisionShape2D.shape.size)
