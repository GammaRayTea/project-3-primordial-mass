extends Node


@export var generator:DungeonGenerator
@export var enemy_wrapper:Node3D
@export var object_wrapper:Node3D
var rng:RandomNumberGenerator


func _ready() -> void:
	rng = generator.rng

#TODO: 
#need lists of enemies and puzzles
#decide what can spawn based on modifiers

#function that branches into spawners and stuff
func evaluate_cell(_cell:Cell) -> void:
	# look at neighbours
	# accumulate value of how many neighbours have enemies
	# randomize whether one spawns based on that value
	# same for traps
	#spawn enemeis, assign modifers, make puzzles
	pass

func spawn_enemy(_cell:Cell) -> void:
	
	#choose random enemy
	#decide whether to place trap
	#decide spaces that are free
	#spawn at location
	pass
