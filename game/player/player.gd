extends CharacterBody3D


@export var MAX_SPEED = 5.0
@export var ACCELERATION = 0.9
@export var TRACTION = 0.3
@export var JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:




	var input_dir := Input.get_vector("move_left","move_right","move_up","move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * MAX_SPEED, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * MAX_SPEED, ACCELERATION)
	
		print(velocity)
		velocity.x = clampf(velocity.x,-MAX_SPEED,MAX_SPEED)
		velocity.z = clampf(velocity.z,-MAX_SPEED,MAX_SPEED)
		
	else:
		velocity.x = move_toward(velocity.x, 0, TRACTION)
		velocity.z = move_toward(velocity.z, 0,TRACTION)

	move_and_slide()
