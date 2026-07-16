@tool
class_name CheckPlayerDistanceState extends ConditionState

var player:Player

func _setup() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _start() -> void:
	pass

func _execute(_delta:float) -> void:
	pass

func _exit() -> void:
	pass
