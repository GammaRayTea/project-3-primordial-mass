@tool
class_name InteractionBox extends TriggerBox

@export var interact_action: String = "interact" 

var target: Node3D = null
var player_in_range: bool = false
var player_ref: Node3D = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	target = get_parent()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	player_in_range = true
	player_ref = body
	if target and target.has_method("hover_start"):
		target.hover_start()

func _on_body_exited(body: Node3D) -> void:
	if body != player_ref:
		return
	player_in_range = false
	player_ref = null
	if target and target.has_method("hover_end"):
		target.hover_end()

func _input(event: InputEvent) -> void:
	if not player_in_range:
		return
	if event.is_action_pressed(interact_action):
		if target and target.has_method("activate"):
			target.activate(player_ref)
