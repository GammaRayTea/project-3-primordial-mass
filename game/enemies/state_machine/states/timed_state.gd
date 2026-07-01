@tool
class_name TimedState extends State
## the time in seconds after which [code]state_finished[/code] is called
@export var time:float = 1:
	set(value):
		if value < 0.001:
			push_warning("Time must be greater than 0.0")
			time = 1.0
		else:
			time = value

func _setup()->void:
	pass
func _start()-> void:
	get_tree().create_timer(time).timeout.connect(state_finished.emit)
func _execute(_delta:float) -> void:
	pass
