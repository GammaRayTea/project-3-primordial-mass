class_name MainMenu extends Control

@export var start_button:Button

func _ready() -> void:
	print(start_button.pressed.get_connections())


func _on_button_pressed() -> void:
	pass
