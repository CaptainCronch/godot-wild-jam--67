extends CanvasLayer

const TEXT_TIME := 1.0

@export var quit_speed := 1.5
@export var return_speed := 80.0

var spins := 0.0
var message_tween : Tween
var collectible_tween : Tween
var title_tween : Tween

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
@onready var big_collectible = $BigCollectible
@onready var screen_fade = $ScreenFade
@onready var title_container = $TitleContainer
@onready var title_label = $TitleContainer/PanelContainer/MarginContainer/Title


func _enter_tree():
	Global.ui = self


func _ready():
	Global.message_label = message_label
	Global.message.connect(_on_message)
	Global.player.spun.connect(_on_spun)
	Global.collectible_get.connect(_on_collectible_get)

	message_tween = get_tree().create_tween()
	message_tween.kill()
	collectible_tween = get_tree().create_tween()
	collectible_tween.kill()
	title_tween = get_tree().create_tween()
	title_tween.kill()

	screen_fade.visible = true
	var fade_tween := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_property(screen_fade, "self_modulate", Color.TRANSPARENT, 5.0)
	fade_tween.tween_callback(func(): screen_fade.visible = false)


func _process(delta):
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
	spins_label.text = str(spins) + " flips" if spins < 10 else str(spins)


func _on_collectible_get(title : String):
	collectibles_panel.show()
	title_container.show()
	title_label.text = title
	title_label.visible_characters = 0
	if title_tween.is_valid(): title_tween.kill()
	title_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	title_tween.tween_property(title_label, "visible_characters", title.length(), TEXT_TIME)

	big_collectible.position = Vector2(435, 420)
	await get_tree().create_timer(1).timeout
	big_collectible.show()
	if collectible_tween.is_valid(): collectible_tween.kill()
	collectible_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	collectible_tween.tween_property(big_collectible, "global_position", collectibles_target_texture.global_position - (big_collectible.size / 2), 0.5)
	collectible_tween.tween_callback(func():
		big_collectible.hide()
		collectibles_texture.show()
		Global.goops += 1
		collectibles_label.text = str(Global.goops))
	collectible_tween.tween_interval(5)
	collectible_tween.tween_callback(func():
		collectibles_panel.hide()
		collectibles_texture.hide()
		title_container.hide())

	if Global.goops == 4:
		Global.message.emit("4 is enough to open that door now!")
		await get_tree().create_timer(3)
		Global.message.emit("")


func _on_message(text : String):
	message_panel.visible = true
	message_label.text = text
	if text.is_empty():
		message_panel.visible = false
		return
	message_label.visible_characters = 0
	if message_tween.is_valid(): message_tween.kill()
	message_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	message_tween.tween_property(message_label, "visible_characters", text.length(), TEXT_TIME)
