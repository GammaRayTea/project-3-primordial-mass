extends Control

var cells:PackedVector2Array = PackedVector2Array()
var points:PackedVector2Array = PackedVector2Array()
var rect_size:int = 16
var player_pos:Vector2
var scalar = 1
var draw_point_ids:PackedInt32Array = PackedInt32Array()
var delaunay_points:PackedVector2Array = PackedVector2Array()


var room_bit_maps:Array[ImageTexture] = []
@export var draw_point_subdivision:int
var offset:Vector2


@export var line_color:Color
@export var cell_color:Color
@export var point_color:Color
@export var draw_cells:bool = false
@export var is_inner:bool = false

func _ready() -> void:
	#offset = Vector2(- rect_size * 0.5 + 2,- rect_size * 0.5 + 2)
	offset = Vector2(0,0)
	rect_size *= scalar
	


func _draw() -> void:
	
	#if draw_cells:
		
	draw_rect(Rect2(0 , 0 ,rect_size,rect_size),Color.RED)
	for cell in range(0,cells.size()):
		#cells
		draw_rect(Rect2(scalar*cells[cell].x,scalar* cells[cell].y , rect_size,rect_size),cell_color)
		if is_inner:
			draw_texture_rect(room_bit_maps[cell] , Rect2(scalar*cells[cell].x,scalar* cells[cell].y , rect_size,rect_size)  , false)
	

	for cell in range(0,cells.size()):
		#small points
		draw_rect(Rect2(scalar*(cells[cell].x + points[cell].x-1),scalar* (cells[cell].y+ points[cell].y-1), 2,2),point_color)
		

	@warning_ignore("integer_division")
	draw_rect(Rect2(rect_size*scalar*player_pos.x+rect_size/4, rect_size*scalar* player_pos.y +rect_size/4,   rect_size/2 , rect_size/2  ),Color.YELLOW)

	var i = 0
	while i < draw_point_ids.size():
		var draw_ids:PackedInt32Array = draw_point_ids.slice(i,i+draw_point_subdivision)
		var points_to_draw : PackedVector2Array = PackedVector2Array()
		for id in draw_ids:
			points_to_draw.push_back(delaunay_points[id]*scalar)
		
		points_to_draw.push_back(Vector2(delaunay_points[draw_point_ids[i]])  *scalar)
		
		#if is_inner:
			#print(points_to_draw)
			#print(points_to_draw)
		draw_polyline(points_to_draw,line_color)
		i+=draw_point_subdivision
