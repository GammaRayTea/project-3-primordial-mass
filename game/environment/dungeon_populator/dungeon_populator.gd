class_name DungeonPopulator extends Node


#@export var generator:DungeonGenerator
@export var cell_size = Vector2i(16,16)
@export_category("Wrappers")
@export var enemy_wrapper:Node3D
@export var object_wrapper:Node3D

@export_category("Scenes")
enum ENEMY_NAMES {GLOBBER, BUNNY, DRAGONFLY}
enum CONTAINER_NAMES {CHEST, PILLAR}
enum OBJECT_TYPE {CONTAINER, ENEMY, KEY}

@export var enemy_scenes:Dictionary[ENEMY_NAMES,PackedScene]
@export var container_scenes:Dictionary[CONTAINER_NAMES, PackedScene]
@export var pearl_scene:PackedScene

@export_category("Probabilites")
@export var base_p_enemy:float = 40.0
@export var base_p_container:float = 60.0
@export var base_p_pearl:float = 40.0


var rng:RandomNumberGenerator


func evaluate_cell(_cell:Cell) -> void:
	if _cell.cell_position == Vector2(0.0, 0.0):
		return
	
	var valid_positions:Array[Vector2i] = get_list_of_true_positions(_cell.bit_map)
	
	var p_enemy = base_p_enemy
	var p_container= base_p_container
	var p_pearl = base_p_pearl
	
	
	
	
	
	# look at neighbours
	# accumulate value of how many neighbours have stuff and subtract from probability
	for cell in _cell.connections:
		if cell.enemy_total > 0:
			p_enemy -= 10.0
		if cell.has_container:
			p_container -= 10.0
			p_enemy += 15.0
			p_pearl += 5.0
		if cell.has_pearl:
			p_pearl -= 10.0
			p_container += 5.0
	
	# ENEMIES-------
	var test_enemy = rng.randf_range(0.0,100.0)
	if test_enemy < p_enemy:
		var result = spawn_object(OBJECT_TYPE.ENEMY,_cell,valid_positions )
		if result[0]:
			valid_positions.erase(result[1])
			
	
	# CONTAINERS-------
	var test_container = rng.randf_range(0.0,100.0)
	if test_container < p_container:
		var result = spawn_object(OBJECT_TYPE.CONTAINER,_cell,valid_positions )
		if result[0]:
			valid_positions.erase(result[1])
	else:
		print("container test failed ", test_container, " ", p_container)
	# KEYS-------
	var test_key = rng.randf_range(0.0,100.0)
	if test_key < p_pearl:
		var result = spawn_object(OBJECT_TYPE.KEY,_cell,valid_positions )
		if result[0]:
			valid_positions.erase(result[1])



##Spawns random enemy at random position of given valid positions. Returns chosen position.
func spawn_object(_type:OBJECT_TYPE,_cell:Cell, _valid_positions:Array[Vector2i]) -> Array:
	

	var object_instance:Node3D
	var tile_spawn_margin:int
	match _type:
		OBJECT_TYPE.ENEMY:
			#choose random enemy
			var enemy_key = ENEMY_NAMES.values()[rng.randi_range(0,ENEMY_NAMES.size()-1)]
			var enemy_instance:Enemy = enemy_scenes[enemy_key].instantiate()
			object_instance = enemy_instance
			enemy_wrapper.add_child(object_instance)
			
		
			tile_spawn_margin = object_instance.tile_spawn_margin
			
			#update cell list
			if _cell.enemy_amounts.keys().has(enemy_key):
				_cell.enemy_amounts[enemy_key] += 1
			else:
				_cell.enemy_amounts[enemy_key] = 0
			
		OBJECT_TYPE.CONTAINER:
			#choose random container:
			var container_instance:Chest = container_scenes.values().pick_random().instantiate()
			object_instance = container_instance
			object_wrapper.add_child(object_instance)
			
			tile_spawn_margin = object_instance.tile_spawn_margin
			
			_cell.has_container = true
		OBJECT_TYPE.KEY:
			#instane pearl
			var pearl_instance:ItemDrop = pearl_scene.instantiate()
			object_instance = pearl_instance
			object_wrapper.add_child(object_instance)
			
			tile_spawn_margin = 1
			
			_cell.has_pearl = true
	
	
	
	


	#decide spawn location
	var valid_position = get_valid_position_within_cell(_cell,_valid_positions,tile_spawn_margin)
	var location_found:bool = valid_position[0]
	var spawn_pos:Vector2i = valid_position[1]
	object_instance.global_position = Vector3(spawn_pos.x, 0 , spawn_pos.y) + Vector3(_cell.cell_position.x, 0.1, _cell.cell_position.y) + Vector3(0.5, 0.0, 0.5)
	
	
	if location_found == false:
		return [false, Vector2.ZERO]
		
	return [true,spawn_pos]

## chooses a random position within a given cell, accounting for the to be spawned objects tile spawn margin
func get_valid_position_within_cell(_cell:Cell, _valid_positions:Array[Vector2i], _tile_spawn_margin:int) -> Variant:
	var location_found:bool = false
	var spawn_pos:Vector2i
	

	var iteration_countdown = 200
	while !location_found:
		iteration_countdown -=1
		spawn_pos = _valid_positions[rng.randi_range(0,_valid_positions.size()-1)]
		var adjacent_true_amount:int = get_adjacent_true_amount(spawn_pos,_tile_spawn_margin, _cell.bit_map)
		if iteration_countdown <= 0:
			return [false, Vector2.ZERO]
		if adjacent_true_amount >= _tile_spawn_margin * 4:
			location_found = true
	return [true,spawn_pos]

## Returns list of positions within BitMap that are true
func get_list_of_true_positions(_bit_map:BitMap) -> Array[Vector2i]:
	var positions:Array[Vector2i]
	
	for x in _bit_map.get_size().x-1:
		for y in _bit_map.get_size().y-1:
			if _bit_map.get_bit(x,y):
				
				positions.append(Vector2i(x,y))
	return positions


func get_adjacent_true_amount(_pos:Vector2,_enemy_margin:int, _bit_map:BitMap) -> int:
	var count:int = 0
	for m in _enemy_margin:
		for i in 4:
			var neighbour_pos =  _pos + Vector2(_enemy_margin,0).rotated(PI/2*i)

			if cell_size.x > neighbour_pos.x and neighbour_pos.x > 0 and cell_size.y > neighbour_pos.y and neighbour_pos.y > 0 :
				if _bit_map.get_bit(neighbour_pos.x,neighbour_pos.y):
					count += 1

	return count
	
	
