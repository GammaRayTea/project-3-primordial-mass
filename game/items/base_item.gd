@tool
@abstract class_name Item extends Resource
@export var name:String = ""
@export var icon:Texture
@export var scene_path:String
@abstract func _setup() -> void

func _init() -> void:
	resource_name = name

@abstract func execute(_source:Node3D) -> void
