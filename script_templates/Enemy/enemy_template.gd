@tool
extends Enemy


#Called when the enemy gets hit. [code]super()[/code] emits [code]enemy_hurt[/code].
func _get_hit(source:HitBox):
	super(source)
	health-= source.damage

#Called when the enemy dies. [code]super()[/code] emits [code]enemy_died[/code].
func _die() -> void:
	super()
	queue_free() #delete enemy
