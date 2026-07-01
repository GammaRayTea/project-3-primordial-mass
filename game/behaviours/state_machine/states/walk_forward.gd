@tool
class_name WalkForwardState extends TimedState

@export var _subject:Node3D
@export var speed:float = 1.0



func _execute(_delta:float) -> void:
	_subject.position += Vector3.FORWARD * speed*_delta
	
