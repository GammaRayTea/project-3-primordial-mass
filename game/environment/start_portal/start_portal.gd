extends Node3D







func _on_interaction_box_entered(area: Area3D) -> void:
	if area is InteractionBox:
		if area.target is Player:
			#show leave icon
			pass
