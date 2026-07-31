class_name StandardChest extends Chest

@export var min_value_goo: int = 1
@export var max_value_goo: int = 1
@export var min_drops_goo: int = 0
@export var max_drops_goo: int = 2

@export var min_value_coins: int = 2
@export var max_value_coins: int = 3
@export var min_drops_coins: int = 3
@export var max_drops_coins: int = 4



func activate(_source: Node3D) -> void:
	if is_locked:
		return
	if was_opened:
		return
	was_opened = true
	var anim_player: AnimationPlayer = $Visuals/chest/AnimationPlayer
	anim_player.play("CylinderAction")
	await anim_player.animation_finished
	
	_spawn_loot()


func hover_start()-> void:
	var game:Game = (get_tree().get_first_node_in_group("Game") as Game)
	if !was_opened:
		game.ui_controller.hud.show_hint("Press E to open")


func hover_end()-> void:
	(get_tree().get_first_node_in_group("Game") as Game).ui_controller.hud.hide_hint()


func get_loot() -> Array[Dictionary]:
	var loot: Array[Dictionary] = []
	var drop_count_goo: int = randi_range(min_drops_goo, max_drops_goo)
	var drop_count_coins: int = randi_range(min_drops_coins, max_drops_coins)
	
	for i in range(drop_count_goo):
		loot.append({
			"type":  GlobalEnum.CURRENCY.GOO,
			"value": randi_range(min_value_goo, max_value_goo)
		})
	
	for i in range(drop_count_coins):
		loot.append({
			"type": GlobalEnum.CURRENCY.COINS,
			"value": randi_range(min_value_coins, max_value_coins)
		})
	
	return loot
