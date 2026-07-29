@tool
class_name SetPropertyEvent extends Event

@export var target:Node
@export var property:String
@export var value:Variant

func execute() -> void:
	target.set(property, value)
