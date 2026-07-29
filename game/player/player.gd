class_name Player extends Entity
## Class for player character
@export_category("Attributes")
@export var MAX_WALKING_SPEED = 2.0
@export var MAX_RUNNING_SPEED = 4.0
@export var BASE_ACCELERATION = 0.4
@export var PUSH_ACCELERATION = 0.05
@export var TRACTION = 0.3
@export var JUMP_VELOCITY = 4.5
@export var MAX_SPRINT_VALUE:float = 1000
@export var SPRINT_REDUCTION:float = 5
@export var SPRINT_RECHARGE_TIME:float = 5.0

@export var do_gravity:bool = true
#Component Nodes
@export_category("Components")
@export var push_box_shape:CollisionShape3D
@export var camera:PlayerCam
@export var sprint_timer:Timer
@export var animation_tree:AnimationTree


@export var idle_animation_variation_timer:Timer


var hit_stun_counter:float = 0.0

var current_sprint_value:float = 0
var can_sprint:bool = true
enum STATE {IDLE, WALKING, RUNNING, PUSHING, HIT_STUN}
var current_state =  STATE.IDLE

var push_target: RigidInteractable
var push_distance:float

var control_interaction_target:Interactable

var held_items:Dictionary[GlobalEnum.ITEM, int] = {
	GlobalEnum.ITEM.PEARL:0
}

func _ready() -> void:
	idle_animation_variation_timer.timeout.connect(start_idle_variation_animation)

func start() -> void:
	global_position = Vector3(8,1,8)
	current_sprint_value = MAX_SPRINT_VALUE * RunManager.player_stats[GlobalEnum.UPGRADES.STAMINA]
	

	for key in held_items:
		held_items.set(key, 0)
	
	switch_state(STATE.IDLE)
	push_target = null
	control_interaction_target = null
	can_sprint = true

func _physics_process(_delta: float) -> void:
	var direction:Vector3 = process_movement_input()
	process_interact_input()
	
	match current_state:
		STATE.IDLE:
			camera._move_to_center()
			apply_gravity(_delta)
			if direction:
				switch_state( STATE.WALKING)
		STATE.WALKING:
			apply_gravity(_delta)
			if Input.is_action_pressed("sprint") and can_sprint:
				switch_state( STATE.RUNNING)
			else:
				current_sprint_value = lerp(current_sprint_value, MAX_SPRINT_VALUE * RunManager.player_stats[GlobalEnum.UPGRADES.STAMINA], 0.1)
			move(_delta,direction, MAX_WALKING_SPEED, BASE_ACCELERATION)
		STATE.RUNNING:
			apply_gravity(_delta)
			move(_delta,direction, MAX_RUNNING_SPEED, BASE_ACCELERATION)
			handle_sprint()
			if Input.is_action_just_released("sprint"):
				switch_state( STATE.IDLE)
			
		STATE.PUSHING:
			apply_gravity(_delta)
			move(_delta,direction, MAX_RUNNING_SPEED, PUSH_ACCELERATION)
			push(_delta,direction)
		STATE.HIT_STUN:
			hit_stun_counter-= 1

			if hit_stun_counter <= 0:
				switch_state( STATE.IDLE)
			reduce_velocity()
			move_and_slide()
			apply_gravity(_delta)
			
			
			


func switch_state(_state:STATE) -> void:
	var animation:String = ""
	var time_scale:float = 1.0
	idle_animation_variation_timer.stop()
	match _state:
		STATE.IDLE:
			animation = "leyla_idle"

			idle_animation_variation_timer.start(randf_range(5,15))
		STATE.WALKING:
			animation = "leyla_walk"
			time_scale = 1.5
			
		STATE.RUNNING:
			time_scale = 1.5
			animation = "leyla_run"
		STATE.PUSHING:
			animation = "leyla_walk"
		STATE.HIT_STUN:
			animation = "leyla_flinch"

	animation_tree["parameters/TimeScale/scale"] = time_scale
	animation_tree["parameters/StateMachine/playback"].travel(animation)
	current_state =  _state


func start_idle_variation_animation() -> void:
	if current_state == STATE.IDLE:
		animation_tree["parameters/StateMachine/playback"].travel("leyla_idle_var")
		idle_animation_variation_timer.start(randf_range(10,20))

#region movement
#region sprint
func handle_sprint() -> void:
	current_sprint_value-= SPRINT_REDUCTION
	if current_sprint_value <= 0:
		can_sprint = false
		switch_state( STATE.IDLE)
		sprint_timer.start(SPRINT_RECHARGE_TIME)
		
func on_sprint_timer_done() -> void:
	can_sprint = true
	sprint_timer.stop()
#endregion

#region input
## checks input keys and returns corresponidng values
func process_movement_input() -> Vector3:
	var input_dir := Input.get_vector("move_left","move_right","move_up","move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	return direction

func process_interact_input() -> void:
	if Input.is_action_just_pressed("interact"):
		
		if control_interaction_target != null:
			control_interaction_target.activate(self)


#endregion

func move(_delta: float, _direction:Vector3, _target_speed:float, _acceleration:float) -> void:
	if _direction:
		var target_rot = rotate_to_direction(_direction)
		camera._update_position(target_rot)
		
		velocity.x = move_toward(velocity.x, _direction.x * _target_speed, _acceleration)
		velocity.z = move_toward(velocity.z, _direction.z * _target_speed, _acceleration)
		
	
		velocity.x = clampf(velocity.x, -_target_speed, _target_speed)
		velocity.z = clampf(velocity.z, -_target_speed, _target_speed)
		
		RunManager.decrease_stability(1)
	else:
		reduce_velocity()
		animation_tree["parameters/TimeScale/scale"]*=0.7
		if velocity.x == 0 and velocity.z == 0:
			switch_state( STATE.IDLE)
	
	
	move_and_slide()
#endregion


func reduce_velocity() -> void:
		velocity.x = move_toward(velocity.x, 0, TRACTION)
		velocity.z = move_toward(velocity.z, 0,TRACTION)
		
	

func apply_gravity(_delta:float) -> void:
	if not is_on_floor() and do_gravity:
		velocity += get_gravity() * _delta
#region push
func start_push():
	push_box_shape.set_deferred("disabled", false)
	push_distance = (push_target.position-position).length()
	velocity = Vector3.ZERO
	switch_state( STATE.PUSHING)
	
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
			push_box_shape.set_deferred("disabled", true)
			switch_state( STATE.IDLE)
#endregion

#region items
func pick_up_item(_item:Item):
	print("picked up ",_item.name)
	if _item.name == "Pearl":
		held_items[GlobalEnum.ITEM.PEARL] += 1
	

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



#region damage handling




func get_hit(source:HitBox):
	hit_stun_counter = source.hit_stun
	switch_state( STATE.HIT_STUN)
	velocity += source.parent.global_position.direction_to(global_position) * Vector3(1,0,1) * source.knockback
	
	print("Player took damage ", source.damage)
	
	GlobalSoundManager.increase_intensity(0.5)
	
	camera.cam_shake()
	Engine.time_scale = 0.1
	var timer =  get_tree().create_timer(0.02)
	await timer.timeout
	Engine.time_scale = 1.0
	
	if !RunManager.stable_phase:
		die()
	else:
		RunManager.decrease_stability(source.damage)

func die() -> void:
	(get_tree().get_first_node_in_group("Game") as Game).die()
#endregion
