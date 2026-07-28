extends Node

enum SONGS {MENU,MAIN_AMBIENCE}
var music_player:AudioStreamPlayer
var ambience_player:AmbiencePlayer
var song_paths:Dictionary[SONGS,String] = {
	SONGS.MENU:"res://assets/sound/music/main_menu.tres",
	SONGS.MAIN_AMBIENCE:"",
}
signal music_faded



var callables_on_faded:Array[Callable] = []
func _ready():
	music_faded.connect(on_music_faded)
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
var music_tween:Tween
func fade_out_music(_time:float = 1.5) -> void:
	if music_tween:
		music_tween.kill()
		music_tween = null
	music_tween = fade_player(music_player,_time, -60)
	await music_tween.finished
	music_faded.emit()

func fade_player(_player:AudioStreamPlayer, _time:float = 1.5, _target_vol_db:float = 0.0) -> Tween:
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(_player,"volume_db", _target_vol_db, _time)
	return tween

func queue_music(_song:SONGS, _immediate:bool = false) -> void:

	if _immediate:
		var song:AudioStreamInteractive= load(song_paths[_song])
		if song:
			if music_tween:
				music_tween.kill()
				music_tween = null
				if music_player.playing:
					start_music(song)
					return
			if !music_player.playing:
				start_music(song)
				return
		
	else:
		callables_on_faded.append(queue_music.bind(_song, true))



func start_music(_song:AudioStreamInteractive) -> void:
	music_player.volume_db = 0.0
	music_player.stream = _song
	music_player.play()
	

func on_music_faded() -> void:
	music_player.stop()
	for callable in callables_on_faded:
		callable.call()
	callables_on_faded.clear()


func start_ambience() -> void:
	ambience_player.start()

func stop_ambience() -> void:
	var tween:Tween = get_tree().create_tween()
	var bus_id = AudioServer.get_bus_index("Ambience")
	var base_volume = AudioServer.get_bus_volume_db(bus_id)
	tween.tween_method(func(v): AudioServer.set_bus_volume_db(bus_id, v), AudioServer.get_bus_volume_db(bus_id), -60, 1.5)
	await tween.finished
	ambience_player.stop()
	AudioServer.set_bus_volume_db(bus_id,base_volume)

func increase_intensity(_amount:float) -> void:
	ambience_player.current_intensity += _amount
	ambience_player.current_density += _amount
