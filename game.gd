extends Node3D
@export var player:Player
@export var hud:Control
@export var dungeon_gen:DungeonGenerator
@export var enemies:Node3D
@export var objects:Node3D
@export var world_environment:WorldEnvironment
@export var default_env:Environment
@export var test_env:Environment
@export var testing:bool = true
@export var dark:bool = true
@export var test_room:PackedScene

@export var rng_seed:int = 0
var global_rng:RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	global_rng.seed = rng_seed

func start():
	
	for node in get_tree().get_nodes_in_group("RNGUnifier"):
		node.rng = global_rng
	
	show()
	if dark:
		world_environment.environment = default_env
	else:
		world_environment.environment = test_env
	player.process_mode = Node.PROCESS_MODE_INHERIT
	hud.show()
	if testing:
		var room = test_room.instantiate()
		add_child(room)
		dungeon_gen.hide()
		
	else:
		
		dungeon_gen.show()
		dungeon_gen._start_generation()
