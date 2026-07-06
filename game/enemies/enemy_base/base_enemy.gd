@tool
class_name Enemy extends CharacterBody3D

@export_category("Attributes")
@export var health:float = 100.0:
	set(value):
		health = value
		if health <= 0.0:
			die()

@export_category("Components")
@export var animation_tree:AnimationTree:
	set(value):
		animation_tree= value
		update_configuration_warnings()
@export var visuals:Node3D
@export_category("State Machine")
@export var state_machine:StateMachine:
	set(value):
		state_machine = value
		update_configuration_warnings()

@export_category("Events")
@export var events_on_hurt: Array[Event] = []
@export var events_on_hit: Array[Event] = []
@export var events_on_death: Array[Event] = []

signal enemy_died
signal enemy_hit


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
		move_and_slide()


func get_hit(source:HitBox):
	health-=source.damage
	
	
	execute_events(events_on_hurt)
	enemy_hit.emit()
	print("damage ", source.damage, " health ", health)

func die() -> void:
	await execute_events(events_on_death)
	enemy_died.emit()
	queue_free()


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area is HitBox and area.get_parent() != self:
		get_hit(area)
		

func execute_events(events:Array[Event])->void:
	for event in events:
		if event is Event:
			event.execute()
			await event.finished
