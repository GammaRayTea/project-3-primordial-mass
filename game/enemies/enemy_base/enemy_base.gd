@tool
class_name Enemy extends CharacterBody3D

@export_category("Attributes")
@export var health:float = 100.0:
	set(value):
		health = value
		if health <= 0.0:
			die()
@export_category("Components")
@export var state_machine:StateMachine:
	set(value):
		state_machine = value
		update_configuration_warnings()
		
@export var animation_tree:AnimationTree:
	set(value):
		animation_tree= value
		update_configuration_warnings()
signal on_death
signal on_hit

#
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	
	if animation_tree == null:
		warnings.append("Set AnimationTree")
	if state_machine == null:
		warnings.append("Set StateMachine")
	return warnings

func _init() -> void:
	update_configuration_warnings()

func _physics_process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		state_machine._update(_delta)


func die() -> void:
	on_death.emit()
	queue_free()
func get_hit(damage:float):
	health-=damage
	on_hit.emit()
	print("damage ", damage, "health ", health)


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area is HitBox and area.get_parent() != self:
		
		get_hit(area.damage)
		
