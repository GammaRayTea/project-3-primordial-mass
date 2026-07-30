class_name CurrencyDrop extends DropContainer



func _ready() -> void:
	#sprite.material_override =sprite.material_overlay.duplicate()
	super()
	
func hover_start() -> void:
	RunManager.change_run_currency(item.type,item.value)
	sound_manager._play(["PickUp"])
	queue_free()
func hover_end() -> void:
	pass
	
func activate(_source:Node3D) -> void:
	pass
	
func deactivate(_source:Node3D) -> void:
	pass
