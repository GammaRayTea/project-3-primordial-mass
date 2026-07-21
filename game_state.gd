extends Node
var process_save:bool = true

var run_curreny:Dictionary[GlobalEnum.CURRENCY, int]

var stability_bar:TextureProgressBar

const SAVE_PATH := "user://simple_save.tres"




var save_game: SaveGame = null
func _init() -> void:
	for key in GlobalEnum.CURRENCY.values():
		run_curreny[key] = 0

func _ready() -> void:
	stability_bar = get_tree().get_first_node_in_group("StabilityBar")
	stability_bar.value = stability_bar.max_value
	
	
	if process_save:
		if ResourceLoader.exists(SAVE_PATH):
			save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
		else:
			save_game = SaveGame.new()
			ResourceSaver.save(save_game,SAVE_PATH)
			print(ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE))


func save(_currency:Dictionary):
	if process_save:
		save_game.add_currency()

func increase_stability(_by_value:float) -> void:
	stability_bar.value += _by_value

func decrease_stability(_by_value:float) -> void:
	stability_bar.value -= _by_value


func add_currency(_type:GlobalEnum.CURRENCY,_value:int):
	match _type:
		GlobalEnum.CURRENCY.STABILITY:
			increase_stability(_value)
		_:
			run_curreny[_type] += _value
