@tool
@abstract class_name TimedState extends State
## Simple state that starts a timer and finishes when that timer is over. Extend this to create timed states.


## The time in seconds after which [code]state_finished[/code] is called.
@export var time:float = 1:
	set(value):
		if value < 0.001:
			push_warning("Time must be greater than 0.0")
			time = 1.0
		else:
			time = value

var active_timer:Timer

func _setup()->void:
	active_timer = Timer.new()
	add_child(active_timer)
	active_timer.timeout.connect(finished.emit)

func _start()-> void:
	active_timer.start(time)


func _execute(_delta:float) -> void:
	pass
	
func _exit() -> void:
	active_timer.stop()
