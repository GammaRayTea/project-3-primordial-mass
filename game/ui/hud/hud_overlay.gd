class_name HUD extends Control


@export var activate_portal_hint:Label


func _ready() -> void:
	pass # Replace with function body.

func set_item(_item:Item) -> void:
	%ItemPreview.set_item(_item)

func set_active_portal_hint_vis(_value:bool) -> void:
	activate_portal_hint.visible = _value
