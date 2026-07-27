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
	next_state = close_enough_state
	super()

func _execute(_delta:float) -> void:
	target_position = player.global_position
	super(_delta)
	if target.global_position.distance_to(target_position) >= distance_limit:
		next_state = too_far_state
		finished.emit(self)


func _exit() -> void:
	super()
	target.velocity = Vector3(0,0,0)
