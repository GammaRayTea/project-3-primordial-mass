class_name Player extends CharacterBody3D
## Class for player character
@export_category("Attributes")
@export var MAX_WALKING_SPEED = 5.0
@export var MAX_RUNNING_SPEED = 10.0
@export var BASE_ACCELERATION = 0.9
@export var PUSH_ACCELERATION = 0.05
@export var TRACTION = 0.3
@export var JUMP_VELOCITY = 4.5
@export var MAX_SPRINT_VALUE:float = 1000
@export var SPRINT_REDUCTION:float = 5
@export var SPRINT_RECHARGE_TIME:float = 5.0
#Component Nodes
@export_category("Components")
@export var rotation_pivot:Node3D
@export var interaction_box:Area3D
@export var push_box_shape:CollisionShape3D
@export var hud:Control
@export var camera:PlayerCam

var current_sprint_value:float = 0
var can_sprint:bool = true
@export var sprint_timer:Timer
enum STATE {IDLE, WALKING, RUNNING, PUSHING}
var current_state = STATE.IDLE

var push_target: RigidInteractable
var push_distance:float

var control_interaction_target:Interactable

var held_item:Item = null



func _physics_process(_delta: float) -> void:
	var direction:Vector3 = process_movement_input()
	process_interact_input()
	
	match current_state:
		STATE.IDLE:
			camera._move_to_center()
			apply_gravity(_delta)
			move(_delta,direction, MAX_WALKING_SPEED, BASE_ACCELERATION)
			if direction:
				current_state = STATE.WALKING
		STATE.WALKING:
			apply_gravity(_delta)
			if Input.is_action_just_pressed("sprint") and can_sprint:
				current_state = STATE.RUNNING
			else:
				current_sprint_value = lerp(current_sprint_value,MAX_SPRINT_VALUE,0.1)
			move(_delta,direction, MAX_WALKING_SPEED, BASE_ACCELERATION)
		STATE.RUNNING:
			apply_gravity(_delta)
			move(_delta,direction, MAX_RUNNING_SPEED, BASE_ACCELERATION)
			handle_sprint()
			if Input.is_action_just_released("sprint"):
				current_state = STATE.IDLE
			
		STATE.PUSHING:
			apply_gravity(_delta)
			move(_delta,direction, MAX_RUNNING_SPEED, PUSH_ACCELERATION)
			push(_delta,direction)
			
#region movement
#region sprint
func handle_sprint() -> void:
	current_sprint_value-= SPRINT_REDUCTION
	if current_sprint_value <= 0:
		can_sprint = false
		current_state = STATE.IDLE
		sprint_timer.start(SPRINT_RECHARGE_TIME)
		
func on_sprint_timer_done() -> void:
	can_sprint = true
	sprint_timer.stop()
#endregion

## checks input keys and returns corresponidng values
func process_movement_input() -> Vector3:
	var input_dir := Input.get_vector("move_left","move_right","move_up","move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	return direction

func process_interact_input() -> void:
	if Input.is_action_just_pressed("interact"):
		
		if control_interaction_target != null:
			control_interaction_target.activate(self)


func move(_delta: float, _direction:Vector3, _target_speed:float, _acceleration:float) -> void:
	if _direction:
		var current_pivot_rot = Quaternion(rotation_pivot.transform.basis)
		var target_rot = Quaternion(Vector3.UP,_direction.signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
		
		rotation_pivot.transform.basis = Basis(current_pivot_rot.slerp(target_rot, 0.5))
		camera._update_position(target_rot)
		
		velocity.x = move_toward(velocity.x, _direction.x * _target_speed, _acceleration)
		velocity.z = move_toward(velocity.z, _direction.z * _target_speed, _acceleration)
		

		velocity.x = clampf(velocity.x, -_target_speed, _target_speed)
		velocity.z = clampf(velocity.z, -_target_speed, _target_speed)
		
	else:
		velocity.x = move_toward(velocity.x, 0, TRACTION)
		velocity.z = move_toward(velocity.z, 0,TRACTION)
		current_state = STATE.IDLE
	
	move_and_slide()
#endregion
func apply_gravity(_delta:float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * _delta
#region push
func start_push():
	push_box_shape.set_deferred("disabled", false)
	push_distance = (push_target.position-position).length()
	velocity = Vector3.ZERO
	current_state = STATE.PUSHING
	
func push(_delta : float, _direction) -> void:
	push_target.apply_central_force(velocity*0.8)


func _on_push_start_box_entered(_area: Area3D) -> void:
	if _area is InteractionBox:
		if _area.target is RigidInteractable and push_target == null:
			push_target = _area.target
			start_push()

func on_push_box_exited(_area: Area3D) -> void:
	if _area is InteractionBox:
		if _area.target == push_target:
			push_target = null
			current_state = STATE.IDLE
#endregion

#region items
func pick_up_item(_item:Item):
	if held_item == null:
		held_item = _item
		print("picked up ",_item.name)
		hud.set_item(_item)
		

func on_interaction_box_entered(_area: Area3D) -> void:
	if _area is InteractionBox:
		if _area.target is Interactable:
			_area.target.hover_start()
			control_interaction_target = _area.target
			


func on_interaction_box_exited(_area: Area3D) -> void:
	if _area is InteractionBox:
		if _area.target is Interactable:
			_area.target.hover_end()
			control_interaction_target = null
#endregion
