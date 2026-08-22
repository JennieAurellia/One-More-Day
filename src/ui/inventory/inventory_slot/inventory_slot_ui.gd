extends Control
class_name InventorySlotUI

@export_subgroup("References")
@export var item_texture_rect : TextureRect
@export var button : Button

var item_data : ItemData = null

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(item_texture_rect, "item_texture_rect is missing")
	assert(button, "button is missing")
	# Connect signals
	button.pressed.connect(_on_pressed)

# ==================================================================================================
#                Inventory slot methods
# ==================================================================================================
func set_item_data(new_item_data:ItemData):
	item_data = new_item_data
	item_texture_rect.texture = item_data.icon
	tooltip_text = item_data.display_name

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_pressed(): InventoryManager.select_item(item_data)
