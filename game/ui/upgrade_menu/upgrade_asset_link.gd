@tool
class_name ItemAssets

static var currency_icons:Dictionary[GlobalEnum.CURRENCY, String] = {
	GlobalEnum.CURRENCY.GOO:"res://assets/Items/currency/goo/goo.png",
	GlobalEnum.CURRENCY.COINS:"res://assets/Items/currency/coin/coin.png"
}

static var stat_names:Dictionary[GlobalEnum.UPGRADES, String] = {
		GlobalEnum.UPGRADES.STAMINA:"Stamina",
		GlobalEnum.UPGRADES.STABILITY_BUILDUP:"Stability Buildup",
		GlobalEnum.UPGRADES.STABILITY_RESILIENCE:"Stability Resilience",
		GlobalEnum.UPGRADES.STABILITY_CAPACITY:"Stability Capacity"

}

var stat_descriptions:Dictionary[GlobalEnum.UPGRADES, String] = {
	GlobalEnum.UPGRADES.STABILITY_BUILDUP: "Increases stability gained",
	GlobalEnum.UPGRADES.STABILITY_RESILIENCE: "Decreases stability reduction",
	GlobalEnum.UPGRADES.STABILITY_CAPACITY: "Increases stability limit",
	GlobalEnum.UPGRADES.STAMINA: "Increases stamina for sprinting"
}
