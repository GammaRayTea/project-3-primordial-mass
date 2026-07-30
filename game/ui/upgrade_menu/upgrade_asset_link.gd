@tool
class_name ItemAssets

static var currency_icons:Dictionary[GlobalEnum.CURRENCY, String] = {
	GlobalEnum.CURRENCY.GOO:"res://assets/items/currency/goo/goo.png",
	GlobalEnum.CURRENCY.COINS:"res://assets/items/currency/coin/coin.png"
}

static var stat_icons:Dictionary[GlobalEnum.UPGRADES, String] = {
	GlobalEnum.UPGRADES.STAMINA:"res://assets/themes/ui_elements/upgrade_icon_stamina_up.png",
	GlobalEnum.UPGRADES.STABILITY_BUILDUP:"res://assets/themes/ui_elements/upgrade_icon_gain_increase.png",
	GlobalEnum.UPGRADES.STABILITY_RESILIENCE:"res://assets/themes/ui_elements/upgrade_icon_reduced_decrease.png",
	GlobalEnum.UPGRADES.STABILITY_CAPACITY:"res://assets/themes/ui_elements/upgrade_icon_capacity_up.png"
}

static var stat_names:Dictionary[GlobalEnum.UPGRADES, String] = {
		GlobalEnum.UPGRADES.STAMINA:"Stamina",
		GlobalEnum.UPGRADES.STABILITY_BUILDUP:"Stability Buildup",
		GlobalEnum.UPGRADES.STABILITY_RESILIENCE:"Stability Resilience",
		GlobalEnum.UPGRADES.STABILITY_CAPACITY:"Stability Capacity"
}

static var stat_descriptions:Dictionary[GlobalEnum.UPGRADES, String] = {
	GlobalEnum.UPGRADES.STABILITY_BUILDUP: "Increases stability gained",
	GlobalEnum.UPGRADES.STABILITY_RESILIENCE: "Decreases stability reduction",
	GlobalEnum.UPGRADES.STABILITY_CAPACITY: "Increases stability limit",
	GlobalEnum.UPGRADES.STAMINA: "Increases stamina for sprinting"
}
