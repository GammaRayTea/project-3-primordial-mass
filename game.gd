class_name Game extends Node3D

@export var ui_controller:UIController


@export var world_environment:WorldEnvironment
@export var default_env:Environment
@export var test_env:Environment
@export var dungeon_gen:DungeonGenerator
@export var escape_sequence:EscapeSequence
@export var dark:bool = true

@export var player:Player
@export var enemies:Node3D
@export var objects:Node3D

@export var testing:bool = true
@export var test_room:PackedScene

@export var lock_seed:bool = false
@export var rng_seed:int = 0
var global_rng:RandomNumberGenerator = RandomNumberGenerator.new()

var current_state:Game.STATE
var paused:bool = false
enum STATE {MAIN_MENU, UPGRADE_MENU, IN_GAME, PAUSED}


func _ready() -> void:
	ui_controller.upgrade_menu.start_run_button.pressed.connect(switch_to_state.bind(STATE.IN_GAME))
	#ui_controller.upgrade_menu.return_to_menu_button.pressed.connect(save)
	ui_controller.main_menu.start_button.pressed.connect(switch_to_state.bind(STATE.UPGRADE_MENU))
	ui_controller.upgrade_menu.return_to_menu_button.pressed.connect(switch_to_state.bind(STATE.MAIN_MENU))
	ui_controller.upgrade_menu.return_to_menu_button.pressed.connect(RunManager.save_game)
	
	ui_controller.pause_screen.continue_button.pressed.connect(unpause)
	
	ui_controller.pause_screen.exit_button.pressed.connect(unpause)
	ui_controller.pause_screen.exit_button.pressed.connect(switch_to_state.bind(STATE.MAIN_MENU))
	
	for node in get_tree().get_nodes_in_group("RNGUnifier"):
		node.rng = global_rng
	switch_to_state(STATE.MAIN_MENU)
	

func start_run():
	#start ambience
	GlobalSoundManager.fade_out_music(1.5)
	GlobalSoundManager.start_ambience()

	#rng seed
	if lock_seed:
		global_rng.seed = rng_seed 
	else:
		global_rng.randomize()
	
	
	#show 3d scene
	show()
	
	#lighting
	if dark:
		world_environment.environment = default_env
	else:
		world_environment.environment = test_env
	process_mode = Node.PROCESS_MODE_INHERIT
	
	#init player
	player.start()
	
	#start dungeon gen
	if testing:
		var room = test_room.instantiate()
		add_child(room)
		dungeon_gen.hide()
		
	else:
		
		dungeon_gen.show()
		dungeon_gen._start_generation()
		
	RunManager.start_run()


func start_escape_sequence() -> void:
	escape_sequence.start(dungeon_gen.locked_cells)
	ui_controller.sound_manager._play(["EscapeStart"])

func end_run() -> void:
	RunManager.leave_run()
	clear_game()
	switch_to_state(STATE.UPGRADE_MENU)


func die() -> void:
	RunManager.lose_progress()
	clear_game()
	switch_to_state(STATE.UPGRADE_MENU)

func to_title() -> void:
	GlobalSoundManager.stop_ambience()
	GlobalSoundManager.queue_music(GlobalSoundManager.SONGS.MENU, true)

	clear_game()

func to_upgrade_menu() -> void:
	GlobalSoundManager.stop_ambience()
	GlobalSoundManager.queue_music(GlobalSoundManager.SONGS.MENU, true)
	clear_game()

func pause() -> void:
	get_tree().paused = true


func unpause() -> void:
	get_tree().paused = false
	switch_to_state(STATE.IN_GAME)


func switch_to_state(_state:STATE) -> void:
	#print("switching to ", STATE.keys()[_state])
	var previous = current_state
	current_state = _state
	ui_controller.switch_to_state(_state)
	match _state:
		STATE.MAIN_MENU:
			to_title()
		STATE.UPGRADE_MENU:
			if previous == STATE.MAIN_MENU:
				GameSaveManager.load_save()
				ui_controller.upgrade_menu.retrieve_saved_data()
			to_upgrade_menu()
		STATE.IN_GAME:
			if !previous == STATE.PAUSED:
				start_run()
		STATE.PAUSED:
			pause()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("pause") and current_state == STATE.IN_GAME:
		switch_to_state(STATE.PAUSED)



func clear_game() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	for child in enemies.get_children():
		child.queue_free()
	for child in objects.get_children():
		child.queue_free()
	dungeon_gen.clear_dungeon()
	escape_sequence.clear()
