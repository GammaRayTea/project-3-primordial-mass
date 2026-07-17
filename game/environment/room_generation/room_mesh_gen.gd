class_name RoomMesh extends MeshInstance3D

@export var room_collisions: Node3D

func build_mesh(_grid: BitMap) -> void:
	print("building mesh")
	
	if mesh == null:
		mesh = ArrayMesh.new()
	
	var grid_size_x: int = _grid.get_size().x
	var grid_size_y: int = _grid.get_size().y
	
	# Array setup
	var surface_array_ground = []
	surface_array_ground.resize(Mesh.ARRAY_MAX)
	var surface_array_wall = []
	surface_array_wall.resize(Mesh.ARRAY_MAX)
	
	var verts_ground = PackedVector3Array()
	var normals_ground = PackedVector3Array()
	#var uvs_ground = PackedVector2Array()
	var indices_ground = PackedInt32Array()
	
	var verts_wall = PackedVector3Array()
	var normals_wall = PackedVector3Array()
	#var uvs_wall = PackedVector2Array()
	var indices_wall = PackedInt32Array()
	
	
	var check_bit_existance = func(_x: int, _y: int) -> bool:
		if (_x < 0 or _y < 0 or _x >= grid_size_x or _y >= grid_size_y):
			return true
		return _grid.get_bit(_x, _y)
	
	#creating floor tiles
	var generate_floor = func(_x: float, _y: float, _height: float) -> void:
		var start_index: int = verts_ground.size()
		for i in range(4):
			verts_ground.append(Vector3(_x + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0)) + 0.5, _height, _y + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)) + 0.5))
			normals_ground.append(Vector3(0, 1, 0))
		indices_ground.append(start_index)
		indices_ground.append(start_index + 1)
		indices_ground.append(start_index + 2)
		indices_ground.append(start_index)
		indices_ground.append(start_index + 2)
		indices_ground.append(start_index + 3)
	
	#creating two stacked wall pieces
	var generate_wall = func(_x: float, _y: float, _facing, _flip_faces: bool, _rotated: bool) -> void:
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
		
		for j in range(2):
			var start_index: int = verts_wall.size()
			for i in range(4):
				if _rotated:
					verts_wall.append(Vector3(_x, height + j + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)), _y + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0))))
				else:
					verts_wall.append(Vector3(_x + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0)), height + j + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)), _y))
				normals_wall.append(normal)
				
				if _flip_faces:
					indices_wall.append(start_index)
					indices_wall.append(start_index + 1)
					indices_wall.append(start_index + 2)
					indices_wall.append(start_index)
					indices_wall.append(start_index + 2)
					indices_wall.append(start_index + 3)
				else:
					indices_wall.append(start_index)
					indices_wall.append(start_index + 2)
					indices_wall.append(start_index + 1)
					indices_wall.append(start_index)
					indices_wall.append(start_index + 3)
					indices_wall.append(start_index + 2)
	
	
	#creating the walls for a tile
	var generate_walls = func(_x: float, _y: float, _adjacent_sub_cells: Array[bool]) -> void:
		if (_adjacent_sub_cells[1] == true):
			generate_wall.call(_x + 0.5, _y + 1.0, PlaneMesh.FACE_Z, false, false)
		if (_adjacent_sub_cells[0] == true):
			generate_wall.call(_x + 0.5, _y, PlaneMesh.FACE_Z, true, false)
		if (_adjacent_sub_cells[3] == true):
			generate_wall.call(_x, _y + 0.5, PlaneMesh.FACE_X, true, true)
		if (_adjacent_sub_cells[2] == true):
			generate_wall.call(_x + 1.0, _y + 0.5, PlaneMesh.FACE_X, false, true)
	
	
	for current_sub_cell_y in range(grid_size_y):
		for current_sub_cell_x in range(grid_size_x):
			if (_grid.get_bit(current_sub_cell_x, current_sub_cell_y) == true):
				generate_floor.call(current_sub_cell_x, current_sub_cell_y, 0.0)
			else:
				#generate_floor.call(current_sub_cell_x, current_sub_cell_y, 2.0)
				var adjacent: Array[bool] = [check_bit_existance.call(current_sub_cell_x, current_sub_cell_y - 1), check_bit_existance.call(current_sub_cell_x, current_sub_cell_y + 1) , check_bit_existance.call(current_sub_cell_x + 1, current_sub_cell_y), check_bit_existance.call(current_sub_cell_x - 1, current_sub_cell_y)]
				generate_walls.call(current_sub_cell_x, current_sub_cell_y, adjacent)
	
	
	# Assign arrays to surface array.
	surface_array_ground[Mesh.ARRAY_VERTEX] = verts_ground
	surface_array_ground[Mesh.ARRAY_NORMAL] = normals_ground
	#surface_array_ground[Mesh.ARRAY_TEX_UV] = uvs_ground
	surface_array_ground[Mesh.ARRAY_INDEX] = indices_ground
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array_ground)
	
	var collision_instance_ground := CollisionShape3D.new()
	collision_instance_ground.shape = mesh.create_trimesh_shape()
	room_collisions.add_child(collision_instance_ground)
	collision_instance_ground.global_position = Vector3()
	
	# Assign arrays to surface array.
	surface_array_wall[Mesh.ARRAY_VERTEX] = verts_wall
	surface_array_wall[Mesh.ARRAY_NORMAL] = normals_wall
	#surface_array_wall[Mesh.ARRAY_TEX_UV] = uvs_wall
	surface_array_wall[Mesh.ARRAY_INDEX] = indices_wall
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array_wall)
	mesh.create_trimesh_shape()
	
	var collision_instance_wall := CollisionShape3D.new()
	collision_instance_wall.shape = mesh.create_trimesh_shape()
	room_collisions.add_child(collision_instance_wall)
