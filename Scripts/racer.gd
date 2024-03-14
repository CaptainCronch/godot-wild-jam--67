extends Path2D

@export var speed := 200.0
@export var time_til_start := 3.0

var started = false

@onready var path_follow_2d : PathFollow2D = $PathFollow2D


func _ready():
	await get_tree().create_timer(time_til_start).timeout
	started = true


func _process(delta):
	if started: path_follow_2d.progress += speed * delta
