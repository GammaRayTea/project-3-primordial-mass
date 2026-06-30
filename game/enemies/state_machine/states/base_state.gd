@abstract class_name State extends Node
@export var next_state:State

signal state_finished
@abstract func _execute(_subject:Node3D,_delta:float) -> void
