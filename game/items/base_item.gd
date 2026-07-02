@tool
class_name Item extends Resource

@export var icon:ImageTexture
@export var scene_path:String
func _setup() -> void:
	var scene = load(scene_path)

func _init() -> void:
	resource_path
