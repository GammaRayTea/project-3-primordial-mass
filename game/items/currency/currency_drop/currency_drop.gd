class_name CurrencyDrop extends DropContainer



func hover_start() -> void:
	RunManager.change_currency(item.type,item.value)
	sound_manager._play(["PickUp"])
	queue_free()
func hover_end() -> void:
	pass
	
func activate(_source:Node3D) -> void:
	pass
	
func deactivate(_source:Node3D) -> void:
	pass
