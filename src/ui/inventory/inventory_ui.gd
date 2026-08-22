extends Control
class_name InventoryUI

@export_subgroup("References")
@export var inventory_slot_parent : Control

@export_subgroup("Inventory Settings")
@export var inventory_slot_ui_scene : PackedScene

var _inventory_slot_dictionary : Dictionary[ItemData, InventorySlotUI] = {}

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(inventory_slot_parent, "inventory_slot_parent is missing")
	assert(inventory_slot_ui_scene, "inventory_slot_ui_scene is missing")
	# Connect signals
	InventoryManager.item_added.connect(_on_item_added)
	InventoryManager.item_removed.connect(_on_item_removed)
	InventoryManager.selection_changed.connect(_on_selection_changed)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_item_added(item_data:ItemData):
	var inventory_slot_ui_instance : InventorySlotUI = inventory_slot_ui_scene.instantiate()
	inventory_slot_parent.add_child(inventory_slot_ui_instance)
	inventory_slot_ui_instance.set_item_data(item_data)
	_inventory_slot_dictionary[item_data] = inventory_slot_ui_instance

func _on_item_removed(item_data:ItemData):
	if _inventory_slot_dictionary.has(item_data):
		_inventory_slot_dictionary[item_data].queue_free()
		_inventory_slot_dictionary.erase(item_data)

func _on_selection_changed(selected_item_data:ItemData):
	for item_data:ItemData in _inventory_slot_dictionary.keys():
		var inventory_slot_ui : InventorySlotUI = _inventory_slot_dictionary[item_data]
		var is_selected : bool = item_data == selected_item_data
		#inventory_slot_ui.scale = Vector2.ONE * (selected_highlight_scale if is_selected else 1.0)
		#inventory_slot_ui.modulate = Color.WHITE if is_selected else Color(0.8, 0.8, 0.8)
