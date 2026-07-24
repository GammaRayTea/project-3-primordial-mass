class_name SoundEffectManager extends Node3D
##Class that keeps track of child AudioStreamPlayers and is called by other things to play them

var sounds:Dictionary[String,AudioStreamPlayer3D]
@export var debug:bool

#
func _ready():
	for child in get_children():
		if child is AudioStreamPlayer3D:
			sounds[child.name] = child


func _play(_sound_names :PackedStringArray) -> void:

	for sound_name in _sound_names:
		if sounds.has(sound_name):
			if debug:
				print("playing ", sound_name)
			sounds[sound_name].play()
		else:
			if debug:
				print("Sound ", sound_name, " not found")
