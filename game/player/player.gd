class_name Player extends CharacterBody3D
## Class for player character

@export var MAX_WALKING_SPEED = 5.0
@export var MAX_RUNNING_SPEED = 5.0
@export var ACCELERATION = 0.9
@export var TRACTION = 0.3
@export var JUMP_VELOCITY = 4.5


@export var rotation_pivot:Node3D

enum STATE {IDLE, WALKING, RUNNING, PUSHING}
var current_state = STATE.IDLE

var push_target: RigidInteractable

func _physics_process(_delta: float) -> void:
	var direction:Vector3 = process_input()
	match current_state:
		STATE.IDLE:
			move(_delta,direction, MAX_WALKING_SPEED)
		STATE.WALKING:
			move(_delta,direction, MAX_WALKING_SPEED)
		STATE.RUNNING:
			move(_delta,direction, MAX_RUNNING_SPEED)
		STATE.PUSHING:
			pass
			


## checks input keys and returns corresponidng values
func process_input() -> Vector3:
	var input_dir := Input.get_vector("move_left","move_right","move_up","move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction

func move(_delta: float, _direction:Vector3, _target_speed:float) -> void:
	if _direction:
		var current_pivot_rot = Quaternion(rotation_pivot.transform.basis)
		var target_rot = Quaternion(Vector3.UP,_direction.signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
		
		rotation_pivot.transform.basis = Basis(current_pivot_rot.slerp(target_rot, 0.5))
		
		
		velocity.x = move_toward(velocity.x, _direction.x * _target_speed, ACCELERATION)
		velocity.z = move_toward(velocity.z, _direction.z * _target_speed, ACCELERATION)
		

		velocity.x = clampf(velocity.x, -_target_speed, _target_speed)
		velocity.z = clampf(velocity.z, -_target_speed, _target_speed)
		
	else:
		velocity.x = move_toward(velocity.x, 0, TRACTION)
		velocity.z = move_toward(velocity.z, 0,TRACTION)
	
	
	move_and_slide()
	
func push(_delta : float) -> void:
	pass


func on_interactable_box_entered(area: Area3D) -> void:
	if area is InteractionBox:
		if area.target is RigidInteractable:
			push_target = area.target
			print(push_target)
	


func on_interactable_box_exited(area: Area3D) -> void:
	if area is InteractionBox:
		if area.target == push_target:
			push_target = null
			print(push_target)
