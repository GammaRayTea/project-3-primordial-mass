@tool
class_name TutorialHint extends Control
@export var text:String
@export var label:RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		modulate = Color(1,1,1,0)
	label.text = text
