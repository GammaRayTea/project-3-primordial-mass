@tool
@abstract class_name State extends Node
##Base class for all States. extends this to create a new one.

##State that the state machine will switch to after this state is finished.
@export var next_state:State:
	set(value):
		next_state = value
		update_configuration_warnings()
		
@export var animation_state_name:String
@export var animation_time_scale:float = 1.0




@export_category("Pass Data")
## If enabled, will expose funtionality of sending data to another state. Add sends by increasing "Target Amount". Each send will have a target state node and the name of the property to change on that Node.
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


var _play_sound:bool =false:
	set(value):
		_play_sound = value
		if value:
			_sound_amount = 1
		else:
			_sound_amount = 0
		notify_property_list_changed()


		
var _sound_amount:int = 1:
	set(value):
		if value > 0:
			_sound_amount = value
			if  value > sound_info.size():
				for i in value-sound_info.size():
					sound_info.append({
						"name":"",
						"offset":0.0
					})
			else:
				sound_info.resize(value)

var sound_names:PackedStringArray:
	get():
		sound_names = PackedStringArray()
		for i in sound_info.size():
			sound_names.append(sound_info[i].name)
		return sound_names

var sound_info:Array[Dictionary] = []

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
			
	
	properties.append({
		"name":"Sound",
		"type": TYPE_NIL,
		"usage" : PROPERTY_USAGE_CATEGORY
		})
	properties.append({
		"name":"play_sound",
		"type":TYPE_BOOL
	})
	if _play_sound:
		
		properties.append(
			{
			"name":"sound_amount",
			"type":TYPE_INT
			}
		
		)
		for i in _sound_amount:
			properties.append({
			"name":"sound_properties_%d" % (i+1),
			"type": TYPE_DICTIONARY,
			"hint_string":"%d:" % [TYPE_STRING],
			"usage":PROPERTY_USAGE_DEFAULT
			})
	return properties
	


func _property_can_revert(property: StringName) -> bool:
	match property:
		"sound_effect_manager":
			return true
		"target_amount":
			return true
		"sound_amount":
			return true
		_:
			return false

func _property_get_revert(property: StringName) -> Variant:
	match property:
		"sound_effect_manager":
			return null
		"target_amount":
			return 0
		"sound_amount":
			return 1
		_:
			return null
	
func _get(property: StringName) -> Variant:
	match property:
		"sound_amount":
			return _sound_amount
		"play_sound":
			return _play_sound
		_:
			if property.begins_with("target_amount"):
				return pass_data_target_amount
			elif property.begins_with("sound_properties_") and property.to_int() is int:
				if sound_info.size() >property.to_int()-1:
					return sound_info[property.to_int()-1]
			for i in pass_data_target_amount:
				if property.begins_with("target_%d"% (i+1)):
					return pass_data_targets[i].target
				if property.begins_with("property_%d"% (i+1)):
					return pass_data_targets[i].property
	return null

func _set(property: StringName, value: Variant) -> bool:
	match property:
		"play_sound":
			_play_sound = value
			return true
		"sound_amount":
			_sound_amount = value
			return true
		_:
			if property.begins_with("target_amount"):
				pass_data_target_amount = value
				return true
			elif property.begins_with("sound_properties_") and property.to_int() is int:
				sound_info[property.to_int()-1] = value
				return true

			elif property.begins_with("target_") and property.to_int() is int:
					pass_data_targets[property.to_int()-1].target= value
					return true
			elif property.begins_with("property_") and property.to_int() is int:
					pass_data_targets[property.to_int()-1].property= value
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
signal finished(_source:State)

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
