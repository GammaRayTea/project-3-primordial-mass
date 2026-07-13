class_name DropContainer extends Node3D

enum CURRENCY {TEST}
@export var type :CURRENCY
@export var value:int

func setup(_type:CURRENCY, _value:int) -> void:
	if _value <1:
		_value = 1
	type = _type
	value = _value


func _on_interaction_box_area_entered(_area: Area3D) -> void:
	#GameState.save_game.currency[type]+= value
	queue_free()
