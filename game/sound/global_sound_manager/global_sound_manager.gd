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

func fade_out_music(_time:float = 1.5) -> void:
	var tween:Tween = fade_player(music_player,_time, -60)
	await tween.finished
	music_faded.emit()

func fade_player(_player:AudioStreamPlayer, _time:float = 1.5, _target_vol_db:float = 0.0) -> Tween:
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(_player,"volume_db", _target_vol_db, _time)
	return tween

func queue_music(_song:SONGS, _immediate:bool = false) -> void:
	if _immediate:
		var song:AudioStreamInteractive= load(song_paths[_song])
		if song:
			music_player.volume_db = 0.0
			music_player.stream = song
			music_player.play()
		
	else:
		callables_on_faded.append(queue_music.bind(_song, true))

func on_music_faded() -> void:
	for callable in callables_on_faded:
		callable.call()
	callables_on_faded.clear()


func start_ambience() -> void:
	ambience_player.start()
