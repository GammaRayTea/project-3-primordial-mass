class_name DeathScreen extends PauseScreen
@export var animation_player: AnimationPlayer
func _ready():
	process_mode = PROCESS_MODE_WHEN_PAUSED


func activate() -> void:
	animation_player.play("show_death_screen")
