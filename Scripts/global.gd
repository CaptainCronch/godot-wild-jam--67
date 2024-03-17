extends Node

signal collectible_get(title : String)
signal message(text : String)

var goops := 0

var ui : CanvasLayer
var player : Node2D
var message_label : Label
var message_tween : Tween


func _ready():
	if is_instance_valid(get_tree().current_scene.get_node_or_null("PlayerFollow")):
		get_tree().current_scene.get_node_or_null("PlayerFollow").global_position = player.global_position
	if is_instance_valid(get_tree().current_scene.get_node_or_null("PlayerCam")):
		get_tree().current_scene.get_node_or_null("PlayerCam").global_position = player.global_position
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#get_window().mode = Window.MODE_FULLSCREEN


func _process(_delta):
	if Input.is_action_just_pressed("debug_key"):
		if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			Engine.max_fps = 0
		elif DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			Engine.max_fps = 60

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


#func decay_towards(value : float, target : float,
			#decay_power : float, delta : float = get_process_delta_time(),
			#round_threshold : float = 0.0) -> float :
#
	#var new_value := (value - target) * pow(2, -delta * decay_power) + target
#
	#if absf(new_value - target) < round_threshold:
		#return target
	#else:
		#return new_value
#
#
#func decay_angle_towards(value : float, target : float,
			#decay_power : float, delta : float = get_process_delta_time(),
			#round_threshold : float = 0.0) -> float :
#
	#var new_value := angle_difference(target, value) * pow(2, -delta * decay_power) + target
#
	#if absf(angle_difference(target, new_value)) < round_threshold:
		#return target
	#else:
		#return new_value
