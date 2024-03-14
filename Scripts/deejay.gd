extends Node

# bass always stays
# chords whenever
# drums most of the time (unless to cut them a little for tension) (nah constant)
# FAST whenever but tension
# ambient could replace the bass (interchangeable) if you dont play one you gotta play the other cuz they have the same chord structure
# melody plays randomly in fifths

const AMBIENT := preload("res://Assets/Music/LevelTheme AMBIENT.mp3") #64
const BASS := preload("res://Assets/Music/LevelTheme BASS.mp3") #32
const DRUMS := preload("res://Assets/Music/LevelTheme DRUMS.mp3") #32
const FAST := preload("res://Assets/Music/LevelTheme FAST.mp3") #24
const MELODIES := [ #32
		preload("res://Assets/Music/LevelTheme MELODY A.mp3"),
		preload("res://Assets/Music/LevelTheme MELODY B.mp3"),
		preload("res://Assets/Music/LevelTheme MELODY C.mp3"),
		preload("res://Assets/Music/LevelTheme MELODY D.mp3"),
		preload("res://Assets/Music/LevelTheme MELODY E.mp3"),
]

var music_bus := AudioServer.get_bus_index("Music")
var ambient_bus := AudioServer.get_bus_index("Ambient")
var bass_bus := AudioServer.get_bus_index("Bass")
var drums_bus := AudioServer.get_bus_index("Drums")
var fast_bus := AudioServer.get_bus_index("Fast")
var melody_bus := AudioServer.get_bus_index("Melody")

var ambient : AudioStreamPlayer
var bass : AudioStreamPlayer
var drums : AudioStreamPlayer
var fast : AudioStreamPlayer
var melody : AudioStreamPlayer

var bass_loops := 0
var drum_loops := 0

var race_time := false

func _ready():
	AudioServer.set_bus_mute(music_bus, false)

	ambient = AudioStreamPlayer.new()
	add_child(ambient)
	ambient.set_bus("Ambient")
	bass = AudioStreamPlayer.new()
	add_child(bass)
	bass.set_bus("Bass")
	drums = AudioStreamPlayer.new()
	add_child(drums)
	drums.set_bus("Drums")
	fast = AudioStreamPlayer.new()
	add_child(fast)
	fast.set_bus("Fast")
	melody = AudioStreamPlayer.new()
	add_child(melody)
	melody.set_bus("Melody")

	ambient.stream = AMBIENT
	bass.stream = BASS
	drums.stream = DRUMS
	fast.stream = FAST
	melody.stream = MELODIES[randi_range(0, MELODIES.size() - 1)]

	ambient.finished.connect(_on_ambient_finished)
	bass.finished.connect(_on_bass_finished)
	drums.finished.connect(_on_drums_finished)
	fast.finished.connect(_on_fast_finished)
	melody.finished.connect(_on_melody_finished)

	ambient.play()
	drums.play()
	bass.play()
	fast.play()
	melody.play()

	reset_music()


func reset_music():
	AudioServer.set_bus_mute(ambient_bus, false)
	AudioServer.set_bus_mute(bass_bus, true)
	AudioServer.set_bus_mute(drums_bus, false)
	AudioServer.set_bus_mute(fast_bus, true)
	AudioServer.set_bus_mute(melody_bus, true)


func _on_ambient_finished():
	ambient.play()
	if race_time:
		AudioServer.set_bus_mute(ambient_bus, false)
		AudioServer.set_bus_mute(bass_bus, false)
		return
	var roll := randi_range(0, 3) # 3 both, 1 ambient
	if roll == 0:
		AudioServer.set_bus_mute(ambient_bus, false)
		AudioServer.set_bus_mute(bass_bus, true)
	else:
		AudioServer.set_bus_mute(ambient_bus, false)
		AudioServer.set_bus_mute(bass_bus, false)



func _on_bass_finished():
	bass.play()


func _on_drums_finished():
	drums.play()
	if drum_loops == 0:
		drum_loops += 1
	else:
		if race_time:
			AudioServer.set_bus_mute(drums_bus, false)
			return
		var roll := randi_range(0, 24) # 1/25 to be muted
		drum_loops = 0
		if roll == 0:
			AudioServer.set_bus_mute(drums_bus, true)
		else:
			AudioServer.set_bus_mute(drums_bus, false)


func _on_fast_finished():
	fast.play()
	if race_time:
		AudioServer.set_bus_mute(fast_bus, false)
	else:
		AudioServer.set_bus_mute(fast_bus, true)


func _on_melody_finished():
	var roll := randi_range(0, 2) # 1/3 chance to play random
	if roll == 0:
		var random_song := randi_range(0, MELODIES.size() - 1)
		melody.stream = MELODIES[random_song]
		AudioServer.set_bus_mute(melody_bus, false)
	else:
		AudioServer.set_bus_mute(melody_bus, true)
	melody.play()
