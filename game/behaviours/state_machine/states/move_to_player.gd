@tool
class_name MoveToPlayer extends TimedState

## target to move
@export var target:Node3D
## speed of movement
@export var speed:float = 1.0


func _setup()->void:
	pass
func _start()-> void:
	pass
func _execute(_delta:float) -> void:
	target.position += Vector3.FORWARD * speed * _delta
	target.position += Vector3.RIGHT * speed * _delta
