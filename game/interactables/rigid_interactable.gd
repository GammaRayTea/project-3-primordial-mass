@tool
@abstract class_name RigidInteractable extends RigidBody3D

func _get_configuration_warnings() -> PackedStringArray:
	var area = null
	for child in get_children():
		if child is InteractionBox:
			area = child
			if area.area_entered.has_connections() == false:
				#area.area_entered.connect(onInteractionAreaEntered)
				pass
				
	print(area.area_entered.get_connections())

	if area == null:
		return ["Add an InteractioBox Node as an interaction box for the player!"]
	else:
		return []

@abstract func onInteractionAreaEntered(area:Area3D)->void

func _init() -> void:
	update_configuration_warnings()
