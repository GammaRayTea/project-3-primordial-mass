class_name CurrencyCounter extends MarginContainer

@export var goo_counter:RichTextLabel
@export var coin_counter:RichTextLabel


func refresh() -> void:
	if GameSaveManager.save_game:
		goo_counter.text  = str(GameSaveManager.save_game.currency[GlobalEnum.CURRENCY.GOO])
		coin_counter.text  = str(GameSaveManager.save_game.currency[GlobalEnum.CURRENCY.COINS])


func _on_visibility_changed():
	if  visible:
		refresh()
