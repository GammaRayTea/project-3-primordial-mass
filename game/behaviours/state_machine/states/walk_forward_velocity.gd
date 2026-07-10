@tool
class_name WalkForwardVelocityState extends WalkForwardState

@export var MAX_VELOCITY:float = 2.0
@export var ACCELERATION:float = 0.1

func _execute(_delta:float) -> void:
	var target_vel = direction * speed 
	target.velocity.x = move_toward(target.velocity.x,target_vel.x,ACCELERATION)
	target.velocity.z = move_toward(target.velocity.z,target_vel.z,ACCELERATION)

	
	var current_pivot_rot = Quaternion(rotation_pivot.transform.basis)
	var target_rot = Quaternion(Vector3.UP,direction.normalized().signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
	rotation_pivot.transform.basis = Basis(current_pivot_rot.slerp(target_rot, 0.5))

func _exit() -> void:
	target.velocity = Vector3(0,0,0)
