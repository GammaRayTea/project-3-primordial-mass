@tool
class_name ChasePlayerState extends WalkToPositionState
@export var distance_limit:float = 0.0

@export var close_enough_state:State
@export var too_far_state:State
var player:Player



func _setup()->void:
	super()
	player = get_tree().get_first_node_in_group("Player")

func _start()-> void:
	super()
	next_state = close_enough_state

func _execute(_delta:float) -> void:
	super(_delta)
	target_position = player.global_position
	if target.global_position.distance_to(target_position) >= distance_limit:
		print(target.global_position.distance_to(target_position))
		next_state = too_far_state
		finished.emit()


func _exit() -> void:
	super()
	target.velocity = Vector3(0,0,0)
