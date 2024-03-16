extends Area2D

@onready var wiggle : Sprite2D = $Wiggle


func _ready():
	wiggle.texture.size = $CollisionShape2D.shape.size
	#(wiggle.material as ShaderMaterial).set_shader_parameter("angle", deg_to_rad(global_rotation_degrees - 90))
	gravity_direction = Vector2.from_angle(deg_to_rad(global_rotation_degrees - 90))
