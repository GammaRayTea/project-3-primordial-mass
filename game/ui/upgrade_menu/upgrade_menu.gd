class_name UpgradeMenu extends Control

@export var upgrade_container:VBoxContainer
@export var start_run_button:Button
@export var return_to_menu_button:Button

@export var currency_counter:CurrencyCounter

@export var upgrade_modules:Array[UpgradeModule]

# Called when the node enters the scene tree for the first time.
func retrieve_saved_data() -> void:
	currency_counter.refresh()
	for module in upgrade_modules:
		module.retrieve_saved_data()
		module.upgrade_successful.connect(RunManager.save_game)
		module.upgrade_successful.connect(currency_counter.refresh)
