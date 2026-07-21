@tool
class_name CheckPlayerDistanceState extends State

@export var target:Enemy
@export var event:Event

@export var distance_threshold:float
var player:Player

func _start()-> void:
	pass


func _setup() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _execute(_delta:float) -> void:
	if target.global_position.distance_to(player.global_position) < distance_threshold:
		event.execute()
		finished.emit()


func _exit() -> void:
	pass
