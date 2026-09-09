extends Node2D
class_name ElenaPhone

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var sprite : Sprite2D
@export var interact_hover_ui : Control
@export var interact_hover_text_label : Label

@export_subgroup("Phone Settings")
@export var place_interact_text : String = "Place?"
@export var take_interact_text : String = "Take?"
@export var phone_item_data : ItemData

var _is_phone_placed : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(sprite, "sprite is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	assert(interact_hover_text_label, "interact_hover_text_label is missing")
	assert(phone_item_data, "phone_item_data is empty")
	# Connect signals
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	interactable_component.interacted_by_npc.connect(_on_interactable_interacted_by_npc)
	# Initialize
	interact_hover_ui.hide()
	take_phone()

# ==================================================================================================
#                Phone methods
# ==================================================================================================
func place_phone():
	_is_phone_placed = true
	sprite.show()

func take_phone():
	_is_phone_placed = false
	sprite.hide()

func is_phone_placed()->bool: return _is_phone_placed

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered():
	if _is_phone_placed:
		interact_hover_text_label.text = take_interact_text
		interact_hover_ui.show()
	elif InventoryManager.has_item(phone_item_data.id):
		interact_hover_text_label.text = place_interact_text
		interact_hover_ui.show()

func _on_interactable_unhovered(): interact_hover_ui.hide()

func _on_interactable_interacted():
	if _is_phone_placed:
		take_phone()
		InventoryManager.add_item(phone_item_data)
		interact_hover_ui.hide()
	elif InventoryManager.has_item(phone_item_data.id):
		place_phone()
		interact_hover_ui.hide()

func _on_interactable_interacted_by_npc(npc:Node) -> void: pass
