@tool
class_name DropEvent extends Event

@export var drop_container:PackedScene
@export var source:Node3D


@export var min_value:int
@export var max_value:int
@export var type:GlobalEnum.CURRENCY

func execute() -> void:
	pass
	var drop:DropContainer = drop_container.instantiate()
	print(drop)
	drop.setup(type,randi_range(min_value,max_value))
	get_tree().get_first_node_in_group("Game").add_child(drop)
	drop.global_position = source.global_position
	
