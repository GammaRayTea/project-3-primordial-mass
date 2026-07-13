@tool
@abstract class_name Event extends Node


func _get_configuration_warnings() -> PackedStringArray:
	var warnings  = PackedStringArray()

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
