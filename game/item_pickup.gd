@tool
class_name ItemPickup extends Interactable



var sprite:Sprite3D = null
var interaction_box:InteractionBox = null

@export var item:Item:
	set(value):
		item = value
		if sprite:
			sprite.texture = item.icon
var player:Player
func _init(_item:Item = null) -> void:
	if _item != null:
		item = _item
	


func _ready()->void:

	if !sprite or !interaction_box:
		for child in get_children():
			child.queue_free()
			
		sprite = Sprite3D.new()
		sprite.name = "Icon"
		add_child(sprite)
		
		sprite.rotation.x = deg_to_rad(90)
		sprite.scale = Vector3(4,4,4)
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite.texture = item.icon
		


		interaction_box = InteractionBox.new()
		add_child(interaction_box)
		interaction_box.name = "InteractionBox"
			
		interaction_box.set_collision_layer_value(1,false)
		interaction_box.set_collision_mask_value(1,false)
		interaction_box.set_collision_layer_value(6,true)
		interaction_box.target = self
		
		
		if Engine.is_editor_hint():
			sprite.owner = get_tree().edited_scene_root
			interaction_box.owner = get_tree().edited_scene_root
	else:
		for child in get_children():
			if child.name == "Icon":
				sprite = child
			if child.name == "InteractionBox":
				interaction_box = child

	


func hover_start()-> void:
	pass

func hover_end()-> void:
	pass

func activate(_source:Node3D) -> void:
	if _source is Player:
		_source.pick_up_item(item)
		queue_free()

func deactivate(_source:Node3D) -> void:
	pass
