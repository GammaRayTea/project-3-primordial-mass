class_name UIController extends CanvasLayer
@export var main_menu:MainMenu
@export var hud:HUD
@export var upgrade_menu:UpgradeMenu
@export var pause_screen:PauseScreen
@export var death_screen:DeathScreen
@export var sound_manager:SoundEffectManager
@export var tutorial_scene:PackedScene

@export var transtion_screen:ColorRect
@export var fade_player:AnimationPlayer
var tutorial:Tutorial

signal fade_finished

func _ready() -> void:

	upgrade_menu.start_run_button.pressed.connect(_on_start_run_button_pressed)
	
	for button in get_tree().get_nodes_in_group("Button"):
		button.pressed.connect(sound_manager._play.bind(["Clicked"]))

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
			if GameSaveManager.save_game.tutorial:
				tutorial = tutorial_scene.instantiate()
				add_child(tutorial)
			
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
			
			death_screen.activate()
			death_screen.show()
			sound_manager._play(["Death"])

#func _physics_process(delta: float) -> void:
	#print($Overlay/StabilityBar.max_value)
	#print($Overlay/StabilityBar.value)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		RunManager.saved_currency[GlobalEnum.CURRENCY.GOO] +=100
		RunManager.saved_currency[GlobalEnum.CURRENCY.COINS] +=100

func _on_start_run_button_pressed() -> void:
	sound_manager._play(["StartRun"])


func fade(_time:float = 1.0) -> void:
	transtion_screen.show()
	var from_end:bool = false
	if _time < 0:
		from_end = true
	fade_player.play("fade", -1, _time, from_end)
	await fade_player.animation_finished
	transtion_screen.hide()
	fade_finished.emit()
