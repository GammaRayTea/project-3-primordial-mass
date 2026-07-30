class_name Pillar extends Chest

@export var currency_type: GlobalEnum.CURRENCY
@export var min_value_goo: int = 2
@export var max_value_goo: int = 3
@export var min_drops_goo: int = 3
@export var max_drops_goo: int = 4

@export var min_value_coins: int = 1
@export var max_value_coins: int = 1
@export var min_drops_coins: int = 0
@export var max_drops_coins: int = 2


@export var sprite:Sprite3D
@export var animation_player:AnimationPlayer
@export var sound_effect_manager:SoundEffectManager
func activate(_source: Node3D) -> void:
	if _source is Player:
		if _source.held_items[GlobalEnum.ITEM.PEARL] > 0:
			_source.held_items[GlobalEnum.ITEM.PEARL] -= 1
			if is_locked:
				return
			if was_opened:
				return
			was_opened = true
			
			sprite.visible = true
			animation_player.play("hover")
			sound_effect_manager._play(["Activate"])
			RunManager.increase_stability(3000)
			_spawn_loot()
		else:
			print("not enough pearl")


func get_loot() -> Array[Dictionary]:
	var loot: Array[Dictionary] = []
	var drop_count_goo: int = randi_range(min_drops_goo, max_drops_goo)
	var drop_count_coins: int = randi_range(min_drops_coins, max_drops_coins)
	
	for i in range(drop_count_goo):
		loot.append({
			"type": GlobalEnum.CURRENCY.GOO,
			"value": randi_range(min_value_goo, max_value_goo)
		})
	
	for i in range(drop_count_coins):
		loot.append({
			"type": GlobalEnum.CURRENCY.COINS,
			"value": randi_range(min_value_coins, max_value_coins)
		})
	
	return loot
