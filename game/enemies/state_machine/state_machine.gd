class_name StateMachine extends Node

@export var initial_state: State

var current_state: State

func _ready() -> void:

	for state in get_children():
		if state is State:
			prepare_state(state)
	switch_to_state(initial_state)

func prepare_state(_state):
	_state.state_finished.connect(_on_state_finished)
	print(_state.state_finished.get_connections())
	_state._setup()

func _update(_delta:float):
	current_state._execute( _delta)
	

func switch_to_state(_incoming_state):
	current_state = _incoming_state
	current_state._start()

func _on_state_finished()->void:
	switch_to_state(current_state.next_state)
