class_name RoomMesh extends MeshInstance3D

var room_collisions:StaticBody3D

var floor_material:Material
var ceiling_material:Material
var wall_material:Material

var grid_size:Vector2i = Vector2i(16,16)

var rng:RandomNumberGenerator

func _init(_grid_size:Vector2,_rng:RandomNumberGenerator,_floor_material:Material,_ceiling_material:Material,_wall_material:Material) -> void:
	floor_material = _floor_material
	ceiling_material = _ceiling_material
	wall_material = _wall_material
	rng = _rng
	grid_size = _grid_size
func _ready() -> void:
	room_collisions = StaticBody3D.new()
	add_child(room_collisions)


func make_array() -> Array:
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	
	
	array[Mesh.ARRAY_VERTEX] = PackedVector3Array()
	array[Mesh.ARRAY_NORMAL] = PackedVector3Array()
	array[Mesh.ARRAY_TEX_UV] = PackedVector2Array()
	array[Mesh.ARRAY_COLOR] = PackedColorArray()
	array[Mesh.ARRAY_INDEX] = PackedInt32Array()
	return array
	

## Builds a mesh from a BitMap
func build_mesh(_grid: BitMap) -> void:
	
	
	var surface_array_ceil = make_array()
	var surface_array_wall = make_array()
	var surface_array_floor = make_array()
	
	
	
	
	if mesh == null:
		mesh = ArrayMesh.new()

	for current_sub_cell_y in range(grid_size.y):
		
		for current_sub_cell_x in range(grid_size.x):

			if (_grid.get_bit(current_sub_cell_x, current_sub_cell_y) == true):
				surface_array_floor = generate_floor(current_sub_cell_x, current_sub_cell_y, 0.0, surface_array_floor)
				
			else:
				surface_array_ceil = generate_floor(current_sub_cell_x,current_sub_cell_y,2.0, surface_array_ceil)
				var adjacent: Array[bool] = [
					does_bit_exist(current_sub_cell_x, current_sub_cell_y - 1, _grid), 
					does_bit_exist(current_sub_cell_x, current_sub_cell_y + 1, _grid) , 
					does_bit_exist(current_sub_cell_x + 1, current_sub_cell_y, _grid), 
					does_bit_exist(current_sub_cell_x - 1, current_sub_cell_y, _grid)
				]
				generate_walls(current_sub_cell_x, current_sub_cell_y, adjacent)
	
	
	# make floor mesh from arrays
	surface_array_floor[Mesh.ARRAY_VERTEX] = verts_floor
	surface_array_floor[Mesh.ARRAY_NORMAL] = normals_floor
	surface_array_floor[Mesh.ARRAY_TEX_UV] = uvs_floor
	surface_array_floor[Mesh.ARRAY_COLOR] = colors_floor
	surface_array_floor[Mesh.ARRAY_INDEX] = indices_floor
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array_floor)
	
	#make floor collision from mesh
	var collision_instance_floor := CollisionShape3D.new()
	collision_instance_floor.shape = mesh.create_trimesh_shape()
	room_collisions.add_child(collision_instance_floor)
	
	(mesh as ArrayMesh).surface_set_material((mesh as ArrayMesh).get_surface_count()-1,test_mat)
	
	
	
	# make wall mesh from arrays
	surface_array_wall[Mesh.ARRAY_VERTEX] = verts_wall
	surface_array_wall[Mesh.ARRAY_NORMAL] = normals_wall
	surface_array_wall[Mesh.ARRAY_TEX_UV] = uvs_wall
	surface_array_wall[Mesh.ARRAY_COLOR] = colors_wall
	surface_array_wall[Mesh.ARRAY_INDEX] = indices_wall
	(mesh as ArrayMesh).add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array_wall)
	(mesh as ArrayMesh).create_trimesh_shape()
	(mesh as ArrayMesh).surface_set_material((mesh as ArrayMesh).get_surface_count()-1,test_mat2)
	
	#make floor collision from wall
	var collision_instance_wall := CollisionShape3D.new()
	collision_instance_wall.shape = mesh.create_trimesh_shape()
	room_collisions.add_child(collision_instance_wall)

	add_mesh(surface_array_floor,floor_material)
	add_mesh(surface_array_ceil,ceiling_material)
	add_mesh(surface_array_wall, wall_material)

	
	
	#make collisionmesh
	var collision_instance := CollisionShape3D.new()
	collision_instance.shape = mesh.create_trimesh_shape()
	room_collisions.add_child(collision_instance)




func add_mesh(_mesh_array:Array, _material:Material) -> void:
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _mesh_array)
	(mesh as ArrayMesh).surface_set_material((mesh as ArrayMesh).get_surface_count()-1,_material)



