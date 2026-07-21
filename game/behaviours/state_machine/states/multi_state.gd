@tool
class_name MultiState extends State


@export var states:Array[State] = []:
	set(value):
		states = []
		for entry in value:
			if !states.has(entry):
				states.append(entry)
			else:
				states.append(null)
				push_warning("No duplicate entries allowed. All states must be unique")
		
		
		var new_state_list:Dictionary[String,bool]
		for state in states:
			if state:
				if !await_state_list.has(state.name):
					new_state_list[state.name] = true
				else:
					new_state_list[state.name] = await_state_list[state.name]
		await_state_list = new_state_list
		notify_property_list_changed()

var await_state_list:Dictionary[String,bool]
func _get_property_list() -> Array[Dictionary]:
	var properties:Array[Dictionary] = []
	if states.size()> 0:

		properties.append({
			"name":"States to await",
			"type": TYPE_NIL,
			"usage" : PROPERTY_USAGE_GROUP
		})
				
		for state in states:
			if state:
				properties.append({
					
					"name":"Await" +state.name,
					"class_name":"State",
					"type":TYPE_BOOL,
					"hint":PROPERTY_HINT_NODE_TYPE,
					"hint_string":"State"
				})

	return properties
	

func _property_can_revert(property: StringName) -> bool:
	if property.begins_with("Await"):
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	if property.begins_with("Await"):
		return true
	return null
	
func _get(property: StringName) -> Variant:
	if property.begins_with("Await"):
		return await_state_list[property.erase(0,5)]
	for i in pass_data_target_amount:
		if property.begins_with("target_%d"% (i+1)):
			return pass_data_targets[i].target
		if property.begins_with("property_%d"% (i+1)):
			return pass_data_targets[i].property

	return null

func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("Await"):
		await_state_list[property.erase(0,5)] = value
		return true

	return false


var states_finished:int 
func _setup() -> void:
	for state in states:
		state._setup()
		state.finished.connect(on_state_finished.bind(state))


func _start() -> void:
	print(await_state_list.values().count(true))
	states_finished = 0
	for state in states:
		state._start()

func _execute(_delta:float) -> void:
	for state in states:
		state._execute(_delta)

func _exit() -> void:
	for state in states:
		state._exit()

func on_state_finished(_state:State) -> void:
	if await_state_list[_state.name]:
		states_finished += 1

	if states_finished == await_state_list.values().count(true):
		finished.emit()
