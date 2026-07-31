class_name StartPortal extends ControlInteractable


@export var activate_timer:Timer

@export var collsion_shape:CollisionShape3D
func _ready() -> void:#
	global_position = Vector3(8,0.1,8)
	activate_timer.start(30)
	await activate_timer.timeout
	print("portal reactivated")
	collsion_shape.set_deferred("disabled", false)

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
	(get_tree().get_first_node_in_group("Game") as Game).ui_controller.hud.show_hint("Press E to leave realm")

func hover_end()-> void:
	(get_tree().get_first_node_in_group("Game") as Game).ui_controller.hud.hide_hint()
