extends CanvasLayer

@export var quit_speed := 1.5
@export var return_speed := 80.0

@onready var quit_bar : ProgressBar = $QuitProgress2
@onready var audio = $QuitProgress2/AudioStreamPlayer


func _ready():
	$VBoxContainer/Found.text = "You found " + str(Global.goops) + "/9 Goops!"


func _process(delta):
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
