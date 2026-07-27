class_name UIController extends CanvasLayer
@export var main_menu:MainMenu
@export var hud:Control
@export var upgrade_menu:UpgradeMenu
@export var sound_manager:SoundEffectManager

enum STATE {MAIN_MENU, UPGRADE_MENU, IN_GAME}
var current_state:STATE




func _ready() -> void:
	main_menu.start_button.pressed.connect(_on_menu_start_button_pressed)
	upgrade_menu.start_run_button.pressed.connect(_on_start_run_button_pressed)

func start() -> void:
	switch_to_state(STATE.MAIN_MENU)

func switch_to_state(_state:STATE) -> void:
	print("switching to ", STATE.keys()[_state])
	match _state:
		STATE.MAIN_MENU:
			current_state = STATE.MAIN_MENU
			upgrade_menu.hide()
			hud.hide()
			
			main_menu.show()
		STATE.UPGRADE_MENU:
			current_state = STATE.UPGRADE_MENU
			hud.hide()
			main_menu.hide()
			
			upgrade_menu.show()
		STATE.IN_GAME:
			current_state = STATE.IN_GAME
			upgrade_menu.hide()
			main_menu.hide()
			
			hud.show()


func _on_start_run_button_pressed() -> void:
	sound_manager._play(["StartRun"])

func _on_menu_start_button_pressed() -> void:
	switch_to_state(STATE.UPGRADE_MENU)
