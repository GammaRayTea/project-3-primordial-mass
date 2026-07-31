class_name SaveGame extends Resource

@export var player_stats:Dictionary[GlobalEnum.UPGRADES,float]

@export var player_stat_levels:Dictionary[GlobalEnum.UPGRADES,int]
@export var currency:Dictionary[GlobalEnum.CURRENCY, int] 

@export var tutorial = true

func _init() -> void:
	currency = {
	GlobalEnum.CURRENCY.GOO : 0,
	GlobalEnum.CURRENCY.COINS: 0
}
	player_stats = {
		GlobalEnum.UPGRADES.STABILITY_BUILDUP:0.2,
		GlobalEnum.UPGRADES.STABILITY_RESILIENCE:0.3,
		GlobalEnum.UPGRADES.STABILITY_CAPACITY:0.6,
		GlobalEnum.UPGRADES.STAMINA:1.0
	
	}
	player_stat_levels = {
		GlobalEnum.UPGRADES.STABILITY_BUILDUP:0,
		GlobalEnum.UPGRADES.STABILITY_RESILIENCE:0,
		GlobalEnum.UPGRADES.STABILITY_CAPACITY:0,
		GlobalEnum.UPGRADES.STAMINA:0
	}
