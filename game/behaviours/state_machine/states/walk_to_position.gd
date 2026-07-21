@tool
class_name WalkToPositionState extends State

@export var ACCELERATION:float

@export var target:Enemy
@export var rotation_pivot:Node3D

@export var speed:float
@export var target_position:Vector3
@export var distance_threshold:float

func _setup()->void:
	pass
func _start()-> void:
	#print("moving to target...")
	pass
func _execute(_delta:float) -> void:
	var direction = target.global_position.direction_to(target_position).normalized()
	var target_vel = direction * speed 
	target.velocity.x = move_toward(target.velocity.x,target_vel.x,ACCELERATION)
	target.velocity.z = move_toward(target.velocity.z,target_vel.z,ACCELERATION)

	
	target.rotate_to_direction(direction)

	if target.global_position.distance_to(target_position) <= distance_threshold:
		finished.emit()
func _exit() -> void:
	target.velocity = Vector3(0,0,0)
