class_name VisionCone extends Area3D


@export var enemy:Enemy
@export var alert_state:State

func _on_area_entered(area: Area3D) -> void:
	if area is HurtBox and area.get_parent().is_in_group("Player"):
		return
		#alert_state.pos = area.global_position

		enemy.state_machine.switch_to_state(alert_state)
