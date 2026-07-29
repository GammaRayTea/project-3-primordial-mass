class_name HUD extends Control


@export var hint:Label
@export var animation_tree:AnimationTree

func _ready() -> void:
	pass # Replace with function body.

func set_item(_item:Item) -> void:
	%ItemPreview.set_item(_item)



func show_hint(_text:String) -> void:
	hint.text = _text
	hint.show()

func hide_hint() -> void:
	hint.hide()

func play_vignette_effect(_effect:String) -> void:
	animation_tree["parameters/playback"].travel(_effect)

func set_escape_effect(_value:bool) -> void:
	animation_tree["parameters/conditions/escape"] = _value
