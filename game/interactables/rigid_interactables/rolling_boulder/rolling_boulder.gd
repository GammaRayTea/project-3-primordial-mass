@tool
extends RigidInteractable
@export var hit_box:HitBox
@export var damage_speed_threshold:float = 1.0
func onInteractionAreaEntered(_area:Area3D)->void:
	print("entered")
	
func _physics_process(_delta: float) -> void:

	if linear_velocity.length() > damage_speed_threshold:
		hit_box.damage = clamp(pow(linear_velocity.length(),3),0, 100)
		hit_box.knockback = clamp(pow(linear_velocity.length(),3),0, 20)
		hit_box.set_disabled(false)
	else: 
		hit_box.damage = 0.0
		hit_box.knockback = 0.0
		hit_box.set_disabled(true)
	
