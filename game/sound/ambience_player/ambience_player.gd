class_name AmbiencePlayer extends Node2D

enum INTENSITY {LOW,MEDIUM,HIGH}

var current_density:float = 0.3:
	set(_value):
		if max_density > _value and _value > min_density:
			current_density = _value
@export var min_density:float = 0.3
@export var max_density:float = 0.7


var min_intensity:float = 0.0
var max_intensity:float = 1.0

var current_intensity:float = 0.0:
	set(value):
		current_intensity = clamp(value, 0.0, 1.0)


@export var drone_player:AudioStreamPlayer
@export var stream_player_2d_template:AudioStreamPlayer2D
@export var center_marker:Marker2D

@export_category("Sample Sets")
@export var low_samples:Array[AudioStream]
@export var medium_samples:Array[AudioStream]
@export var high_samples:Array[AudioStream]

@export_category("Probablity Curves")
@export var low_curve:Curve
@export var medium_curve:Curve
@export var high_curve:Curve

var low

var low_players:Array[AudioStreamPlayer2D]
var medium_players:Array[AudioStreamPlayer2D]
var high_players:Array[AudioStreamPlayer2D]

func _ready():
	GlobalSoundManager.ambience_player = self



func start() -> void:
	process_mode =Node.PROCESS_MODE_INHERIT
	drone_player.volume_db = -60
	drone_player.play()
	var tween  = GlobalSoundManager.fade_player(drone_player, 0.5, 0.0)



var increment_counter:int = 60
func _physics_process(_delta) -> void:
	if increment_counter< 60 * 1.0:
		increment_counter+=1
	else:

		increment_counter = 0
		if randf() < low_curve.sample(current_intensity) * current_density:
			play_sample(INTENSITY.LOW)
		if randf() < medium_curve.sample(current_intensity) * current_density:
			play_sample(INTENSITY.MEDIUM)
		if randf() < high_curve.sample(current_intensity) * current_density:
			play_sample(INTENSITY.HIGH)
		current_intensity -= 0.001
		current_density -= 0.001
		
		

func play_sample(_intensity:INTENSITY) ->void:
	var player = stream_player_2d_template.duplicate()
	add_child(player)
	player.finished.connect(player.queue_free)
	
	player.position = calculate_random_position()
	
	player.stream = choose_sample(_intensity)
	
	player.play()
	#print("played " ,INTENSITY.keys()[_intensity], " at position ", player.position)

func choose_sample(_intensity:INTENSITY) -> AudioStream:
	var sample:AudioStream
	match _intensity:
		INTENSITY.LOW:
			sample = low_samples.pick_random()
		INTENSITY.MEDIUM:
			sample = medium_samples.pick_random()
		INTENSITY.HIGH:
			sample = high_samples.pick_random()
	return sample



func calculate_random_position()-> Vector2:
	var pos:Vector2 = Vector2(-400,0).rotated(randf()*2*PI) + center_marker.position
	return pos
