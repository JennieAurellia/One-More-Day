extends Node2D
class_name MakeupDesk

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var interact_hover_ui : Control

var _is_used : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	# Connect signals
	EventFlag.instance.makeup_desk_released.connect(release)
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	interactable_component.interacted_by_npc.connect(_on_interactable_interacted_by_npc)
	# Initialize
	interact_hover_ui.hide()

# ==================================================================================================
#                Desk methods
# ==================================================================================================
func use(): _is_used = true

func release(): _is_used = false

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered():
	if GameManager.loop_count <= 0: return
	if InventoryManager.selected_item: return
	if !_is_used: interact_hover_ui.show()

func _on_interactable_unhovered(): interact_hover_ui.hide()

func _on_interactable_interacted():
	if GameManager.loop_count <= 0: return
	if !_is_used:
		use()
		interact_hover_ui.hide()
		EventFlag.instance.makeup_desk_used.emit()

func _on_interactable_interacted_by_npc(npc:Node) -> void: pass
