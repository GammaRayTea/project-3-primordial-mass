
@abstract class_name DropContainer extends Interactable

@export var item:Item
@export var sprite:Sprite3D
@export var anim_player:AnimationPlayer
@export var sound_manager:SoundEffectManager

func _ready() -> void:
	update_texture()
	anim_player.play("hover")

func update_texture() -> void:
	sprite.texture = item.icon
