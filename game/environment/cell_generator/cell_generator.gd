extends Node3D
@export var player:Player
@export var cell_size:Vector2 = Vector2(16,16)

var start_pos = Vector2(0,0)
var current_position := Vector2(0,0):
	set(value):
		current_position = value
		print("new gen ---------------------------")
		check_cells(inner_check_range,active_map,active_cells)
		check_cells(outer_check_range,outer_map,staged_cells)
		

@export var active_map:Control
@export var outer_map:Control


var outer_check_range:int = 3
var inner_check_range:int = 1
@export var random_seed:int
var rng := RandomNumberGenerator.new()


var active_cells:Dictionary[Vector2,Cell] = {}
var staged_cells:Dictionary[Vector2,Cell] = {}

func _ready() -> void:
	rng.seed = random_seed
	var start_cell = Cell.new(cell_size,rng)
	active_cells[start_pos] = start_cell
	staged_cells[start_pos] = start_cell
	
	active_map.cells.push_back(start_pos)
	outer_map.cells.push_back(start_pos)
	
	active_map.points.push_back(start_pos)
	outer_map.points.push_back(start_pos)
	
	
	check_cells(inner_check_range,active_map,active_cells)
	check_cells(outer_check_range,outer_map, staged_cells)
	
	#var test_points:=PackedVector2Array()
	#test_points.push_back(Vector2(0,0))
	#test_points.push_back(Vector2(5,0))
	#test_points.push_back(Vector2(0,5))
	#test_points.push_back(Vector2(10,0))
	#test_points.push_back(Vector2(5,20))
	#active_map.delaunay_points = test_points
	#active_map.delaunay_ids = Geometry2D.triangulate_delaunay(test_points)
	#

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
func check_cells(_check_range:int,_map:Control,_cell_dict):
	
	for i in range(_check_range*2+1):
		for j in range(_check_range*2+1):
			var pos = (Vector2(i-_check_range,j-_check_range) +current_position)*cell_size
			#print(pos)
			if _cell_dict.has(pos):
				pass
			else:
				_cell_dict[pos] = Cell.new(cell_size,rng)
				#print("generated cell (",i + current_position.x,", ",j + current_position.y,")  point:", _cell_dict[pos].point_position)
				_map.cells.push_back(pos)
				_map.points.push_back(_cell_dict[pos].point_position)
	#print("current_pos: ",current_position,"-------------------------------")
	var world_points = get_points(_cell_dict)
	var delaunayIDs = Geometry2D.triangulate_delaunay(world_points)
	
	_map.delaunay_ids = delaunayIDs
	_map.delaunay_points = world_points
	print(delaunayIDs, " ", delaunayIDs.size())
	print(world_points)
	_map.queue_redraw()
func cell_to_world(_coord:Vector2) -> Vector3:
	var vec = Vector3(_coord.x * cell_size.x, 0 ,_coord.y*cell_size.y)
	return vec


func get_points(_cell_dict)->PackedVector2Array:
	var points := PackedVector2Array()
	
	for pos in  _cell_dict:
		points.push_back(_cell_dict[pos].point_position + pos )
		#print(_cell_dict[pos].point_position*cell_size + pos)
	
	
	return points
