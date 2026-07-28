class_name StartPortal extends ControlInteractable


@export var ui:UIController




func _on_interaction_box_entered(area: Area3D) -> void:
	if area is InteractionBox:
		if area.target is Player:
			#show leave icon
			pass


func activate(_source:Node3D) -> void:
	
	(get_tree().get_first_node_in_group("Game") as Game).end_run()

func deactivate(_source:Node3D) -> void:
	pass
	
func hover_start()-> void:
	ui.hud.set_active_portal_hint_vis(true)

func hover_end()-> void:
	ui.hud.set_active_portal_hint_vis(false)
