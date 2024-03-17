extends Area2D

@onready var wiggle : Sprite2D = $Wiggle


func _ready():
	var new_size : Vector2 = $CollisionShape2D.shape.size
	var new_image := wiggle.texture.get_image()
	new_image.resize(new_size.x, new_size.y, Image.INTERPOLATE_NEAREST)
	wiggle.texture = ImageTexture.create_from_image(new_image)
	#(wiggle.material as ShaderMaterial).set_shader_parameter("angle", deg_to_rad(global_rotation_degrees - 90))
	gravity_direction = Vector2.from_angle(deg_to_rad(global_rotation_degrees - 90))
