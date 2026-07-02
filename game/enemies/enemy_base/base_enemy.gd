@tool
class_name Enemy extends CharacterBody3D
##Enemy base class. Extend to define custom Events.
@export_category("Attributes")
@export var health:float = 100.0:
	set(value):
		health = value
		if health <= 0.0:
			_die()

@export_category("Components")
@export var animation_tree:AnimationTree:
	set(value):
		animation_tree= value
		update_configuration_warnings()#
@export var visuals:Node3D
@export_category("State Machine")
@export var state_machine:StateMachine:
	set(value):
		state_machine = value
		update_configuration_warnings()



signal enemy_died
signal enemy_hurt


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


##Called when the enemy gets hit
func _get_hit(source:HitBox):
	health-=source.damage
	enemy_hurt.emit()

##Called when the enemy dies
func _die() -> void:
	enemy_died.emit()



func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area is HitBox and area.get_parent() != self:
		_get_hit(area)
