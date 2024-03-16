extends CanvasLayer

@export var quit_speed := 1.5
@export var return_speed := 80.0

var spins := 0.0

@onready var quit_bar : ProgressBar = $QuitProgress
@onready var audio = $QuitProgress/AudioStreamPlayer
@onready var message_label : Label = $MarginContainer/MessageContainer/MarginContainer/Message
@onready var message_panel = $MarginContainer/MessageContainer
@onready var spins_label = $MarginContainer/SpinsContainer/MarginContainer/Spins
@onready var spins_panel = $MarginContainer/SpinsContainer
@onready var collectibles_label = $MarginContainer/CollectiblesContainer/MarginContainer/HSplitContainer/Collectibles
@onready var collectibles_panel = $MarginContainer/CollectiblesContainer
@onready var collectibles_texture = $CollectiblesTexture
@onready var collectibles_anim = $CollectiblesTexture/AnimationPlayer
@onready var collectibles_target_texture = $MarginContainer/CollectiblesContainer/MarginContainer/HSplitContainer/TextureRect


func _ready():
	Global.message_label = message_label
	Global.player.spun.connect(_on_spun)


func _process(delta):
	message_panel.visible = not message_label.text.is_empty()

	if Input.is_action_just_pressed("escape") and not audio.playing:
		audio.play()

	if Input.is_action_pressed("escape"):
		quit_bar.value = lerp(quit_bar.value, 105.0, quit_speed * delta)
	else:
		quit_bar.value -= return_speed * delta

	if is_equal_approx(quit_bar.value, 100.0) or quit_bar.value >= 100.0:
		get_tree().quit()

	collectibles_texture.position = collectibles_target_texture.global_position


func _on_audio_finished():
	audio.pitch_scale = 1 + ((quit_bar.value / 100) * 2)
	if not is_zero_approx(quit_bar.value): audio.play()


func _on_spun(amount : float):
	spins_panel.visible = amount != 0.0
	spins += amount
	spins_label.text = str(spins)
