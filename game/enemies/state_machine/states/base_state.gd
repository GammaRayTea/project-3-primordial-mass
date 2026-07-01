@abstract class_name State extends Node
@export var next_state:State

@warning_ignore("unused_signal")
signal state_finished
@abstract func _setup()->void
@abstract func _start()-> void
@abstract func _execute(_delta:float) -> void
