class_name DungeonGenerator extends Node3D
@export_category("Parameters")
@export var cell_size: int = 16
@export var cell_margin: int = 2
@export var debug: bool = false
		
@export_category("Components")
@export var player: Player
@export var generated_map: Control
@export var outer_map: Control



@export var room_generator: RoomGen
var generated_rooms: Array[BitMap]
var generated_room_mesh: Array[Array]

var start_pos = Vector2(0, 0)
var current_position := Vector2(0, 0):
	set(value):
		current_position = value
		call_deferred("expand_map")

var outer_check_range: int = 3
var inner_check_range: int = 1
var rng : RandomNumberGenerator

var generated_cells: Dictionary[Vector2, Cell] = {}
var locked_cells: Dictionary[Vector2, Cell] = {}

var current_cell_tier:int

func _start_generation() -> void:
	current_cell_tier = 0
	room_generator.rng = rng
	@warning_ignore("narrowing_conversion")
	var start_cell = Cell.new(cell_size, cell_size / 2.0, rng)
	start_cell.global_point_position = start_cell.point_position
	generated_cells[start_pos] = start_cell
	start_cell.tier = current_cell_tier
	
	call_deferred("expand_map")


func expand_map() -> void:
	print("expanding")
	
	var staged_delanauy_ids := generate_new_cells(outer_check_range)
	lock_in_cells(inner_check_range, staged_delanauy_ids)


func _physics_process(_delta: float) -> void:
	var player_pos = Vector2(player.position.x, player.position.z) / cell_size
	
	var new_pos = Vector2()
	if (player_pos.x < 0):
		new_pos.x = int(ceil(player_pos.x))
	else:
		new_pos.x = int(floor(player_pos.x)) 
	
	if (player_pos.y < 0):
		new_pos.y = int(ceil(player_pos.y))
	else:
		new_pos.y = int(floor(player_pos.y))
	
	if (new_pos != current_position):
		current_position = new_pos
		generated_map.player_pos = new_pos
		outer_map.player_pos = new_pos
		
	
	
	

##Check Cells in a rectangle around current cell and generate a preliminary delaunay triangulation. Returns ids of points of triangulation in sets of threes, forming triangles.
func generate_new_cells(_check_range: int) -> PackedInt32Array:
	var new_cells:Dictionary[Vector2, Cell] = {}
	for i in range(_check_range * 2 + 1):
		for j in range(_check_range * 2 + 1):
			var pos = (Vector2(i - _check_range, j - _check_range) + current_position) * cell_size
			if !generated_cells.has(pos):

				new_cells[pos] = Cell.new(cell_size, cell_margin, rng)
				new_cells[pos].global_point_position = pos + new_cells[pos].point_position
				
				outer_map.cells.push_back(pos)
				outer_map.points.push_back(new_cells[pos].point_position)
	
	generated_cells.merge(new_cells)
	
	var world_points = get_points(generated_cells)
	var delaunayIDs = Geometry2D.triangulate_delaunay(world_points)
	
	outer_map.draw_point_ids = delaunayIDs
	outer_map.delaunay_points = world_points
	generated_map.delaunay_points = world_points

	outer_map.queue_redraw()
	
	return delaunayIDs


func lock_in_cells(_check_range: int, _staged_delaunay_ids: PackedInt32Array) -> void:
	var active_delaunay := PackedInt32Array()
	var have_new_cells_been_locked:bool = false
	
	for i in range(_check_range * 2 + 1):
		for j in range(_check_range * 2 + 1):
			var pos = (Vector2(i - _check_range, j - _check_range) + current_position) * cell_size

			
			if !locked_cells.has(pos):
				have_new_cells_been_locked = true
				
				
				locked_cells[pos] = generated_cells[pos]
				locked_cells[pos].tier = current_cell_tier+1
				
				print(locked_cells[pos].tier )
				generated_map.cells.push_back(pos)
				generated_map.points.push_back(locked_cells[pos].point_position)
				var cell_accepted_connection_ids: PackedInt32Array = get_cell_draw_ids(_staged_delaunay_ids, pos)
				
		
				
				active_delaunay.append_array(cell_accepted_connection_ids)
				var room_bit_map: BitMap = room_generator.generate_room(cell_size, locked_cells[pos].global_point_position, pos, locked_cells[pos].connections)
				generated_rooms.append(room_bit_map)
				generated_map.room_bit_maps.append(ImageTexture.create_from_image(room_bit_map.convert_to_image()))
				generated_cells[pos].bit_map = room_bit_map
				if debug:
					print("cell ", pos)
					for cell in locked_cells[pos].connections:
						print(cell.global_point_position)
						
				
				# Instantiate mesh
				make_cell_mesh(room_bit_map,pos)

	if have_new_cells_been_locked:
		current_cell_tier+=1
	generated_map.draw_point_ids.append_array(active_delaunay)
	generated_map.current_cell_tier = current_cell_tier
	generated_map.queue_redraw()
	

