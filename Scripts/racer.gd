extends Path2D

@export var speed := 80.0
@export var flip := 0.0

var started = false

@onready var path_follow : PathFollow2D = $PathFollow2D
@onready var sprite = $PathFollow2D/Sprite2D


func _ready():
	sprite.rotation_degrees = flip


func _process(delta):
	if started: path_follow.progress += speed * delta
	if path_follow.progress_ratio >= 1.0:
		Deejay.race_time = false
		path_follow.progress = 0
		started = false
		$"../EndRace".ended = true
		$"../StartRace".activated = false
		$"../Spawner".enabled = false
		Global.message.emit("You lost!!!")
		await get_tree().create_timer(3).timeout
		Global.message.emit("")

