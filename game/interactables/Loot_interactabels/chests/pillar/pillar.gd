class_name Pillar extends Chest

@export var currency_type: GlobalEnum.CURRENCY
@export var min_amount_goo: int = 1
@export var max_amount_goo: int = 1
@export var min_drops_goo: int = 2
@export var max_drops_goo: int = 5

func get_loot() -> Array[Dictionary]:
	var loot: Array[Dictionary] = []
	var drop_count: int = randi_range(min_drops_goo, max_drops_goo)
	
	for i in range(drop_count):
		loot.append({
			"type": currency_type,
			"value": randi_range(min_amount_goo, max_amount_goo)
		})
	
	return loot
