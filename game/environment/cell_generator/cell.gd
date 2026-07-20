class_name Cell extends Resource
var cell_position:Vector2
var point_position:Vector2
var global_point_position:Vector2
var rng:RandomNumberGenerator
var locked:bool = false
var connections:Array[Cell] = []
var bit_map:BitMap
var tier:int
var enemy_amounts:Dictionary[DungeonPopulator.ENEMY_NAMES,int]:
	set(value):
		enemy_total = 0
		for number in value.values():
			enemy_total+= number
		enemy_amounts = value
var enemy_total:int

func _init(_cell_size:int,_margin:int, _rng):
	rng = _rng
	@warning_ignore("narrowing_conversion")
	point_position = Vector2(rng.randi_range(_margin,_cell_size-_margin),rng.randi_range(_margin,_cell_size-_margin))
