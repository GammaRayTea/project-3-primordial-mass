@tool
class_name PlayAnimationEvent extends Event
@export var animation_tree:AnimationTree
@export var animation_name:String
func execute() -> void:
	animation_tree["parameters/StateMachine/playback"].travel(animation_name)
