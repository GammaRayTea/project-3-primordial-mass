@tool
class_name WalkForwardState extends TimedState
##Moves [param target] in direction [code]Vector3.FORWARD = Vector3(0,0,1)[/code] by [param speed] every frame.

##Target to move.
@export var target:CharacterBody3D
##Speed of movement.
@export var speed:float = 1.0


func _setup()->void:
	pass
func _execute(_delta:float) -> void:
	target.position += Vector3.FORWARD * speed*_delta


func _exit() -> void:
	pass
