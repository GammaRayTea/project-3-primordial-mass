@tool
class_name Slot extends TextureRect

@export var on_texture:Texture2D
@export var off_texture:Texture2D
@export var value:bool = false:
	set(_value):
		value = _value
		if _value:
			texture = on_texture
		else:
			texture = off_texture
		print(texture)

func _ready() -> void:
	texture = off_texture
