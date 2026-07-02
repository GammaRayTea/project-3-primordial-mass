class_name ItemPickup extends Interactable

@export var item:Item

func _init(_item:Item) -> void:
	if !item:
		item = _item

func hover_start()-> void:
	pass

func hover_end()-> void:
	pass
