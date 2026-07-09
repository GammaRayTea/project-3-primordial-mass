class_name Cell extends Resource
var point_position:Vector2
var rng:RandomNumberGenerator
var locked:bool = false
var connections
func _init(_cell_size:Vector2,_margin:int, _rng):
	rng = _rng
	@warning_ignore("narrowing_conversion")
	point_position = Vector2(rng.randi_range(_margin,_cell_size.x-_margin),rng.randi_range(_margin,_cell_size.y-_margin))
