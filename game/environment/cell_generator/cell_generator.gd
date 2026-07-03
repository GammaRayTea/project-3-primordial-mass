extends Node3D
@export var player:Player
@export var cell_size:Vector2 = Vector2(16,16)
@export var random_seed:int
var start_pos = Vector2(0,0)
var current_position := Vector2(0,0)
var check_range:int = 3

var generated_cells:Dictionary[Vector2,Cell] = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generated_cells[start_pos] = Cell.new()
	check_cells()
	
	
func check_cells():
	
	for i in range(check_range*2+1):
		for j in range(check_range*2+1):
			var pos = Vector2(i-check_range,j-check_range)
			if generated_cells.has(pos):
				print(generated_cells[pos])
			else:
				generated_cells[pos] = Cell.new()
				


func cell_to_world(_coord:Vector2) -> Vector3:
	var vec = Vector3(_coord.x * cell_size.x,0,_coord.y*cell_size.y)
	return vec
