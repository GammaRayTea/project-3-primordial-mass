extends VisionCone
var detect_position:Vector3
@export var path_trace:RayCast3D


func _physics_process(_delta: float) -> void:
	path_trace.target_position = -(path_trace.global_position - get_tree().get_nodes_in_group("Player")[0].global_position)
	
func _on_area_entered(_area: Area3D) -> void:
	if _area is HurtBox and _area.get_parent().is_in_group("Player"):
		detect_position = (_area.get_parent() as Player).global_position
		path_trace.target_position = -(path_trace.global_position - detect_position)
		path_trace.target_position.y = 0
		path_trace.target_position*= 1.2 

		var collider = path_trace.get_collider()

		if collider == _area:
			(alert_state as WalkToPositionState).target_position = detect_position
			enemy.state_machine.switch_to_state(alert_state)
			set_deferred("monitoring", false)
