@tool
@abstract class_name RigidInteractable extends RigidBody3D

func _get_configuration_warnings() -> PackedStringArray:
	var area = null
	var warnings = PackedStringArray()
	for child in get_children():
		if child is InteractionBox:
			area = child
			if area.area_entered.has_connections() == false:
				warnings.append("Connect area_entered of InteractionBox to onInteractionAreaEntered")
				


	if area == null:
		warnings.append("Add an InteractioBox Node as an interaction box for the player!")
	return warnings

@abstract func onInteractionAreaEntered(_area:Area3D)->void

func _init() -> void:
	update_configuration_warnings()
