class_name DungeonPopulator extends Node


#@export var generator:DungeonGenerator
@export var enemy_wrapper:Node3D
@export var object_wrapper:Node3D

enum ENEMY_NAMES {GLOBBER, BUNNY, DRAGONFLY}

@export var enemy_scenes:Dictionary[ENEMY_NAMES,PackedScene]

@export var cell_size = Vector2i(16,16)

var rng:RandomNumberGenerator


func evaluate_cell(_cell:Cell) -> void:
	
	var valid_positions:Array[Vector2i] = get_list_of_true_positions(_cell.bit_map)
	
	# ENEMIES-------
	var p_enemy:float = 40.0
	
	
	# look at neighbours
	# accumulate value of how many neighbours have enemies
	for cell in _cell.connections:
		if cell.enemy_total >0:
			p_enemy -= 10.0
	var test = rng.randf_range(0.0,100.0)
	if test< p_enemy and _cell.cell_position!= Vector2(0,0):
		var result = spawn_enemy(_cell,valid_positions )
		if result[0]:
			valid_positions.erase(result[1])




##Spawns random enemy at random position of given valid positions. Returns chosen position.
func spawn_enemy(_cell:Cell, _valid_positions:Array[Vector2i]) -> Array:
	
	#choose random enemy
	var enemy_key = ENEMY_NAMES.values()[rng.randi_range(0,ENEMY_NAMES.size()-1)]
	
	var trap_p = 0.5
	
	#decide whether to place trap
	if rng.randf_range(0,1) < trap_p:
		pass
	#decide spawn location
	var location_found:bool = false
	var spawn_pos:Vector2i
	var enemy_instance:Enemy = enemy_scenes[enemy_key].instantiate()
	
	var enemy_margin =  enemy_instance.tile_spawn_margin * 4

	var iteration_countdown = 200
	while !location_found:
		iteration_countdown -=1
		spawn_pos = _valid_positions[rng.randi_range(0,_valid_positions.size()-1)]
		var adjacent_true_amount:int = get_adjacent_true_amount(spawn_pos,enemy_instance.tile_spawn_margin, _cell.bit_map)
		if iteration_countdown <= 0:
			return [false, Vector2.ZERO]
		if adjacent_true_amount >= enemy_margin:
			location_found = true
		
	#spawn at location
	
	
	enemy_wrapper.add_child(enemy_instance)
	enemy_instance.global_position = Vector3(spawn_pos.x, 0 , spawn_pos.y) + Vector3(_cell.cell_position.x, 2, _cell.cell_position.y)
	
	#update cell list
	if _cell.enemy_amounts.keys().has(enemy_key):
		_cell.enemy_amounts[enemy_key]+=1
	else:
		_cell.enemy_amounts[enemy_key]= 0
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
	
	
