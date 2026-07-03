extends Control

var cells:PackedVector2Array = PackedVector2Array()
var points:PackedVector2Array = PackedVector2Array()
var rect_size:int = 20
var rect_offset:int = 30

func _draw() -> void:
	for cell in range(cells.size()):
		draw_rect(Rect2(cells[cell].x * rect_offset, cells[cell].y * rect_offset, rect_size,rect_size),Color.BLUE)
		draw_rect(Rect2(cells[cell].x * rect_offset+points[cell].x, cells[cell].y * rect_offset+points[cell].y, 5,5),Color.CADET_BLUE)
