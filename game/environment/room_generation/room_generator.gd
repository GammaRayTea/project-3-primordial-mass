class_name RoomGen extends Node

#var connecting_points: Array = [Vector2(rng.randf() * 16 - 16, rng.randf() * 16), Vector2(rng.randf() * 16, rng.randf() * 16 -16), Vector2(rng.randf() * 16 + 16, rng.randf() * 16), Vector2(rng.randf() * 16 - 16, rng.randf() * 16 + 16)]
#var center: Vector2 = Vector2(rng.randf() * 16, rng.randf() * 16)
#var size: int = 16
var rng:RandomNumberGenerator

## [param _size] determines cell size in game engine units 
## [param _global_random_point_position] is the position of the randomized point of the cell
func generate_room(_size: int, _global_random_point_position: Vector2,_cell_origin_position, connected_cells: Array[Cell]) -> BitMap:
	var bit_map:BitMap = BitMap.new()
	bit_map.create(Vector2(_size,_size))
	var room_corners: Array[Vector2] = []
	var outer_ring_width: int = 1
	var inner_square_radius: int = int((_size - outer_ring_width * 2.0) / 2.0)
	
	var connected_cell_points:= PackedVector2Array()
	#convert all connecting center points and center to local coordinates
	for i in range(connected_cells.size()):
		connected_cell_points.push_back(convert_too_local_coords(_cell_origin_position, _size, connected_cells[i].global_point_position))
		
	var center_lc = convert_too_local_coords(_cell_origin_position,_size,_global_random_point_position)

	
	#generate sizeXsize cell grid with walkways to the center
	for current_sub_cell_x in range(_size):

		for current_sub_cell_y in range(_size):
			var value:bool = false
			for i in range(connected_cell_points.size()):
				if doIntersect([[[center_lc.x, center_lc.y], [connected_cell_points[i].x, connected_cell_points[i].y]], [[current_sub_cell_x, current_sub_cell_y], [current_sub_cell_x + 1.0, current_sub_cell_y]]]) \
				or doIntersect([[[center_lc.x, center_lc.y], [connected_cell_points[i].x, connected_cell_points[i].y]], [[current_sub_cell_x, current_sub_cell_y + 1.0], [current_sub_cell_x + 1.0, current_sub_cell_y + 1.0]]]) \
				or doIntersect([[[center_lc.x, center_lc.y], [connected_cell_points[i].x, connected_cell_points[i].y]], [[current_sub_cell_x, current_sub_cell_y], [current_sub_cell_x, current_sub_cell_y + 1.0]]]) \
				or doIntersect([[[center_lc.x, center_lc.y], [connected_cell_points[i].x, connected_cell_points[i].y]], [[current_sub_cell_x + 1.0, current_sub_cell_y], [current_sub_cell_x + 1.0, current_sub_cell_y + 1.0]]]):
					value = true
					break
			bit_map.set_bit(current_sub_cell_x,current_sub_cell_y,value)
	
	#generate four additional room corners
	for i in range(4):
		room_corners.append(Vector2((rng.randf() * inner_square_radius) * snappedf(sin((i + 1.5) * PI/2), 1.0), (rng.randf() * inner_square_radius) * snappedf(sin((i + 0.5) * PI/2), 1.0)) + Vector2(_size/2.0, _size/2.0))
	
	#put the original center at the right corner possition
	if (center_lc.x > _size/2.0):
		if (center_lc.y > _size/2.0):
			room_corners[0] = center_lc + (Vector2(_size, _size) - center_lc) / 2.0
		else:
			room_corners[3] = center_lc + (Vector2(_size, 0.0) - center_lc) / 2.0
	else:
		if (center_lc.y > _size/2.0):
			room_corners[1] = center_lc + (Vector2(0.0, _size) - center_lc) / 2.0
		else:
			room_corners[2] = center_lc - center_lc/2
	
	#adjust grid with new room
	#set the boundry and everything in the boundry true
	for current_sub_cell_x in range(outer_ring_width, _size - outer_ring_width):
		for current_sub_cell_y in range(outer_ring_width, _size - outer_ring_width):
			if bit_map.get_bit(current_sub_cell_x,current_sub_cell_y) == true:
				pass
			elif in_triangle(room_corners[0], room_corners[1], room_corners[2], Vector2(current_sub_cell_x, current_sub_cell_y)) or in_triangle(room_corners[0], room_corners[2], room_corners[3], Vector2(current_sub_cell_x, current_sub_cell_y)):
				bit_map.set_bit(current_sub_cell_x,current_sub_cell_y, true)
			else:
				for i in range(room_corners.size()):
					if doIntersect([[[room_corners[i].x, room_corners[i].y], [room_corners[(i + 1) % room_corners.size()].x, room_corners[(i + 1) % room_corners.size()].y]], [[current_sub_cell_x, current_sub_cell_y], [current_sub_cell_x + 1.0, current_sub_cell_y]]]):
						bit_map.set_bit(current_sub_cell_x,current_sub_cell_y, true)
						break
	
	return bit_map

