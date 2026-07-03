class_name Cell extends Node
var point_position:Vector2
var rng:RandomNumberGenerator
func _init(_cell_size:Vector2, _rng):
	rng = _rng
	@warning_ignore("narrowing_conversion")
	point_position = Vector2(rng.randi_range(0,_cell_size.x-1),rng.randi_range(0,_cell_size.y-1))
