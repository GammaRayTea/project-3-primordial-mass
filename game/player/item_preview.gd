extends Panel


@export var image:TextureRect
@export var label:Label


func _ready() -> void:
	image.texture = null
	label.text = ""


func set_item(_item:Item) -> void:
	image.texture = _item.icon
	label.text = _item.name
