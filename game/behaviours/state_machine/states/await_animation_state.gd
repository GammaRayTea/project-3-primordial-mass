@tool
class_name AwaitAnimationState extends State
@export var animation_tree:AnimationTree
@export var animation:String

func _setup() -> void:
	animation_tree.animation_finished.connect(anim_finished)

func _start() -> void:
	animation_tree["parameters/playback"].travel(animation)

func _execute(_delta:float) -> void:
	pass

func _exit() -> void:
	pass

func anim_finished(_animation:StringName) -> void:
	finished.emit()
