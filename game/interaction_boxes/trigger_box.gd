@tool
@abstract class_name TriggerBox extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_disabled(value:bool)->  void:
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = value
