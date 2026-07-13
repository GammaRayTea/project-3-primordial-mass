class_name DropContainer extends Node3D


@export var type :GlobalEnum.CURRENCY
@export var value:int
@export var sprite:Sprite3D
@export var anim_player:AnimationPlayer

@export var aoutonomous_setup:bool = false
func _ready() -> void:
	anim_player.play("hover")
	if aoutonomous_setup:
		sprite.texture = load(ItemAssets.assets[type])


func setup(_type:GlobalEnum.CURRENCY, _value:int) -> void:
	if _value <1:
		_value = 1
	type = _type
	sprite.texture = load(ItemAssets.assets[type])
	print(sprite.texture )
	value = _value


func _on_interaction_box_area_entered(_area: Area3D) -> void:
	GameState.save_game.add_currency(type,value)
	queue_free()
