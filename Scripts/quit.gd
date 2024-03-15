extends ProgressBar

@export var quit_speed := 1.5
@export var return_speed := 80.0

var tween : Tween

@onready var audio : AudioStreamPlayer = $AudioStreamPlayer


func _process(delta):
	if Input.is_action_just_pressed("escape") and not audio.playing:
		audio.play()

	if Input.is_action_pressed("escape"):
		value = lerp(value, 105.0, quit_speed * delta)
	else:
		value -= return_speed * delta

	if is_equal_approx(value, 100.0) or value >= 100.0:
		get_tree().quit()


func _on_audio_finished():
	audio.pitch_scale = 1 + ((value / 100) * 2)
	if not is_zero_approx(value): audio.play()
