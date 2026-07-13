class_name PlayerCam extends Camera3D

@export var bounding_box:Vector2
@export_range(0,0.2,0.0001)
var return_weight:float

@export_range(0,0.2,0.0001)
var move_weight:float

@export var max_speed:float
@export_range(0,10,0.0001)
var height:float

@export var reset_time:int = 40
var current_time_until_reset:int = 0
var current_return_weight:float = 0

func _update_position(_player_rotation:Quaternion) -> void:
	
	var target_position:Vector3 = -_player_rotation*Vector3.FORWARD * Vector3(bounding_box.x,0,bounding_box.y)
	target_position.y = height
	position = position.lerp(target_position,move_weight)
	current_time_until_reset = reset_time
	current_return_weight = 0.0

func _move_to_center() -> void:
	if current_time_until_reset <= 0:
		current_return_weight = lerpf(current_return_weight,return_weight,0.01)
		position = position.lerp(Vector3(0,height,0),current_return_weight)
	else:
		current_time_until_reset-= 1
