@tool
class_name AlertState extends TimedState

var pos:Vector3
@export var move_to_player: MoveToPlayer

func _setup()->void:
	pass
func _start()-> void:
	pass
func _execute(_delta:float) -> void:
	pass
func _exit() -> void:
	move_to_player.pos = pos
	
