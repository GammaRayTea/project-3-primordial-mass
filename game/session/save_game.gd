class_name SaveGame extends Resource


@export var currency:Dictionary[GlobalEnum.CURRENCY, int] = {}
func _init() -> void:
	for key in GlobalEnum.CURRENCY.values():
		if key!= GlobalEnum.CURRENCY.STABILITY:
			currency[key] = 0


func add(_currency:Dictionary[GlobalEnum.CURRENCY,int]):
	
	for entry in _currency.keys():
		currency[entry] += _currency[entry]
	print(currency)
