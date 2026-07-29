@tool
class_name FreeEvent extends Event

@export var target:Node

func execute() -> void:
	target.queue_free()
