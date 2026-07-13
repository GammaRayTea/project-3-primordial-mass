class_name DropContainer extends Node3D


@export var type :GlobalEnum.CURRENCY
@export var value:int
@export var sprite:Sprite3D

func setup(_type:GlobalEnum.CURRENCY, _value:int) -> void:
	if _value <1:
		_value = 1
	type = _type
	value = _value


func _on_interaction_box_area_entered(_area: Area3D) -> void:
	GameState.save_game.add_currency(type,value)
	queue_free()
