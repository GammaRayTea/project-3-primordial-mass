class_name RoomMesh extends Mesh

var center: Vector2 = Vector2(randf() * 16, randf() * 16)
var size: int = 16
var connecting_points: Array = [Vector2(randf() * 16 - 16, randf() * 16), Vector2(randf() * 16, randf() * 16 -16), Vector2(randf() * 16 + 16, randf() * 16), Vector2(randf() * 16 - 16, randf() * 16 + 16)]

func build_mesh(_grid: Array[Array]) -> void:
	# Array setup
	var surface_array_ground = []
	surface_array_ground.resize(Mesh.ARRAY_MAX)
	
	var verts_ground = PackedVector3Array()
	var normals_ground = PackedVector3Array()
	var uvs_ground = PackedVector2Array()
	var indices_ground = PackedInt32Array()
	
	for current_sub_cell_x in range(roomGen.size):
		for current_sub_cell_y in range(roomGen.size):
			verts_ground.append(current_sub_cell_x, current_sub_cell_y)
	
	
	# Assign arrays to surface array.
	surface_array_ground[Mesh.ARRAY_VERTEX] = verts_ground
	surface_array_ground[Mesh.ARRAY_NORMAL] = normals_ground
	surface_array_ground[Mesh.ARRAY_TEX_UV] = uvs_ground
	surface_array_ground[Mesh.ARRAY_INDEX] = indices_ground
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array_ground)

#plane generator to make a square at the right height
func square_gen(_x: float, _y: float, _height: float):
	pass


func _ready() -> void:
	var roomGen = RoomGen.new()
	var room_layout = roomGen.room_generator(size, center, connecting_points)
	build_mesh(room_layout)
