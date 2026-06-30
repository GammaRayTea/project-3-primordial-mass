@abstract class_name ControlInteractable extends Node3D

@export var indicator:Node3D

signal on_activation
signal on_deactivation

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

func _init() -> void:
	update_configuration_warnings()



@abstract func activate() -> void
@abstract func deactivate() -> void
