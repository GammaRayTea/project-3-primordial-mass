class_name Player extends CharacterBody3D
## Class for player character

@export var MAX_WALKING_SPEED = 5.0
@export var MAX_RUNNING_SPEED = 5.0
@export var BASE_ACCELERATION = 0.9
@export var PUSH_ACCELERATION = 0.05
@export var TRACTION = 0.3
@export var JUMP_VELOCITY = 4.5

#Component Nodes
@export var rotation_pivot:Node3D
@export var interaction_box:Area3D
enum STATE {IDLE, WALKING, RUNNING, PUSHING}
var current_state = STATE.IDLE

var push_target: RigidInteractable
var push_distance:float



func _physics_process(_delta: float) -> void:
	var direction:Vector3 = process_movement_input()
	match current_state:
		STATE.IDLE:
			move(_delta,direction, MAX_WALKING_SPEED, BASE_ACCELERATION)
		STATE.WALKING:
			move(_delta,direction, MAX_WALKING_SPEED, BASE_ACCELERATION)
		STATE.RUNNING:
			move(_delta,direction, MAX_RUNNING_SPEED, BASE_ACCELERATION)
		STATE.PUSHING:
			move(_delta,direction, MAX_RUNNING_SPEED, PUSH_ACCELERATION)
			push(_delta,direction)
			


## checks input keys and returns corresponidng values
func process_movement_input() -> Vector3:
	var input_dir := Input.get_vector("move_left","move_right","move_up","move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction

func move(_delta: float, _direction:Vector3, _target_speed:float, _acceleration:float) -> void:
	if _direction:
		var current_pivot_rot = Quaternion(rotation_pivot.transform.basis)
		var target_rot = Quaternion(Vector3.UP,_direction.signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
		
		rotation_pivot.transform.basis = Basis(current_pivot_rot.slerp(target_rot, 0.5))
		
		
		velocity.x = move_toward(velocity.x, _direction.x * _target_speed, _acceleration)
		velocity.z = move_toward(velocity.z, _direction.z * _target_speed, _acceleration)
		

		velocity.x = clampf(velocity.x, -_target_speed, _target_speed)
		velocity.z = clampf(velocity.z, -_target_speed, _target_speed)
		
	else:
		velocity.x = move_toward(velocity.x, 0, TRACTION)
		velocity.z = move_toward(velocity.z, 0,TRACTION)
	
	
	move_and_slide()

func start_push():
	push_distance = (push_target.position-position).length()
	velocity = Vector3.ZERO
	print(push_distance)
	current_state = STATE.PUSHING
	
func push(_delta : float, _direction) -> void:
	
	push_target.apply_force(_direction*0.2,Vector3(0,1,0))


func on_interactable_box_entered(_area: Area3D) -> void:
	if _area is InteractionBox:
		if _area.target is RigidInteractable and push_target == null:
			push_target = _area.target
			start_push()





func on_interactable_box_exited(_area: Area3D) -> void:
	if _area is InteractionBox:
		if _area.target == push_target:
			push_target = null
			current_state = STATE.IDLE
