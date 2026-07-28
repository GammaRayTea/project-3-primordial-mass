@tool
class_name InteractionBox extends TriggerBox

var target: Node3D = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if target == null:
		target = get_parent()
