@tool
class_name DropEvent extends Event

@export var drop_container:PackedScene
@export var source:Node3D


@export var min_value:int
@export var max_value:int
@export var type:GlobalEnum.CURRENCY
@export var random_type:bool = true

func execute() -> void:
	pass
	var drop:CurrencyDrop = drop_container.instantiate()
	print(drop)
	if random_type:
		drop.item = Currency.make_random(min_value,max_value)
	(get_tree().get_first_node_in_group("Game") as Game).objects.add_child(drop)
	drop.global_position = source.global_position
	
