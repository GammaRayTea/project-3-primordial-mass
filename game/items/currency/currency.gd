@tool
class_name Currency extends Item


@export var type:GlobalEnum.CURRENCY
@export var value:int

func _init() -> void:
	icon = load(ItemAssets.currency_icons[type])
	
	
static func make_random(_min_value:int, max_value:int) -> Currency:
	var new_item = Currency.new()
	new_item.type = GlobalEnum.CURRENCY.keys().pick_random()
	new_item.value = randi_range(_min_value, max_value)
	return new_item
