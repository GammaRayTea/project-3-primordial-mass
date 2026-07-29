class_name MainMenu extends Control

@export var start_button:Button
@export var clear_save_button:Button

func _ready() -> void:
	clear_save_button.pressed.connect(GameSaveManager.delete_save)


func _on_button_pressed() -> void:
	pass
