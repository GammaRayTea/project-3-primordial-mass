@tool
@abstract class_name ConditionState extends State

@export var branch_state:State

@abstract func _setup() -> void


@abstract func _start() -> void


@abstract func _execute(_delta:float) -> void


@abstract func _exit() -> void
