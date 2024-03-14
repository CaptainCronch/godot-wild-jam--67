extends RigidBody2D

@export var time_to_boom := 3.0
@export var power := 1000.0

@onready var checker = $Checker


func _ready():
	$Timer.start(time_to_boom)


func _on_timer_timeout():
	for body in checker.get_overlapping_bodies():
		if body != self and (body as PhysicsBody2D).is_class("RigidBody2D"):
			var distance_factor := (inverse_lerp(0, $Checker/CollisionShape2D.shape.radius
					, global_position.distance_to(body.global_position)) * -0.5) + 1
			print(distance_factor)
			if distance_factor < 0.5: return
			body.linear_velocity += global_position.direction_to(body.global_position) * distance_factor * power
	queue_free()
