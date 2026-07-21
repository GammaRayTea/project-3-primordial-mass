@tool
class_name HitBox extends TriggerBox
@export var parent:Entity

@export var damage:= 10.0
@export var knockback:= 2.0

func _init() -> void:
	for c in get_children():
		if c is CollisionShape3D:
			c.set("debug_color",Color("41a720ff"))
