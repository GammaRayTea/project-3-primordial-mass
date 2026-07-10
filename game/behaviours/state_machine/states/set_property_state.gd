@tool
class_name SetPropertyState extends State
## Use this state to set the value of a property on [param target]


##Node where the property to set resides
@export var target:Node

##StringName of property to set
@export var property_name:StringName

## Type of the property to set. Can only be bool, int, float, Vector2, Vector3, or String. Ask to expand if needed.
@export var type:Variant.Type:
	set(value):
		type = value
		notify_property_list_changed()

## The internally stored value.
var property_value
func _get_property_list() -> Array[Dictionary]:
	var properties:Array[Dictionary]
	if type != TYPE_NIL:
		properties.append({
			"name":"value",
			"type":type
		})

	return properties


func _set(_property: StringName, _value: Variant) -> bool:
	if _property == "value":
		property_value = _value
		return true
	else: return false

func _get(_property: StringName) -> Variant:
	if _property == "value":
		return property_value
	return null
func _setup() -> void:
	pass

func _start() -> void:
	target.set(property_name,property_value)
	finished.emit()

func _execute(_delta:float) -> void:
	pass

func _exit() -> void:
	pass
