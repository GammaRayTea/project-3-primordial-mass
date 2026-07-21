extends Node3D
@export var player:Player
@export var dungeon_gen:DungeonGenerator
@export var enemies:Node3D
@export var objects:Node3D
@export var world_environment:WorldEnvironment
@export var default_env:Environment
@export var test_env:Environment
@export var testing:bool = true
@export var dark:bool = true
@export var test_room:PackedScene
func start():
	
	show()
	if dark:
		world_environment.environment = default_env
	else:
		world_environment.environment = test_env
	player.process_mode = Node.PROCESS_MODE_INHERIT
	if testing:
		var room = test_room.instantiate()
		add_child(room)
		dungeon_gen.hide()
		
	else:
		
		dungeon_gen.show()
		dungeon_gen._start_generation()
