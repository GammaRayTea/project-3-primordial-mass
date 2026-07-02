@tool
@abstract class_name State extends Node
##Base class for all States. extends this to create a new one.

##State that the state machine will switch to after this state is finished.
@export var next_state:State


##Signal that needs to be emited when the state is finished.
@warning_ignore("unused_signal")
signal finished

##Called once when the state is first loaded.
@abstract func _setup()->void;

##Called when the state starts execution.
@abstract func _start()-> void;

##Called every frame by the state machine when this state is active. [code]_delta[/code] is delta physics frame time.
@abstract func _execute(_delta:float) -> void;

##Called when a state is exited.
@abstract func _exit() -> void;
