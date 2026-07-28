@tool
class_name Item extends Resource
@export var name:String = ""
@export var icon:Texture
@export var scene_path:String

func _init() -> void:
	resource_name = name
