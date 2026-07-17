class_name Cell extends Resource
var point_position:Vector2
var global_point_position:Vector2
var rng:RandomNumberGenerator
var locked:bool = false
var connections:Array[Cell] = []
var bit_map:BitMap
var tier:int
func _init(_cell_size:int,_margin:int, _rng):
	rng = _rng
	@warning_ignore("narrowing_conversion")
	point_position = Vector2(rng.randi_range(_margin,_cell_size-_margin),rng.randi_range(_margin,_cell_size-_margin))
