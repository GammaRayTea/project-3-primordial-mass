@tool
class_name InteractionBox extends TriggerBox

@export var target:Node3D

func _init() -> void:
	set_collision_mask_value(6,true)
	set_collision_layer_value(6,true)
	set_collision_mask_value(1,false)
	set_collision_layer_value(1,false)
