@tool
class_name WalkForwardState extends TimedState
##Moves [param target] in direction [code]Vector3.FORWARD = Vector3(0,0,1)[/code] by [param speed] every frame.

##Target to move.
@export var target:Node3D
@export var rotation_pivot:Node3D
##Speed of movement.
@export var speed:float = 1.0
@export var direction:Vector3


func _execute(_delta:float) -> void:
	target.position += direction * speed*_delta
	var current_pivot_rot = Quaternion(rotation_pivot.transform.basis)
	var target_rot = Quaternion(Vector3.UP,direction.signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
	rotation_pivot.transform.basis = Basis(current_pivot_rot.slerp(target_rot, 0.5))
	
