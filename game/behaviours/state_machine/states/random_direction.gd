@tool
class_name RandomDirectionState extends State
@export var target:CharacterBody3D


@export var min_scale:float = 0.1:
	set(value):
		if value> 0:
			min_scale= value
@export var max_scale:float = 10:
	set(value):
		if value> min_scale:
			max_scale = value

var direction:Vector3

##Components of randomized [param direcction] get multiplied with components of [param mask] use this to include and exclude axes from randomization (e.g. (1,0,1) will make direction not have a y component
@export var mask:Vector3
func _setup()->void:
	print("started")

func _start()-> void:
	direction = Vector3(randf_range(-1,1) * mask.x, randf_range(-1,1) * mask.y, randf_range(-1,1) * mask.z).normalized()*randf_range(min_scale,max_scale)
	set_data(direction,pass_data_targets[0])
	finished.emit()

func _execute(_delta:float) -> void:
	pass

func _exit() -> void:
	pass
