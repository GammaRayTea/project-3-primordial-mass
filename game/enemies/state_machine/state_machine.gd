class_name StateMachine extends Node

@export var initial_state: State
@export var subject: Node3D
var current_state: State

func _ready() -> void:
	current_state = initial_state

func prepare_state(_incoming_state):
	current_state = _incoming_state
	current_state.state_finished.connect(_on_state_finished)

func _update(_delta:float):
	current_state._execute(subject, _delta)
	


func _on_state_finished()->void:
	prepare_state(current_state.next_state)
	
