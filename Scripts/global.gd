extends Node

const TEXT_TIME := 1.0

var player : Node2D
var message_label : Label
var message_tween : Tween


func _ready():
	message_tween = get_tree().create_tween()
	message_tween.kill()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#get_window().mode = Window.MODE_FULLSCREEN


#func _process(_delta):
	#if Input.is_action_just_pressed("debug_key"):
		#if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			#Engine.max_fps = 0
		#elif DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			#Engine.max_fps = 60

	#if Input.is_action_just_pressed("escape"):
		#get_tree().quit() # temporary for testing

	#if Input.is_action_just_pressed("fullscreen"):
		#if get_window().mode != Window.MODE_FULLSCREEN:
			#get_window().mode = Window.MODE_FULLSCREEN
		#else:
			#get_window().mode = Window.MODE_WINDOWED


#func mouse_switch(pos := Vector2(0, 0)) -> void :
	#if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#get_window().warp_mouse(pos)
	#elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func set_message(text : String):
	message_label.text = text
	message_label.visible_characters = 0
	if message_tween.is_valid(): message_tween.kill()
	message_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	message_tween.tween_property(message_label, "visible_characters", text.length(), TEXT_TIME)


func decay_towards(value : float, target : float,
			decay_power : float, delta : float = get_process_delta_time(),
			round_threshold : float = 0.0) -> float :

	var new_value := (value - target) * pow(2, -delta * decay_power) + target

	if absf(new_value - target) < round_threshold:
		return target
	else:
		return new_value


func decay_angle_towards(value : float, target : float,
			decay_power : float, delta : float = get_process_delta_time(),
			round_threshold : float = 0.0) -> float :

	var new_value := angle_difference(target, value) * pow(2, -delta * decay_power) + target

	if absf(angle_difference(target, new_value)) < round_threshold:
		return target
	else:
		return new_value
