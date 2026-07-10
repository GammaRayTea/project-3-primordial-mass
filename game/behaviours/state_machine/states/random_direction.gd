@tool
class_name RandomDirectionState extends State
@export var target:CharacterBody3D

var direction:Vector3

##Components of randomized [param direcction] get multiplied with components of [param mask] use this to include and exclude axes from randomization (e.g. (1,0,1) will make direction not have a y component
@export var mask:Vector3
func _setup()->void:
	pass

func _start()-> void:
	direction = Vector3(randf_range(-1,1) * mask.x, randf_range(-1,1) * mask.y, randf_range(-1,1) * mask.z)
	set_data(direction,pass_data_targets[0])
	finished.emit()

func _execute(_delta:float) -> void:
	pass

func _exit() -> void:
	pass
