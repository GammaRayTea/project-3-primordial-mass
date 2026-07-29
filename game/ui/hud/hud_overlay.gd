class_name HUD extends Control


@export var hint:Label


func _ready() -> void:
	pass # Replace with function body.

func set_item(_item:Item) -> void:
	%ItemPreview.set_item(_item)



func show_hint(_text:String) -> void:
	hint.text = _text
	hint.show()

func hide_hint() -> void:
	hint.hide()
