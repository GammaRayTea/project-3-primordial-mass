
@abstract class_name DropContainer extends Interactable

@export var item:Item
@export var sprite:Sprite3D
@export var anim_player:AnimationPlayer
@export var sound_manager:SoundEffectManager

func _ready() -> void:
	sprite.texture = item.icon
	anim_player.play("hover")