#convert other centers to the local coordinate systhem
func convert_too_local_coords(_cell_origin_position: Vector2, _size: int,_external_point: Vector2) -> Vector2:
	var localized_center_point = _external_point - _cell_origin_position
	return localized_center_point

#function to check if a point lies in a triangle
func in_triangle(_tri_1: Vector2, _tri_2: Vector2, _tri_3: Vector2, _point: Vector2):
	var denominator: float =  ((_tri_2.y - _tri_3.y)*(_tri_1.x - _tri_3.x) + (_tri_3.x - _tri_2.x)*(_tri_1.y - _tri_3.y))
	
	var a: float = ((_tri_2.y - _tri_3.y)*(_point.x - _tri_3.x) + (_tri_3.x - _tri_2.x)*(_point.y - _tri_3.y)) / denominator;
	var b: float = ((_tri_3.y - _tri_1.y)*(_point.x - _tri_3.x) + (_tri_1.x - _tri_3.x)*(_point.y - _tri_3.y)) / denominator;
	var c: float = 1 - a - b
	
	return 0 <= a && a <= 1 && 0 <= b && b <= 1 && 0 <= c && c <= 1


# function to check if point q lies on line segment 'pr'
func onSegment(_p, _q, _r) -> bool:
	return (_q[0] <= max(_p[0], _r[0]) and _q[0] >= min(_p[0], _r[0]) and _q[1] <= max(_p[1], _r[1]) and _q[1] >= min(_p[1], _r[1]))

# function to find orientation of ordered triplet (p, q, r)
# 0 --> p, q and r are collinear
# 1 --> Clockwise
# 2 --> Counterclockwise
func orientation(_p, _q, _r) ->int:
	var val: float = (_q[1] - _p[1]) * (_r[0] - _q[0]) - (_q[0] - _p[0]) * (_r[1] - _q[1])
	
	# collinear
	if val == 0:
		return 0
	
	# clock or counterclock wise
	# 1 for clockwise, 2 for counterclockwise
	return 1 if val > 0 else 2


# function to check if two line segments intersect
func doIntersect(_points) -> bool:
	# find the four orientations needed
	# for general and special cases
	var o1 = orientation(_points[0][0], _points[0][1], _points[1][0])
	var o2 = orientation(_points[0][0], _points[0][1], _points[1][1])
	var o3 = orientation(_points[1][0], _points[1][1], _points[0][0])
	var o4 = orientation(_points[1][0], _points[1][1], _points[0][1])

	# general case
	if o1 != o2 and o3 != o4:
		return true

	# special cases
	# p1, q1 and p2 are collinear and p2 lies on segment p1q1
	if o1 == 0 and onSegment(_points[0][0], _points[1][0], _points[0][1]):
		return true

	# p1, q1 and q2 are collinear and q2 lies on segment p1q1
	if o2 == 0 and onSegment(_points[0][0], _points[1][1], _points[0][1]):
		return true

	# p2, q2 and p1 are collinear and p1 lies on segment p2q2
	if o3 == 0 and onSegment(_points[1][0], _points[0][0], _points[1][1]):
		return true

	# p2, q2 and q1 are collinear and q1 lies on segment p2q2 
	if o4 == 0 and onSegment(_points[1][0], _points[0][1], _points[1][1]):
		return true

	return false

#
#func _ready() -> void:
	#var room_1 = generate_room(size, center, connecting_points)
	#for i in range(room_1.size()):
		#print(room_1[i])
