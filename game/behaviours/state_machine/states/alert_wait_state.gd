@tool
class_name AlertWaitState extends WaitState
@export var target:Enemy
@export var distance_threshold:float = 0.0
@export var branch_state:State

var player

func _setup()->void:
	super()
	player = get_tree().get_first_node_in_group("Player")

func _execute(_delta:float) -> void:
	if target.global_position.distance_to(player.global_position) < distance_threshold:
		next_state = branch_state
		finished.emit(self)
		return
	super(_delta)
