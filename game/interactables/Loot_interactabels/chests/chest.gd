@abstract class_name Chest extends Interactable

@export var was_opened: bool = false
@export var is_locked: bool = false
@export var currency_drop_scene: PackedScene
@export var drop_scatter_radius_min: float = 0.6
@export var drop_scatter_radius_max: float = 1.5



func activate(_source: Node3D) -> void:
	if is_locked:
		return
	if was_opened:
		return
	was_opened = true
	
	_spawn_loot()

func deactivate(_source: Node3D) -> void:
	pass

func hover_start() -> void:
	pass

func hover_end() -> void:
	pass


@abstract func get_loot() -> Array[Dictionary]


func _spawn_loot() -> void:
	if currency_drop_scene == null:
		push_warning("Chest '%s' has no drop_container_scene assigned." % name)
		return
	for drop in get_loot():
		var instance := currency_drop_scene.instantiate()
		instance.item = Currency.new()
		(instance.item as Currency).type = drop.type
		if drop.type == GlobalEnum.CURRENCY.GOO:
			pass
		(instance.item as Currency).value = drop.value
		instance.update_texture()
		get_parent().add_child(instance)
		instance.global_position = global_position + Vector3(
			randf_range(drop_scatter_radius_min, drop_scatter_radius_max),
			0.2,
			0.0
		).rotated(Vector3(0.0, 1.0, 0.0), randf() * TAU)
