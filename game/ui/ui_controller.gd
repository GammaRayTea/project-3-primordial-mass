class_name UIController extends CanvasLayer
@export var main_menu:MainMenu
@export var hud:HUD
@export var upgrade_menu:UpgradeMenu
@export var pause_screen:PauseScreen
@export var sound_manager:SoundEffectManager






func _ready() -> void:

	upgrade_menu.start_run_button.pressed.connect(_on_start_run_button_pressed)


func switch_to_state(_state:Game.STATE) -> void:
	#print("ui switching to ", Game.STATE.keys()[_state])
	match _state:
		Game.STATE.MAIN_MENU:
			upgrade_menu.hide()
			hud.hide()
			pause_screen.hide()
			
			main_menu.show()
		
		
		Game.STATE.UPGRADE_MENU:
			hud.hide()
			main_menu.hide()
			pause_screen.hide()
			
			upgrade_menu.show()
		
		
		Game.STATE.IN_GAME:
			upgrade_menu.hide()
			main_menu.hide()
			pause_screen.hide()
			
			hud.show()
		
		
		Game.STATE.PAUSED:
			upgrade_menu.hide()
			main_menu.hide()
			
			pause_screen.show()


func _on_start_run_button_pressed() -> void:
	sound_manager._play(["StartRun"])
