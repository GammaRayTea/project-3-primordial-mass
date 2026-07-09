class_name RoomGen extends Node

var center: Vector2 = Vector2(randf() * 16, randf() * 16)
var size: int = 16
var connecting_points: Array = [Vector2(randf() * 16 - 16, randf() * 16), Vector2(randf() * 16, randf() * 16 -16), Vector2(randf() * 16 + 16, randf() * 16), Vector2(randf() * 16 - 16, randf() * 16 + 16)]

func room_generator(_size: int, _center: Vector2, _connected_center_points: Array):
	var sub_cells: Array = []
	var room_corners: Array[Vector2] = []
	var outer_ring_width: int = 1
	var inner_square_radius: int = int((_size - outer_ring_width * 2.0) / 2.0)
	
	#convert all connecting center points and center to local coordinates
	for i in range(_connected_center_points.size()):
		_connected_center_points[i] = convert_too_local_coords(_center, _size, _connected_center_points[i])
	var center_lc = Vector2(int(floor(_center.x)) % _size, int(floor(_center.y)) % _size)
	center_lc += _center - floor(_center)
	print("local_center: ", center_lc)
	
	#generate sizeXsize cell grid with walkways to the center
	for current_sub_cell_x in range(_size):
		sub_cells.append([])
		for current_sub_cell_y in range(_size):
			var air = false
			for i in range(_connected_center_points.size()):
				if doIntersect([[[center_lc.x, center_lc.y], [_connected_center_points[i].x, _connected_center_points[i].y]], [[current_sub_cell_x, current_sub_cell_y], [current_sub_cell_x + 1.0, current_sub_cell_y]]]) \
				or doIntersect([[[center_lc.x, center_lc.y], [_connected_center_points[i].x, _connected_center_points[i].y]], [[current_sub_cell_x, current_sub_cell_y + 1.0], [current_sub_cell_x + 1.0, current_sub_cell_y + 1.0]]]) \
				or doIntersect([[[center_lc.x, center_lc.y], [_connected_center_points[i].x, _connected_center_points[i].y]], [[current_sub_cell_x, current_sub_cell_y], [current_sub_cell_x, current_sub_cell_y + 1.0]]]) \
				or doIntersect([[[center_lc.x, center_lc.y], [_connected_center_points[i].x, _connected_center_points[i].y]], [[current_sub_cell_x + 1.0, current_sub_cell_y], [current_sub_cell_x + 1.0, current_sub_cell_y + 1.0]]]):
					air = true
					break
			sub_cells[current_sub_cell_x].append(air)
	
	#generate four additional room corners
	for i in range(4):
		room_corners.append(Vector2((randf() * inner_square_radius) * snappedf(sin((i + 1.5) * PI/2), 1.0), (randf() * inner_square_radius) * snappedf(sin((i + 0.5) * PI/2), 1.0)) + Vector2(_size/2.0, _size/2.0))
	
	#put the original center at the right corner possition
	if (center_lc.x > _size/2.0):
		if (center_lc.y > _size/2.0):
			room_corners[0] = center_lc
		else:
			room_corners[3] = center_lc
	else:
		if (center_lc.y > _size/2.0):
			room_corners[1] = center_lc
		else:
			room_corners[2] = center_lc
	
	print(room_corners)
	
	#adjust grid with new room
	#set the boundry and everything in the boundry true
	for current_sub_cell_x in range(outer_ring_width, _size - outer_ring_width):
		for current_sub_cell_y in range(outer_ring_width, _size - outer_ring_width):
			if sub_cells[current_sub_cell_x][current_sub_cell_y] == true:
				pass
			elif in_triangle(room_corners[0], room_corners[1], room_corners[2], Vector2(current_sub_cell_x, current_sub_cell_y)) or in_triangle(room_corners[0], room_corners[2], room_corners[3], Vector2(current_sub_cell_x, current_sub_cell_y)):
				sub_cells[current_sub_cell_x][current_sub_cell_y] = true
			else:
				for i in range(room_corners.size()):
					if doIntersect([[[room_corners[i].x, room_corners[i].y], [room_corners[(i + 1) % room_corners.size()].x, room_corners[(i + 1) % room_corners.size()].y]], [[current_sub_cell_x, current_sub_cell_y], [current_sub_cell_x + 1.0, current_sub_cell_y]]]):
						sub_cells[current_sub_cell_x][current_sub_cell_y] = true
						break
	
	return sub_cells

#convert other centers to the local coordinate systhem
func convert_too_local_coords(_center: Vector2, _size: int,_center_point: Vector2):
	var local_origin_wc = floor(_center) - abs(Vector2(int(floor(_center.x)) % _size, int(floor(_center.y)) % _size))
	var localized_center_point = _center_point - local_origin_wc
	return localized_center_point

#function to check if a point lies in a triangle
func in_triangle(_tri_1: Vector2, _tri_2: Vector2, _tri_3: Vector2, _point: Vector2):
	var denominator: float =  ((_tri_2.y - _tri_3.y)*(_tri_1.x - _tri_3.x) + (_tri_3.x - _tri_2.x)*(_tri_1.y - _tri_3.y))
	
	var a: float = ((_tri_2.y - _tri_3.y)*(_point.x - _tri_3.x) + (_tri_3.x - _tri_2.x)*(_point.y - _tri_3.y)) / denominator;
	var b: float = ((_tri_3.y - _tri_1.y)*(_point.x - _tri_3.x) + (_tri_1.x - _tri_3.x)*(_point.y - _tri_3.y)) / denominator;
	var c: float = 1 - a - b
	
	return 0 <= a && a <= 1 && 0 <= b && b <= 1 && 0 <= c && c <= 1


# function to check if point q lies on line segment 'pr'
func onSegment(_p, _q, _r):
	return (_q[0] <= max(_p[0], _r[0]) and _q[0] >= min(_p[0], _r[0]) and _q[1] <= max(_p[1], _r[1]) and _q[1] >= min(_p[1], _r[1]))

# function to find orientation of ordered triplet (p, q, r)
# 0 --> p, q and r are collinear
# 1 --> Clockwise
# 2 --> Counterclockwise
func orientation(_p, _q, _r):
	var val: float = (_q[1] - _p[1]) * (_r[0] - _q[0]) - (_q[0] - _p[0]) * (_r[1] - _q[1])
	
	# collinear
	if val == 0:
		return 0
	
	# clock or counterclock wise
	# 1 for clockwise, 2 for counterclockwise
	return 1 if val > 0 else 2


# function to check if two line segments intersect
func doIntersect(_points):
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


'func _ready() -> void:
	var room_1 = room_generator(size, center, connecting_points)
	for i in range(room_1.size()):
		print(room_1[i])'
