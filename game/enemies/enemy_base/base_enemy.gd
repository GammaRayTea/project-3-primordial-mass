@tool
class_name Enemy extends Entity

@export_category("Attributes")
@export var health:float = 100.0:
	set(value):
		health = value
		if health <= 0.0:
			die()
@export var tile_spawn_margin:int = 1
@export_category("Components")
@export var animation_tree:AnimationTree:
	set(value):
		animation_tree= value
		update_configuration_warnings()




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
		if not is_on_floor():
			velocity += get_gravity() * _delta
		move_and_slide()
		
	

func get_hit(source:HitBox):
	health-=source.damage
	velocity += source.global_position.direction_to(global_position) * Vector3(1,0,1) * source.knockback
	execute_events(events_on_hurt)
	enemy_hit.emit()

func die() -> void:
	execute_events(events_on_death)
	enemy_died.emit()




func execute_events(events:Array[Event])->void:
	for event in events:
		if event is Event:
			event.execute()


func _on_screen_entered() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	print("active")


func _on_screen_exited() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	print("exited")
