@tool
class_name InteractionBox extends TriggerBox

@export var target:Node3D

func _init() -> void:
	if !find_children("Collision","CollisionShape3D"):
		var shape = CollisionShape3D.new()
		add_child(shape)
		shape.owner = self
		shape.shape = BoxShape3D.new()
		
		
		
