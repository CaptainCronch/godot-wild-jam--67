extends Area2D

const BUBBLE := preload("res://Scenes/speech_bubble.tscn")

@export var dialogues : Array[String] = ["..."]
@export var give_goop := false
@export var goop_name : String
@export var post_dialogues : Array[String] = ["..."]

var last_message := ""
var dialogue_index := -1
var inside := false
var current_bubble : CanvasItem

@onready var prompt := $InteractPrompt
@onready var animation_player := $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D

func _process(_delta):
	if inside:
		if Input.is_action_just_released("interact"):
			var rand := randi_range(0, 1)
			if animation_player.is_playing(): animation_player.stop()
			if rand: animation_player.play("jiggle_up")
			else: animation_player.play("jiggle_down")

			if is_instance_valid(current_bubble): current_bubble.free()
			current_bubble = BUBBLE.instantiate()
			current_bubble.global_position = global_position + Vector2(0, -100).rotated(global_rotation)
			current_bubble.global_rotation = global_rotation
			current_bubble.og_pos = current_bubble.global_position
			get_tree().current_scene.add_child(current_bubble)

			dialogue_index += 1
			if dialogue_index > dialogues.size() - 1:
				dialogue_index = 0
				if give_goop:
					give_goop = false
					dialogue_index = -1
					Global.message.emit("")
					last_message = ""
					Global.collectible_get.emit(goop_name)
					dialogues = post_dialogues
					return
			audio.play()
			Global.message.emit(dialogues[dialogue_index])
			last_message = dialogues[dialogue_index]
	else:
		if not last_message.is_empty():
			Global.message.emit("")
			last_message = ""
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
