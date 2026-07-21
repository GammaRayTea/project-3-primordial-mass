extends Node
@export var jump_to_game:bool = true
@export var main_menu:MainMenu
@export var game:Node3D
@export var render_low_res:bool = false
@export var low_resolution:Vector2i
@export var high_resolution:Vector2i
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if render_low_res:
		get_tree().root.content_scale_size = low_resolution
	else:
		get_tree().root.content_scale_size = high_resolution
	get_tree().root.size = high_resolution
	
	
	main_menu.start_button.pressed.connect($Game.start)
	if jump_to_game:
		$Game.start()
		main_menu.hide()
