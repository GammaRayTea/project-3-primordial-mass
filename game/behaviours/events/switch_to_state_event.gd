@tool
class_name SwitchToStateEvent extends Event
@export var state_machine:StateMachine
@export var state:State
func execute() -> void:
	state_machine.switch_to_state(state)
