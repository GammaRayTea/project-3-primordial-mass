class_name RoomMesh extends MeshInstance3D

@export var room_collisions: Node3D

@export var test_mat:Material
@export var test_mat2:Material

@export var grid_size:Vector2i = Vector2i(16,16)

# Array setup
var surface_array_floor = []

var surface_array_wall = []


var verts_floor := PackedVector3Array()
var normals_floor := PackedVector3Array()
var uvs_floor := PackedVector2Array()
var colors_floor := PackedColorArray()
var indices_floor := PackedInt32Array()

var verts_wall := PackedVector3Array()
var normals_wall := PackedVector3Array()
var uvs_wall := PackedVector2Array()
var colors_wall := PackedColorArray()
var indices_wall := PackedInt32Array()


func reset_arrays() -> void:
	surface_array_floor = []
	surface_array_floor.resize(Mesh.ARRAY_MAX)
	
	surface_array_wall = []
	surface_array_wall.resize(Mesh.ARRAY_MAX)
	
	verts_floor = PackedVector3Array()
	normals_floor = PackedVector3Array()
	uvs_floor = PackedVector2Array()
	colors_floor = PackedColorArray()
	indices_floor = PackedInt32Array()
	
	verts_wall = PackedVector3Array()
	normals_wall = PackedVector3Array()
	uvs_wall = PackedVector2Array()
	colors_wall = PackedColorArray()
	indices_wall = PackedInt32Array()


## Builds a mesh from a BitMap
func build_mesh(_grid: BitMap) -> void:
	reset_arrays()
	if mesh == null:
		mesh = ArrayMesh.new()

	for current_sub_cell_y in range(grid_size.y):
		for current_sub_cell_x in range(grid_size.x):
			if (_grid.get_bit(current_sub_cell_x, current_sub_cell_y) == true):
				generate_floor(current_sub_cell_x, current_sub_cell_y, 0.0)
			else:
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
	collision_instance_floor.global_position = Vector3()
	
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




#create floor tiles
func generate_floor(_x: float, _y: float, _height: float) -> void:
		var start_index: int = verts_floor.size()
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
			verts_floor.append(Vector3(
				_x + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0)) + 0.5, 
			_height, 
			_y + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)) + 0.5)
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
		



func does_bit_exist(_x: int, _y: int, _grid:BitMap) -> bool:
		
		if (_x < 0 or _y < 0 or _x >= _grid.get_size().x or _y >= _grid.get_size().y):
			return true
		return _grid.get_bit(_x, _y)




#creating the walls for a tile
func generate_walls(_x: float, _y: float, _adjacent_sub_cells: Array[bool]) -> void:
	if (_adjacent_sub_cells[1] == true):
		generate_wall(_x + 0.5, _y + 1.0, PlaneMesh.FACE_Z, false, false)
	if (_adjacent_sub_cells[0] == true):
		generate_wall(_x + 0.5, _y, PlaneMesh.FACE_Z, true, false)
	if (_adjacent_sub_cells[3] == true):
		generate_wall(_x, _y + 0.5, PlaneMesh.FACE_X, true, true)
	if (_adjacent_sub_cells[2] == true):
		generate_wall(_x + 1.0, _y + 0.5, PlaneMesh.FACE_X, false, true)




#creating two stacked wall pieces
func generate_wall(_x: float, _y: float, _facing, _flip_faces: bool, _rotated: bool) -> void:
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
		var start_index: int = verts_wall.size()
		for i in range(4):
			if _rotated:
				verts_wall.append(Vector3(_x, height + j + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)), _y + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0))))
				uvs_wall.append(Vector2(
				verts_wall[verts_wall.size()-1].z,
				-verts_wall[verts_wall.size()-1].y)
				)
			else:
				verts_wall.append(Vector3(_x + (0.5 * snappedf(sin((i + 1.5) * PI/2), 1.0)), height + j + (0.5 * snappedf(sin((i + 0.5) * PI/2), 1.0)), _y))
				uvs_wall.append(Vector2(
				verts_wall[verts_wall.size()-1].x,
				-verts_wall[verts_wall.size()-1].y)
				
				)
			normals_wall.append(normal)
			colors_wall.append(colors[j])

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
