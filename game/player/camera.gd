class_name PlayerCam extends Camera3D



@export var bounding_box:Vector2
@export_range(0,0.2,0.0001)
var return_weight:float

@export_range(0,0.2,0.0001)
var move_weight:float

@export var max_speed:float
@export_range(0,100,0.0001)
var height:float = 2.621

@export var reset_time:int = 40
var current_time_until_reset:int = 0
var current_return_weight:float = 0

@export var ray_cast:RayCast3D
@export var visualizer:Node3D

@export var wall_margin:float = 0.5
var target_position:Vector3 = Vector3(0,height,0)
var player_rotation:Quaternion

func _ready():
	target_position = Vector3(0,height,0)
	position.y = height
	
func _update_position(_player_rotation:Quaternion) -> void:
	player_rotation = _player_rotation
	current_time_until_reset = reset_time
	current_return_weight = 0.0

func _physics_process(_delta):
	

	if current_time_until_reset>0:
		target_position = player_rotation*Vector3.FORWARD * Vector3(bounding_box.x,0,bounding_box.y)
		ray_cast.target_position = Vector3(target_position.x,0,target_position.z).normalized()*3
	
		if ray_cast.is_colliding():
			var collision_point:Vector3 = ray_cast.get_collision_point()-global_position
			
			if collision_point:
				target_position.y = height
				collision_point.y = height
				if target_position.distance_to(collision_point) < wall_margin or collision_point.length()< target_position.length():
				
					target_position = collision_point-target_position.normalized()*(wall_margin)
		target_position.y = height
		position.y = height
		visualizer.position = target_position
		position = position.lerp(target_position,move_weight)

	


func _move_to_center() -> void:
	if current_time_until_reset <= 0:
		current_return_weight = lerpf(current_return_weight,return_weight,0.01)
		position = position.lerp(Vector3(0,height,0),current_return_weight)
	else:
		current_time_until_reset-= 1
