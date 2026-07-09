extends Node3D
@export_category("Parameters")
@export var cell_size:int = 16
@export var cell_margin:int = 2
@export var random_seed:int
@export var debug:bool = false
		
@export_category("Components")
@export var player:Player
@export var active_map:Control
@export var outer_map:Control

@export var room_generator:RoomGen
var generated_rooms:Array

var start_pos = Vector2(0,0)
var current_position := Vector2(0,0):
	set(value):
		current_position = value
		if debug:
			print("new gen ---------------------------")
		expand_map()

var outer_check_range:int = 3
var inner_check_range:int = 1
var rng := RandomNumberGenerator.new()

var generated_cells:Dictionary[Vector2,Cell] = {}
var locked_cells:Dictionary[Vector2,Cell] = {}

func _ready() -> void:
	rng.seed = random_seed
	
	room_generator.rng = rng
	@warning_ignore("narrowing_conversion")
	var start_cell = Cell.new(cell_size,cell_size/2.0,rng)
	start_cell.global_point_position = start_cell.point_position
	generated_cells[start_pos] = start_cell

	
	active_map.cells.push_back(start_pos)
	outer_map.cells.push_back(start_pos)
	
	active_map.points.push_back(start_cell.point_position)
	outer_map.points.push_back(start_cell.point_position)
	
	
	expand_map()


func expand_map()->void:
	var staged_delanauy_ids := generate_new_cells(outer_check_range)
	lock_in_cells(inner_check_range, staged_delanauy_ids)


func _physics_process(_delta: float) -> void:
	var player_pos = Vector2(player.position.x, player.position.z) / cell_size
	
	var new_pos = Vector2()
	if (player_pos.x <0):
		new_pos.x = int(ceil(player_pos.x))
	else:
		new_pos.x = int(floor(player_pos.x)) 
	
	if (player_pos.y <0):
		new_pos.y = int(ceil(player_pos.y))
	else:
		new_pos.y = int(floor(player_pos.y))
	
	if (new_pos != current_position):
		current_position = new_pos
		active_map.player_pos = new_pos
		outer_map.player_pos = new_pos
		
	
	
	

##Check Cells in a rectangle around current cell
func generate_new_cells(_check_range:int) -> PackedInt32Array:
	var new_cells:Dictionary[Vector2,Cell] = {}
	for i in range(_check_range*2+1):
		for j in range(_check_range*2+1):
			var pos = (Vector2(i-_check_range,j-_check_range) +current_position)*cell_size
			if !generated_cells.has(pos):

				new_cells[pos] = Cell.new(cell_size,cell_margin, rng )
				new_cells[pos].global_point_position = pos+new_cells[pos].point_position
				outer_map.cells.push_back(pos)
				outer_map.points.push_back(new_cells[pos].point_position)
	
	generated_cells.merge(new_cells)
	
	var world_points = get_points(generated_cells)
	var delaunayIDs = Geometry2D.triangulate_delaunay(world_points)
	
	outer_map.draw_point_ids = delaunayIDs
	outer_map.delaunay_points = world_points
	active_map.delaunay_points = world_points

	outer_map.queue_redraw()
	
	return delaunayIDs
	
func lock_in_cells(_check_range:int, _staged_delaunay_ids:PackedInt32Array) -> void:
	var new_positions:=PackedVector2Array()
	var active_delaunay:= PackedInt32Array()
	for i in range(_check_range*2+1):
		for j in range(_check_range*2+1):
			var pos = (Vector2(i-_check_range,j-_check_range) +current_position)*cell_size
			new_positions.push_back(pos)
			
			if !locked_cells.has(pos):
				locked_cells[pos] = generated_cells[pos]
				
				
				
				active_map.cells.push_back(pos)
				active_map.points.push_back(locked_cells[pos].point_position)
				var cell_accepted_connection_ids:PackedInt32Array = get_cell_draw_ids(_staged_delaunay_ids,pos)
				
		
				
				active_delaunay.append_array(cell_accepted_connection_ids)
				
				generated_rooms.append(room_generator.generate_room(cell_size,locked_cells[pos].global_point_position,pos, locked_cells[pos].connections))
				
				#if(pos == start_pos):
					#for room in generated_rooms:
						#print("room " ,generated_rooms.find(room),"---------------------------------")
						#for line in room:
							#print(line)
				
	active_map.draw_point_ids.append_array(active_delaunay)
	active_map.queue_redraw()
	for line in generated_rooms[0]:
		print(line)
		
	print(generated_cells[Vector2(-16,-16)].connections[0].global_point_position)
	print(generated_cells[Vector2(-16,-16)].connections[1].global_point_position)
	print(generated_cells[Vector2(-16,-16)].connections[2].global_point_position)
	print(generated_cells[Vector2(-16,-16)].connections[3].global_point_position)

func cell_to_world(_coord:Vector2) -> Vector3:
	var vec = Vector3(_coord.x * cell_size, 0 ,_coord.y*cell_size)
	return vec


func get_points(_cell_dict) -> PackedVector2Array:
	var points := PackedVector2Array()
	
	for pos in  _cell_dict:
		points.push_back(_cell_dict[pos].point_position + pos )
	
	return points
	
func get_cell_draw_ids(_outer_ids:PackedInt32Array, _cell_pos:Vector2) -> PackedInt32Array:
	var cell_id:int = generated_cells.keys().find(_cell_pos)
	
	var ids_triangles_with_pos:PackedInt32Array
	var i:int = 0
	
	var cell_neighbour_ids:PackedInt32Array = get_cell_neighbours(_cell_pos)
	if debug:
		print("---------------id ",cell_id, " pos ", _cell_pos/16,"----------------------------")
		print("neighbours: ", cell_neighbour_ids)
		print(_outer_ids.count(cell_id), " triangles found")
	
	#find indices of where the triangles containing this point start
	var accepted_lines := PackedInt32Array()
	while i < _outer_ids.size():
		if _outer_ids[i] == cell_id:
			
			var triangle:=PackedInt32Array()
			triangle = _outer_ids.slice(i- i%3,i- i%3+3)
			ids_triangles_with_pos.append(i- i%3)
			if debug:
				print(triangle)
			
			for id in triangle:
				if cell_neighbour_ids.has(id):
					accepted_lines.append_array([cell_id,id])
					var neighbour_cell:Cell= generated_cells[generated_cells.keys()[id]]
					if !locked_cells[_cell_pos].connections.has(neighbour_cell):
						
						locked_cells[_cell_pos].connections.append(neighbour_cell)
				else:
					if debug:
						print("cell ", cell_id ,": cut ", [cell_id,id], " because of ", id)
					
		
		
		i += 1
	if debug:
		print("cell ", cell_id," ",_cell_pos, " has ",locked_cells[_cell_pos].connections.size(), " connections: ", locked_cells[_cell_pos].connections, " from ", generated_cells[_cell_pos].global_point_position)
	return accepted_lines

	
func get_cell_neighbours(_cell_pos:Vector2) -> PackedInt32Array:
	var ids:=PackedInt32Array()
	ids.push_back(generated_cells.keys().find(_cell_pos-Vector2(cell_size,0)))
	ids.push_back(generated_cells.keys().find(_cell_pos-Vector2(0,cell_size)))
	ids.push_back(generated_cells.keys().find(_cell_pos+Vector2(cell_size,0)))
	ids.push_back(generated_cells.keys().find(_cell_pos+Vector2(0,cell_size)))
	
	return ids
