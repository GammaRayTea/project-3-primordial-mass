class_name Tutorial extends Control



@export var hint_container:VBoxContainer

@export_category("Hints")
@export var movement_hint:Control
@export var sprint_hint:Control
@export var stability_hint:Control

@export var pearl_hint:Control
@export var escape_hint:Control

enum TUTORIAL_TIMED_PHASE {INIT,SPAWN, STABILITY_HINT, OBJECTIVE}
var current_phase:TUTORIAL_TIMED_PHASE = TUTORIAL_TIMED_PHASE.INIT

var is_pearl_collected:bool = false


func _ready() -> void:
	get_tree().node_added.connect(on_node_created)
	RunManager.stability_depleted.connect(on_stability_depleted)

	next_phase()
	

func next_phase() -> void:
	current_phase = (current_phase + 1) as TUTORIAL_TIMED_PHASE
	await get_tree().create_timer(1).timeout
	match current_phase:
		TUTORIAL_TIMED_PHASE.SPAWN:
			
			modulate_element(movement_hint)
			await get_tree().create_timer(1).timeout
			await modulate_element(sprint_hint)
			next_phase()
		TUTORIAL_TIMED_PHASE.STABILITY_HINT:
			modulate_element(stability_hint)

func modulate_element(_control:Control ) -> void:
	
	
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(_control,"modulate:a", 1.0, 1)
	await tween.finished
	var timer = get_tree().create_timer(5)
	await timer.timeout
	tween = get_tree().create_tween()
	tween.tween_property(_control,"modulate:a",0.0, 1)
	await tween.finished

func on_pearl_collected(_node:Node) -> void:
	if !is_pearl_collected:
		modulate_element(pearl_hint)
		is_pearl_collected = true

func on_stability_depleted() -> void:
	modulate_element(escape_hint)

func on_node_created(_node:Node) -> void:
	if _node is ItemDrop:
		_node.child_exiting_tree.connect(on_pearl_collected)
