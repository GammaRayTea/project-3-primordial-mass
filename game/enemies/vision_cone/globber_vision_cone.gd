extends VisionCone
var detect_position:Vector3

func _on_area_entered(area: Area3D) -> void:
	if area is HurtBox and area.get_parent().is_in_group("Player"):
		detect_position = (area.get_parent() as Player).global_position
		(alert_state as WalkToPositionState).target_position = detect_position
		enemy.state_machine.switch_to_state(alert_state)
	set_deferred("monitoring", false)
