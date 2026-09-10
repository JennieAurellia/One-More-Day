extends Node
class_name PlayerInteraction

@export_subgroup("References")
@export var player : Player
@export var interactable_component : InteractableComponent
@export var interact_hover_ui : Control

@export_subgroup("Interaction Settings")
@export var phone_item_data : ItemData

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(player, "player is missing")
	assert(interactable_component, "interactable_component is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	assert(phone_item_data, "phone_item_data is empty")
	# Connect signals
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	interactable_component.item_used_on.connect(_on_interactable_item_used_on)
	# Initialize
	interact_hover_ui.hide()

func _process(delta: float) -> void:
	interact_hover_ui.rotation = -player.rotation

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered():
	if !InventoryManager.selected_item: return
	if InventoryManager.selected_item.id == phone_item_data.id: interact_hover_ui.show()

func _on_interactable_unhovered(): interact_hover_ui.hide()

func _on_interactable_interacted(): pass

func _on_interactable_item_used_on(item_data:ItemData):
	if item_data.id == phone_item_data.id:
		EventFlag.instance.has_peak_inside_phone = true
