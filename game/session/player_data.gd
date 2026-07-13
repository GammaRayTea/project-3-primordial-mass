class_name SaveGame extends Resource

@export var currency:Dictionary[DropContainer.CURRENCY, int] = {}

func _init() -> void:
	for key in DropContainer.CURRENCY.values():
		currency[key] = 0
