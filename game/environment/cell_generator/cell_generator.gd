extends Node3D
@export var player:Player
@export var cell_size:Vector2 = Vector2(16,16)

var start_pos = Vector2(0,0)
var current_position := Vector2(0,0):
	set(value):
		current_position = value
		print("new gen ---------------------------")
		check_cells()
		

var check_range:int = 2
@export var random_seed:int
var rng := RandomNumberGenerator.new()

var generated_cells:Dictionary[Vector2,Cell] = {}

func _ready() -> void:
	rng.seed = random_seed
	generated_cells[start_pos] = Cell.new(cell_size,rng)
	$Control.cells.push_back(start_pos)
	$Control.points.push_back(start_pos)
	check_cells()

func _physics_process(_delta: float) -> void:
	var player_pos = Vector2(player.position.x, player.position.z) / cell_size
	var new_pos = Vector2()
	
	if (player_pos.x <0):
		new_pos.x = int(ceil(player_pos.x)) % int(cell_size.x)
	else:
		new_pos.x = int(floor(player_pos.x)) % int(cell_size.x)
	
	if (player_pos.y <0):
		new_pos.y = int(ceil(player_pos.y)) % int(cell_size.y)
	else:
		new_pos.y = int(floor(player_pos.y)) % int(cell_size.y)
	
	if (new_pos != current_position):
		current_position = new_pos
		print(current_position)


##Check squares in a rectangle around current
func check_cells():
	
	for i in range(check_range*2+1):
		for j in range(check_range*2+1):
			var pos = Vector2(i-check_range,j-check_range) +current_position
			print(pos)
			if generated_cells.has(pos):
				pass
			else:
				generated_cells[pos] = Cell.new(cell_size,rng)
				print("generated cell (",i + current_position.x,", ",j + current_position.y,")")
				$Control.cells.push_back(pos)
				$Control.points.push_back(pos + generated_cells[pos].point_position)
	$Control.queue_redraw()

func cell_to_world(_coord:Vector2) -> Vector3:
	var vec = Vector3(_coord.x * cell_size.x, 0 ,_coord.y*cell_size.y)
	return vec
