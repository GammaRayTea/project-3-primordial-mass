class_name Entity extends CharacterBody3D
@export_category("Attributes")
@export var health:float = 100.0:
	set(value):
		health = value
		if health <= 0.0:
			die()
@export_category("Components")
@export var rotation_pivot:Node3D

func get_hit(source:HitBox):
	health-=source.damage
	print("damage ", source.damage, " health ", health)

func die() -> void:
	pass



func rotate_to_direction(_direction:Vector3) -> Quaternion:
	var current_pivot_rot = Quaternion(rotation_pivot.transform.basis)
	var target_rot = Quaternion(Vector3.UP,_direction.normalized().signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
	rotation_pivot.transform.basis = Basis(current_pivot_rot.slerp(target_rot, 0.5))
	return target_rot
