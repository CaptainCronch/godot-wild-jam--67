extends Area2D

const BUBBLE := preload("res://Scenes/speech_bubble.tscn")

@export var dialogues : Array[String] = ["..."]

var dialogue_index := -1
var inside := false
var current_bubble : CanvasItem

@onready var prompt := $InteractPrompt
@onready var animation_player := $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D

func _process(delta):
	if inside:
		if Input.is_action_just_released("interact"):
			var rand := randi_range(0, 1)
			if animation_player.is_playing(): animation_player.stop()
			if rand: animation_player.play("jiggle_up")
			else: animation_player.play("jiggle_down")

			audio.play()

			if is_instance_valid(current_bubble): current_bubble.free()
			current_bubble = BUBBLE.instantiate()
			current_bubble.global_position = global_position + Vector2(0, -100)
			current_bubble.og_pos = current_bubble.global_position
			get_tree().current_scene.add_child(current_bubble)
			dialogue_index += 1
			if dialogue_index > dialogues.size() - 1:
				dialogue_index = 0
			current_bubble.label.text = dialogues[dialogue_index]
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


func _on_animation_finished(_anim_name):
	animation_player.play("idle")
