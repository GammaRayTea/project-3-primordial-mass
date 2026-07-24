@tool
class_name AlertWalkToPositionState extends WalkToPositionState


var player:Player

@export var branch_state:State

func _setup()->void:
	super()
	player = get_tree().get_first_node_in_group("Player")
	
	
func _execute(_delta:float) -> void:
	if target.global_position.distance_to(player.global_position) < distance_threshold:
		next_state = branch_state
		finished.emit()
		return
	super(_delta)
