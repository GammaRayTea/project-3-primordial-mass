@tool
@abstract class_name State extends Node
##Base class for all States. extends this to create a new one.

##State that the state machine will switch to after this state is finished.
@export var next_state:State:
	set(value):
		next_state = value
		update_configuration_warnings()
@export_category("Pass Data")
@export var pass_data:bool = false:
	set(value):
		pass_data = value
		if value:
			pass_data_target_amount = 1
		else:
			pass_data_target_amount = 0
		notify_property_list_changed()
var pass_data_target_amount:int = 0:
	set(value):
		if value >=0:
			pass_data_target_amount = value
			if value>pass_data_targets.size():
				
				for i in value-pass_data_targets.size():
					pass_data_targets.append({
						"target":null,
						"property":""
					})
			else:
				pass_data_targets = pass_data_targets.slice(0, value)

		notify_property_list_changed()
var pass_data_targets: Array[Dictionary] = []

func _get_property_list() -> Array[Dictionary]:
	var properties:Array[Dictionary] = []
	if pass_data:
		properties.append({
			"name":"target_amount",
			"type":TYPE_INT
		})
		properties.append({
			"name":"Pass Data Targets",
			"type": TYPE_NIL,
			"usage" : PROPERTY_USAGE_GROUP
		})
				
		for i in pass_data_target_amount:
			properties.append({
				
				"name":"target_%d"  % (i+1),
				"class_name":"State",
				"type":TYPE_OBJECT,
				"hint":PROPERTY_HINT_NODE_TYPE,
				"hint_string":"State"
			})
			properties.append({
				
				"name":"property_%d"  % (i+1),
				"type":TYPE_STRING,
				"hint_string":"The property to assign"
			})

	return properties
	

func _property_can_revert(property: StringName) -> bool:
	if property == "target_amount":
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	if property == "target_amount":
		return 0
	return null
	
func _get(property: StringName) -> Variant:
	if property.begins_with("target_amount"):
		return pass_data_target_amount
	for i in pass_data_target_amount:
		if property.begins_with("target_%d"% (i+1)):
			return pass_data_targets[i].target
		if property.begins_with("property_%d"% (i+1)):
			return pass_data_targets[i].property

	return null

func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("target_amount"):
		pass_data_target_amount = value
		return true
	for i in pass_data_target_amount:
		if property.begins_with("target_%d"% (i+1)):
			pass_data_targets[i].target= value
			return true
		if property.begins_with("property_%d"% (i+1)):
			pass_data_targets[i].property= value
			return true
	return false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:= PackedStringArray()
	if next_state == null:
		warnings.append("No Next State Set")
		
	
	return warnings

func _init() -> void:
	update_configuration_warnings()

##Signal that needs to be emited when the state is finished.
@warning_ignore("unused_signal")
signal finished

##Called once when the state is first loaded.
@abstract func _setup()->void
##Called when the state starts execution.
@abstract func _start()-> void
##Called every frame by the state machine when this state is active. [code]_delta[/code] is delta physics frame time.
@abstract func _execute(_delta:float) -> void
##Called when the state exits
@abstract func _exit() -> void


@warning_ignore("unused_parameter")
func set_data(value:Variant,target:Dictionary) -> void:
	target["target"].set(target["property"], value)
