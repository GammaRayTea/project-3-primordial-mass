extends ControlInteractable
## Simple Button

## If [code]false[/code], will only emit Signal [code]on_actiation[/code]. Otherwise, will emit Signal [code]on_deactiation[/code] after [param time_delta] seconds.
@export var turn_off = false
## Deactivation offset in seconds
@export var time_delta = 0
func activate(_source:Node3D) -> void:
	on_activation.emit()
	print("button pressed")
	if turn_off:
		await get_tree().create_timer(time_delta).timeout
		deactivate(self)
	
func deactivate(_source:Node3D) -> void:
	on_deactivation.emit()
