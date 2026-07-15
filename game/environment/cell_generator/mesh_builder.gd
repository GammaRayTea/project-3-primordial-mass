#class_name MeshBuilder extends Node
#
#@export var room_mesh:RoomMesh
#var generated_room_mesh: Array[Array]
#
#func cell_to_world(_coord:Vector2, _cell_size: int) -> Vector3:
	#var vec = Vector3(_coord.x * _cell_size, 0, _coord.y * _cell_size)
	#return vec
#
#func extend_mesh(_cell_position_wc: Vector3) -> void:
	##var pos = (Vector2(i - _check_range, j - _check_range) + current_position) * cell_size
	#var cell_instance: RoomMesh = room_mesh.duplicate() as RoomMesh
	#add_child(cell_instance)
	#
	#cell_instance.position = _cell_position_wc
	#cell_instance.build_mesh(room_bit_map)
	#generated_room_mesh.append([pos, cell_instance])
#
