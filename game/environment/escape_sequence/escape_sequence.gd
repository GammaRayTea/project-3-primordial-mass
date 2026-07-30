class_name EscapeSequence extends Node3D
var locked_cells:Dictionary[Vector2, Cell]
var generated_void_blocks:Array[VoidBlock]
@export var cycle_decay_speed:float = 3.0
@export var void_scene:PackedScene
var current_index:int = 0

signal clearing

func start(_locked_cells:Dictionary[Vector2, Cell]) -> void:
	locked_cells = _locked_cells
	process_mode = Node.PROCESS_MODE_INHERIT
	current_index = _locked_cells.size()-1

var time_counter = 60 * cycle_decay_speed


func _physics_process(_delta: float) -> void:
	if time_counter< 60 * cycle_decay_speed:
		time_counter+=1
		
	else:
		var new_void_block:VoidBlock = void_scene.instantiate()
		new_void_block.activation_time = cycle_decay_speed
		generated_void_blocks.append(new_void_block)
		clearing.connect(new_void_block.queue_free)
		add_child(new_void_block)
		var new_position:Vector3 = Vector3(locked_cells.keys()[current_index].x, 0, locked_cells.keys()[current_index].y)
		new_void_block.global_position = new_position
		current_index -= 1
		time_counter = 0

func clear() -> void:
	set_deferred("process_mode", PROCESS_MODE_DISABLED)
	time_counter = 60 * cycle_decay_speed
	clearing.emit()
