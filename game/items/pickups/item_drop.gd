
class_name ItemDrop extends DropContainer


@export var interaction_box:InteractionBox = null



var player:Player


func hover_start()-> void:
	(get_tree().get_first_node_in_group("Game") as Game).ui_controller.hud.show_hint("Press E to pick up Pearl")

func hover_end()-> void:
	(get_tree().get_first_node_in_group("Game") as Game).ui_controller.hud.hide_hint()

func activate(_source:Node3D) -> void:
	if _source is Player:
		sound_manager._play(["PickUp"])
		_source.pick_up_item(item)
		queue_free()

func deactivate(_source:Node3D) -> void:
	pass
