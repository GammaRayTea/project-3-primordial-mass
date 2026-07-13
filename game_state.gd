extends Node
@export var save:bool = false
const SAVE_PATH := "user://simple_save.tres"

var save_game: SaveGame = null

func _ready() -> void:
	save_game = SaveGame.new()
	
	
	if save:
		if ResourceLoader.exists(SAVE_PATH):
			save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
		else:
			save_game = SaveGame.new()
			ResourceSaver.save(save_game,SAVE_PATH)
			print(ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE))
