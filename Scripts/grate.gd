extends StaticBody2D

@onready var sprite : Sprite2D = $Sprite2D


func _ready():
	sprite.region_rect.size = 3.5 * ($CollisionShape2D.shape.size)
