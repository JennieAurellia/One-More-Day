extends Node2D
class_name MakeupDesk

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var interact_hover_ui : Control

@export_subgroup("Makeup Desk Settings")
@export var diary_item_data : ItemData

@export_subgroup("Audio Settings")
@export var search_sfx_name : String = "desk_search"

var _is_already_searched : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	# Connect signals
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	interactable_component.interacted_by_npc.connect(_on_interactable_interacted_by_npc)
	# Initialize
	interact_hover_ui.hide()

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
		EventFlag.instance.has_found_diary = true
		InventoryManager.add_item(diary_item_data)
		AudioManager.play_sfx(search_sfx_name)
		_is_already_searched = true
		interact_hover_ui.hide()

func _on_interactable_interacted_by_npc(npc:Node) -> void: pass
