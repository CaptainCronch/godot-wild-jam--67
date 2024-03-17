extends Sprite2D

const BOMB = preload("res://Scenes/bomb.tscn")
const SPAWN_SPEED := 150.0

@export var enabled := false
@export var spawn_time := 3.0

@onready var animation_player = $AnimationPlayer


func _ready():
	$Timer.start(spawn_time)


func _on_timer_timeout():
	if not enabled: return
	var new_bomb := BOMB.instantiate()
	get_tree().current_scene.add_child(new_bomb)
	new_bomb.global_position = global_position
	new_bomb.linear_velocity = Vector2(randf()*2-1, randf()*2-1) * SPAWN_SPEED
	new_bomb.angular_velocity = randf()*2-1 * (SPAWN_SPEED / 25)
	animation_player.speed_scale = 3.0
	await get_tree().create_timer(0.5).timeout
	animation_player.speed_scale = 1.0
