extends Panel



func _on_visibility_changed() -> void:
	if visible:
		await get_tree().create_timer(4).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a",0, 3)
		await tween.finished
		hide()


func _on_credits_button_pressed() -> void:
	modulate.a = 1.0
	show()