#create floor tiles
func generate_floor(_x: float, _y: float, _height: float, _surface_array:Array) -> Array:
	
	
	var start_index:int = _surface_array[Mesh.ARRAY_VERTEX].size()

	var rand:float = randf()
	var color:Color
	if rand < 0.8:
		color = Color(0,0,0,1)
	elif rand < 0.9:
		color = Color(1,0,0,1)
	elif rand < 0.95:
		color = Color(0,1,0,1)
	elif rand <= 1.0:
		color = Color(0,0,1,1)

	
	for i in range(4):
		_surface_array[Mesh.ARRAY_VERTEX].append(Vector3(
			_x + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0)) + 0.5, 
		_height, 
		_y + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)) + 0.5)
		)
		_surface_array[Mesh.ARRAY_TEX_UV].append(Vector2(
			_surface_array[Mesh.ARRAY_VERTEX][_surface_array[Mesh.ARRAY_VERTEX].size()-1].x,
			_surface_array[Mesh.ARRAY_VERTEX][_surface_array[Mesh.ARRAY_VERTEX].size()-1].z)
			)
			uvs_floor.append(Vector2(
				verts_floor[verts_floor.size()-1].x,
				verts_floor[verts_floor.size()-1].z)
				)
			colors_floor.append(color)
			normals_floor.append(Vector3(0, 1, 0))
		indices_floor.append(start_index)
		indices_floor.append(start_index + 1)
		indices_floor.append(start_index + 2)
		indices_floor.append(start_index)
		indices_floor.append(start_index + 2)
		indices_floor.append(start_index + 3)
		_surface_array[Mesh.ARRAY_COLOR].append(color)
		_surface_array[Mesh.ARRAY_NORMAL].append(Vector3(0, 1, 0))
	_surface_array[Mesh.ARRAY_INDEX].append(start_index)
	_surface_array[Mesh.ARRAY_INDEX].append(start_index + 1)
	_surface_array[Mesh.ARRAY_INDEX].append(start_index + 2)
	_surface_array[Mesh.ARRAY_INDEX].append(start_index)
	_surface_array[Mesh.ARRAY_INDEX].append(start_index + 2)
	_surface_array[Mesh.ARRAY_INDEX].append(start_index + 3)
	
	return _surface_array



##checks if a bit, with coords _x, _y, is inside the given bitmap
func does_bit_exist(_x: int, _y: int, _grid: BitMap) -> bool:
	if (_x < 0 or _y < 0 or _x >= _grid.get_size().x or _y >= _grid.get_size().y):
		return true
	return _grid.get_bit(_x, _y)




#creating the walls for a tile
func generate_walls(_x: float, _y: float, _adjacent_sub_cells: Array[bool], _mesh_array:Array) -> Array:
	if (_adjacent_sub_cells[1] == true):
		_mesh_array = generate_wall(_x + 0.5, _y + 1.0, PlaneMesh.FACE_Z, false, false, _mesh_array)
	if (_adjacent_sub_cells[0] == true):
		_mesh_array = generate_wall(_x + 0.5, _y, PlaneMesh.FACE_Z, true, false, _mesh_array)
	if (_adjacent_sub_cells[3] == true):
		_mesh_array = generate_wall(_x, _y + 0.5, PlaneMesh.FACE_X, true, true, _mesh_array)
	if (_adjacent_sub_cells[2] == true):
		_mesh_array = generate_wall(_x + 1.0, _y + 0.5, PlaneMesh.FACE_X, false, true, _mesh_array)
	return _mesh_array



#creating two stacked wall pieces
func generate_wall(_x: float, _y: float, _facing, _flip_faces: bool, _rotated: bool, _mesh_array:Array) -> Array:
	var height: float = 0.5
	var normal: Vector3
	if _rotated:
		_flip_faces = not _flip_faces
	
	if _facing == PlaneMesh.FACE_Z:
		if _flip_faces:
			normal = Vector3(0.0, 0.0, -1.0)
		else:
			normal = Vector3(0.0, 0.0, 1.0)
	else:
		if _flip_faces:
			normal = Vector3(1.0, 0.0, 0.0)
		else:
			normal = Vector3(-1.0, 0.0, 0.0)
	
	
	
	var rand:float = randf()
	var colors:Array[Color] = []
	if rand < 0.8:
		colors.append(Color(0,0,0,1))
		colors.append(Color(0,0,0,-1.0))
	#elif rand < 0.9:
		#colors.append(Color(1,0,0,1))
		#colors.append(Color(1,0,0,0.0))
	#elif rand < 0.95:
		#colors.append(Color(0,1,0,1))
		#colors.append(Color(0,1,0,0.0))
	elif rand <= 1.0:
		colors.append(Color(0,0,1,1))
		colors.append(Color(0,0,1,-1.0))
	
	for j in range(2):
		var start_index: int = _mesh_array[Mesh.ARRAY_VERTEX].size()
		for i in range(4):
			if _rotated:
				_mesh_array[Mesh.ARRAY_VERTEX].append(Vector3(
					_x, 
					height + j + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)), 
					_y + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0))
				))
				_mesh_array[Mesh.ARRAY_TEX_UV].append(Vector2(
					_mesh_array[Mesh.ARRAY_VERTEX][_mesh_array[Mesh.ARRAY_VERTEX].size()-1].z,
					-_mesh_array[Mesh.ARRAY_VERTEX][_mesh_array[Mesh.ARRAY_VERTEX].size()-1].y)
				)
			else:
				_mesh_array[Mesh.ARRAY_VERTEX].append(Vector3(
					_x + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0)), 
					height + j + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)), 
					_y
				))
				_mesh_array[Mesh.ARRAY_TEX_UV].append(Vector2(
					_mesh_array[Mesh.ARRAY_VERTEX][_mesh_array[Mesh.ARRAY_VERTEX].size()-1].x,
					-_mesh_array[Mesh.ARRAY_VERTEX][_mesh_array[Mesh.ARRAY_VERTEX].size()-1].y)
				)
			_mesh_array[Mesh.ARRAY_NORMAL].append(normal)
			_mesh_array[Mesh.ARRAY_COLOR].append(colors[j])

			if _flip_faces:
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index + 1)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index + 2)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index + 2)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index + 3)
			else:
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index + 2)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index + 1)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index + 3)
				_mesh_array[Mesh.ARRAY_INDEX].append(start_index + 2)
	return _mesh_array
