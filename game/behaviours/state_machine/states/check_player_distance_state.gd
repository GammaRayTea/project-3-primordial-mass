@tool
class_name CheckPlayerDistanceState extends WaitState

@export var target:Enemy
@export var branch_state:State
@export var default_state:State
@export var distance_threshold:float
var player:Player

func _setup() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _execute(_delta:float) -> void:
	if target.global_position.distance_to(player.global_position) < distance_threshold:
		next_state = branch_state
		finished.emit()
	else:
		next_state = default_state

func _exit() -> void:
	pass
