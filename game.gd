extends Node3D
@export var player:Player
@export var dungeon_gen:DungeonGenerator
@export var enemies:Node3D
@export var objects:Node3D

@export var testing:bool = true
@export var test_room:PackedScene
func start():
	dungeon_gen._start_generation()
	show()
	player.process_mode = Node.PROCESS_MODE_INHERIT
	if testing:
		var room = test_room.instantiate()
		add_child(room)
