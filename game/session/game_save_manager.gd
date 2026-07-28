extends Node
var process_save:bool = true







const SAVE_PATH := "user://simple_save.tres"


var stability_bar_increase_factor:float = 1.0

var save_game: SaveGame = null
func _ready() -> void:
	delete_save()
#
	#if process_save:
		#var load_success:bool = load_save()
		#if !load_success:
			#print("No save data found")
			#create_save()

func delete_save() -> void:
	DirAccess.remove_absolute(SAVE_PATH)
	print("save data deleted")
 
func create_save() -> void:
	save_game = SaveGame.new()
	ResourceSaver.save(save_game,SAVE_PATH)
	print(ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE))
	print("save data created")
	
func save(_currency:Dictionary, _stats:Dictionary, _stat_levels):
	if process_save:
		save_game.currency = _currency
		save_game.player_stats = _stats
		save_game.player_stat_levels = _stat_levels
		ResourceSaver.save(save_game,SAVE_PATH)
		print("game saved")

func load_save() -> bool:
	if ResourceLoader.exists(SAVE_PATH):
		save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
		RunManager.saved_currency = save_game.currency
		print("game loaded")
		print(save_game)
		return true
	else: 
		print("No save data found")
		create_save()
		return false
