class_name RoomMesh extends MeshInstance3D

var center: Vector2 = Vector2(randf() * 16, randf() * 16)
var size: int = 16
var cell_origin: Vector2 = Vector2(0.0, 0.0)
var connecting_points: Array = [Vector2(randf() * 16 - 16, randf() * 16), Vector2(randf() * 16, randf() * 16 -16), Vector2(randf() * 16 + 16, randf() * 16), Vector2(randf() * 16 - 16, randf() * 16 + 16)]

var floor_meshes: Array[Mesh] = []
var wall_meshes: Array[Mesh] = []

func build_mesh(_grid: BitMap) -> void:
	print("building mesh")
	var grid_size_x: int = _grid.get_size().x
	var grid_size_y: int = _grid.get_size().y
	
	
	var check_bit_existance = func(_x: int, _y: int) -> bool:
		if (_x < 0 or _y < 0 or _x >= grid_size_x or _y >= grid_size_y):
			return true
		return _grid.get_bit(_x, _y)
	
	
	var test_array: Array[Array] = []
	for current_sub_cell_y in range(grid_size_y):
		test_array.append([])
		for current_sub_cell_x in range(grid_size_x):
			test_array[current_sub_cell_y].append(_grid.get_bit(current_sub_cell_x, current_sub_cell_y))
			if (_grid.get_bit(current_sub_cell_x, current_sub_cell_y) == true):
				generate_floor(current_sub_cell_x, current_sub_cell_y, 0.0)
			else:
				#generate_floor(current_sub_cell_x, current_sub_cell_y, 2.0)
				var adjacent: Array[bool] = [check_bit_existance.call(current_sub_cell_x, current_sub_cell_y - 1), check_bit_existance.call(current_sub_cell_x, current_sub_cell_y + 1) , check_bit_existance.call(current_sub_cell_x + 1, current_sub_cell_y), check_bit_existance.call(current_sub_cell_x - 1, current_sub_cell_y)]
				generate_walls(current_sub_cell_x, current_sub_cell_y, adjacent)
	
	var floor_mesh: Mesh =  merge_meshes(floor_meshes)
	var wall_mesh: Mesh =  merge_meshes(wall_meshes)
	
	initiate_mesh(floor_mesh)
	initiate_mesh(wall_mesh)

#creating floor tiles
func generate_floor(_x: float, _y: float, _height: float) -> void:
	var plane: PlaneMesh = PlaneMesh.new()
	plane.center_offset = Vector3(_x + 0.5, _height, _y + 0.5)
	plane.size = Vector2(1.0, 1.0)
	plane.orientation = PlaneMesh.FACE_Y
	floor_meshes.append(plane)


#creating two stacked wall pieces
func generate_wall(_x: float, _y: float, _facing, _flip_faces: bool) -> void:
	var height: float = 0.5
	for j in range(2):
		var plane: PlaneMesh = PlaneMesh.new()
		plane.size = Vector2(1.0, 1.0)
		plane.center_offset = Vector3(_x, height + j, _y)
		plane.orientation = _facing
		plane.flip_faces = _flip_faces
		wall_meshes.append(plane)


#creating the walls for a tile
func generate_walls(_x: float, _y: float, _adjacent_sub_cells: Array[bool]) -> void:
	if (_adjacent_sub_cells[1] == true):
		generate_wall.call(_x + 0.5, _y + 1.0, PlaneMesh.FACE_Z, false)
	if (_adjacent_sub_cells[0] == true):
		generate_wall.call(_x + 0.5, _y, PlaneMesh.FACE_Z, true)
	if (_adjacent_sub_cells[3] == true):
		generate_wall.call(_x, _y + 0.5, PlaneMesh.FACE_X, true)
	if (_adjacent_sub_cells[2] == true):
		generate_wall.call(_x + 1.0, _y + 0.5, PlaneMesh.FACE_X, false)


#merging planes in one meshinstance
func merge_meshes(_meshes: Array[Mesh]) -> Mesh:
	var singleMesh := SurfaceTool.new()
	singleMesh.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in _meshes:
		singleMesh.append_from(i, 0, Transform3D.IDENTITY)
	return singleMesh.commit()


#add meshes as instances
func initiate_mesh(_mesh: Mesh) -> void:
	var new := MeshInstance3D.new()
	new.mesh = _mesh
	var material = StandardMaterial3D.new()
	new.material_override = material
	add_child(new)



'var roomGen = RoomGen.new()
	var room_layout = roomGen.room_generator(size, center, connecting_points)
	var mesh: Mesh
	
	# Array setup
	var surface_array_ground = []
	surface_array_ground.resize(Mesh.ARRAY_MAX)
	
	var verts_ground = PackedVector3Array()
	var normals_ground = PackedVector3Array()
	var uvs_ground = PackedVector2Array()
	var indices_ground = PackedInt32Array()
	
	var generate = func(_x: float, _y: float, _height: float) -> void:
		for i in range(4):
			verts_ground.append(Vector3(_x + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0)) + 0.5, _y + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)) + 0.5, _height))
			normals_ground.append(Vector3(0, 1, 0))
		
	for current_sub_cell_x in range(roomGen.size):
		for current_sub_cell_y in range(roomGen.size):
			if (room_layout[current_sub_cell_x][current_sub_cell_y] == true):
				generate.call(current_sub_cell_x, current_sub_cell_y, 2.0)
			else:
				generate.call(current_sub_cell_x, current_sub_cell_y, 2.0)
	
	
	# Assign arrays to surface array.
	surface_array_ground[Mesh.ARRAY_VERTEX] = verts_ground
	surface_array_ground[Mesh.ARRAY_NORMAL] = normals_ground
	surface_array_ground[Mesh.ARRAY_TEX_UV] = uvs_ground
	surface_array_ground[Mesh.ARRAY_INDEX] = indices_ground
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array_ground)


#plane generator to make a square at the right height
func square_gen(_x: float, _y: float, _height: float):
	pass'
