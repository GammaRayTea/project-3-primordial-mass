@tool
class_name WalkForwardVelocityState extends WalkForwardState

@export var MAX_VELOCITY:float = 2.0
@export var ACCELERATION:float = 0.1

func _execute(_delta:float) -> void:
	var target_vel = direction * speed 
	target.velocity.x = move_toward(target.velocity.x,target_vel.x,ACCELERATION)
	target.velocity.z = move_toward(target.velocity.z,target_vel.z,ACCELERATION)

	
	target.rotate_to_direction(direction)

func _exit() -> void:
	super()
	target.velocity = Vector3(0,0,0)
