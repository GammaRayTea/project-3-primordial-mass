extends AnimatedSprite3D

@onready var camera = get_viewport().get_camera_3d()

func _ready() -> void:
	frame_changed.connect(_update_shader_texture)
	animation_changed.connect(_update_shader_texture)
	play("default")
	_update_shader_texture()

func _update_shader_texture() -> void:
	var tex := sprite_frames.get_frame_texture(animation, frame)
	if material_override is ShaderMaterial:
		material_override.set_shader_parameter("sprite_texture", tex)
