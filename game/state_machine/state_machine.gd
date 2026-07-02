@tool
class_name StateMachine extends Node

@export var initial_state: State:
	set(value):
		initial_state = value
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if get_children().size() == 0:
		warnings.append("No States attached. Add at least one State as children of this Node")
	else:
		var state_amount = 1
		for child in get_children():
			if child is State:
				state_amount +=  1
		if state_amount == 0:
			warnings.append("No States attached. Add at least one State as children of this Node")
	if initial_state == null:
		warnings.append("Set initial State")
	return warnings

var current_state: State


func _init() -> void:
	update_configuration_warnings()

func _ready() -> void:
	if !Engine.is_editor_hint():
		for state in get_children():
			if state is State:
				prepare_state(state)
		switch_to_state(initial_state)

func prepare_state(_state:State) -> void:
	_state.finished.connect(_on_state_finished)
	_state._setup()

func _update(_delta:float) -> void:
	current_state._execute( _delta)
	

func switch_to_state(_state:State) -> void:
	current_state = _state
	current_state._start()

func _on_state_finished()->void:
	current_state._exit()
	switch_to_state(current_state.next_state)
