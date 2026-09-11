extends Node2D
class_name Wardrobe

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var normal_sprite : Sprite2D
@export var opened_sprite : Sprite2D
@export var interact_hover_ui : Control

@export_subgroup("Wardrobe Settings")
@export var gift_item_data : ItemData

@export_subgroup("Audio Settings")
@export var open_sfx_name : String = "wardrobe_open"
@export var close_sfx_name : String = "wardrobe_close"

var _is_already_searched : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "normal_sprite is missing")
	assert(normal_sprite, "normal_sprite is missing")
	assert(opened_sprite, "opened_sprite is missing")
	assert(interact_hover_ui, "opened_sprite is missing")
	assert(gift_item_data, "gift_item_data is missing")
	# Connect signals
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	interactable_component.interacted_by_npc.connect(_on_interactable_interacted_by_npc)
	# Initialize
	normal_sprite.show()
	opened_sprite.hide()
	interact_hover_ui.hide()

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func open():
	normal_sprite.hide()
	opened_sprite.show()
	AudioManager.play_sfx(open_sfx_name)

func close():
	normal_sprite.show()
	opened_sprite.hide()
	AudioManager.play_sfx(close_sfx_name)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered():
	if GameManager.loop_count <= 0: return
	if InventoryManager.selected_item: return
	if !_is_already_searched: interact_hover_ui.show()

func _on_interactable_unhovered(): interact_hover_ui.hide()

func _on_interactable_interacted():
	if GameManager.loop_count <= 0: return
	if !_is_already_searched:
		EventFlag.instance.has_found_present = true
		InventoryManager.add_item(gift_item_data)
		_is_already_searched = true
		interact_hover_ui.hide()

func _on_interactable_interacted_by_npc(npc:Node) -> void: pass
