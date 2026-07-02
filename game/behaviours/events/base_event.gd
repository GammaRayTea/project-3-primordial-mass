@tool
@abstract class_name Event extends Node
signal finished

func _get_configuration_warnings() -> PackedStringArray:
	var warnings  = PackedStringArray()
	if finished.get_connections().size() <0:
		warnings.append("Event doesn't emit finished. Enemy will stall when starting it's execution")
	var properties: = get_property_list()
	
	for p in properties:
		if p["class_name"] !="":
			if get(p["name"]) == null:
				warnings.append("Property %s has no value"%p["name"])

	return warnings


func _init():
	notify_property_list_changed()

func _validate_property(property):
	if property.usage  & PROPERTY_USAGE_SCRIPT_VARIABLE:
		update_configuration_warnings()
		


@abstract func execute() -> void
