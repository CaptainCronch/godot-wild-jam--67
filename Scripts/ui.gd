extends CanvasLayer

@export var quit_speed := 1.5
@export var return_speed := 80.0

@onready var quit_bar : ProgressBar = $QuitProgress
@onready var audio = $QuitProgress/AudioStreamPlayer
@onready var message_label : Label = $MarginContainer/PanelContainer/MarginContainer/Message
@onready var panel_container = $MarginContainer/PanelContainer


func _ready():
	Global.message_label = message_label


func _process(delta):
	panel_container.visible = not message_label.text.is_empty()

	if Input.is_action_just_pressed("escape") and not audio.playing:
		audio.play()

	if Input.is_action_pressed("escape"):
		quit_bar.value = lerp(quit_bar.value, 105.0, quit_speed * delta)
	else:
		quit_bar.value -= return_speed * delta

	if is_equal_approx(quit_bar.value, 100.0) or quit_bar.value >= 100.0:
		get_tree().quit()


func _on_audio_finished():
	audio.pitch_scale = 1 + ((quit_bar.value / 100) * 2)
	if not is_zero_approx(quit_bar.value): audio.play()
