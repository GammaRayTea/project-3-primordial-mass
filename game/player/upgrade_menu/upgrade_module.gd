@tool
class_name UpgradeModule extends Control

@export var upgrade_value:GlobalEnum.UPGRADES
@export var slot_amount:int = 3:
	set(_value):
		if _value >= 0:
			slot_amount = _value
		call_deferred("update_slot_amount")

@export_category("Components")
@export var slot_scene:PackedScene
@export var slot_container:HBoxContainer
@export var plus_button:Button
@export var minus_button:Button
var slots:Array[Slot] = []

func _ready() -> void:
	update_slot_amount()

func update_slot_amount() -> void:

	if slots.size() > slot_amount:
		for i in slots.size()-slot_amount:
			slots[slots.size()-1-i].queue_free()
	slots.resize(slot_amount)
	for slot in slot_amount:
		if !slots[slot]:
			slots[slot] = load(slot_scene.resource_path).instantiate()
			slot_container.add_child(slots[slot])
			slots[slot].set_owner(slot_container)
	slot_container.move_child(plus_button,slot_amount+1)
