@abstract class_name ControlInteractable extends Node3D
##Extend this to make a control interactable like a switch or button
@export var indicator:Node3D

@warning_ignore("unused_signal")
signal on_activation
@warning_ignore("unused_signal")
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
