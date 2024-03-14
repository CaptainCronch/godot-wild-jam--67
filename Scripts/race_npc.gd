extends Area2D

const BUBBLE := preload("res://Scenes/speech_bubble.tscn")

@export var dialogues : Array[String] = ["..."]

var dialogue_index := -1
var inside := false
var current_bubble : Node2D

@onready var prompt := $InteractPrompt


func _process(delta):
	if inside:
		if Input.is_action_just_released("interact"):
			if is_instance_valid(current_bubble): current_bubble.free()
			current_bubble = BUBBLE.instantiate()
			current_bubble.global_position = global_position + Vector2(0, -75)
			current_bubble.og_pos = current_bubble.global_position
			get_tree().current_scene.add_child(current_bubble)
			dialogue_index += 1
			if dialogue_index > dialogues.size() - 1:
				race_begin()
			current_bubble.get_child(0).text = dialogues[dialogue_index]
	else:
		dialogue_index = -1
		if is_instance_valid(current_bubble):
			current_bubble.queue_free()


func _physics_process(_delta):
	prompt.visible = false
	inside = false
	for body in get_overlapping_bodies():
		if body.name == "Body":
			prompt.visible = true
			inside = true


func race_begin():
	pass


func _on_body_entered(body):
	pass # Replace with function body.


func _on_body_exited(body):
	pass # Replace with function body.
