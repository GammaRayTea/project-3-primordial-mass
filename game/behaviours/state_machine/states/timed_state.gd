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

@export var randomize_time:bool = false:
	set(value):
		randomize_time = value
		notify_property_list_changed()

var _minimum:float
var _maximum:float

var active_timer:Timer

func _get_property_list() -> Array[Dictionary]:
	var properties:Array[Dictionary]
	if randomize_time:
		properties.append({
			"name":"minimum",
			"type":TYPE_FLOAT
		})
		properties.append({
			"name":"maximum",
			"type":TYPE_FLOAT
		})
	
	return properties

func _property_get_revert(property: StringName) -> Variant:
	match property:
		"minimum":
			return 0.0
		"maximum":
			return 5.0
	return null
	
func _property_can_revert(property: StringName) -> bool:
	match property:
		"minimum":
			return true
		"maximum":
			return true
	return false

func _get(property: StringName) -> Variant:
	match property:
		"minimum":
			return _minimum
		"maximum":
			return _maximum
	return null
	
	
func _set(property: StringName, value: Variant) -> bool:
	match property:
		"minimum":
			_minimum = value
			return true
		"maximum":
			_maximum = value
			return true
	return false


func _setup()->void:
	active_timer = Timer.new()
	add_child(active_timer)
	active_timer.timeout.connect(finished.emit)

func _start()-> void:
	if randomize_time:
		time = randf_range(_minimum,_maximum)
	active_timer.start(time)


func _execute(_delta:float) -> void:
	pass
	
func _exit() -> void:
	active_timer.stop()
