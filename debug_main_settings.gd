extends Node3D

@export var render_low_res:bool = false
@export var low_resolution:Vector2i
@export var high_resolution:Vector2i
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_tree().root.content_scale_mode)

	if render_low_res:
		get_tree().root.content_scale_size = low_resolution

	else:
		get_tree().root.content_scale_size = high_resolution
