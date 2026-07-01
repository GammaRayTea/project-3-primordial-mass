class_name Enemy extends CharacterBody3D
@export var state_machine:StateMachine

const SPEED = 5.0



func _physics_process(_delta: float) -> void:
	state_machine._update(_delta)
