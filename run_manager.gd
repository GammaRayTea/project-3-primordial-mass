class_name RunManager extends Node
@export var max_stability = 100.0:
	set(value):
		max_stability = value
		if stability_bar:
			stability_bar.max_value = max_stability

@export var stability_bar:TextureProgressBar

@export var run_curreny:Dictionary[GlobalEnum.CURRENCY, int] = {}
func _init() -> void:
	for key in GlobalEnum.CURRENCY.values():
		run_curreny[key] = 0


#TODO: Move dungeon start here

func increase_stability(_by_value:float) -> void:
	stability_bar.value += _by_value

func decrease_stability(_by_value:float) -> void:
	stability_bar.value -= _by_value


func lock_progress() -> void:
	GameState.save(run_curreny)

	

func add_currency(_type:GlobalEnum.CURRENCY,_value:int):
	match _type:
		GlobalEnum.CURRENCY.STABILITY:
			increase_stability(_value)
		_:
			run_curreny[_type] += _value
