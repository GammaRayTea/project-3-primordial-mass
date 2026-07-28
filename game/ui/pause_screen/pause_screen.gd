class_name PauseScreen extends Control

@export var continue_button:Button
@export var exit_button:Button

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		get_viewport().set_input_as_handled()
		(get_tree().get_first_node_in_group("Game") as Game).unpause()
