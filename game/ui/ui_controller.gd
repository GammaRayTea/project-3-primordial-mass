class_name UIController extends CanvasLayer
@export var main_menu:MainMenu
@export var hud:HUD
@export var upgrade_menu:UpgradeMenu
@export var pause_screen:PauseScreen
@export var death_screen:DeathScreen
@export var sound_manager:SoundEffectManager


func _ready() -> void:

	upgrade_menu.start_run_button.pressed.connect(_on_start_run_button_pressed)
	
	for button in get_tree().get_nodes_in_group("Button"):
		button.pressed.connect(sound_manager._play.bind(["Clicked"]))
		print(button)
	for module in upgrade_menu.upgrade_modules:
		module.upgrade_successful.connect(sound_manager._play.bind(["Upgraded"]))


func switch_to_state(_state:Game.STATE) -> void:
	#print("ui switching to ", Game.STATE.keys()[_state])
	match _state:
		Game.STATE.MAIN_MENU:
			death_screen.hide()
			upgrade_menu.hide()
			hud.hide()
			pause_screen.hide()
			
			main_menu.show()
		
		
		Game.STATE.UPGRADE_MENU:
			death_screen.hide()
			hud.hide()
			main_menu.hide()
			pause_screen.hide()
			
			upgrade_menu.show()
		
		
		Game.STATE.IN_GAME:
			death_screen.hide()
			upgrade_menu.hide()
			main_menu.hide()
			pause_screen.hide()
			
			hud.show()
		
		
		Game.STATE.PAUSED:
			upgrade_menu.hide()
			main_menu.hide()
			
			pause_screen.show()
		
		Game.STATE.DIED:
			hud.hide()
			upgrade_menu.hide()
			main_menu.hide()
			pause_screen.hide()
			
			death_screen.show()
			death_screen.activate()


func _on_start_run_button_pressed() -> void:
	sound_manager._play(["StartRun"])
