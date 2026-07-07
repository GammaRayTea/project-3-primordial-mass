extends Node3D
@export_category("Cell Attributes")
@export var cell_size:Vector2 = Vector2(16,16)
@export var cell_margin:int = 2
		

@export var player:Player
@export var active_map:Control
@export var outer_map:Control
@export var random_seed:int

var start_pos = Vector2(0,0)
var current_position := Vector2(0,0):
	set(value):
		current_position = value
		print("new gen ---------------------------")
		generate_new_cells(outer_check_range)
		lock_in_cells(inner_check_range)

var outer_check_range:int = 3
var inner_check_range:int = 1
var rng := RandomNumberGenerator.new()

var generated_cells:Dictionary[Vector2,Cell] = {}
var locked_cells:Dictionary[Vector2,Cell] = {}

func _ready() -> void:
	rng.seed = random_seed
	var start_cell = Cell.new(cell_size,cell_margin,rng)
	generated_cells[start_pos] = start_cell

	
	active_map.cells.push_back(start_pos)
	outer_map.cells.push_back(start_pos)
	
	active_map.points.push_back(start_pos)
	outer_map.points.push_back(start_pos)
	
	
	generate_new_cells(outer_check_range)
	lock_in_cells(inner_check_range)


func _physics_process(_delta: float) -> void:
	var player_pos = Vector2(player.position.x, player.position.z) / cell_size
	
	var new_pos = Vector2()
	active_map.player_pos = player_pos
	outer_map.player_pos = player_pos
	if (player_pos.x <0):
		new_pos.x = int(ceil(player_pos.x)) 
	else:
		new_pos.x = int(floor(player_pos.x)) 
	
	if (player_pos.y <0):
		new_pos.y = int(ceil(player_pos.y))
	else:
		new_pos.y = int(floor(player_pos.y))
	
	if (new_pos != current_position):
		current_position = new_pos
	
	
	
	
	

##Check  ells in a rectangle around current cell
func generate_new_cells(_check_range:int,):
	var new_cells:Dictionary[Vector2,Cell] = {}
	for i in range(_check_range*2+1):
		for j in range(_check_range*2+1):
			var pos = (Vector2(i-_check_range,j-_check_range) +current_position)*cell_size
			#print(pos)
			if generated_cells.has(pos):
				pass
			else:
				new_cells[pos] = Cell.new(cell_size,cell_margin, rng )
				#print("generated cell (",i + current_position.x,", ",j + current_position.y,")  point:", _cell_dict[pos].point_position)
				outer_map.cells.push_back(pos)
				outer_map.points.push_back(new_cells[pos].point_position)
	
	generated_cells.merge(new_cells)
	
	var world_points = get_points(generated_cells)
	var delaunayIDs = Geometry2D.triangulate_delaunay(world_points)
	
	outer_map.delaunay_ids = delaunayIDs
	outer_map.delaunay_points = world_points
	print(delaunayIDs, " ", delaunayIDs.size())
	print(world_points)
	outer_map.queue_redraw()
	
func lock_in_cells(_check_range:int):

	for i in range(_check_range*2+1):
		for j in range(_check_range*2+1):
			var pos = (Vector2(i-_check_range,j-_check_range) +current_position)*cell_size
			if generated_cells.has(pos):

				locked_cells[pos] = generated_cells[pos]
				active_map.cells.push_back(pos)
				active_map.points.push_back(locked_cells[pos].point_position)
				
				
				
				
				
				
	
	
	var world_points = get_points(locked_cells)
	var delaunayIDs = Geometry2D.triangulate_delaunay(world_points)
	
	
	active_map.delaunay_ids = delaunayIDs
	active_map.delaunay_points = world_points
	active_map.queue_redraw()
	

func cell_to_world(_coord:Vector2) -> Vector3:
	var vec = Vector3(_coord.x * cell_size.x, 0 ,_coord.y*cell_size.y)
	return vec


func get_points(_cell_dict)->PackedVector2Array:
	var points := PackedVector2Array()
	
	for pos in  _cell_dict:
		points.push_back(_cell_dict[pos].point_position + pos )
		#print(_cell_dict[pos].point_position*cell_size + pos)
	
	
	return points
