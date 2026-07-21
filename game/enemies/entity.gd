@abstract class_name Entity extends CharacterBody3D
@export_category("Attributes")

@export_category("Components")
@export var rotation_pivot:Node3D



func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area is HitBox and area.parent != self:
		get_hit(area)
		

@abstract func get_hit(_source:HitBox)

func die() -> void:
	pass





func rotate_to_direction(_direction:Vector3) -> Quaternion:
	var current_pivot_rot = Quaternion(rotation_pivot.transform.basis)
	var target_rot = Quaternion(Vector3.UP,_direction.normalized().signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
	rotation_pivot.transform.basis = Basis(current_pivot_rot.slerp(target_rot, 0.5))
	return target_rot
