extends Node2D
class_name Doll

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var interact_hover_ui : Control

@export_subgroup("Doll Settings")
@export var doll_item_data : ItemData

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	assert(doll_item_data, "doll_item_data is empty")
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
	interact_hover_ui.show()

func _on_interactable_unhovered(): interact_hover_ui.hide()

func _on_interactable_interacted():
	if GameManager.loop_count <= 0: return
	EventFlag.instance.has_found_doll = true
	InventoryManager.add_item(doll_item_data)
	interact_hover_ui.hide()
	queue_free()

func _on_interactable_interacted_by_npc(npc:Node) -> void: pass
