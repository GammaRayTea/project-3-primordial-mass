@tool
class_name UpgradeModule extends Control
##Class responsible for displaying and updating one player stat in the shop menu

@export var upgrade_stat:GlobalEnum.UPGRADES
@export var upgrade_stat_amount:float = -0.1


@export var upgrade_currency:GlobalEnum.CURRENCY
@export var base_cost:int:
	set(value):
		base_cost = value
		update_data()
var current_cost:int
@export var cost_mulitplier:float = 1.0:
	set(value):
		cost_mulitplier = value
		update_data()


signal upgrade_successful

var current_upgrade_level:int = 0:
	set(_value):
		if current_upgrade_level < max_level:
			current_upgrade_level = _value
			for i in current_upgrade_level:
				slots[i].value = true

		
		
@export var max_level:int = 3:
	set(_value):
		if _value >= 0:
			max_level = _value
		call_deferred("update_slot_amount")

@export_category("Components")
@export var slot_scene:PackedScene
@export var slot_container:HBoxContainer
@export var plus_button:TextureButton
@export var name_label:RichTextLabel
@export var cost_label:RichTextLabel
@export var description_label:RichTextLabel
@export var upgrade_icon:TextureRect

var slots:Array[Slot] = []

func retrieve_saved_data() -> void:
	current_upgrade_level = GameSaveManager.save_game.player_stat_levels[upgrade_stat]

func _ready() -> void:
	update_data()
	update_slot_amount()
	plus_button.pressed.connect(on_button_press.bind(true))

	

func update_slot_amount() -> void:

	if slots.size() > max_level:
		for i in slots.size() - max_level:
			slots[slots.size() - 1 - i].queue_free()
	slots.resize(max_level)
	for slot in max_level:
		if !slots[slot]:
			slots[slot] = slot_scene.instantiate()
			slot_container.add_child(slots[slot])
			slots[slot].set_owner(slot_container)

func update_data() -> void:
	#TODO
	if current_upgrade_level == 0:
		current_cost = base_cost
	else:
		@warning_ignore("narrowing_conversion")
		current_cost = base_cost * pow(2, current_upgrade_level) * cost_mulitplier 
	name_label.text = ItemAssets.stat_names[upgrade_stat]
	cost_label.text = '[img]'+ ItemAssets.currency_icons[upgrade_currency] + '[/img] ' + str(current_cost)
	description_label.text = ItemAssets.stat_descriptions[upgrade_stat]
	upgrade_icon.texture = load(ItemAssets.stat_icons[upgrade_stat])
	
	
func on_button_press(_increase:bool) -> void:
	
	if _increase:
		if RunManager.saved_currency[upgrade_currency] >= current_cost:
			RunManager.change_currency(upgrade_currency, -current_cost)
			current_upgrade_level += 1
			update_data()
			upgrade_successful.emit()
			RunManager.change_stat(upgrade_stat,upgrade_stat_amount, current_upgrade_level)
			if current_upgrade_level == max_level:
				plus_button.disabled = true
