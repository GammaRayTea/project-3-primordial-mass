extends Node
var base_max_stability = 100.0

var stability_bar:TextureProgressBar
var stable_phase:bool = true


var saved_currency:Dictionary[GlobalEnum.CURRENCY, int] = {
	GlobalEnum.CURRENCY.GOO : 0,
	GlobalEnum.CURRENCY.COINS: 0
}
var run_currency:Dictionary[GlobalEnum.CURRENCY, int]




var player_stats:Dictionary[GlobalEnum.UPGRADES,float] = {
	GlobalEnum.UPGRADES.STABILITY_BUILDUP:1.0,
	GlobalEnum.UPGRADES.STABILITY_RESILIENCE:1.0,
	GlobalEnum.UPGRADES.STABILITY_CAPACITY:1.0,
	GlobalEnum.UPGRADES.STAMINA:1.0
	
}
var player_stat_levels:Dictionary[GlobalEnum.UPGRADES,int] = {
	GlobalEnum.UPGRADES.STABILITY_BUILDUP:0,
	GlobalEnum.UPGRADES.STABILITY_RESILIENCE:0,
	GlobalEnum.UPGRADES.STABILITY_CAPACITY:0,
	GlobalEnum.UPGRADES.STAMINA:0
	
}
var player_stat


func _ready() -> void:
	
	
	stability_bar = get_tree().get_first_node_in_group("StabilityBar")
	if stability_bar:
		stability_bar.value = stability_bar.max_value
		stability_bar.value_changed.connect(_on_stability_value_changed)
	reset()

func start_run() -> void:
	
	reset()

func reset() -> void:
	run_currency = {
	GlobalEnum.CURRENCY.GOO : 0,
	GlobalEnum.CURRENCY.COINS: 0
	}
	stability_bar.value = base_max_stability * player_stats[GlobalEnum.UPGRADES.STABILITY_CAPACITY]
	stability_bar.value = stability_bar.max_value
	
	stable_phase = true
#TODO: implement player upgrades




	

func start_escape_event() -> void:
	stable_phase = false
	(get_tree().get_first_node_in_group("Game") as Game).start_escape_sequence()

func lose_progress() -> void:
	for key in run_currency:
		run_currency[key] = 0
	save_game()

func leave_run() -> void:
	for key in run_currency:
		saved_currency[key]+= run_currency[key]
	save_game()

func save_game() -> void:
	GameSaveManager.save(saved_currency,player_stats, player_stat_levels)

func increase_stability(_by_value:float) -> void:
	if stable_phase:
		stability_bar.value += _by_value * player_stats[GlobalEnum.UPGRADES.STABILITY_BUILDUP]

func decrease_stability(_by_value:float) -> void:
	if stable_phase:
		stability_bar.value -= _by_value / player_stats[GlobalEnum.UPGRADES.STABILITY_RESILIENCE]


func _on_stability_value_changed(_value:float) -> void:
	if _value <= 0:
		start_escape_event()



func change_currency(_type:GlobalEnum.CURRENCY,_value:int):
	match _type:
		GlobalEnum.CURRENCY.STABILITY:
			increase_stability(_value)
		_:
			saved_currency[_type] += _value


## changes given stats value by [param _value]
func change_stat(_type:GlobalEnum.UPGRADES, _value:float, _level:int) -> void:
	if !player_stats.has(_type):
		player_stats[_type] = 1.0
	player_stats[_type]+= _value
	player_stats[_type] = max(player_stats[_type],0.1)
	
	player_stat_levels[_type] = _level
	if _type == GlobalEnum.UPGRADES.STABILITY_CAPACITY:
		stability_bar.max_value = base_max_stability*player_stats[_type]
