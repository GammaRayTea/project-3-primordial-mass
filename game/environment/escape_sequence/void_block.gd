class_name VoidBlock extends Node3D

@export var fog_volume: FogVolume
@export var collison_shape:CollisionShape3D
@export var escape_fog_material:FogMaterial
var activation_time:float = 0.0


func _ready() -> void:
	fog_volume.material = escape_fog_material.duplicate_deep()
	
	var tween = get_tree().create_tween()
	tween.tween_property(fog_volume.material,"density", 6.0, activation_time)
	await tween.finished
	collison_shape.disabled = false
	

func _on_area_3d_area_entered(_area: Area3D) -> void:
	if _area.get_parent() is Player:
		(get_tree().get_first_node_in_group("Game") as Game).die()
