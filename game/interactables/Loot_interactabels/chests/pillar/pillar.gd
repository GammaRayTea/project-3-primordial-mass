class_name Pillar extends Chest

@export var currency_type: GlobalEnum.CURRENCY
@export var min_value_goo: int = 1
@export var max_value_goo: int = 2
@export var min_drops_goo: int = 2
@export var max_drops_goo: int = 5

@export var min_value_coins: int = 1
@export var max_value_coins: int = 2
@export var min_drops_coins: int = 2
@export var max_drops_coins: int = 5


func activate(_source: Node3D) -> void:
	if is_locked:
		return
	if was_opened:
		return
	was_opened = true
	
	find_child("Sprite3D").visible = true
	find_child("AnimationPlayer").play("hover")
	
	_spawn_loot()


func get_loot() -> Array[Dictionary]:
	var loot: Array[Dictionary] = []
	var drop_count_goo: int = randi_range(min_drops_goo, max_drops_goo)
	var drop_count_coins: int = randi_range(min_drops_coins, max_drops_coins)
	
	for i in range(drop_count_goo):
		loot.append({
			"type": currency_type,
			"value": randi_range(min_value_goo, max_value_goo)
		})
	
	for i in range(drop_count_coins):
		loot.append({
			"type": currency_type,
			"value": randi_range(min_value_coins, max_value_coins)
		})
	
	return loot
