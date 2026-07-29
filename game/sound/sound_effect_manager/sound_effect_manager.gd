class_name SoundEffectManager extends Node3D
##Class that keeps track of child AudioStreamPlayers and is called by other things to play them

var sounds:Dictionary[String,Variant]
@export var debug:bool
@export var persist:bool = false
#
func _ready():
	for child in get_children():
		if child is AudioStreamPlayer3D or child is  AudioStreamPlayer2D or child is AudioStreamPlayer:
			sounds[child.name] = child


func _play(_sound_names :PackedStringArray) -> void:

	for sound_name in _sound_names:
		if sounds.has(sound_name):
			if debug:
				print("playing ", sound_name)
			if persist:
				sounds[sound_name].reparent(get_tree().get_first_node_in_group("Game"))
				sounds[sound_name].finished.connect(sounds[sound_name].queue_free)
			sounds[sound_name].play()
		else:
			if debug:
				print("Sound ", sound_name, " not found")
				
