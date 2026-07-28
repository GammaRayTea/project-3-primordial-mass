
class_name ItemDrop extends DropContainer


@export var interaction_box:InteractionBox = null


var player:Player


func hover_start()-> void:
	pass

func hover_end()-> void:
	pass

func activate(_source:Node3D) -> void:
	if _source is Player:
		sound_manager._play(["PickUp"])
		_source.pick_up_item(item)
		queue_free()

func deactivate(_source:Node3D) -> void:
	pass
