@abstract class_name Chest extends Interactable

@export var was_opened: bool = false
@export var is_locked: bool = false
@export var drop_container_scene: PackedScene
@export var drop_scatter_radius_min: float = 0.6
@export var drop_scatter_radius_max: float = 1.5

var in_player_range: bool = false

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
	in_player_range = true

func hover_end() -> void:
	in_player_range = false


@abstract func get_loot() -> Array[Dictionary]


func _spawn_loot() -> void:
	if drop_container_scene == null:
		push_warning("Chest '%s' has no drop_container_scene assigned." % name)
		return
	for drop in get_loot():
		var instance := drop_container_scene.instantiate()
		get_parent().add_child(instance)
		instance.global_position = global_position + Vector3(
			randf_range(drop_scatter_radius_min, drop_scatter_radius_max),
			0.2,
			0.0
		).rotated(Vector3(0.0, 1.0, 0.0), randf() * TAU)
		if instance.has_method("setup"):
			instance.setup(drop.type, drop.value)
