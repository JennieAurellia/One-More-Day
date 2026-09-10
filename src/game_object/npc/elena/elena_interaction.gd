extends Node
class_name ElenaInteraction

@export_subgroup("References")
@export var elena : Elena
@export var interactable_component : InteractableComponent
@export var interact_hover_ui : Control
@export var interact_hover_text_label : Label

@export_subgroup("Interaction Settings")
@export var doll_item_data : ItemData
@export var normal_interact_text : String = "talk?"
@export var item_interact_text : String = "give?"

@export_subgroup("Dialogue Settings")
@export var talk_dialogue_resource : DialogueResource

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(elena, "elena is missing")
	assert(interactable_component, "interactable_component is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	assert(interact_hover_text_label, "interact_hover_text_label is empty")
	assert(doll_item_data, "doll_item_data is empty")
	assert(talk_dialogue_resource, "talk_dialogue_resource is empty")
	# Connect signals
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	interactable_component.item_used_on.connect(_on_interactable_item_used_on)
	# Initialize
	interact_hover_ui.hide()

func _process(delta: float) -> void:
	interact_hover_ui.rotation = -elena.rotation

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered():
	# Holding item
	if InventoryManager.selected_item:
		if InventoryManager.selected_item.id == doll_item_data.id:
			interact_hover_text_label.text = item_interact_text
	# Not holding item
	else: interact_hover_text_label.text = normal_interact_text
	# Show
	interact_hover_ui.show()

func _on_interactable_unhovered(): interact_hover_ui.hide()

func _on_interactable_interacted():
	# Hide
	interact_hover_ui.hide()
	# Without item
	elena.do_dialogue("talk", talk_dialogue_resource)

func _on_interactable_item_used_on(item_data:ItemData):
	# Hide
	interact_hover_ui.hide()
	# With item
	if InventoryManager.selected_item.id == doll_item_data.id: elena.do_dialogue("doll")
