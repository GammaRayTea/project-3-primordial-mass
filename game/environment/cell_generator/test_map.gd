extends Control

var cells:PackedVector2Array = PackedVector2Array()
var points:PackedVector2Array = PackedVector2Array()
var rect_size:int = 16
var player_pos:Vector2
var scalar = 1
var delaunay_ids:PackedInt32Array = PackedInt32Array()
var delaunay_points:PackedVector2Array = PackedVector2Array()


var offset:Vector2


@export var line_color:Color
@export var cell_color:Color
@export var point_color:Color
@export var draw_cells:bool = false

func _ready() -> void:
	#offset = Vector2(- rect_size * 0.5 + 2,- rect_size * 0.5 + 2)
	offset = Vector2(0,0)

func _draw() -> void:
	
	#if draw_cells:
		
	draw_rect(Rect2(0 , 0 ,rect_size,rect_size),Color.RED)
	for cell in range(1,cells.size()):
		#points
		draw_rect(Rect2(scalar*cells[cell].x,scalar* cells[cell].y , rect_size,rect_size),cell_color)

	
	
	
	for cell in range(1,cells.size()):
		#small points
		draw_rect(Rect2(scalar*cells[cell].x + points[cell].x-2,scalar* cells[cell].y+ points[cell].y-2, 4,4),point_color)
		

	draw_rect(Rect2(16*scalar*player_pos.x + 8 ,16*scalar* player_pos.y + 8,   2 , 2  ),Color.YELLOW)
	@warning_ignore("integer_division")
	#for i in range(delaunay_ids.size()-1):
		#var p1 = Vector2(delaunay_points[delaunay_ids[i]].x  , delaunay_points[delaunay_ids[i]].y)  *scalar
		#var p2 = Vector2(delaunay_points[delaunay_ids[i+1 ]].x, delaunay_points[delaunay_ids[i+1]].y) *scalar
		#
		#
		#draw_line(p1+offset,p2+offset,line_color)
	var i = 0
	while i < delaunay_ids.size():
		var points_to_draw := PackedVector2Array()
		points_to_draw.push_back(Vector2(delaunay_points[delaunay_ids[i]].x  , delaunay_points[delaunay_ids[i]].y)  *scalar)
		points_to_draw.push_back(Vector2(delaunay_points[delaunay_ids[i+1]].x  , delaunay_points[delaunay_ids[i+1]].y)  *scalar)
		points_to_draw.push_back(Vector2(delaunay_points[delaunay_ids[i+2]].x  , delaunay_points[delaunay_ids[i+2]].y)  *scalar)
		

		draw_polyline(points_to_draw,line_color)
		i+=3