func make_cell_mesh(_bit_map:BitMap, _position:Vector2) -> void:
	var cell_instance: RoomMesh = RoomMesh.new(
		Vector2(cell_size,cell_size),
		rng,
		EnvironmentMaterials.get_material(EnvironmentMaterials.MATERIALS.FLOOR_WOOD),
		EnvironmentMaterials.get_material(EnvironmentMaterials.MATERIALS.TEST_CEILING),
		EnvironmentMaterials.get_material(EnvironmentMaterials.MATERIALS.WALL_PAPER),
		)
	add_child(cell_instance)
	var cell_position_wc: Vector3 = cell_to_world(_position / cell_size) + Vector3(-cell_size / 2.0, 0.0, -cell_size / 2.0)
	cell_instance.position = cell_position_wc
	cell_instance.build_mesh(_bit_map)
	generated_room_mesh.append([_position, cell_instance])


func cell_to_world(_coord:Vector2) -> Vector3:
	var vec = Vector3(_coord.x * cell_size, 0, _coord.y * cell_size)
	return vec


func get_points(_cell_dict) -> PackedVector2Array:
	var points := PackedVector2Array()
	
	for pos in  _cell_dict:
		points.push_back(_cell_dict[pos].point_position + pos )
	
	return points
	
func get_cell_draw_ids(_outer_ids:PackedInt32Array, _cell_pos: Vector2) -> PackedInt32Array:
	var cell_id: int = generated_cells.keys().find(_cell_pos)
	var this_cell: Cell = generated_cells[_cell_pos]
	var ids_triangles_with_pos: PackedInt32Array
	
	var cell_neighbour_ids: PackedInt32Array = get_cell_neighbours(_cell_pos)
	if debug:
		print("---------------id ", cell_id, " pos ", _cell_pos / 16, "----------------------------")
		print("neighbours: ", cell_neighbour_ids)
		print(_outer_ids.count(cell_id), " triangles found")
	
	#find indices of lines to draw, meaning they have valid connections
	var found_lines: Array[Array] = []
	
	var i: int = 0
	while i < _outer_ids.size():
		if _outer_ids[i] == cell_id:
			#get start of triangle that contains cell_id
			var triangle := PackedInt32Array()
			triangle = _outer_ids.slice(i - i % 3, i - i % 3 + 3)
			ids_triangles_with_pos.append(i - i % 3)
			if debug:
				print(triangle)
			#find valid lines to neighbours
			for id in triangle:
				if cell_neighbour_ids.has(id):
					var neighbour_cell: Cell= generated_cells[generated_cells.keys()[id]]
					
					if !locked_cells[_cell_pos].connections.has(neighbour_cell):
						locked_cells[_cell_pos].connections.append(neighbour_cell)
						
					if !found_lines.has([cell_id,id]):
						found_lines.append([cell_id,id])
						
		i += 1

	var accepted_lines := PackedInt32Array()
	
	#if debug:
		#print(_cell_pos, "---------", cell_id)
	
	for neighbour_cell in this_cell.connections:
		if locked_cells.values().has(neighbour_cell) and !neighbour_cell.connections.has(this_cell):
			this_cell.connections.erase(neighbour_cell)
			
	var connection_amount = this_cell.connections.size()
	if connection_amount == 0:
		push_warning("Cell with no connections detected")
	for line in found_lines:

		var id = line[1]
		var neighbour_cell: Cell = generated_cells.values()[id]
		
		if this_cell.connections.has(neighbour_cell):
			if !neighbour_cell.connections.has(this_cell) and connection_amount > 2 and rng.randf() > 0.5:
				this_cell.connections.erase(neighbour_cell)
				connection_amount -= 1
				#if debug:
					#print("discarded ", line, ", connection to ", generated_cells.find_key(neighbour_cell))
			else:
				accepted_lines.append_array(line)
				#if debug:
					#print("accepted ",line, ", connection to ",generated_cells.find_key(neighbour_cell))
#
	#if debug:
		#print(accepted_lines)
	return accepted_lines



func get_cell_neighbours(_cell_pos: Vector2) -> PackedInt32Array:
	var ids := PackedInt32Array()
	ids.push_back(generated_cells.keys().find(_cell_pos-Vector2(cell_size, 0)))
	ids.push_back(generated_cells.keys().find(_cell_pos-Vector2(0, cell_size)))
	ids.push_back(generated_cells.keys().find(_cell_pos+Vector2(cell_size, 0)))
	ids.push_back(generated_cells.keys().find(_cell_pos+Vector2(0, cell_size)))
	return ids


func _on_visibility_changed() -> void:
	$Control.visible = visible
