class_name SaveGame extends Resource


@export var currency:Dictionary[GlobalEnum.CURRENCY, int] = {}
func _init() -> void:
	for key in GlobalEnum.CURRENCY.values():
		currency[key] = 0


func add_currency(_type:GlobalEnum.CURRENCY,_value:int):
	currency[_type] +=_value
	print(currency)
