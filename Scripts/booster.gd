extends Area2D

@export var strength := 1000.0

@onready var line : Line2D = $Line2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _process(_delta):
	line.points[1] = sprite.position + sprite.offset


func _on_body_entered(body):
	if body == Global.player.body:
		for part in Global.player.body_parts:
			part.linear_velocity = Vector2.from_angle(deg_to_rad(rotation_degrees - 90)) * strength
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play("bounce")
		audio.play()
		return

	for limb in Global.player.body_parts:
		if body == limb: return

	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("bounce")
	audio.play()
	body.linear_velocity = Vector2.from_angle(deg_to_rad(rotation_degrees - 90)) * strength
