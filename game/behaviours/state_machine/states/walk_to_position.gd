@tool
class_name WalkToPositionState extends WalkForwardVelocityState


@export var target_position:Vector3
@export var distance_threshold:float

func _setup()->void:
	pass
func _start()-> void:
	var distance = target.global_position.distance_to(target_position)
	time = speed/distance
func _execute(_delta:float) -> void:
	direction = target.global_position.direction_to(target_position).normalized()
	super(_delta)
	if target.global_position.distance_to(target_position) <= distance_threshold:
		finished.emit()
